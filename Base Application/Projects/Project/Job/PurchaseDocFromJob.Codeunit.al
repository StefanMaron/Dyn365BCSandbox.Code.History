// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Projects.Project.Job;

using Microsoft.Foundation.Navigate;
using Microsoft.Inventory.Requisition;
using Microsoft.Purchases.Document;

codeunit 1018 "Purchase Doc. From Job"
{

    trigger OnRun()
    begin
    end;

    var
        NoPurchaseOrdersCreatedErr: Label 'No purchase orders are created.';

    procedure CreatePurchaseOrder(Job: Record Job)
    var
        TempManufacturingUserTemplate: Record "Manufacturing User Template" temporary;
        RequisitionLine: Record "Requisition Line";
        PurchaseHeader: Record "Purchase Header";
        TempDocumentEntry: Record "Document Entry" temporary;
        OrderPlanningMgt: Codeunit "Order Planning Mgt.";
        PurchOrderFromSalesOrder: Page "Purch. Order From Sales Order";
        NoFilter: Text;
    begin
        CreateTempManufacturingUserTemplate(TempManufacturingUserTemplate);
        PurchOrderFromSalesOrder.LookupMode(true);
        PurchOrderFromSalesOrder.SetJobNo(Job."No.");
        if PurchOrderFromSalesOrder.RunModal() <> ACTION::LookupOK then begin
            OrderPlanningMgt.PrepareRequisitionRecord(RequisitionLine);
            exit;
        end;

        PurchOrderFromSalesOrder.GetRecord(RequisitionLine);
        SetRequisitionLineFilters(RequisitionLine, Job);
        if not RequisitionLine.IsEmpty() then
            MakeSupplyOrders(TempManufacturingUserTemplate, TempDocumentEntry, RequisitionLine);

        TempDocumentEntry.SetRange("Table ID", Database::"Purchase Header");
        if TempDocumentEntry.FindSet() then
            repeat
                if PurchaseHeader.Get(TempDocumentEntry."Document Type", TempDocumentEntry."Document No.") then
                    BuildFilter(NoFilter, PurchaseHeader."No.");
            until TempDocumentEntry.Next() = 0;

        if NoFilter = '' then
            Error(NoPurchaseOrdersCreatedErr);

        PurchaseHeader.SetFilter("No.", NoFilter);
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);

        case PurchaseHeader.Count of
            0:
                Error(NoPurchaseOrdersCreatedErr);
            1:
                Page.Run(Page::"Purchase Order", PurchaseHeader);
            else
                Page.Run(Page::"Purchase Order List", PurchaseHeader);
        end;
    end;

    local procedure SetRequisitionLineFilters(var RequisitionLine: Record "Requisition Line"; Job: Record Job)
    begin
        RequisitionLine.SetRange("User ID", UserId);
        RequisitionLine.SetRange("Demand Order No.", Job."No.");
        RequisitionLine.SetRange("Demand Subtype", 2);
        RequisitionLine.SetRange(Level);
        RequisitionLine.SetFilter(Quantity, '>%1', 0);
    end;

    local procedure BuildFilter(var InitialFilter: Text; NewValue: Text)
    begin
        if StrPos(InitialFilter, NewValue) = 0 then begin
            if StrLen(InitialFilter) > 0 then
                InitialFilter += '|';
            InitialFilter += NewValue;
        end;
    end;

    local procedure MakeSupplyOrders(var TempManufacturingUserTemplate: Record "Manufacturing User Template" temporary; var TempDocumentEntry: Record "Document Entry" temporary; var RequisitionLine: Record "Requisition Line")
    var
        MakeSupplyOrdersYesNo: Codeunit "Make Supply Orders (Yes/No)";
    begin
        MakeSupplyOrdersYesNo.SetManufUserTemplate(TempManufacturingUserTemplate);
        MakeSupplyOrdersYesNo.SetBlockForm();

        MakeSupplyOrdersYesNo.SetCreatedDocumentBuffer(TempDocumentEntry);
        MakeSupplyOrdersYesNo.Run(RequisitionLine);
    end;

    local procedure CreateTempManufacturingUserTemplate(var TempManufacturingUserTemplate: Record "Manufacturing User Template" temporary)
    begin
        TempManufacturingUserTemplate.Init();
        TempManufacturingUserTemplate."User ID" := CopyStr(UserId(), 1, MaxStrLen(TempManufacturingUserTemplate."User ID"));
        TempManufacturingUserTemplate."Make Orders" := TempManufacturingUserTemplate."Make Orders"::"The Active Order";
        TempManufacturingUserTemplate."Create Purchase Order" :=
          TempManufacturingUserTemplate."Create Purchase Order"::"Make Purch. Orders";
        TempManufacturingUserTemplate."Create Production Order" := TempManufacturingUserTemplate."Create Production Order"::" ";
        TempManufacturingUserTemplate."Create Transfer Order" := TempManufacturingUserTemplate."Create Transfer Order"::" ";
        TempManufacturingUserTemplate."Create Assembly Order" := TempManufacturingUserTemplate."Create Assembly Order"::" ";
        TempManufacturingUserTemplate.Insert();
    end;
}
