codeunit 144028 "UT REP UKGEN"
{
    // // [FEATURE] [UI] [GB Reports]
    // Includes UKGEN test cases:
    // 
    //  1 - 2. Test to verify the Dimension Text after running Report, Purchase/Sales - Credit Memo GB.
    //  3 - 6. Test to verify the Dimension Text after running Report Sales - Quote GB, Blanket Sales Order GB and Order Confirmation GB.
    //  7 - 8. Test to verify the Dimension Text after running Report Order GB and Blanket Purchase Order GB.
    //  8 - 9. Test to verify Archive Document field on Order GB when Archive Quotes & Orders is True/False in Purchase & Payables setup.
    // 10 - 11. Test to verify Archive Document field on Order Confirmation GB when Archive Quotes & Orders is True/False in Sales & Receivable setup.
    // 
    //  Covers Test Cases for WI - 340223
    //  --------------------------------------------------------------------------------------------------------------------------------------------
    //  Test Function Name                                                                                                                 TFS ID
    //  --------------------------------------------------------------------------------------------------------------------------------------------
    //  OnAfterGetRecordDimLoopPurchaseCreditMemoGB, OnAfterGetRecordDimLoopSalesCreditMemoGB                                              159501
    //  OnAfterGetRecordDimLoopSalesInvoiceGB                                                                                              159503
    //  OnAfterGetRecordDimLoopSalesQuoteGB, OnAfterGetRecordDimLoopOrderConfirmationGB, OnAfterGetRecordDimLoopBlanketSalesOrderGB        159506,159505
    //  OnAfterGetRecordDimLoopOrderGB                                                                                                     159502
    //  OnAfterGetRecordDimLoopBlanketPurchaseOrderGB                                                                                      159504
    // 
    //  Covers Test Cases for Bug Id - 74034
    //  --------------------------------------------------------------------------------------------------------------------------------------------
    //  Test Function Name                                                                                                                 TFS ID
    //  --------------------------------------------------------------------------------------------------------------------------------------------
    //  OrderGBWithArchiveTrue,OrderGBWithArchiveFalse,OrderConfirmationGBWithArchiveTrue,OrderConfirmationGBWithArchiveFalse

    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
    end;

    var
        LibraryReportDataset: Codeunit "Library - Report Dataset";
        LibraryUTUtility: Codeunit "Library UT Utility";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        IsInitialized: Boolean;
        DimensionFilterCap: Label '%1 %2';
        DimensionTextCap: Label 'DimText';

    [Test]
    [HandlerFunctions('PurchaseCreditMemoGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopPurchaseCreditMemoGB()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10578, Purchase - Credit Memo GB.
        Initialize();

        // [GIVEN] Setup.
        CreatePostedPurchaseCreditMemoWithDimension(DimensionSetEntry);

        // [WHEN] Run and verify the Dimension Text after running Report, Purchase - Credit Memo GB.
        RunReportAndVerifyDimension(
          REPORT::"Purchase - Credit Memo GB", DimensionTextCap,
          StrSubstNo(DimensionFilterCap, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code"));
    end;

    [Test]
    [HandlerFunctions('SalesCreditMemoGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopSalesCreditMemoGB()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10573, Sales - Credit Memo GB.
        Initialize();

        // [GIVEN] Setup.
        CreatePostedSalesCreditMemoWithDimension(DimensionSetEntry);

        // [WHEN] Run and verify the Dimension Text after running Report, Sales - Credit Memo GB.
        RunReportAndVerifyDimension(
          REPORT::"Sales - Credit Memo GB", DimensionTextCap,
          StrSubstNo(DimensionFilterCap, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code"));
    end;

    [Test]
    [HandlerFunctions('SalesInvoiceGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopSalesInvoiceGB()
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10572, Sales - Invoice GB.
        Initialize();

        // [GIVEN] Setup.
        CreatePostedSalesInvoiceWithDimension(DimensionSetEntry);

        // [WHEN] Run and verify the Dimension Text after running Report, Sales - Invoice GB.
        RunReportAndVerifyDimension(
          REPORT::"Sales - Invoice GB", DimensionTextCap,
          StrSubstNo(DimensionFilterCap, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code"));
    end;

    [Test]
    [HandlerFunctions('SalesdQuoteGBRequestPageHandler,ConfirmHandlerFALSE')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopSalesQuoteGB()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10570, Sales - Quote GB.
        OnAfterGetRecordDimLoopSalesOrderReport(SalesHeader."Document Type"::Quote, REPORT::"Sales - Quote GB")
    end;

    [Test]
    [HandlerFunctions('BlanketSalesOrderGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopBlanketSalesOrderGB()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10572, Blanket Sales Order GB.
        OnAfterGetRecordDimLoopSalesOrderReport(SalesHeader."Document Type"::"Blanket Order", REPORT::"Blanket Sales Order GB")
    end;

    [Test]
    [HandlerFunctions('OrderConfirmationGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopOrderConfirmationGB()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10571, Order Confirmation GB.
        OnAfterGetRecordDimLoopSalesOrderReport(SalesHeader."Document Type"::Order, REPORT::"Order Confirmation GB")
    end;

    local procedure OnAfterGetRecordDimLoopSalesOrderReport(DocumentType: Enum "Sales Document Type"; ReportID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        // Setup.
        Initialize();
        CreateSalesDocumentWithDimension(DimensionSetEntry, DocumentType);

        // Run and verify the Dimension Text after running Report.
        RunReportAndVerifyDimension(
          ReportID, DimensionTextCap,
          StrSubstNo(DimensionFilterCap, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code"));
    end;

    [Test]
    [HandlerFunctions('OrderGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopOrderGB()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10576, Order GB.
        PurchaseOrderWithDimension(PurchaseHeader."Document Type"::Order, REPORT::"Order GB", DimensionTextCap, DimensionFilterCap);
    end;

    [Test]
    [HandlerFunctions('BlanketPurchaseOrderGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordDimLoopBlanketPurchaseOrderGB()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        // [SCENARIO] validate the DimensionLoop1 - OnAfterGetRecord trigger of Report ID: 10579, Blanket Purchase Order GB.
        PurchaseOrderWithDimension(
          PurchaseHeader."Document Type"::"Blanket Order", REPORT::"Blanket Purchase Order GB", 'DimText_DimensionLoop1', '%1 - %2');
    end;

    local procedure PurchaseOrderWithDimension(DocumentType: Enum "Purchase Document Type"; ReportID: Integer; ElementName: Text; ExpectedNode: Text)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        // Setup.
        Initialize();
        CreatePurchaseDocumentWithDimension(DimensionSetEntry, DocumentType);

        // Run and verify the Dimension Text after running Report Blanket Purchase Order GB.
        RunReportAndVerifyDimension(
          ReportID, ElementName, StrSubstNo(ExpectedNode, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code"));
    end;

    [Test]
    [HandlerFunctions('OrderGBReqPageHandler')]
    [Scope('OnPrem')]
    procedure OrderGBWithArchiveTrue()
    begin
        // [SCENARIO] verify Archive Document field on Order GB when Archive Quotes & Orders is True in Purchase & Payables setup.
        Initialize();
        OrderGBWithArchive(true);
    end;

    [Test]
    [HandlerFunctions('OrderGBReqPageHandler')]
    [Scope('OnPrem')]
    procedure OrderGBWithArchiveFalse()
    begin
        // [SCENARIO] verify Archive Document field on Order GB when Archive Quotes & Orders is False in Purchase & Payables setup.
        Initialize();
        OrderGBWithArchive(false);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmationGBReqPageHandler')]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBWithArchiveTrue()
    begin
        // [SCENARIO] verify Archive Document field on Order Confirmation GB when Archive Quotes & Orders is True in Sales & Receivable setup.
        Initialize();
        OrderConfirmationGBWithArchive(true);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmationGBReqPageHandler')]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBWithArchiveFalse()
    begin
        // [SCENARIO] verify Archive Document field on Order Confirmation GB when Archive Quotes & Orders is False in Sales & Receivable setup.
        Initialize();
        OrderConfirmationGBWithArchive(false);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmationGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBFormatAddressWithBilltoPostCode()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO 122292] Print Order Confirmation GB report when Address information is detailed with Bill-to Post Code
        Initialize();

        // [GIVEN] Sales Order with "Bill-to Post Code" = 'X'
        CreateSalesDocumentWithFormatAddress(SalesHeader, SalesHeader."Document Type"::Order);
        SalesHeader."Bill-to Post Code" := LibraryUTUtility.GetNewCode();
        SalesHeader.Modify();
        Commit();

        // [WHEN] Run Order Confirmation GB Report
        REPORT.Run(REPORT::"Order Confirmation GB");

        // [THEN] Address Element filled with "Bill-to Post Code" = 'X'
        VerifyElementValue('CustAddr1', SalesHeader."Bill-to Post Code" + ' ');
    end;

    [Test]
    [HandlerFunctions('OrderConfirmationGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBFormatAddressWithSelltoPostCode()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO 122292] Print Order Confirmation GB report when Address information is detailed with Ship-to Post Code
        Initialize();

        // [GIVEN] Sales Order with "Ship-to Post Code" = 'X'
        CreateSalesDocumentWithFormatAddress(SalesHeader, SalesHeader."Document Type"::Order);
        SalesHeader."Ship-to Post Code" := LibraryUTUtility.GetNewCode();
        SalesHeader.Modify();
        Commit();

        // [WHEN] Run Order Confirmation GB Report
        REPORT.Run(REPORT::"Order Confirmation GB");

        // [THEN] Address Element filled with "Ship-to Post Code" = 'X'
        VerifyElementValue('ShipToAddr1', SalesHeader."Ship-to Post Code" + ' ');
    end;

    [Test]
    [HandlerFunctions('OrderConfirmationGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBFormatAddressCompanyInfo()
    var
        SalesHeader: Record "Sales Header";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        PostCode: Code[20];
    begin
        // [SCENARIO 122292] Print Order Confirmation GB report if G/L Setup with "Local Address Format" = "Post Code+City"
        Initialize();

        // [GIVEN] G/L Setup with "Local Address Format" = "Post Code+City", "Company Information"."Post Code" = 'X'
        PostCode := LibraryUTUtility.GetNewCode();
        UpdateCompanyInfoPostCode(PostCode);
        UpdateGLSetupAddressFormat(GeneralLedgerSetup."Local Address Format"::"Post Code+City");

        // [GIVEN] Sales Order
        MockSalesDocument(SalesHeader, SalesHeader."Document Type"::Order);
        LibraryVariableStorage.Enqueue(SalesHeader."No.");
        Commit();

        // [WHEN] Run Order Confirmation GB Report
        REPORT.Run(REPORT::"Order Confirmation GB");

        // [THEN] Company Address Element filled with "Post Code" = 'X'
        CompanyInformation.Get();
        VerifyElementValue('CompanyAddr4', PostCode + ' ' + CompanyInformation.City);
    end;

    [Test]
    [HandlerFunctions('BlanketSalesOrderGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure BlanketSalesOrderGBFormatAddressWithPostCodes()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [FEATURE] [Sales]
        // [SCENARIO 375372] Print Blanket Sales Order GB report when Address information is detailed with Bill-to Post Code
        Initialize();

        // [GIVEN] Blanket Sales Order with "Bill-to Post Code" = 'X', "Ship-to Post Code" = 'Y'
        CreateSalesDocumentWithFormatAddress(SalesHeader, SalesHeader."Document Type"::"Blanket Order");
        SalesHeader."Bill-to Post Code" := LibraryUTUtility.GetNewCode();

        SalesHeader."Ship-to Post Code" := LibraryUTUtility.GetNewCode();

        SalesHeader.Modify();
        Commit();

        // [WHEN] Run Blanket Sales Order GB Report
        REPORT.Run(REPORT::"Blanket Sales Order GB");

        // [THEN] Address Element filled with "Bill-to Post Code" = 'X'
        VerifyElementValue('CustAddr1', SalesHeader."Bill-to Post Code" + ' ');
        // [THEN] Address Element filled with "Ship-to Post Code" = 'Y'
        LibraryReportDataset.AssertElementWithValueExists('ShipToAddr1', SalesHeader."Ship-to Post Code" + ' ');
    end;

    [Test]
    [HandlerFunctions('BlanketSalesOrderGBRequestPageHandler')]
    [Scope('OnPrem')]
    procedure BlanketSalesOrderGBFormatAddressCompanyInfo()
    var
        SalesHeader: Record "Sales Header";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        PostCode: Code[20];
    begin
        // [FEATURE] [Sales]
        // [SCENARIO 375372] Print Blanket Sales Order GB report if G/L Setup with "Local Address Format" = "Post Code+City"
        Initialize();

        // [GIVEN] G/L Setup with "Local Address Format" = "Post Code+City", "Company Information"."Post Code" = 'X'
        PostCode := LibraryUTUtility.GetNewCode();
        UpdateCompanyInfoPostCode(PostCode);
        UpdateGLSetupAddressFormat(GeneralLedgerSetup."Local Address Format"::"Post Code+City");

        // [GIVEN] Blanket Sales Order
        MockSalesDocument(SalesHeader, SalesHeader."Document Type"::"Blanket Order");
        LibraryVariableStorage.Enqueue(SalesHeader."No.");
        Commit();

        // [WHEN] Run Order Confirmation GB Report
        REPORT.Run(REPORT::"Blanket Sales Order GB");

        // [THEN] Company Address Element filled with "Post Code" = 'X'
        CompanyInformation.Get();
        VerifyElementValue('CompanyAddr4', PostCode + ' ' + CompanyInformation.City);
    end;

    local procedure Initialize()
    begin
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
        LibrarySetupStorage.Save(DATABASE::"General Ledger Setup");
        LibrarySetupStorage.Save(DATABASE::"Company Information");
        LibrarySetupStorage.Save(DATABASE::"Sales & Receivables Setup");
        LibrarySetupStorage.Save(DATABASE::"Purchases & Payables Setup");
    end;

    local procedure CreateDimensionSetEntry(var DimensionSetEntry: Record "Dimension Set Entry")
    var
        DimensionValue: Record "Dimension Value";
        DimensionSetEntry2: Record "Dimension Set Entry";
    begin
        DimensionValue."Dimension Code" := LibraryUTUtility.GetNewCode();
        DimensionValue.Code := LibraryUTUtility.GetNewCode();
        DimensionValue.Insert();

        DimensionSetEntry2.FindLast();
        DimensionSetEntry."Dimension Set ID" := DimensionSetEntry2."Dimension Set ID" + 1;
        DimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
        DimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
        DimensionSetEntry.Insert();
    end;

    local procedure CreatePurchaseDocumentWithDimension(var DimensionSetEntry: Record "Dimension Set Entry"; DocumentType: Enum "Sales Document Type")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        CreateDimensionSetEntry(DimensionSetEntry);
        PurchaseHeader."Document Type" := DocumentType;
        PurchaseHeader."No." := LibraryUTUtility.GetNewCode();
        PurchaseHeader."Dimension Set ID" := DimensionSetEntry."Dimension Set ID";
        PurchaseHeader.Insert();
        PurchaseLine."Document Type" := DocumentType;
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."No." := LibraryUTUtility.GetNewCode();
        PurchaseLine.Insert();

        // Enqueue value for use in OrderGBRequestPageHandler and BlanketPurchaseOrderGBRequestPageHandler.
        LibraryVariableStorage.Enqueue(PurchaseHeader."No.");
    end;

    local procedure CreatePostedPurchaseCreditMemoWithDimension(var DimensionSetEntry: Record "Dimension Set Entry")
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        CreateDimensionSetEntry(DimensionSetEntry);
        PurchCrMemoHdr."No." := LibraryUTUtility.GetNewCode();
        PurchCrMemoHdr."Dimension Set ID" := DimensionSetEntry."Dimension Set ID";
        PurchCrMemoHdr.Insert();
        PurchCrMemoLine."Document No." := PurchCrMemoHdr."No.";
        PurchCrMemoLine."No." := LibraryUTUtility.GetNewCode();
        PurchCrMemoLine.Insert();
        LibraryVariableStorage.Enqueue(PurchCrMemoHdr."No.");  // Enqueue value for use in PurchaseCreditMemoGBRequestPageHandler.
    end;

    local procedure CreatePostedSalesCreditMemoWithDimension(var DimensionSetEntry: Record "Dimension Set Entry")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        CreateDimensionSetEntry(DimensionSetEntry);
        SalesCrMemoHeader."No." := LibraryUTUtility.GetNewCode();
        SalesCrMemoHeader."Dimension Set ID" := DimensionSetEntry."Dimension Set ID";
        SalesCrMemoHeader.Insert();
        SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
        SalesCrMemoLine."No." := LibraryUTUtility.GetNewCode();
        SalesCrMemoLine.Insert();
        LibraryVariableStorage.Enqueue(SalesCrMemoHeader."No.");  // Enqueue value for use in SalesCreditMemoGBRequestPageHandler.
    end;

    local procedure CreatePostedSalesInvoiceWithDimension(var DimensionSetEntry: Record "Dimension Set Entry")
    var
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        CreateDimensionSetEntry(DimensionSetEntry);
        Customer."No." := LibraryUTUtility.GetNewCode();
        Customer.Insert();
        SalesInvoiceHeader."No." := LibraryUTUtility.GetNewCode();
        SalesInvoiceHeader."Bill-to Customer No." := Customer."No.";
        SalesInvoiceHeader."Dimension Set ID" := DimensionSetEntry."Dimension Set ID";
        SalesInvoiceHeader.Insert();
        SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
        SalesInvoiceLine."No." := LibraryUTUtility.GetNewCode();
        SalesInvoiceLine.Insert();
        LibraryVariableStorage.Enqueue(SalesInvoiceHeader."No.");  // Enqueue value for use in SalesInvoiceGBRequestPageHandler.
    end;

    local procedure CreateSalesDocumentWithDimension(var DimensionSetEntry: Record "Dimension Set Entry"; DocumentType: Enum "Sales Document Type")
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateDimensionSetEntry(DimensionSetEntry);
        MockSalesDocument(SalesHeader, DocumentType);
        SalesHeader."Dimension Set ID" := DimensionSetEntry."Dimension Set ID";
        SalesHeader.Modify();

        // Enqueue value for use in SalesdQuoteGBRequestPageHandler, BlanketSalesOrderGBRequestPageHandler and OrderConfirmationGBRequestPageHandler.
        LibraryVariableStorage.Enqueue(SalesHeader."No.");
    end;

    local procedure CreateSalesDocumentWithFormatAddress(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type")
    begin
        MockSalesDocument(SalesHeader, DocumentType);
        SalesHeader."Bill-to Country/Region Code" := MockCountryRegionWithFormatAddress();
        SalesHeader."Ship-to Country/Region Code" := MockCountryRegionWithFormatAddress();
        SalesHeader.Modify();

        // Enqueue value for use in SalesdQuoteGBRequestPageHandler, BlanketSalesOrderGBRequestPageHandler and OrderConfirmationGBRequestPageHandler.
        LibraryVariableStorage.Enqueue(SalesHeader."No.");
    end;

    local procedure MockSalesDocument(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type")
    begin
        MockSalesHeader(SalesHeader, DocumentType);
        MockSalesLine(SalesHeader."Document Type", SalesHeader."No.");
    end;

    local procedure MockSalesHeader(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type")
    begin
        SalesHeader."Document Type" := DocumentType;
        SalesHeader."No." := LibraryUTUtility.GetNewCode();
        SalesHeader.Insert();
    end;

    local procedure MockSalesLine(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20])
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
            "Document Type" := DocumentType;
            "Document No." := DocumentNo;
            Type := Type::Item;
            "No." := LibraryUTUtility.GetNewCode();
            Insert();
        end;
    end;

    local procedure MockCountryRegionWithFormatAddress(): Code[10]
    var
        CountryRegion: Record "Country/Region";
    begin
        with CountryRegion do begin
            Init();
            Code := LibraryUTUtility.GetNewCode10();
            "Address Format" := "Address Format"::"Post Code+City";
            Insert();
            exit(Code);
        end;
    end;

    local procedure OrderGBWithArchive(ArchiveQuotesAndOrders: Boolean)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        // Setup: Update Purchases and Payables Setup.
        Initialize();
        PurchasesPayablesSetup.Get();
        UpdatePurchasesPayablesSetup(ArchiveQuotesAndOrders);
        LibraryVariableStorage.Enqueue(ArchiveQuotesAndOrders);
        Commit();

        // Exercise: Run Oder GB Report.
        REPORT.Run(REPORT::"Order GB");

        // Verify: Verify Archive Document field on Order GB Report using OrderGBReqPageHandler.
    end;

    local procedure OrderConfirmationGBWithArchive(ArchiveQuotesAndOrders: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // Setup: Update Sales and Receivables Setup.
        SalesReceivablesSetup.Get();
        UpdateSalesReceivableSetup(ArchiveQuotesAndOrders);
        LibraryVariableStorage.Enqueue(ArchiveQuotesAndOrders);
        Commit();

        // Exercise: Run Oder Confirmation GB Report.
        REPORT.Run(REPORT::"Order Confirmation GB");

        // Verify: Verify Archive Document field on Order Confimation GB Report using OrderConfirmationGBReqPageHandler.
    end;

    local procedure RunReportAndVerifyDimension(ReportID: Integer; ElementName: Text; ExpectedValue: Variant)
    begin
        // Exercise.
        Commit();  // Used explicit commit.
        REPORT.Run(ReportID);

        // Verify: Verify the Dimension Text after running Report.
        LibraryReportDataset.LoadDataSetFile();
        LibraryReportDataset.AssertElementWithValueExists(ElementName, ExpectedValue);
    end;

    local procedure UpdatePurchasesPayablesSetup(ArchiveOrders: Boolean)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        with PurchasesPayablesSetup do begin
            Get();
            "Archive Orders" := ArchiveOrders;
            Modify();
        end;
    end;

    local procedure UpdateSalesReceivableSetup(ArchiveOrders: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesReceivablesSetup do begin
            Get();
            "Archive Orders" := ArchiveOrders;
            Modify();
        end;
    end;

    local procedure UpdateGLSetupAddressFormat(AddressFormat: Option)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        with GeneralLedgerSetup do begin
            Get();
            "Local Address Format" := AddressFormat;
            Modify();
        end;
    end;

    local procedure UpdateCompanyInfoPostCode(PostCode: Code[20])
    var
        CompanyInformation: Record "Company Information";
    begin
        with CompanyInformation do begin
            Get();
            "Post Code" := PostCode;
            Modify();
        end;
    end;

    local procedure VerifyElementValue(ElementName: Text; ExpectedValue: Variant)
    begin
        LibraryReportDataset.LoadDataSetFile();
        LibraryReportDataset.AssertElementWithValueExists(ElementName, ExpectedValue);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure BlanketPurchaseOrderGBRequestPageHandler(var PurchaseBlanketOrderGB: TestRequestPage "Blanket Purchase Order GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        PurchaseBlanketOrderGB."Purchase Header".SetFilter("No.", No);
        PurchaseBlanketOrderGB.ShowInternalInformation.SetValue(true);
        PurchaseBlanketOrderGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure BlanketSalesOrderGBRequestPageHandler(var BlanketSalesOrderGB: TestRequestPage "Blanket Sales Order GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        BlanketSalesOrderGB."Sales Header".SetFilter("No.", No);
        BlanketSalesOrderGB.ShowInternalInformation.SetValue(true);
        BlanketSalesOrderGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure OrderGBRequestPageHandler(var OrderGB: TestRequestPage "Order GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        OrderGB."Purchase Header".SetFilter("No.", No);
        OrderGB.ShowInternalInformation.SetValue(true);
        OrderGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure PurchaseCreditMemoGBRequestPageHandler(var PurchaseCreditMemoGB: TestRequestPage "Purchase - Credit Memo GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        PurchaseCreditMemoGB."Purch. Cr. Memo Hdr.".SetFilter("No.", No);
        PurchaseCreditMemoGB.ShowInternalInformation.SetValue(true);
        PurchaseCreditMemoGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBRequestPageHandler(var OrderConfirmationGB: TestRequestPage "Order Confirmation GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        OrderConfirmationGB."Sales Header".SetFilter("No.", No);
        OrderConfirmationGB.ShowInternalInformation.SetValue(true);
        OrderConfirmationGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure SalesdQuoteGBRequestPageHandler(var SalesQuoteGB: TestRequestPage "Sales - Quote GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        SalesQuoteGB."Sales Header".SetFilter("No.", No);
        SalesQuoteGB.ShowInternalInformation.SetValue(true);
        SalesQuoteGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure SalesInvoiceGBRequestPageHandler(var SalesInvoiceGB: TestRequestPage "Sales - Invoice GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        SalesInvoiceGB."Sales Invoice Header".SetFilter("No.", No);
        SalesInvoiceGB.ShowInternalInformation.SetValue(true);
        SalesInvoiceGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure SalesCreditMemoGBRequestPageHandler(var SalesCreditMemoGB: TestRequestPage "Sales - Credit Memo GB")
    var
        No: Variant;
    begin
        LibraryVariableStorage.Dequeue(No);
        SalesCreditMemoGB."Sales Cr.Memo Header".SetFilter("No.", No);
        SalesCreditMemoGB.ShowInternalInformation.SetValue(true);
        SalesCreditMemoGB.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [ConfirmHandler]
    [Scope('OnPrem')]
    procedure ConfirmHandlerFALSE(Message: Text[1024]; var Reply: Boolean)
    begin
        Reply := false;
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure OrderGBReqPageHandler(var OrderGB: TestRequestPage "Order GB")
    var
        ArchiveDocument: Variant;
    begin
        LibraryVariableStorage.Dequeue(ArchiveDocument);
        OrderGB.ArchiveDocument.AssertEquals(ArchiveDocument);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure OrderConfirmationGBReqPageHandler(var OrderConfirmationGB: TestRequestPage "Order Confirmation GB")
    var
        ArchiveDocument: Variant;
    begin
        LibraryVariableStorage.Dequeue(ArchiveDocument);
        OrderConfirmationGB.ArchiveDocument.AssertEquals(ArchiveDocument);
    end;
}
