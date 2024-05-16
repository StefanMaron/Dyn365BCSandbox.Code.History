﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Bank.Payment;

using Microsoft.Bank.BankAccount;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.NoSeries;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using System;
using System.Environment;
using System.IO;
using System.Xml;

report 2000006 "File Non Euro SEPA Payments"
{
    Caption = 'File Non Euro SEPA Payments';
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem("Payment Journal Line"; "Payment Journal Line")
        {
            DataItemTableView = sorting("Bank Account", "Beneficiary Bank Account No.", Status, "Account Type", "Account No.", "Currency Code", "Posting Date");

            trigger OnAfterGetRecord()
            var
                NewPaymentGroup: Boolean;
            begin
                NewPaymentGroup := CheckNewGroup("Payment Journal Line");
                if NewConsolidatedPayment("Payment Journal Line") then begin
                    ExportTransactionInformation(PmtInfNode, ConsolidatedPmtJnlLine, ConsolidatedPmtMessage);
                    InitConsolidatedPayment("Payment Journal Line");
                end else
                    UpdateConsolidatedPayment("Payment Journal Line");

                if NewPaymentGroup then
                    ExportPaymentInformation(CstmrCdtTrfInitnNode, "Payment Journal Line");
            end;

            trigger OnPostDataItem()
            begin
                if not EmptyConsolidatedPayment() then
                    ExportTransactionInformation(PmtInfNode, ConsolidatedPmtJnlLine, ConsolidatedPmtMessage);
                PostPmtLines("Payment Journal Line");
            end;

            trigger OnPreDataItem()
            begin
                OnBeforePreDataItemPaymentJournalLine("Payment Journal Line");

                if ExecutionDate <> 0D then
                    ModifyAll("Posting Date", ExecutionDate);

                SetRange("Separate Line", false);
                Clear(ConsolidatedPmtJnlLine);
            end;
        }
        dataitem(SeparatePmtJnlLine; "Payment Journal Line")
        {
            DataItemTableView = sorting("Bank Account", "Beneficiary Bank Account No.", Status, "Account Type", "Account No.", "Currency Code", "Posting Date");

            trigger OnAfterGetRecord()
            begin
                if CheckNewGroup(SeparatePmtJnlLine) then
                    ExportPaymentInformation(CstmrCdtTrfInitnNode, SeparatePmtJnlLine);
                ExportTransactionInformation(PmtInfNode, SeparatePmtJnlLine, "Payment Message");
            end;

            trigger OnPostDataItem()
            begin
                PostPmtLines(SeparatePmtJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                OnBeforePreDataItemSeparatePmtJnlLine(SeparatePmtJnlLine);

                Copy("Payment Journal Line");
                SetRange("Separate Line", true);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("GenJnlLine.""Journal Template Name"""; GenJnlLine."Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Template Name';
                        NotBlank = true;
                        TableRelation = "Gen. Journal Template";
                        ToolTip = 'Specifies the name of the journal template that is used for the posting.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::General);
                            GenJnlTemplate.Name := GenJnlLine."Journal Template Name";
                            if GenJnlTemplate.Find('=><') then;
                            if PAGE.RunModal(0, GenJnlTemplate) = ACTION::LookupOK then
                                GenJnlLine."Journal Template Name" := GenJnlTemplate.Name;
                        end;

                        trigger OnValidate()
                        begin
                            GenJnlLineJournalTemplateNameOnAfterValidate();
                        end;
                    }
                    field("GenJnlLine.""Journal Batch Name"""; GenJnlLine."Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Lookup = true;
                        NotBlank = true;
                        ToolTip = 'Specifies the general journal batch for the non-euro SEPA payment report.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine.TestField("Journal Template Name");
                            GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                            GenJnlBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            if GenJnlBatch.Find('=><') then;
                            if PAGE.RunModal(0, GenJnlBatch) = ACTION::LookupOK then
                                GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
                        end;

                        trigger OnValidate()
                        begin
                            GenJnlLine.TestField("Journal Template Name");
                            GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                            GenJnlBatch.TestField("No. Series");
                        end;
                    }
                    field(AutomaticPosting; AutomaticPosting)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post General Journal Lines';
                        ToolTip = 'Specifies if you want to transfer the payment lines to the general ledger.';
                    }
                    field(IncludeDimText; IncludeDimText)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Dimensions';
                        Editable = false;
                        Enabled = IncludeDimTextEnable;
                        ToolTip = 'Specifies the dimensions that you want to include in the report. The option is only available if the Summarize Gen. Jnl. Lines field in the Electronic Banking Setup window is selected.';

                        trigger OnAssistEdit()
                        var
                            DimSelectionBuf: Record "Dimension Selection Buffer";
                        begin
                            DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"File Non Euro SEPA Payments", IncludeDimText);
                        end;
                    }
                    field(ExecutionDate; ExecutionDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Execution Date';
                        ToolTip = 'Specifies the desired execution date if you want an execution date that is different than the posting date on the payment journal lines. The date you enter here will overwrite the posting date on the selected journal lines.';
                    }
                    field(FileName; FileName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'File Name';
                        ToolTip = 'Specifies the name of the file, including the drive and folder, to which you want to print the report.';
                        Visible = false;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            IncludeDimTextEnable := true;
        end;

        trigger OnOpenPage()
        begin
            IncludeDimTextEnable := EBSetup."Summarize Gen. Jnl. Lines";
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        FinishGroupHeader();
        XMLDomDoc.Save(SaveToFileName);

        Download(SaveToFileName, '', '', AllFilesDescriptionTxt, FileName);

        Clear(XMLDomDoc);
    end;

    trigger OnPreReport()
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootElement: DotNet XmlElement;
        XMLNodeCurr: DotNet XmlNode;
        XMLNewChild: DotNet XmlNode;
    begin
        EBSetup.Get();
        CompanyInfo.Get();

        OnBeforePreReport("Payment Journal Line", GenJnlLine, AutomaticPosting, IncludeDimText, ExecutionDate, FileName);

        if ClientTypeManagement.GetCurrentClientType() in [CLIENTTYPE::Desktop, CLIENTTYPE::Windows] then begin
            if DelChr(FileName, '<>') = '' then
                Error(Text003);

            if Exists(FileName) then
                if not Confirm(Text004, false, FileName) then
                    Error(Text005, FileName);
        end;
        If FileName = '' then
            FileName := NonEuroSEPAPaymentsFileNameTxt;

        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8"?><Document></Document>', XMLDomDoc);
        XMLRootElement := XMLDomDoc.DocumentElement;
        XMLRootElement.SetAttribute('xmlns', 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03');
        XMLRootElement.SetAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        XMLNodeCurr := XMLDomDoc.SelectSingleNode('Document');
        AddElement(XMLNodeCurr, 'CstmrCdtTrfInitn', '', '', XMLNewChild);
        CstmrCdtTrfInitnNode := XMLNewChild;
        MessageId := GetMessageID(GetExportProtocolCode("Payment Journal Line"));
        StartGroupHeader(XMLNewChild);
        PaymentInformationCounter := 0;
        NumberOfTransactions := 0;
        ControlSum := 0;

        SaveToFileName := RBMgt.ServerTempFileName('.xml');
    end;

    var
        EBSetup: Record "Electronic Banking Setup";
        ConsolidatedPmtJnlLine: Record "Payment Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        BankAcc: Record "Bank Account";
        VendorBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Currency: Record Currency;
        RBMgt: Codeunit "File Management";
        ClientTypeManagement: Codeunit "Client Type Management";
        XMLDomDoc: DotNet XmlDocument;
        CstmrCdtTrfInitnNode: DotNet XmlNode;
        PmtInfNode: DotNet XmlNode;
        ConsolidatedPmtMessage: Text[140];
        Text002: Label 'Journal %1 is not a general journal.';
        SaveToFileName: Text[250];
        MessageId: Text[35];
        PaymentInformationCounter: Integer;
        Text003: Label 'File name must be specified.';
        Text004: Label 'The %1 already exists.\\Do you want to replace the existing file?';
        Text005: Label 'The file %1 already exists.';
        NonEuroSEPAPaymentsFileNameTxt: Label 'NonEuroSEPAPayments.xml';
        NumberOfTransactions: Integer;
        ControlSum: Decimal;
        IncludeDimTextEnable: Boolean;
        AllFilesDescriptionTxt: Label 'All Files (*.*)|*.*', Comment = '{Split=r''\|''}{Locked=s''1''}';

    protected var
        GenJnlLine: Record "Gen. Journal Line";
        AutomaticPosting: Boolean;
        ExecutionDate: Date;
        IncludeDimText: Text[250];
        FileName: Text;

    local procedure PostPmtLines(var PmtJnlLine: Record "Payment Journal Line")
    var
        BalancingPostingDate: Date;
    begin
        if PmtJnlLine.IsEmpty() then
            exit;
        if ExecutionDate <> 0D then
            BalancingPostingDate := ExecutionDate
        else
            BalancingPostingDate := Today;

        PostPaymentJournal(GenJnlLine, PmtJnlLine, BalancingPostingDate);
    end;

    local procedure PostPaymentJournal(var GenJnlLine: Record "Gen. Journal Line"; var PaymentJournalLine: Record "Payment Journal Line"; BalancingPostingDate: Date)
    var
        PaymentJournalPost: Report "Payment Journal Post";
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforePostPaymentJournal(GenJnlLine, PaymentJournalLine, AutomaticPosting, BalancingPostingDate, IsHandled);
        if IsHandled then
            exit;

        PaymentJournalPost.SetParameters(GenJnlLine, AutomaticPosting, Report::"File Non Euro SEPA Payments", BalancingPostingDate);
        PaymentJournalPost.SetTableView(PaymentJournalLine);
        PaymentJournalPost.RunModal();
    end;

    local procedure StartGroupHeader(XMLNodeCurr: DotNet XmlNode)
    var
        XMLNewChild: DotNet XmlNode;
    begin
        AddElement(XMLNodeCurr, 'GrpHdr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'MsgId', MessageId, '', XMLNewChild);
        AddElement(XMLNodeCurr, 'CreDtTm', Format(CurrentDateTime, 19, 9), '', XMLNewChild);
    end;

    [Scope('OnPrem')]
    procedure FinishGroupHeader()
    var
        XMLNodeCurr: DotNet XmlNode;
        XMLNewChild: DotNet XmlNode;
    begin
        // Insert Number of Transactions and ControlSum in the Group Header
        XMLNodeCurr := XMLDomDoc.SelectSingleNode('Document');
        XMLNodeCurr := XMLNodeCurr.FirstChild;
        XMLNodeCurr := XMLNodeCurr.FirstChild;

        AddElement(XMLNodeCurr, 'NbOfTxs', Format(NumberOfTransactions, 0, 9), '', XMLNewChild);
        AddElement(XMLNodeCurr, 'CtrlSum', Format(ControlSum, 0, 9), '', XMLNewChild);

        AddElement(XMLNodeCurr, 'InitgPty', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Nm', CompanyInfo.Name, '', XMLNewChild);
        AddEnterpriseNo(XMLNodeCurr, CompanyInfo."Enterprise No.");
    end;

    local procedure ExportPaymentInformation(XMLNodeCurr: DotNet XmlNode; PmtJnlLine: Record "Payment Journal Line")
    var
        ExportProtocol: Record "Export Protocol";
        XMLNewChild: DotNet XmlNode;
        RootNode: DotNet XmlNode;
        AddressLine1: Text[110];
        AddressLine2: Text[60];
        ChargeBearer: Text[4];
    begin
        RootNode := XMLNodeCurr;

        PaymentInformationCounter := PaymentInformationCounter + 1;
        AddElement(XMLNodeCurr, 'PmtInf', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;
        PmtInfNode := XMLNodeCurr;

        AddElement(XMLNodeCurr, 'PmtInfId', MessageId + '-' + Format(PaymentInformationCounter), '', XMLNewChild);
        AddElement(XMLNodeCurr, 'PmtMtd', 'TRF', '', XMLNewChild);

        ExportProtocol.Get(PmtJnlLine."Export Protocol Code");
        if ExportProtocol."Grouped Payment" then
            AddElement(XMLNodeCurr, 'BtchBookg', 'true', '', XMLNewChild)
        else
            AddElement(XMLNodeCurr, 'BtchBookg', 'false', '', XMLNewChild);
        AddElement(XMLNodeCurr, 'PmtTpInf', '', '', XMLNewChild);

        XMLNodeCurr := XMLNewChild;
        AddElement(XMLNodeCurr, 'InstrPrty', GetInstructionPriority(PmtJnlLine."Instruction Priority"), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'ReqdExctnDt', Format(PmtJnlLine."Posting Date", 0, 9), '', XMLNewChild);
        AddElement(XMLNodeCurr, 'Dbtr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Nm', CompanyInfo.Name, '', XMLNewChild);

        AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        GetCountry(CompanyInfo."Country/Region Code");

        if Country."ISO Code" <> '' then
            AddElement(XMLNodeCurr, 'Ctry', CopyStr(Country."ISO Code", 1, 2), '', XMLNewChild);

        AddressLine1 := DelChr(CompanyInfo.Address, '<>') + ' ' + DelChr(CompanyInfo."Address 2", '<>');
        if DelChr(AddressLine1) <> '' then
            AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 35), '', XMLNewChild);

        AddressLine2 := DelChr(CompanyInfo."Post Code", '<>') + ' ' + DelChr(CompanyInfo.City, '<>');
        if DelChr(AddressLine2) <> '' then
            AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 35), '', XMLNewChild);

        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'DbtrAcct', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Id', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        GetBankAccount(PmtJnlLine."Bank Account");
        AddElement(XMLNodeCurr, 'IBAN', CopyStr(DelChr(BankAcc.IBAN), 1, 34), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'DbtrAgt', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'FinInstnId', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'BIC', CopyStr(DelChr(BankAcc."SWIFT Code"), 1, 11), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        case PmtJnlLine."Code Expenses" of
            PmtJnlLine."Code Expenses"::" ",
          PmtJnlLine."Code Expenses"::SHA:
                ChargeBearer := 'SHAR';
            PmtJnlLine."Code Expenses"::BEN:
                ChargeBearer := 'CRED';
            PmtJnlLine."Code Expenses"::OUR:
                ChargeBearer := 'DEBT';
        end;

        AddElement(XMLNodeCurr, 'ChrgBr', ChargeBearer, '', XMLNewChild);

        XMLNodeCurr := RootNode;
    end;

    [Scope('OnPrem')]
    procedure ExportTransactionInformation(XMLNodeCurr: DotNet XmlNode; PmtJnlLine: Record "Payment Journal Line"; PaymentMessage: Text[140])
    var
        GLSetup: Record "General Ledger Setup";
        XMLNewChild: DotNet XmlNode;
        RootNode: DotNet XmlNode;
        AddressLine1: Text[110];
        AddressLine2: Text[60];
        ISOCurrCode: Text[3];
        IBANTransfer: Boolean;
    begin
        OnBeforeExportTransactionInformation(PmtJnlLine, PaymentMessage);

        GLSetup.Get();
        RootNode := XMLNodeCurr;
        NumberOfTransactions += 1;
        ControlSum += PmtJnlLine.Amount;

        AddElement(XMLNodeCurr, 'CdtTrfTxInf', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'PmtId', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'EndToEndId', CutText(PaymentMessage, 35), '', XMLNewChild);
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'Amt', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'InstdAmt', Format(PmtJnlLine.Amount, 0, 9), '', XMLNewChild);
        if PmtJnlLine."Currency Code" = '' then
            ISOCurrCode := CopyStr(GLSetup."LCY Code", 1, 3)
        else begin
            GetCurrency(PmtJnlLine."Currency Code");
            ISOCurrCode := CopyStr(Currency."ISO Code", 1, 3);
        end;
        AddAttribute(XMLDomDoc, XMLNewChild, 'Ccy', ISOCurrCode);
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        AddElement(XMLNodeCurr, 'CdtrAgt', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'FinInstnId', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'BIC', CopyStr(DelChr(PmtJnlLine."SWIFT Code"), 1, 11), '', XMLNewChild);
        case PmtJnlLine."Account Type" of
            PmtJnlLine."Account Type"::Vendor:
                begin
                    GetVendorBankAccount(PmtJnlLine."Account No.", PmtJnlLine."Beneficiary Bank Account");
                    AddElement(XMLNodeCurr, 'Nm', VendorBankAcc.Name, '', XMLNewChild);
                    AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;

                    GetCountry(VendorBankAcc."Country/Region Code");
                    if Country."ISO Code" <> '' then
                        AddElement(XMLNodeCurr, 'Ctry', CopyStr(Country."ISO Code", 1, 2), '', XMLNewChild);

                    AddressLine1 := DelChr(VendorBankAcc.Address, '<>') + ' ' + DelChr(VendorBankAcc."Address 2", '<>');
                    if DelChr(AddressLine1) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 35), '', XMLNewChild);

                    AddressLine2 := DelChr(VendorBankAcc."Post Code", '<>') + ' ' + DelChr(VendorBankAcc.City, '<>');
                    if DelChr(AddressLine2) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 35), '', XMLNewChild);
                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                    XMLNodeCurr := XMLNodeCurr.ParentNode;

                    AddElement(XMLNodeCurr, 'Cdtr', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;

                    GetVendor(PmtJnlLine."Account No.");
                    AddElement(XMLNodeCurr, 'Nm', CopyStr(Vendor.Name, 1, 70), '', XMLNewChild);
                    AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;

                    GetCountry(Vendor."Country/Region Code");
                    if Country."ISO Code" <> '' then
                        AddElement(XMLNodeCurr, 'Ctry', CopyStr(Country."ISO Code", 1, 2), '', XMLNewChild);

                    AddressLine1 := DelChr(Vendor.Address, '<>') + ' ' + DelChr(Vendor."Address 2", '<>');
                    if DelChr(AddressLine1) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 35), '', XMLNewChild);

                    AddressLine2 := DelChr(Vendor."Post Code", '<>') + ' ' + DelChr(Vendor.City, '<>');
                    if DelChr(AddressLine2) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 35), '', XMLNewChild);

                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                end;
            PmtJnlLine."Account Type"::Customer:
                begin
                    GetCustomerBankAccount(PmtJnlLine."Account No.", PmtJnlLine."Beneficiary Bank Account");
                    AddElement(XMLNodeCurr, 'Nm', CustomerBankAcc.Name, '', XMLNewChild);
                    AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;

                    GetCountry(CustomerBankAcc."Country/Region Code");
                    if Country."ISO Code" <> '' then
                        AddElement(XMLNodeCurr, 'Ctry', CopyStr(Country."ISO Code", 1, 2), '', XMLNewChild);

                    AddressLine1 := DelChr(CustomerBankAcc.Address, '<>') + ' ' + DelChr(CustomerBankAcc."Address 2", '<>');
                    if DelChr(AddressLine1) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 35), '', XMLNewChild);

                    AddressLine2 := DelChr(CustomerBankAcc."Post Code", '<>') + ' ' + DelChr(CustomerBankAcc.City, '<>');
                    if DelChr(AddressLine2) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 35), '', XMLNewChild);
                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                    XMLNodeCurr := XMLNodeCurr.ParentNode;

                    AddElement(XMLNodeCurr, 'Cdtr', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;

                    GetCustomer(PmtJnlLine."Account No.");
                    AddElement(XMLNodeCurr, 'Nm', CopyStr(Customer.Name, 1, 70), '', XMLNewChild);
                    AddElement(XMLNodeCurr, 'PstlAdr', '', '', XMLNewChild);
                    XMLNodeCurr := XMLNewChild;

                    GetCountry(Customer."Country/Region Code");
                    if Country."ISO Code" <> '' then
                        AddElement(XMLNodeCurr, 'Ctry', CopyStr(Country."ISO Code", 1, 2), '', XMLNewChild);

                    AddressLine1 := DelChr(Customer.Address, '<>') + ' ' + DelChr(Customer."Address 2", '<>');
                    if DelChr(AddressLine1) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine1, 1, 35), '', XMLNewChild);

                    AddressLine2 := DelChr(Customer."Post Code", '<>') + ' ' + DelChr(Customer.City, '<>');
                    if DelChr(AddressLine2) <> '' then
                        AddElement(XMLNodeCurr, 'AdrLine', CopyStr(AddressLine2, 1, 35), '', XMLNewChild);

                    XMLNodeCurr := XMLNodeCurr.ParentNode;
                end;
        end;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'CdtrAcct', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Id', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;
        // If IBAN Transfer then Export IBAN else BBAN
        IBANTransfer := (PmtJnlLine."Beneficiary IBAN" <> '') and Country."IBAN Country/Region";
        if IBANTransfer then
            AddElement(XMLNodeCurr, 'IBAN', CopyStr(DelChr(PmtJnlLine."Beneficiary IBAN"), 1, 34), '', XMLNewChild)
        else begin
            AddElement(XMLNodeCurr, 'Othr', '', '', XMLNewChild);
            XMLNodeCurr := XMLNewChild;
            AddElement(XMLNodeCurr, 'Id', PmtJnlLine."Beneficiary Bank Account No.", '', XMLNewChild);
            XMLNodeCurr := XMLNodeCurr.ParentNode;
        end;
        XMLNodeCurr := XMLNodeCurr.ParentNode;
        XMLNodeCurr := XMLNodeCurr.ParentNode;

        AddElement(XMLNodeCurr, 'RmtInf', '', '', XMLNewChild);
        XMLNodeCurr := XMLNewChild;

        AddElement(XMLNodeCurr, 'Ustrd', PaymentMessage, '', XMLNewChild);

        XMLNodeCurr := RootNode;
    end;

    local procedure GetMessageID(ExportProtocolCode: Code[20]): Text[35]
    var
        ExportProtocol: Record "Export Protocol";
        NoSeries: Codeunit "No. Series";
    begin
        ExportProtocol.Get(ExportProtocolCode);
        exit(NoSeries.GetNextNo(ExportProtocol."Export No. Series", Today()));
    end;

    local procedure GetExportProtocolCode(var PmtJnlLine: Record "Payment Journal Line"): Code[20]
    var
        ExportProtocolCode: Code[20];
    begin
        PmtJnlLine.FilterGroup(2);
        ExportProtocolCode := PmtJnlLine.GetRangeMax("Export Protocol Code");
        PmtJnlLine.FilterGroup(0);
        exit(ExportProtocolCode);
    end;

    [Scope('OnPrem')]
    procedure GetCountry(CountryCode: Code[10])
    begin
        if CountryCode <> Country.Code then
            if not Country.Get(CountryCode) then
                Country.Init();
    end;

    [Scope('OnPrem')]
    procedure GetBankAccount(BankAccCode: Code[20])
    begin
        if BankAcc."No." <> BankAccCode then
            if not BankAcc.Get(BankAccCode) then
                BankAcc.Init();
    end;

    [Scope('OnPrem')]
    procedure GetVendorBankAccount(VendorNo: Code[20]; BankAccCode: Code[20])
    begin
        if (VendorNo <> VendorBankAcc."Vendor No.") or (BankAccCode <> VendorBankAcc.Code) then
            if not VendorBankAcc.Get(VendorNo, BankAccCode) then
                VendorBankAcc.Init();
    end;

    [Scope('OnPrem')]
    procedure GetCustomerBankAccount(CustomerNo: Code[20]; BankAccCode: Code[20])
    begin
        if (CustomerNo <> CustomerBankAcc."Customer No.") or (BankAccCode <> CustomerBankAcc.Code) then
            if not CustomerBankAcc.Get(CustomerNo, BankAccCode) then
                CustomerBankAcc.Init();

        OnAfterGetCustomerBankAccount(CustomerBankAcc, "Payment Journal Line");
    end;

    [Scope('OnPrem')]
    procedure GetVendor(VendorNo: Code[20])
    begin
        if Vendor."No." <> VendorNo then
            if not Vendor.Get(VendorNo) then
                Vendor.Init();
    end;

    [Scope('OnPrem')]
    procedure GetCustomer(CustomerNo: Code[20])
    begin
        if Customer."No." <> CustomerNo then
            if not Customer.Get(CustomerNo) then
                Customer.Init();
    end;

    [Scope('OnPrem')]
    procedure GetCurrency(CurrencyCode: Code[10])
    begin
        if Currency.Code <> CurrencyCode then
            if not Currency.Get(CurrencyCode) then
                Currency.Init();
    end;

    local procedure GetInstructionPriority(InstructionPriorityOption: Option): Text[10]
    var
        DummyPaymentJournalLine: Record "Payment Journal Line";
    begin
        if InstructionPriorityOption = DummyPaymentJournalLine."Instruction Priority"::High then
            exit('HIGH');
        exit('NORM');
    end;

    procedure CheckNewGroup(PmtJnlLine: Record "Payment Journal Line") ReturnValue: Boolean
    begin
        if EmptyConsolidatedPayment() then
            exit(true);

        ReturnValue :=
              (ConsolidatedPmtJnlLine."Bank Account" <> PmtJnlLine."Bank Account") or
              (ConsolidatedPmtJnlLine."Currency Code" <> PmtJnlLine."Currency Code") or
              (ConsolidatedPmtJnlLine."Posting Date" <> PmtJnlLine."Posting Date") or
              (ConsolidatedPmtJnlLine."Instruction Priority" <> PmtJnlLine."Instruction Priority") or
              (ConsolidatedPmtJnlLine."Code Expenses" <> PmtJnlLine."Code Expenses");

        OnAfterCheckNewGroup(PmtJnlLine, ConsolidatedPmtJnlLine, ReturnValue);

        exit(ReturnValue);
    end;

    local procedure EmptyConsolidatedPayment(): Boolean
    begin
        exit(ConsolidatedPmtJnlLine."Bank Account" = '');
    end;

    local procedure NewConsolidatedPayment(PmtJnlLine: Record "Payment Journal Line") ReturnValue: Boolean
    begin
        if EmptyConsolidatedPayment() then
            exit(false);

        ReturnValue :=
              CheckNewGroup(PmtJnlLine) or
              IsPaymentMessageTooLong(PmtJnlLine."Payment Message") or
              (ConsolidatedPmtJnlLine."Account Type" <> PmtJnlLine."Account Type") or
              (ConsolidatedPmtJnlLine."Account No." <> PmtJnlLine."Account No.") or
              (ConsolidatedPmtJnlLine."Beneficiary Bank Account No." <> PmtJnlLine."Beneficiary Bank Account No.");

        OnAfterNewConsolidatedPayment(PmtJnlLine, ConsolidatedPmtJnlLine, ReturnValue);

        exit(ReturnValue);
    end;

    local procedure InitConsolidatedPayment(PmtJnlLine: Record "Payment Journal Line")
    begin
        ConsolidatedPmtJnlLine := PmtJnlLine;
        ConsolidatedPmtMessage := ConsolidatedPmtJnlLine."Payment Message";
    end;

    local procedure UpdateConsolidatedPayment(PmtJnlLine: Record "Payment Journal Line")
    begin
        if EmptyConsolidatedPayment() then
            InitConsolidatedPayment(PmtJnlLine)
        else begin
            ConsolidatedPmtJnlLine.Amount := ConsolidatedPmtJnlLine.Amount + PmtJnlLine.Amount;
            UpdateConsolidatedPmtMessage(PmtJnlLine."Payment Message");
        end;
    end;

    local procedure UpdateConsolidatedPmtMessage(PaymentMessage: Text[100])
    var
        NewMessage: Text[1024];
    begin
        NewMessage := ConcatenatedPmtMessage(PaymentMessage);
        if EBSetup."Cut off Payment Message Texts" then
            ConsolidatedPmtMessage := CopyStr(
                CutText(NewMessage, MaxStrLen(ConsolidatedPmtMessage)),
                1, MaxStrLen(ConsolidatedPmtMessage))
        else
            ConsolidatedPmtMessage := CopyStr(NewMessage, 1, MaxStrLen(ConsolidatedPmtMessage));
    end;

    procedure IsPaymentMessageTooLong(PaymentMessage: Text[100]): Boolean
    begin
        if not EBSetup."Cut off Payment Message Texts" then
            exit(StrLen(ConcatenatedPmtMessage(PaymentMessage)) > MaxStrLen(ConsolidatedPmtMessage));
        exit(false);
    end;

    local procedure ConcatenatedPmtMessage(PaymentMessage: Text[100]): Text[1024]
    begin
        exit(ConsolidatedPmtMessage + ' ' + PaymentMessage);
    end;

    local procedure CutText(OriginalText: Text[1024]; MaxLength: Integer) Text: Text[1024]
    begin
        Text := OriginalText;
        if DelChr(Text, '<>') = '' then
            Text := 'NOTPROVIDED';
        AddCutMarker(Text, MaxLength);
    end;

    local procedure AddCutMarker(var Text: Text[1024]; MaxLength: Integer)
    var
        CutMarker: Text[30];
    begin
        CutMarker := '...';
        if StrLen(Text) > MaxLength then
            Text := CopyStr(Text, 1, MaxLength - StrLen(CutMarker)) + CutMarker;
    end;

    [Scope('OnPrem')]
    procedure AddEnterpriseNo(XMLNodeCurr: DotNet XmlNode; EnterpriseNo: Text[50])
    var
        XMLNewChild: DotNet XmlNode;
    begin
        if DelChr(EnterpriseNo, '<>') <> '' then begin
            AddElement(XMLNodeCurr, 'Id', '', '', XMLNewChild);
            XMLNodeCurr := XMLNewChild;

            AddElement(XMLNodeCurr, 'OrgId', '', '', XMLNewChild);
            XMLNodeCurr := XMLNewChild;

            AddElement(XMLNodeCurr, 'Othr', '', '', XMLNewChild);
            XMLNodeCurr := XMLNewChild;

            AddElement(XMLNodeCurr, 'Id', EnterpriseNo, '', XMLNewChild);
            AddElement(XMLNodeCurr, 'Issr', 'KBO-BCE', '', XMLNewChild);
        end;
    end;

    local procedure AddElement(var XMLNode: DotNet XmlNode; NodeName: Text[250]; NodeText: Text[250]; NameSpace: Text[250]; var CreatedXMLNode: DotNet XmlNode): Boolean
    var
        NewChildNode: DotNet XmlNode;
    begin
        NewChildNode := XMLNode.OwnerDocument.CreateNode('element', NodeName, NameSpace);

        if IsNull(NewChildNode) then
            exit(false);

        if NodeText <> '' then
            NewChildNode.InnerText := NodeText;
        XMLNode.AppendChild(NewChildNode);
        CreatedXMLNode := NewChildNode;
        exit(true);
    end;

    local procedure AddAttribute(var XMLDomDocParam: DotNet XmlDocument; var XMLDomNode: DotNet XmlNode; AttribName: Text[250]; AttribValue: Text[250]): Boolean
    var
        XMLDomAttribute: DotNet XmlAttribute;
    begin
        XMLDomAttribute := XMLDomDocParam.CreateAttribute(AttribName);
        if IsNull(XMLDomAttribute) then
            exit(false);

        if AttribValue <> '' then
            XMLDomAttribute.Value := AttribValue;
        XMLDomNode.Attributes.SetNamedItem(XMLDomAttribute);
        Clear(XMLDomAttribute);
        exit(true);
    end;

    local procedure GenJnlLineJournalTemplateNameOnAfterValidate()
    begin
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate.Type <> GenJnlTemplate.Type::General then
            Error(Text002, GenJnlTemplate.Name);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckNewGroup(PaymentJournalLine: Record "Payment Journal Line"; ConsolidatedPaymentJournalLine: Record "Payment Journal Line"; var ReturnValue: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCustomerBankAccount(var CustomerBankAccount: Record "Customer Bank Account"; PaymentJournalLine: Record "Payment Journal Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterNewConsolidatedPayment(PaymentJournalLine: Record "Payment Journal Line"; ConsolidatedPaymentJournalLine: Record "Payment Journal Line"; var ReturnValue: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExportTransactionInformation(var PaymentJournalLine: Record "Payment Journal Line"; var PaymentMessage: Text[140]);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPaymentJournal(var GenJnlLine: Record "Gen. Journal Line"; var PaymentJournalLine: Record "Payment Journal Line"; AutomaticPosting: Boolean; BalancingPostingDate: Date; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePreDataItemPaymentJournalLine(var PaymentJournalLine: Record "Payment Journal Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePreReport(var PaymentJournalLine: Record "Payment Journal Line"; var GenJnlLine: Record "Gen. Journal Line"; var AutomaticPosting: Boolean; var IncludeDimText: Text[250]; var ExecutionDate: Date; var FileName: Text);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePreDataItemSeparatePmtJnlLine(var PaymentJournalLine: Record "Payment Journal Line");
    begin
    end;
}

