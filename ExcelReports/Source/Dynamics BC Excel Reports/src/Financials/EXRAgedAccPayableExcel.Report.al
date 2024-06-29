// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.Finance.ExcelReports;

using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;

report 4403 "EXR Aged Acc Payable Excel"
{
    ApplicationArea = All;
    Caption = 'Aged Accounts Payable Excel (Preview)';
    DataAccessIntent = ReadOnly;
    DefaultRenderingLayout = AgedAccountsPayableExcel;
    ExcelLayoutMultipleDataSheets = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    MaximumDatasetSize = 1000000;

    dataset
    {
        dataitem(VendorAgingData; Vendor)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Vendor Posting Group", "Currency Code";
            PrintOnlyIfDetail = true;

            column(VendorNumber; VendorAgingData."No.")
            {
                IncludeCaption = true;
            }
            column(VendorName; VendorAgingData.Name)
            {
                IncludeCaption = true;
            }

            dataitem(AgingData; "EXR Aging Report Buffer")
            {
                DataItemTableView = sorting("Vendor Source No.");
                DataItemLink = "Vendor Source No." = field("No.");

                column(PeriodStart;
                "Period Start Date")
                {
                    IncludeCaption = true;
                }
                column(PeriodEnd; "Period End Date")
                {
                    IncludeCaption = true;
                }
                column(RemainingAmount; "Remaining Amount")
                {
                    IncludeCaption = true;
                }
                column(OriginalAmount; "Original Amount")
                {
                    IncludeCaption = true;
                }
                column(RemainingAmountLCY; "Remaining Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(OriginalAmountLCY; "Original Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(Dimension1Code; "Dimension 1 Code")
                {
                    IncludeCaption = true;
                }
                column(Dimension2Code; "Dimension 2 Code")
                {
                    IncludeCaption = true;
                }
                column(CurrencyCode; CurrencyCodeDisplayCode)
                {
                }
                column(PostingDate; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(DocumentDate; "Document Date")
                {
                    IncludeCaption = true;
                }
                column(DueDate; "Due Date")
                {
                    IncludeCaption = true;
                }
                column(EntryNo; "Entry No.")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(AgingData);
                AgingData.DeleteAll();
                InsertAgingData(VendorAgingData);

                if AgingData."Currency Code" = '' then
                    CurrencyCodeDisplayCode := GeneralLedgerSetup.GetCurrencyCode('')
                else
                    CurrencyCodeDisplayCode := AgingData."Currency Code";
            end;
        }

        dataitem(Dimension1; "Dimension Value")
        {
            DataItemTableView = sorting("Code") where("Global Dimension No." = const(1));

            column(Dim1Code; Dimension1."Code")
            {
                IncludeCaption = true;
            }
            column(Dim1Name; Dimension1.Name)
            {
                IncludeCaption = true;
            }

            trigger OnPreDataItem()
            begin
                VendorAgingData.CopyFilter("Global Dimension 1 Filter", Dimension1.Code);
            end;
        }
        dataitem(Dimension2; "Dimension Value")
        {
            DataItemTableView = sorting("Code") where("Global Dimension No." = const(2));

            column(Dim2Code; Dimension2."Code")
            {
                IncludeCaption = true;
            }
            column(Dim2Name; Dimension2.Name)
            {
                IncludeCaption = true;
            }

            trigger OnPreDataItem()
            begin
                VendorAgingData.CopyFilter("Global Dimension 2 Filter", Dimension2.Code);
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
                    field(AgedAsOfOption; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(AgingbyOption; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the aging will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLengthOption; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is sent to the report. For example, enter "-1M" for one month, "-30D" for thirty days, "-3Q" for three quarters, or "-5Y" for five years.';
                    }
                    field(PeriodCountOption; PeriodCount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Count';
                        ToolTip = 'Specifies the number of periods for which data is sent to the report.';
                    }
                    field("Skip Zero Balance Vendors"; SkipZeroBalanceVendors)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Skip Vendors with Zero Balance';
                        ToolTip = 'Specifies if you want to skip Vendors with a zero balance in the report.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if EndingDate = 0D then
                EndingDate := WorkDate();
            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '<-1M>');

            if not GeneralLedgerSetup.Get() then
#pragma warning disable AA0205
                GeneralLedgerSetup.Insert();
#pragma warning restore AA0205
        end;
    }

    rendering
    {
        layout(AgedAccountsPayableExcel)
        {
            Type = Excel;
            LayoutFile = './ReportLayouts/Excel/Purchase/AgedAccountsPayableExcel.xlsx';
        }
    }
    labels
    {
        ByPeriodLCY = 'By period (LCY)';
        BalanceLCY = 'Balance (LCY)';
        AgedAccountsPayableByPeriodLCY = 'Aged Accounts Payable by Period (LCY)';
        OpenAmountsInLCY = 'Open amounts in LCY';
        ByPeriodFCY = 'By Period (FCY)';
        BalanceFCY = 'Balance (FCY)';
        AgedAccountsPayableByPeriodFCY = 'Aged Accounts Payable by Period (FCY)';
        OpenAmountsInFCY = 'Open amounts in FCY';
        AgedAccountsPayableDueByCurrencyFCY = 'Aged Accounts Payable due by Currency (FCY)';
        DueDateMonth = 'Due Date (Month)';
        DueDateQuarter = 'Due Date (Quarter)';
        DueDateYear = 'Due Date (Year)';
        PostingDateYear = 'Posting Date (Year)';
        PostingDateMonth = 'Posting Date (Month)';
        PostingDateQuarter = 'Posting Date (Quarter)';
        DueByCurrencies = 'Due by Currencies';
        OpenByFCY = 'Open by (FCY)';
        DataRetrieved = 'Data retrieved:';
        CurrencyCodeDisplay = 'Currency Code';
    }

    protected var
        GeneralLedgerSetup: Record "General Ledger Setup";
        PeriodLength: DateFormula;
        SkipZeroBalanceVendors: Boolean;
        EndingDate: Date;
        PeriodCount: Integer;
        PeriodEnds: List of [Date];
        PeriodStarts: List of [Date];
        CurrencyCodeDisplayCode: Code[20];
        AgingBy: Option "Due Date","Posting Date","Document Date";

    trigger OnPreReport()
    begin
        InitReport();
    end;

    local procedure InitReport()
    var
        FirstStartDate: Date;
        WorkingEndDate: Date;
        WorkingStartDate: Date;
        i: Integer;
    begin
        if Format(PeriodLength) = '' then
            Evaluate(PeriodLength, '<-1M>');

        if PeriodCount = 0 then
            PeriodCount := 5;

        WorkingEndDate := EndingDate;
        WorkingStartDate := CalcDate(PeriodLength, WorkingEndDate);
        repeat
            i += 1;
            PeriodStarts.Add(WorkingStartDate);
            PeriodEnds.Add(WorkingEndDate);

            WorkingStartDate := CalcDate(PeriodLength, WorkingStartDate);
            WorkingEndDate := CalcDate(PeriodLength, WorkingEndDate);
        until i >= PeriodCount;
        FirstStartDate := WorkingStartDate;

        VendorAgingData.SetAutoCalcFields("Net Change (LCY)");
        VendorAgingData.SetRange("Date Filter", FirstStartDate, EndingDate);
        if SkipZeroBalanceVendors then
            VendorAgingData.SetFilter("Net Change (LCY)", '<>0');
    end;

    local procedure InsertAgingData(var Vendor: Record "Vendor")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date", "Currency Code");
        VendorLedgerEntry.SetRange("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SetRange("Posting Date", 0D, EndingDate);
        VendorLedgerEntry.SetRange("Date Filter", 0D, EndingDate);
        VendorLedgerEntry.SetAutoCalcFields("Remaining Amt. (LCY)", "Remaining Amount", "Original Amount", "Original Amt. (LCY)");
        VendorLedgerEntry.SetFilter("Remaining Amt. (LCY)", '<>0');
        if VendorLedgerEntry.FindSet() then
            repeat
                AddVendorLedgerEntryToBuffer(VendorLedgerEntry);
            until VendorLedgerEntry.Next() = 0;
    end;

    local procedure AddVendorLedgerEntryToBuffer(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        Clear(AgingData);
        AgingData."Entry No." := VendorLedgerEntry."Entry No.";
        AgingData."Vendor Source No." := VendorLedgerEntry."Vendor No.";
        AgingData."Source Name" := VendorLedgerEntry."Vendor Name";
        AgingData."Document No." := VendorLedgerEntry."Document No.";
        AgingData."Dimension 1 Code" := VendorLedgerEntry."Global Dimension 1 Code";
        AgingData."Dimension 2 Code" := VendorLedgerEntry."Global Dimension 2 Code";
        AgingData."Currency Code" := VendorLedgerEntry."Currency Code";
        AgingData."Posting Date" := VendorLedgerEntry."Posting Date";
        AgingData."Document Date" := VendorLedgerEntry."Document Date";
        AgingData."Due Date" := VendorLedgerEntry."Due Date";
        FindPeriodRange(AgingData);
        AgingData."Remaining Amount (LCY)" := VendorLedgerEntry."Remaining Amt. (LCY)";
        AgingData."Remaining Amount" := VendorLedgerEntry."Remaining Amount";
        AgingData."Original Amount (LCY)" := VendorLedgerEntry."Original Amt. (LCY)";
        AgingData."Original Amount" := VendorLedgerEntry."Original Amount";
        AgingData.Insert(true);
    end;

    local procedure FindPeriodRange(var TempFERAgingReportBuffer: Record "EXR Aging Report Buffer" temporary)
    begin
        case AgingBy of
            AgingBy::"Due Date":
                begin
                    TempFERAgingReportBuffer."Period Start Date" := FindPeriodStart(TempFERAgingReportBuffer."Due Date");
                    TempFERAgingReportBuffer."Period End Date" := FindPeriodEnd(TempFERAgingReportBuffer."Due Date");
                end;
            AgingBy::"Posting Date":
                begin
                    TempFERAgingReportBuffer."Period Start Date" := FindPeriodStart(TempFERAgingReportBuffer."Posting Date");
                    TempFERAgingReportBuffer."Period End Date" := FindPeriodEnd(TempFERAgingReportBuffer."Posting Date");
                end;
            AgingBy::"Document Date":
                begin
                    TempFERAgingReportBuffer."Period Start Date" := FindPeriodStart(TempFERAgingReportBuffer."Document Date");
                    TempFERAgingReportBuffer."Period End Date" := FindPeriodEnd(TempFERAgingReportBuffer."Document Date");
                end;
        end;
    end;

    local procedure FindPeriodStart(WhatDate: Date): Date
    var
        PossibleDate: Date;
    begin
        foreach PossibleDate in PeriodStarts do
            if WhatDate >= PossibleDate then
                exit(PossibleDate);

        exit(PossibleDate);
    end;

    local procedure FindPeriodEnd(WhatDate: Date): Date
    var
        PossibleDate: Date;
    begin
        foreach PossibleDate in PeriodEnds do
            if WhatDate < PossibleDate then
                exit(PossibleDate);

        exit(PossibleDate);
    end;
}

