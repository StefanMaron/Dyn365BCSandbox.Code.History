﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Sales.History;

using Microsoft.Bank.BankAccount;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Foundation.AuditCodes;

table 7000006 "Posted Bill Group"
{
    Caption = 'Posted Bill Group';
    DrillDownPageID = "Posted Bill Groups List";
    LookupPageID = "Posted Bill Groups List";

    fields
    {
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(4; "Bank Account Name"; Text[100])
        {
            CalcFormula = Lookup("Bank Account".Name where("No." = field("Bank Account No.")));
            Caption = 'Bank Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
        field(6; "Dealing Type"; Enum "Cartera Dealing Type")
        {
            Caption = 'Dealing Type';
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Posted Cartera Doc."."Remaining Amount" where("Bill Gr./Pmt. Order No." = field("No."),
                                                                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              Status = field("Status Filter"),
                                                                              "Category Code" = field("Category Filter"),
                                                                              "Due Date" = field("Due Date Filter"),
                                                                              Type = const(Receivable)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(9; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = exist("BG/PO Comment Line" where("BG/PO No." = field("No."),
                                                            Type = filter(Receivable)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Category Filter"; Code[10])
        {
            Caption = 'Category Filter';
            FieldClass = FlowFilter;
            TableRelation = "Category Code";
            ValidateTableRelation = false;
        }
        field(13; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            FieldClass = FlowFilter;
        }
        field(14; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(15; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(16; "Amount Grouped"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Posted Cartera Doc."."Amount for Collection" where("Bill Gr./Pmt. Order No." = field("No."),
                                                                                   "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                   "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                   Status = field("Status Filter"),
                                                                                   "Category Code" = field("Category Filter"),
                                                                                   "Due Date" = field("Due Date Filter"),
                                                                                   Type = const(Receivable)));
            Caption = 'Amount Grouped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Posted Cartera Doc."."Remaining Amount" where("Bill Gr./Pmt. Order No." = field("No."),
                                                                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              Status = field("Status Filter"),
                                                                              "Category Code" = field("Category Filter"),
                                                                              "Due Date" = field("Due Date Filter"),
                                                                              Type = const(Receivable)));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Status Filter"; Enum "Cartera Document Status")
        {
            Caption = 'Status Filter';
            FieldClass = FlowFilter;
        }
        field(29; "Collection Expenses Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Collection Expenses Amt.';
        }
        field(30; "Discount Expenses Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Discount Expenses Amt.';
        }
        field(31; "Discount Interests Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Discount Interests Amt.';
        }
        field(32; "Rejection Expenses Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Rejection Expenses Amt.';
        }
        field(33; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(34; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Posted Cartera Doc."."Remaining Amt. (LCY)" where("Bill Gr./Pmt. Order No." = field("No."),
                                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                  Status = field("Status Filter"),
                                                                                  "Category Code" = field("Category Filter"),
                                                                                  "Due Date" = field("Due Date Filter"),
                                                                                  Type = const(Receivable)));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Amount Grouped (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Posted Cartera Doc."."Amt. for Collection (LCY)" where("Bill Gr./Pmt. Order No." = field("No."),
                                                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                       Status = field("Status Filter"),
                                                                                       "Category Code" = field("Category Filter"),
                                                                                       "Due Date" = field("Due Date Filter"),
                                                                                       Type = const(Receivable)));
            Caption = 'Amount Grouped (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Remaining Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Posted Cartera Doc."."Remaining Amt. (LCY)" where("Bill Gr./Pmt. Order No." = field("No."),
                                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                  Status = field("Status Filter"),
                                                                                  "Category Code" = field("Category Filter"),
                                                                                  "Due Date" = field("Due Date Filter"),
                                                                                  Type = const(Receivable)));
            Caption = 'Remaining Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Risked Factoring Exp. Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Risked Factoring Exp. Amt.';
        }
        field(38; "Unrisked Factoring Exp. Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Unrisked Factoring Exp. Amt.';
        }
        field(39; Factoring; Option)
        {
            Caption = 'Factoring';
            Editable = false;
            OptionCaption = ' ,Unrisked,Risked';
            OptionMembers = " ",Unrisked,Risked;
        }
        field(1200; "Partner Type"; Option)
        {
            Caption = 'Partner Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ",Company,Person;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Bank Account No.", "Posting Date")
        {
            SumIndexFields = "Collection Expenses Amt.", "Discount Expenses Amt.", "Discount Interests Amt.", "Rejection Expenses Amt.", "Risked Factoring Exp. Amt.", "Unrisked Factoring Exp. Amt.";
        }
        key(Key3; "Bank Account No.", "Posting Date", "Currency Code")
        {
            SumIndexFields = "Collection Expenses Amt.", "Discount Expenses Amt.", "Discount Interests Amt.", "Rejection Expenses Amt.", "Risked Factoring Exp. Amt.", "Unrisked Factoring Exp. Amt.";
        }
        key(Key4; "Bank Account No.", "Posting Date", Factoring)
        {
            SumIndexFields = "Collection Expenses Amt.", "Discount Expenses Amt.", "Discount Interests Amt.", "Rejection Expenses Amt.", "Risked Factoring Exp. Amt.", "Unrisked Factoring Exp. Amt.";
        }
    }

    fieldgroups
    {
    }

    var
        Text1100000: Label 'untitled';

    procedure Caption(): Text
    begin
        if "No." = '' then
            exit(Text1100000);
        CalcFields("Bank Account Name");
        exit(StrSubstNo('%1 %2', "No.", "Bank Account Name"));
    end;
}

