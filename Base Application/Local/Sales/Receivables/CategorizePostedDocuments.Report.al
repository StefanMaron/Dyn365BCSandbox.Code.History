﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Sales.Receivables;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Foundation.AuditCodes;

report 7000094 "Categorize Posted Documents"
{
    Caption = 'Categorize Posted Documents';
    Permissions = TableData "Posted Cartera Doc." = m;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted Cartera Doc."; "Posted Cartera Doc.")
        {
            DataItemTableView = sorting(Type, "Entry No.");

            trigger OnPreDataItem()
            begin
                ModifyAll("Category Code", CategoryCode);
                CurrReport.Break();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CategoryCode; CategoryCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Category Code';
                        TableRelation = "Category Code";
                        ToolTip = 'Specifies the category.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CategoryCode: Code[10];
}

