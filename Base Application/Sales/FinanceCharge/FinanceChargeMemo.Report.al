﻿namespace Microsoft.Sales.FinanceCharge;

using Microsoft.Bank.BankAccount;
using Microsoft.CRM.Contact;
using Microsoft.CRM.Interaction;
using Microsoft.CRM.Segment;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.VAT.Clause;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Setup;
using System.Email;
using System.Globalization;
using System.Utilities;

report 118 "Finance Charge Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Sales/FinanceCharge/FinanceChargeMemo.rdlc';
    Caption = 'Finance Charge Memo';
    WordMergeDataItem = "Issued Fin. Charge Memo Header";

    dataset
    {
        dataitem("Issued Fin. Charge Memo Header"; "Issued Fin. Charge Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Finance Charge Memo';
            column(No_IssuedFinChgMemo; "No.")
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(VATAmtCaption; VATAmtCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(DoctDateCaption; DoctDateCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EMailCaption; EMailCaptionLbl)
            {
            }
            column(ContactPhoneNoLbl; ContactPhoneNoLbl)
            {
            }
            column(ContactMobilePhoneNoLbl; ContactMobilePhoneNoLbl)
            {
            }
            column(ContactEmailLbl; ContactEmailLbl)
            {
            }
            column(ContactPhoneNo; PrimaryContact."Phone No.")
            {
            }
            column(ContactMobilePhoneNo; PrimaryContact."Mobile Phone No.")
            {
            }
            column(ContactEmail; PrimaryContact."E-mail")
            {
            }
#if not CLEAN23
            column(PlusGiroNoCaption; PlusGiroNoCaptionLbl)
            {
                ObsoleteReason = 'Refer to the column PlusGiroNumberCaption in the corresponding report extension from SE Core.';
                ObsoleteTag = '23.0';
                ObsoleteState = Pending;
            }
            column(BoardOfDirLocCaption; BoardOfDirLocCaptionLbl)
            {
                ObsoleteReason = 'Refer to the column BoardOfDirectorsLocationCaptionLbl in the corresponding report extension from SE Core.';
                ObsoleteTag = '23.0';
                ObsoleteState = Pending;
            }
            column(CompHasTaxAssNoteCaption; CompHasTaxAssNoteCaptionLbl)
            {
                ObsoleteReason = 'Refer to the column CompanyHasTaxAssessCaptionLbl in the corresponding report extension from SE Core.';
                ObsoleteTag = '23.0';
                ObsoleteState = Pending;
            }
#endif
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(CompanyInfo1Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyInfo3Picture; CompanyInfo3.Picture)
                {
                }
                column(PostDt_IssuFinChrgMemoHr; Format("Issued Fin. Charge Memo Header"."Posting Date"))
                {
                }
                column(DueDt_IssuFinChrgMemoHr; Format("Issued Fin. Charge Memo Header"."Due Date"))
                {
                }
                column(No1_IssuFinChrgMemoHr; "Issued Fin. Charge Memo Header"."No.")
                {
                }
                column(DocDt_IssuFinChrgMemoHr; Format("Issued Fin. Charge Memo Header"."Document Date"))
                {
                }
                column(YourRef_IssuFinChrgMemoHr; "Issued Fin. Charge Memo Header"."Your Reference")
                {
                }
                column(ReferenceText; ReferenceText)
                {
                }
                column(VatRNo_IssuFinChrgMemoHr; "Issued Fin. Charge Memo Header".GetCustomerVATRegistrationNumber())
                {
                }
                column(VATNoText; VATNoText)
                {
                }
                column(CompanyInfoBankAccNo; CompanyBankAccount."Bank Account No.")
                {
                }
                column(CompanyInfoIBAN; CompanyBankAccount.IBAN)
                {
                }
                column(CustNo_IssuFinChrgMemoHr; "Issued Fin. Charge Memo Header"."Customer No.")
                {
                }
                column(CustNo_IssuFinChrgMemoHrCaption; "Issued Fin. Charge Memo Header".FieldCaption("Customer No."))
                {
                }
                column(CompanyInfoBankName; CompanyBankAccount.Name)
                {
                }
                column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfoVatRegNo; CompanyInfo.GetVATRegistrationNumber())
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoEMail; CompanyInfo."E-Mail")
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                {
                }
#if not CLEAN23
                column(CompanyInfoPlusGiroNo; CompanyInfo."Plus Giro No.")
                {
                        ObsoleteReason = 'Refer to the column CompanyInforPlusGiroNumber in the corresponding report extension from SE Core.';
                        ObsoleteTag = '23.0';
                        ObsoleteState = Pending;
                }
                column(CompanyInfoRegisteredOffice; CompanyInfo."Registered Office")
                {
                        ObsoleteReason = 'Refer to the column CompanyInfoRegisteredOfficeInfo in the corresponding report extension from SE Core.';
                        ObsoleteTag = '23.0';
                        ObsoleteState = Pending;
                }
#endif
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CompanyAddr7; CompanyAddr[7])
                {
                }
                column(CompanyAddr8; CompanyAddr[8])
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(PageCaption; StrSubstNo(Text002, ''))
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(FinChrgMemoNoCaption; FinChrgMemoNoCaptionLbl)
                {
                }
                column(BankAccNoCaption; BankAccNoCaptionLbl)
                {
                }
                column(IBANCaption; IBANCaptionLbl)
                {
                }
                column(BankNameCaption; BankNameCaptionLbl)
                {
                }
                column(GiroNoCaption; GiroNoCaptionLbl)
                {
                }
                column(VATRegNoCaption; "Issued Fin. Charge Memo Header".GetCustomerVATRegistrationNumberLbl())
                {
                }
                column(PhoneNoCaption; PhoneNoCaptionLbl)
                {
                }
                column(FinChgMemoCaption; FinChgMemoCaptionLbl)
                {
                }
                column(CompanyVATRegistrationNoCaption; CompanyInfo.GetVATRegistrationNumberLbl())
                {
                }
                dataitem(DimensionLoop; "Integer")
                {
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(DimText; DimText)
                    {
                    }
                    column(Number_DimLoop; Number)
                    {
                    }
                    column(HdrDimCaption; HdrDimCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            if not DimSetEntry.FindSet() then
                                CurrReport.Break();
                        end else
                            if not Continue then
                                CurrReport.Break();

                        Clear(DimText);
                        Continue := false;
                        repeat
                            OldDimText := DimText;
                            if DimText = '' then
                                DimText := StrSubstNo('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
                            else
                                DimText :=
                                  StrSubstNo(
                                    '%1; %2 - %3', DimText,
                                    DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                            if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                            end;
                        until DimSetEntry.Next() = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowInternalInfo then
                            CurrReport.Break();
                    end;
                }
                dataitem("Issued Fin. Charge Memo Line"; "Issued Fin. Charge Memo Line")
                {
                    DataItemLink = "Finance Charge Memo No." = field("No.");
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = sorting("Finance Charge Memo No.", "Line No.");
                    column(LineNo_IssuFinChrgMemoLine; "Line No.")
                    {
                    }
                    column(StartLineNo; StartLineNo)
                    {
                    }
                    column(TypeInt; TypeInt)
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(Amt_IssuFinChrgMemoLine; Amount)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Desc_IssuFinChrgMemoLine; Description)
                    {
                    }
                    column(DocDt_IssuFinChrgMemoLine; Format("Document Date"))
                    {
                    }
                    column(DocNo_IssuFinChrgMemoLine; "Document No.")
                    {
                    }
                    column(DueDt_IssuFinChrgMemoLine; Format("Due Date"))
                    {
                    }
                    column(DcType_IssuFinChrgMemoLine; "Document Type")
                    {
                    }
                    column(DocNo_IssuFinChrgMemoLineCaption; FieldCaption("Document No."))
                    {
                    }
                    column(Desc_IssuFinChrgMemoLineCaption; FieldCaption(Description))
                    {
                    }
                    column(Amt_IssuFinChrgMemoLineCaption; FieldCaption(Amount))
                    {
                    }
                    column(DcType_IssuFinChrgMemoLineCaption; FieldCaption("Document Type"))
                    {
                    }
                    column(No_IssuedFinChgMemoLine; "No.")
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(TotalInclVATText; TotalInclVATText)
                    {
                    }
                    column(VatAmt_IssuFinChrgMemoLine; "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(DocDateCaption1; DocDateCaption1Lbl)
                    {
                    }
                    column(TotalVatAmount; TotalVatAmount)
                    {
                    }
                    column(TotalAmount; TotalAmount)
                    {
                    }
                    column(MultiIntRateEntry_IssuFinChrgMemoLine; "Detailed Interest Rates Entry")
                    {
                    }
                    column(ShowMIRLines; ShowMIRLines)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not "Detailed Interest Rates Entry" then begin
                            TempVATAmountLine.Init();
                            TempVATAmountLine."VAT Identifier" := "VAT Identifier";
                            TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            TempVATAmountLine."Tax Group Code" := "Tax Group Code";
                            TempVATAmountLine."VAT %" := "VAT %";
                            TempVATAmountLine."VAT Base" := Amount;
                            TempVATAmountLine."VAT Amount" := "VAT Amount";
                            TempVATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                            TempVATAmountLine."VAT Clause Code" := "VAT Clause Code";
                            TempVATAmountLine.InsertLine();

                            TotalAmount += Amount;
                            TotalVatAmount += "VAT Amount";
                        end;

                        TypeInt := Type;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if Find('-') then begin
                            StartLineNo := 0;
                            repeat
                                Continue := Type = Type::" ";
                                if Continue and (Description = '') then
                                    StartLineNo := "Line No.";
                            until (Next() = 0) or not Continue;
                        end;
                        if Find('+') then begin
                            EndLineNo := "Line No." + 1;
                            repeat
                                Continue := Type = Type::" ";
                                if Continue and (Description = '') then
                                    EndLineNo := "Line No.";
                            until (Next(-1) = 0) or not Continue;
                        end;

                        TempVATAmountLine.DeleteAll();
                        SetFilter("Line No.", '<%1', EndLineNo);
                        if not ShowMIRLines then
                            SetRange("Detailed Interest Rates Entry", false);

                        TotalAmount := 0;
                        TotalVatAmount := 0;
                    end;
                }
                dataitem(IssuedFinChrgMemoLine2; "Issued Fin. Charge Memo Line")
                {
                    DataItemLink = "Finance Charge Memo No." = field("No.");
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = sorting("Finance Charge Memo No.", "Line No.");
                    column(Desc2_IssuFinChrgMemoLine; Description)
                    {
                    }
                    column(LnNo_IssuFinChrgMemoLine2; "Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Line No.", '>=%1', EndLineNo);
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ValVatBaseValVatAmt; VALVATBase + VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(ValvataAmt; VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VALVATBase; VALVATBase)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VatAmtLineVAT; TempVATAmountLine."VAT %")
                    {
                    }
                    column(AmtInclVATCaption; AmtInclVATCaptionLbl)
                    {
                    }
                    column(VATPercentCaption; VATPercentCaptionLbl)
                    {
                    }
                    column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempVATAmountLine.GetLine(Number);
                        VALVATBase := TempVATAmountLine."Amount Including VAT" / (1 + TempVATAmountLine."VAT %" / 100);
                        VALVATAmount := TempVATAmountLine."Amount Including VAT" - VALVATBase;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempVATAmountLine.Count);
                        Clear(VALVATBase);
                        Clear(VALVATAmount);
                    end;
                }
                dataitem(VATClauseEntryCounter; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(VATClauseVATIdentifier; TempVATAmountLine."VAT Identifier")
                    {
                    }
                    column(VATClauseCode; TempVATAmountLine."VAT Clause Code")
                    {
                    }
                    column(VATClauseDescription; VATClauseText)
                    {
                    }
                    column(VATClauseDescription2; VATClause."Description 2")
                    {
                    }
                    column(VATClauseAmount; TempVATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATClausesCaption; VATClausesCap)
                    {
                    }
                    column(VATClauseVATIdentifierCaption; VATIdentifierLbl)
                    {
                    }
                    column(VATClauseVATAmtCaption; VATAmtCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempVATAmountLine.GetLine(Number);
                        if not VATClause.Get(TempVATAmountLine."VAT Clause Code") then
                            CurrReport.Skip();
                        VATClauseText := VATClause.GetDescriptionText("Issued Fin. Charge Memo Header");
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(VATClause);
                        SetRange(Number, 1, TempVATAmountLine.Count);
                    end;
                }
                dataitem(VATCounterLCY; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ValExchRate; VALExchRate)
                    {
                    }
                    column(ValspecLCYHdr; VALSpecLCYHeader)
                    {
                    }
                    column(ValvatamountLCY; VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(ValvataBaseLCY; VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VatAmtLnVat1; TempVATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(VATPercentCaption1; VATPercentCaption1Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempVATAmountLine.GetLine(Number);

                        VALVATBaseLCY := Round(TempVATAmountLine."Amount Including VAT" / (1 + TempVATAmountLine."VAT %" / 100) / CurrFactor);
                        VALVATAmountLCY := Round(TempVATAmountLine."Amount Including VAT" / CurrFactor - VALVATBaseLCY);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (not GLSetup."Print VAT specification in LCY") or
                           ("Issued Fin. Charge Memo Header"."Currency Code" = '') or
                           (TempVATAmountLine.GetTotalVATAmount() = 0)
                        then
                            CurrReport.Break();

                        SetRange(Number, 1, TempVATAmountLine.Count);
                        Clear(VALVATBaseLCY);
                        Clear(VALVATAmountLCY);

                        if GLSetup."LCY Code" = '' then
                            VALSpecLCYHeader := Text007 + Text008
                        else
                            VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                        CurrExchRate.FindCurrency("Issued Fin. Charge Memo Header"."Posting Date", "Issued Fin. Charge Memo Header"."Currency Code", 1);
                        CustLedgerEntry.SetRange("Customer No.", "Issued Fin. Charge Memo Header"."Customer No.");
                        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Finance Charge Memo");
                        CustLedgerEntry.SetRange("Document No.", "Issued Fin. Charge Memo Header"."No.");
                        if CustLedgerEntry.FindFirst() then begin
                            CustLedgerEntry.CalcFields("Amount (LCY)", Amount);
                            CurrFactor := 1 / (CustLedgerEntry."Amount (LCY)" / CustLedgerEntry.Amount);
                            VALExchRate := StrSubstNo(Text009, Round(1 / CurrFactor * 100, 0.000001), CurrExchRate."Exchange Rate Amount");
                        end else begin
                            CurrFactor := CurrExchRate.ExchangeRate("Issued Fin. Charge Memo Header"."Posting Date",
                                "Issued Fin. Charge Memo Header"."Currency Code");
                            VALExchRate := StrSubstNo(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");
                CurrReport.FormatRegion := Language.GetFormatRegionOrDefault("Format Region");
                FormatAddr.SetLanguageCode("Language Code");
                DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");

                if not CompanyBankAccount.Get("Issued Fin. Charge Memo Header"."Company Bank Account Code") then
                    CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);

                FormatAddr.IssuedFinanceChargeMemo(CustAddr, "Issued Fin. Charge Memo Header");
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "Issued Fin. Charge Memo Header".GetCustomerVATRegistrationNumber() = '' then
                    VATNoText := ''
                else
                    VATNoText := "Issued Fin. Charge Memo Header".GetCustomerVATRegistrationNumberLbl();

                Customer.GetPrimaryContact("Customer No.", PrimaryContact);
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text000, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text001, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text000, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text001, "Currency Code");
                end;
                if not IsReportInPreviewMode() then
                    IncrNoPrinted();
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
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
                    field(ShowInternalInformation; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want the program to record the finance charge memos you print as interactions, and add them to the Interaction Log Entry table.';
                    }
                    field(ShowMIR; ShowMIRLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show MIR Detail';
                        ToolTip = 'Specifies if you want the printed report to show multiple interest rate detail.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo3.Get();
                    CompanyInfo3.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if "Issued Fin. Charge Memo Header".FindSet() then
                repeat
                    SegManagement.LogDocument(
                      19, "Issued Fin. Charge Memo Header"."No.", 0, 0, DATABASE::Customer,
                      "Issued Fin. Charge Memo Header"."Customer No.", '', '', "Issued Fin. Charge Memo Header"."Posting Description", '');

                until "Issued Fin. Charge Memo Header".Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction();
    end;

    var
        PrimaryContact: Record Contact;
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        CompanyBankAccount: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        VATClause: Record "VAT Clause";
        DimSetEntry: Record "Dimension Set Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesSetup: Record "Sales & Receivables Setup";
        Language: Codeunit Language;
        SegManagement: Codeunit SegManagement;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        VATNoText: Text[30];
        ReferenceText: Text[35];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        StartLineNo: Integer;
        EndLineNo: Integer;
        TypeInt: Integer;
        Continue: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CurrFactor: Decimal;
        VALVATBase: Decimal;
        VALVATAmount: Decimal;
        VATClauseText: Text;
        LogInteractionEnable: Boolean;
        TotalAmount: Decimal;
        TotalVatAmount: Decimal;
        ShowMIRLines: Boolean;

        Text000: Label 'Total %1';
        Text001: Label 'Total %1 Incl. VAT';
        Text002: Label 'Page %1';
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        PostingDateCaptionLbl: Label 'Posting Date';
        FinChrgMemoNoCaptionLbl: Label 'Finance Charge Memo No.';
        BankAccNoCaptionLbl: Label 'Account No.';
        IBANCaptionLbl: Label 'IBAN';
        BankNameCaptionLbl: Label 'Bank';
        GiroNoCaptionLbl: Label 'Giro No.';
        PhoneNoCaptionLbl: Label 'Phone No.';
        FinChgMemoCaptionLbl: Label 'Finance Charge Memo';
        HdrDimCaptionLbl: Label 'Header Dimensions';
        DocDateCaption1Lbl: Label 'Document Date';
        AmtInclVATCaptionLbl: Label 'Amount Including VAT';
        VATPercentCaptionLbl: Label 'VAT %';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        VATPercentCaption1Lbl: Label 'VAT %';
        VATClausesCap: Label 'VAT Clause';
        VATIdentifierLbl: Label 'VAT Identifier';
        DueDateCaptionLbl: Label 'Due Date';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATBaseCaptionLbl: Label 'VAT Base';
        TotalCaptionLbl: Label 'Total';
        DoctDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EMailCaptionLbl: Label 'Email';
        ContactPhoneNoLbl: Label 'Contact Phone No.';
        ContactMobilePhoneNoLbl: Label 'Contact Mobile Phone No.';
        ContactEmailLbl: Label 'Contact E-Mail';
#if not CLEAN23
        PlusGiroNoCaptionLbl: Label 'Plus Giro No.';
        BoardOfDirLocCaptionLbl: Label 'Board of Directors Location (registered office)';
        CompHasTaxAssNoteCaptionLbl: Label 'Company has Tax Assessment Note';
#endif

    protected var
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        LogInteraction: Boolean;
        ShowInternalInfo: Boolean;

    protected procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody());
    end;

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Finance Charge Memo") <> '';
    end;

    procedure InitializeRequest(NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
    begin
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;
}

