﻿#if not CLEAN22
codeunit 134153 "Test Intrastat"
{
    Subtype = Test;
    TestPermissions = Disabled;
    ObsoleteState = Pending;
#pragma warning disable AS0072
    ObsoleteTag = '22.0';
#pragma warning restore AS0072
    ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';

    trigger OnRun()
    begin
        // [FEATURE] [Intrastat]
    end;

    var
        Assert: Codeunit Assert;
        LibraryERM: Codeunit "Library - ERM";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibraryRandom: Codeunit "Library - Random";
        FileManagement: Codeunit "File Management";
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";
        LibraryPurchase: Codeunit "Library - Purchase";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryReportDataset: Codeunit "Library - Report Dataset";
        LibraryERMCountryData: Codeunit "Library - ERM Country Data";
        IsInitialized: Boolean;
        ReportedMustBeNoErr: Label 'Reported must be equal to ''No''  in Intrastat Jnl. Batch';
        FileNotCreatedErr: Label 'Intrastat file was not created';
        FileExtenstionTxt: Label '.EDI';
        AdvChecklistErr: Label 'There are one or more errors. For details, see the journal error FactBox.';

    [Test]
    [HandlerFunctions('GetItemLedgerEntriesRequestPageHandler')]
    [Scope('OnPrem')]
    procedure IntrastatAmountIsUnitPriceAfterSalesOrder()
    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        SalesHeader: Record "Sales Header";
        Item: Record Item;
    begin
        // [SCENARIO 362690] Intrastat Journal Line Amount = Item."Unit Price" after Sales Order posting with Quantity = 1
        // [FEATURE] [Sales] [Order]
        Initialize();
        CreateIntrastatJournalTemplateAndBatch(IntrastatJnlBatch, WorkDate());

        // [GIVEN] Item with "Unit Price" = "X"
        LibraryInventory.CreateItemWithTariffNo(Item, CreateTariffNo);

        // [GIVEN] Create Post Sales Order with Quantity = 1
        CreateAndPostSalesDoc(SalesHeader."Document Type"::Order, CreateForeignCustomerNo, Item."No.", 1);

        // [WHEN] Run Intrastat "Get Item Ledger Entries" report
        RunGetItemLedgerEntriesToCreateJnlLines(IntrastatJnlBatch);

        // [THEN] Intrastat Journal Line Amount = "X"
        VerifyIntrastatJnlLine(IntrastatJnlBatch, Item."No.", 1, Item."Unit Price");
    end;

    [Test]
    [HandlerFunctions('GetItemLedgerEntriesRequestPageHandler')]
    [Scope('OnPrem')]
    procedure IntrastatAmountIsUnitPriceAfterSalesReturnOrder()
    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        SalesHeader: Record "Sales Header";
        Item: Record Item;
    begin
        // [SCENARIO 362690] Intrastat Journal Line Amount = Item."Unit Price" after Sales Return Order posting with Quantity = 1
        // [FEATURE] [Sales] [Return Order]
        Initialize();
        CreateIntrastatJournalTemplateAndBatch(IntrastatJnlBatch, WorkDate());

        // [GIVEN] Item with "Unit Price" = "X"
        LibraryInventory.CreateItemWithTariffNo(Item, CreateTariffNo);

        // [GIVEN] Create Post Sales Return Order with Quantity = 1
        CreateAndPostSalesDoc(SalesHeader."Document Type"::"Return Order", CreateForeignCustomerNo, Item."No.", 1);

        // [WHEN] Run Intrastat "Get Item Ledger Entries" report
        RunGetItemLedgerEntriesToCreateJnlLines(IntrastatJnlBatch);

        // [THEN] Intrastat Journal Line Amount = "X"
        VerifyIntrastatJnlLine(IntrastatJnlBatch, Item."No.", 1, Item."Unit Price");
    end;

    [Test]
    [HandlerFunctions('GetItemLedgerEntriesRequestPageHandler')]
    [Scope('OnPrem')]
    procedure IntrastatAmountIsUnitCostAfterPurchaseOrder()
    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        PurchaseHeader: Record "Purchase Header";
        Item: Record Item;
    begin
        // [SCENARIO 362690] Intrastat Journal Line Amount = Item."Last Direct Cost" after Purchase Order posting with Quantity = 1
        // [FEATURE] [Purchase] [Order]
        Initialize();
        CreateIntrastatJournalTemplateAndBatch(IntrastatJnlBatch, WorkDate());

        // [GIVEN] Item with "Last Direct Cost" = "X"
        LibraryInventory.CreateItemWithTariffNo(Item, CreateTariffNo);

        // [GIVEN] Create Post Purchase Order with Quantity = 1
        CreateAndPostPurchDoc(PurchaseHeader."Document Type"::Order, CreateForeignVendorNo, Item."No.", 1);

        // [WHEN] Run Intrastat "Get Item Ledger Entries" report
        RunGetItemLedgerEntriesToCreateJnlLines(IntrastatJnlBatch);

        // [THEN] Known failure. Expected: Intrastat Journal Line Amount = "X". Actual: no Intrastat Journal Line
        asserterror VerifyIntrastatJnlLine(IntrastatJnlBatch, Item."No.", 1, Round(Item."Last Direct Cost", 1));
    end;

    [Test]
    [HandlerFunctions('GetItemLedgerEntriesRequestPageHandler')]
    [Scope('OnPrem')]
    procedure IntrastatAmountIsUnitCostAfterPurchaseReturnOrder()
    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        PurchaseHeader: Record "Purchase Header";
        Item: Record Item;
    begin
        // [SCENARIO 362690] Intrastat Journal Line Amount = Item."Last Direct Cost" after Purchase Return Order posting with Quantity = 1
        // [FEATURE] [Purchase] [Return Order]
        Initialize();
        CreateIntrastatJournalTemplateAndBatch(IntrastatJnlBatch, WorkDate());

        // [GIVEN] Item with "Last Direct Cost" = "X"
        LibraryInventory.CreateItemWithTariffNo(Item, CreateTariffNo);

        // [GIVEN] Create Post Purchase Return Order with Quantity = 1
        CreateAndPostPurchDoc(PurchaseHeader."Document Type"::Order, CreateForeignVendorNo, Item."No.", 1);

        // [WHEN] Run Intrastat "Get Item Ledger Entries" report
        RunGetItemLedgerEntriesToCreateJnlLines(IntrastatJnlBatch);

        // [THEN] Known failure. Expected: Intrastat Journal Line Amount = "X". Actual: no Intrastat Journal Line
        asserterror VerifyIntrastatJnlLine(IntrastatJnlBatch, Item."No.", 1, Round(Item."Last Direct Cost", 1));
    end;

    [Test]
    [Scope('OnPrem')]
    procedure IntrastatJournalStatisticalValueEditable()
    var
        IntrastatJournal: TestPage "Intrastat Journal";
    begin
        // [FEATURE] [UI] [UT]
        // [SCENARIO 331036] Statistical Value is editable on Intrastat Journal page
        Initialize();
        RunIntrastatJournal(IntrastatJournal);
        Assert.IsTrue(IntrastatJournal."Statistical Value".Editable, '');
    end;

    local procedure Initialize()
    var
        IntrastatJnlTemplate: Record "Intrastat Jnl. Template";
    begin
        LibraryVariableStorage.Clear();
        LibraryReportDataset.Reset();
        IntrastatJnlTemplate.DeleteAll(true);

        if IsInitialized then
            exit;

        LibraryERMCountryData.UpdateGeneralLedgerSetup();
        LibraryERMCountryData.UpdateGeneralPostingSetup();
        SetIntrastatCodeOnCountryRegion;
        SetTariffNoOnItems;
        SetCompanyInfoFields;

        IsInitialized := true;
        Commit();
    end;

    local procedure CreateIntrastatJournalTemplateAndBatch(var IntrastatJnlBatch: Record "Intrastat Jnl. Batch"; PostingDate: Date)
    var
        IntrastatJnlTemplate: Record "Intrastat Jnl. Template";
    begin
        LibraryERM.CreateIntrastatJnlTemplate(IntrastatJnlTemplate);
        LibraryERM.CreateIntrastatJnlBatch(IntrastatJnlBatch, IntrastatJnlTemplate.Name);
        IntrastatJnlBatch.Validate("Statistics Period", Format(PostingDate, 0, '<Year,2><Month,2>'));
        IntrastatJnlBatch.Modify(true);
    end;

    local procedure CreateAndPostSalesDoc(DocumentType: Enum "Sales Document Type"; CustomerNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, CustomerNo);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, ItemNo, Quantity);
        LibrarySales.PostSalesDocument(SalesHeader, true, true);
    end;

    local procedure CreateAndPostPurchDoc(DocumentType: Enum "Purchase Document Type"; VendorNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, DocumentType, VendorNo);
        PurchaseHeader.Validate("Vendor Invoice No.", PurchaseHeader."No.");
        PurchaseHeader.Validate("Vendor Cr. Memo No.", PurchaseHeader."No.");
        PurchaseHeader.Modify();

        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, ItemNo, Quantity);
        LibraryPurchase.PostPurchaseDocument(PurchaseHeader, true, true);
    end;

    local procedure CreateForeignCustomerNo(): Code[20]
    var
        Customer: Record Customer;
    begin
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate("Country/Region Code", FindCountryRegionCode);
        Customer.Modify(true);
        exit(Customer."No.");
    end;

    local procedure CreateForeignVendorNo(): Code[20]
    var
        Vendor: Record Vendor;
    begin
        LibraryPurchase.CreateVendor(Vendor);
        Vendor.Validate("Country/Region Code", FindCountryRegionCode);
        Vendor.Modify(true);
        exit(Vendor."No.");
    end;

    local procedure RunIntrastatJournal(var IntrastatJournal: TestPage "Intrastat Journal")
    begin
        IntrastatJournal.OpenEdit;
    end;

    local procedure RunGetItemLedgerEntriesToCreateJnlLines(IntrastatJnlBatch: Record "Intrastat Jnl. Batch")
    var
        IntrastatJournal: TestPage "Intrastat Journal";
    begin
        RunIntrastatJournal(IntrastatJournal);
        LibraryVariableStorage.AssertEmpty;
        LibraryVariableStorage.Enqueue(CalcDate('<-CM>', WorkDate()));
        LibraryVariableStorage.Enqueue(CalcDate('<CM>', WorkDate()));
        IntrastatJournal.GetEntries.Invoke;
        VerifyIntrastatJnlLinesExist(IntrastatJnlBatch);
        IntrastatJournal.Close();
    end;

    local procedure RunIntrastatJournalForm(Type: Option)
    var
        IntrastatJournal: TestPage "Intrastat Journal";
    begin
        RunIntrastatJournal(IntrastatJournal);
        LibraryVariableStorage.AssertEmpty;
        LibraryVariableStorage.Enqueue(Type);
        IntrastatJournal.Form.Invoke;
    end;

    local procedure VerifyIntrastatJnlLinesExist(var IntrastatJnlBatch: Record "Intrastat Jnl. Batch")
    var
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
    begin
        IntrastatJnlLine.SetRange("Journal Template Name", IntrastatJnlBatch."Journal Template Name");
        IntrastatJnlLine.SetRange("Journal Batch Name", IntrastatJnlBatch.Name);
        Assert.IsFalse(IntrastatJnlLine.IsEmpty, 'No Intrastat Journal Lines exist');
    end;

    local procedure FindOrCreateIntrastatTransactionType(): Code[10]
    var
        TransactionType: Record "Transaction Type";
    begin
        TransactionType.Code := Format(LibraryRandom.RandIntInRange(1, 9));
        if not TransactionType.Get(TransactionType.Code) then
            TransactionType.Insert();
        exit(TransactionType.Code);
    end;

    local procedure FindOrCreateIntrastatTransportMethod(): Code[10]
    begin
        exit(LibraryUtility.FindOrCreateCodeRecord(DATABASE::"Transport Method"));
    end;

    local procedure FindCountryRegionCode(): Code[10]
    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
    begin
        CompanyInfo.Get();
        with CountryRegion do begin
            SetFilter(Code, '<>%1', CompanyInfo."Country/Region Code");
            SetFilter("Intrastat Code", '<>%1', '');
            FindFirst();
            exit(Code);
        end;
    end;

    local procedure FindOrCreateIntrastatTransactionSpecification(): Code[10]
    begin
        exit(LibraryUtility.FindOrCreateCodeRecord(DATABASE::"Transaction Specification"));
    end;

    local procedure CreateTariffNo() TariffNo: Code[8]
    var
        TariffNumber: Record "Tariff Number";
        TempTariffNo: Code[20];
    begin
        // TariffNo must be length 8 and unique
        TempTariffNo := LibraryUtility.GenerateGUID();
        TariffNo := CopyStr(TempTariffNo, StrLen(TempTariffNo) - MaxStrLen(TariffNo) + 1);
        TariffNumber.Init();
        TariffNumber.Validate("No.", TariffNo);
        TariffNumber.Insert(true);
        exit(TariffNumber."No.");
    end;

    local procedure GetIntrastatFilenames(var Filepath: Text; var FilenameSales: Text; var FilenamePurchase: Text; IntrastatJnlBatch: Record "Intrastat Jnl. Batch")
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        Filepath := FileManagement.GetDirectoryName(FileManagement.ServerTempFileName(FileExtenstionTxt));
        FilenameSales := Filepath + '\' + CopyStr(CompanyInfo."Sales Authorized No.", 1, 4) +
          IntrastatJnlBatch."Statistics Period" + FileExtenstionTxt;
        FilenamePurchase := Filepath + '\' + CopyStr(CompanyInfo."Purch. Authorized No.", 1, 4) +
          IntrastatJnlBatch."Statistics Period" + FileExtenstionTxt;
    end;

    local procedure SetIntrastatCodeOnCountryRegion()
    var
        CountryRegion: Record "Country/Region";
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        CountryRegion.Get(CompanyInformation."Country/Region Code");
        CountryRegion.Validate("Intrastat Code", CountryRegion.Code);
        CountryRegion.Modify(true);
    end;

    local procedure SetTariffNoOnItems()
    var
        Item: Record Item;
        TariffNumber: Record "Tariff Number";
    begin
        TariffNumber.FindFirst();
        Item.SetRange("Tariff No.", '');
        if not Item.IsEmpty() then
            Item.ModifyAll("Tariff No.", TariffNumber."No.");
    end;

    local procedure SetCompanyInfoFields()
    var
        CompanyInfo: Record "Company Information";
        ControlNo: Code[20];
    begin
        CompanyInfo.Get();
        CompanyInfo.Validate("Statistic No.",
          LibraryUtility.GenerateRandomCode(CompanyInfo.FieldNo("Statistic No."), DATABASE::"Company Information"));
        ControlNo := LibraryUtility.GenerateRandomCode(CompanyInfo.FieldNo("Control No."), DATABASE::"Company Information");
        CompanyInfo.Validate("Control No.", CopyStr(ControlNo, StrLen(ControlNo) - 7)); // must be 8 chars long
        CompanyInfo.Modify(true);
    end;

    local procedure VerifyIntrastatJnlLine(IntrastatJnlBatch: Record "Intrastat Jnl. Batch"; ItemNo: Code[20]; ExpectedQty: Decimal; ExpectedAmount: Decimal)
    var
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
    begin
        with IntrastatJnlLine do begin
            SetRange("Journal Template Name", IntrastatJnlBatch."Journal Template Name");
            SetRange("Journal Batch Name", IntrastatJnlBatch.Name);
            SetRange("Item No.", ItemNo);
            FindFirst();
            Assert.AreEqual(ExpectedQty, Quantity, FieldCaption(Quantity));
            Assert.AreEqual(ExpectedAmount, Amount, FieldCaption(Amount));
        end;
    end;

    local procedure VerifyTestfieldChecklistError(FieldName: Text)
    begin
        Assert.ExpectedErrorCode('TestField');
        Assert.ExpectedError(FieldName);
    end;

    local procedure VerifyAdvanvedChecklistError(IntrastatJnlLine: Record "Intrastat Jnl. Line"; FieldName: Text)
    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        ErrorMessage: Record "Error Message";
    begin
        Assert.ExpectedErrorCode('Dialog');
        Assert.ExpectedError(AdvChecklistErr);
        VerifyBatchError(IntrastatJnlLine, FieldName);
    end;

    local procedure VerifyBatchError(IntrastatJnlLine: Record "Intrastat Jnl. Line"; FieldName: Text)
    var
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
        ErrorMessage: Record "Error Message";
    begin
        IntrastatJnlBatch."Journal Template Name" := IntrastatJnlLine."Journal Template Name";
        IntrastatJnlBatch.Name := IntrastatJnlLine."Journal Batch Name";
        ErrorMessage.SetContext(IntrastatJnlBatch);
        Assert.AreEqual(1, ErrorMessage.ErrorMessageCount(ErrorMessage."Message Type"::Error), '');
        ErrorMessage.FindFirst();
        Assert.ExpectedMessage(FieldName, ErrorMessage."Message");
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure GetItemLedgerEntriesRequestPageHandler(var GetItemLedgerEntriesReqPage: TestRequestPage "Get Item Ledger Entries")
    var
        StartDate: Variant;
        EndDate: Variant;
    begin
        LibraryVariableStorage.Dequeue(StartDate);
        LibraryVariableStorage.Dequeue(EndDate);
        GetItemLedgerEntriesReqPage.StartingDate.SetValue(StartDate);
        GetItemLedgerEntriesReqPage.EndingDate.SetValue(EndDate);
        GetItemLedgerEntriesReqPage."Cost Regulation %".SetValue(0);
        GetItemLedgerEntriesReqPage.OK.Invoke;
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure IntratstatJnlFormReqPageHandler(var IntrastatFormReqPage: TestRequestPage "Intrastat - Form AT")
    var
        Type: Variant;
    begin
        LibraryVariableStorage.Dequeue(Type);
        IntrastatFormReqPage."Intrastat Jnl. Line".SetFilter(Type, Format(Type));
        IntrastatFormReqPage.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;
}

#endif