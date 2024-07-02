namespace Microsoft.Utilities;

using Microsoft.Foundation.Attachment;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Availability;
using Microsoft.Foundation.Reporting;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Service.Document;
using Microsoft.Service.History;
using Microsoft.Service.Item;
using Microsoft.Service.Resources;
using Microsoft.Service.Maintenance;
using Microsoft.Service.Contract;
using Microsoft.Foundation.Calendar;
using Microsoft.Service.Setup;
using Microsoft.Integration.D365Sales;
using Microsoft.Manufacturing.Planning;

codeunit 6450 "Serv. Integration Mgt."
{
    var
        ServiceItemQtyErr: Label 'The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.', Comment = '%1 - service item, %2 - field caption';
        CustomerDeletionQst: Label 'Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?', Comment = '%1 - table caption, %2 - customer no., %3 - field caption';
        CannotDeleteCustomerErr: Label 'Cannot delete customer.';
        ServiceDocumentExistErr: Label 'You cannot delete customer %1 because there is at least one outstanding Service %2 for this customer.', Comment = '%1 - customer no., %2 - service document type.';

    // Table Customer

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteRelatedData', '', false, false)]
    local procedure CustomerOnAfterDelete(Customer: Record Customer)
    var
        ServiceItem: Record "Service Item";
        ServiceHeader: Record "Service Header";
        ConfirmManagement: Codeunit System.Utilities."Confirm Management";
    begin
        ServiceItem.SetRange("Customer No.", Customer."No.");
        if ServiceItem.FindFirst() then
            if ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(CustomerDeletionQst, Customer.TableCaption(), Customer."No.", ServiceItem.FieldCaption("Customer No.")), true)
            then
                ServiceItem.ModifyAll("Customer No.", '')
            else
                Error(CannotDeleteCustomerErr);

        ServiceHeader.SetCurrentKey("Customer No.", "Order Date");
        ServiceHeader.SetRange("Customer No.", Customer."No.");
        if ServiceHeader.FindFirst() then
            Error(ServiceDocumentExistErr, Customer."No.", ServiceHeader."Document Type");

        ServiceHeader.SetRange("Customer No.");
        ServiceHeader.SetRange("Bill-to Customer No.", Customer."No.");
        if ServiceHeader.FindFirst() then
            Error(ServiceDocumentExistErr, Customer."No.", ServiceHeader."Document Type");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnGetTotalAmountLCYOnAfterCalcFields', '', false, false)]
    local procedure OnGetTotalAmountLCYOnAfterCalcFields(var Customer: Record Customer)
    begin
        Customer.CalcFields("Outstanding Serv. Orders (LCY)", "Serv Shipped Not Invoiced(LCY)", "Outstanding Serv.Invoices(LCY)");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnGetTotalAmountLCYUIOnAfterSetAutoCalcFields', '', false, false)]
    local procedure OnGetTotalAmountLCYUIOnAfterSetAutoCalcFields(var Customer: Record Customer)
    begin
        Customer.SetAutoCalcFields("Outstanding Serv. Orders (LCY)", "Serv Shipped Not Invoiced(LCY)", "Outstanding Serv.Invoices(LCY)");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterGetTotalAmountLCYCommon', '', false, false)]
    local procedure OnAfterGetTotalAmountLCYCommon(var Customer: Record Customer; var TotalAmountLCY: Decimal)
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServiceLine: Record "Service Line";
        ServOutstandingAmountFromShipment: Decimal;
    begin
        ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment(Customer."No.");
        Customer.CalcFields("Outstanding Serv. Orders (LCY)", "Serv Shipped Not Invoiced(LCY)", "Outstanding Serv.Invoices(LCY)");
        TotalAmountLCY +=
            Customer."Outstanding Serv. Orders (LCY)" + Customer."Serv Shipped Not Invoiced(LCY)" + Customer."Outstanding Serv.Invoices(LCY)" -
            ServOutstandingAmountFromShipment;
    end;

    // Table Cust. Ledger Entry

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeShowDoc', '', false, false)]
    local procedure CustLedgerEntryOnBeforeShowDoc(CustLedgerEntry: Record "Cust. Ledger Entry"; var IsPageOpened: Boolean; var IsHandled: Boolean)
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        case CustLedgerEntry."Document Type" of
            CustLedgerEntry."Document Type"::Invoice:
                if ServiceInvoiceHeader.Get(CustLedgerEntry."Document No.") then begin
                    Page.Run(PAGE::"Posted Service Invoice", ServiceInvoiceHeader);
                    IsPageOpened := true;
                    IsHandled := true;
                end;
            CustLedgerEntry."Document Type"::"Credit Memo":
                if ServiceCrMemoHeader.Get(CustLedgerEntry."Document No.") then begin
                    Page.Run(PAGE::"Posted Service Credit Memo", ServiceCrMemoHeader);
                    IsPageOpened := true;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterShowPostedDocAttachment', '', false, false)]
    local procedure CustLedgerEntryOnAfterShowPostedDocAttachment(CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        case CustLedgerEntry."Document Type" of
            CustLedgerEntry."Document Type"::Invoice:
                if ServiceInvoiceHeader.Get(CustLedgerEntry."Document No.") then
                    OpenDocumentAttachmentDetails(ServiceInvoiceHeader);
            CustLedgerEntry."Document Type"::"Credit Memo":
                if ServiceCrMemoHeader.Get(CustLedgerEntry."Document No.") then
                    OpenDocumentAttachmentDetails(ServiceCrMemoHeader);
        end;
    end;

    local procedure OpenDocumentAttachmentDetails("Record": Variant)
    var
        DocumentAttachmentDetails: Page "Document Attachment Details";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Record);
        DocumentAttachmentDetails.OpenForRecRef(RecRef);
        DocumentAttachmentDetails.RunModal();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterHasPostedDocAttachment', '', false, false)]
    local procedure CustLedgerEntryOnAfterHasPostedDocAttachment(CustLedgerEntry: Record "Cust. Ledger Entry"; var HasPostedDocumentAttachment: Boolean)
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServiceInvoiceHeader: Record "Service Invoice Header";
        [SecurityFiltering(SecurityFilter::Filtered)]
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        DocumentAttachment: Record "Document Attachment";
    begin
        case CustLedgerEntry."Document Type" of
            CustLedgerEntry."Document Type"::Invoice:
                if ServiceInvoiceHeader.Get(CustLedgerEntry."Document No.") then
                    HasPostedDocumentAttachment := DocumentAttachment.HasPostedDocumentAttachment(ServiceInvoiceHeader);
            CustLedgerEntry."Document Type"::"Credit Memo":
                if ServiceCrMemoHeader.Get(CustLedgerEntry."Document No.") then
                    HasPostedDocumentAttachment := DocumentAttachment.HasPostedDocumentAttachment(ServiceCrMemoHeader);
        end;
    end;

    // Table Sales Line

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnCheckServItemCreation', '', false, false)]
    local procedure SalesLineOnCheckServItemCreation(SalesLine: Record "Sales Line")
    begin
        CheckServItemCreation(SalesLine);
    end;

    local procedure CheckServItemCreation(SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        ServItemGroup: Record "Service Item Group";
    begin
        Item.Get(SalesLine."No.");
        if Item."Service Item Group" = '' then
            exit;
        if ServItemGroup.Get(Item."Service Item Group") then
            if ServItemGroup."Create Service Item" then
                if SalesLine."Qty. to Ship (Base)" <> Round(SalesLine."Qty. to Ship (Base)", 1) then
                    Error(
                      ServiceItemQtyErr,
                      SalesLine.FieldCaption("Qty. to Ship (Base)"),
                      ServItemGroup.FieldCaption("Create Service Item"));
    end;

    // Table Sales Shipment Line

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure SalesShipmentLineOnAfterDelete(Rec: Record "Sales Shipment Line")
    var
        ServiceItem: Record "Service Item";
    begin
        ServiceItem.Reset();
        ServiceItem.SetCurrentKey("Sales/Serv. Shpt. Document No.", "Sales/Serv. Shpt. Line No.");
        ServiceItem.SetRange("Sales/Serv. Shpt. Document No.", Rec."Document No.");
        ServiceItem.SetRange("Sales/Serv. Shpt. Line No.", Rec."Line No.");
        ServiceItem.SetRange("Shipment Type", ServiceItem."Shipment Type"::Sales);
        if ServiceItem.Find('-') then
            repeat
                ServiceItem.Validate("Sales/Serv. Shpt. Document No.", '');
                ServiceItem.Validate("Sales/Serv. Shpt. Line No.", 0);
                ServiceItem.Modify(true);
            until ServiceItem.Next() = 0;
    end;

    // Table Item

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterDeleteRelatedData', '', false, false)]
    local procedure ItemOnAfterDeleteRelatedData(Item: Record Item)
    var
        TroubleshootingSetup: Record "Troubleshooting Setup";
        ResourceSkillMgt: Codeunit "Resource Skill Mgt.";
    begin
        TroubleshootingSetup.Reset();
        TroubleshootingSetup.SetRange(Type, "Troubleshooting Item Type"::Item);
        TroubleshootingSetup.SetRange("No.", Item."No.");
        TroubleshootingSetup.DeleteAll();

        ResourceSkillMgt.DeleteItemResSkills(Item."No.");
    end;

    // Table Resource

    [EventSubscriber(ObjectType::Table, Database::Resource, 'OnAfterDeleteEvent', '', false, false)]
    local procedure ResourceOnAfterDelete(var Rec: Record Resource)
    var
        ResourceSkill: Record "Resource Skill";
        ResourceLocation: Record "Resource Location";
        ResourceServiceZone: Record "Resource Service Zone";
    begin
        ResourceSkill.Reset();
        ResourceSkill.SetRange(Type, "Resource Skill Type"::Resource);
        ResourceSkill.SetRange("No.", Rec."No.");
        ResourceSkill.DeleteAll();

        ResourceLocation.Reset();
        ResourceLocation.SetCurrentKey("Resource No.", "Starting Date");
        ResourceLocation.SetRange("Resource No.", Rec."No.");
        ResourceLocation.DeleteAll();

        ResourceServiceZone.Reset();
        ResourceServiceZone.SetRange("Resource No.", Rec."No.");
        ResourceServiceZone.DeleteAll();
    end;

    // Codeunit "Data Privacy Mgmt"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::System.Privacy."Data Privacy Mgmt", 'OnAfterIsContactPersonTable', '', false, false)]
    local procedure OnAfterIsContactPersonTable(TableNo: Integer; var Result: Boolean)
    begin
        Result := Result or
                    (TableNo in [
                                DATABASE::"Service Header",
                                DATABASE::"Service Contract Header",
                                DATABASE::"Service Shipment Header",
                                DATABASE::"Service Invoice Header",
                                DATABASE::"Service Cr.Memo Header"]);
    end;

    // Codeunit "Calendar Management"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calendar Management", 'OnFillSourceRec', '', false, false)]
    local procedure CalendarManagementOnFillSourceRec(var CustomCalendarChange: Record "Customized Calendar Change"; RecRef: RecordRef)
    begin
        if RecRef.Number = Database::"Service Mgt. Setup" then
            SetSourceServiceMgtSetup(RecRef, CustomCalendarChange);
    end;

    local procedure SetSourceServiceMgtSetup(RecRef: RecordRef; var CustomCalendarChange: Record "Customized Calendar Change")
    var
        ServMgtSetup: Record "Service Mgt. Setup";
    begin
        RecRef.SetTable(ServMgtSetup);
        CustomCalendarChange.SetSource(CustomCalendarChange."Source Type"::Service, '', '', ServMgtSetup."Base Calendar Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calendar Management", 'OnCreateWhereUsedEntries', '', false, false)]
    local procedure OnCreateWhereUsedEntries(BaseCalendarCode: Code[10]; sender: Codeunit "Calendar Management")
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        WhereUsedBaseCalendar: Record "Where Used Base Calendar";
    begin
        if ServMgtSetup.Get() then
            if ServMgtSetup."Base Calendar Code" = BaseCalendarCode then begin
                WhereUsedBaseCalendar.Init();
                WhereUsedBaseCalendar."Base Calendar Code" := ServMgtSetup."Base Calendar Code";
                WhereUsedBaseCalendar."Source Type" := WhereUsedBaseCalendar."Source Type"::Service;
                WhereUsedBaseCalendar."Source Name" := CopyStr(ServMgtSetup.TableCaption(), 1, MaxStrLen(WhereUsedBaseCalendar."Source Name"));
                WhereUsedBaseCalendar."Customized Changes Exist" := sender.CustomizedChangesExist(ServMgtSetup);
                WhereUsedBaseCalendar.Insert();
            end;
    end;

    // Table "Customized Calendar Change"

    [EventSubscriber(ObjectType::Table, Database::"Customized Calendar Change", 'OnAfterCalcCalendarCode', '', false, false)]
    local procedure OnAfterCalcCalendarCode(var CustomizedCalendarChange: Record "Customized Calendar Change")
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        if CustomizedCalendarChange."Source Type" = CustomizedCalendarChange."Source Type"::Service then
            if ServiceMgtSetup.Get() then
                CustomizedCalendarChange."Base Calendar Code" := ServiceMgtSetup."Base Calendar Code";
    end;

    // Table "Customized Calendar Entry"

    [EventSubscriber(ObjectType::Table, Database::"Customized Calendar Entry", 'OnGetCaptionOnCaseElse', '', false, false)]
    local procedure OnGetCaptionOnCaseElse(var CustomizedCalendarEntry: Record "Customized Calendar Entry"; var TableCaption: Text[250])
    var
        ServMgtSetup: Record "Service Mgt. Setup";
    begin
        if CustomizedCalendarEntry."Source Type" = CustomizedCalendarEntry."Source Type"::Service then
            if ServMgtSetup.Get() then
                TableCaption := CustomizedCalendarEntry."Source Code" + ' ' + ServMgtsetup.TableCaption();
    end;

    // Codeunit "CRM Statistics Job"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Statistics Job", 'OnAfterAddCustomersWithLinesActivity', '', false, false)]
    local procedure OnAfterAddCustomersWithLinesActivity(StartDateTime: DateTime; var CustomerNumbers: List of [Code[20]])
    var
        ServiceLine: Record "Service Line";
    begin
        ServiceLine.SetFilter(SystemModifiedAt, '>' + Format(StartDateTime));
        if ServiceLine.FindSet() then
            repeat
                if not CustomerNumbers.Contains(ServiceLine."Customer No.") then
                    CustomerNumbers.Add(ServiceLine."Customer No.");
            until ServiceLine.Next() = 0;
    end;

    // Codeunit "Calc. Item Plan - Plan Wksh."

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calc. Item Plan - Plan Wksh.", 'OnPlanThisItemOnBeforeExitMPS', '', false, false)]
    local procedure OnPlanThisItemOnBeforeExitMPS(var Item: Record Item; var LinesExist: Boolean)
    var
        ServiceLine: Record "Service Line";
    begin
        LinesExist := ServiceLine.LinesWithItemToPlanExist(Item);
    end;

    // Codeunit "Instruction Mgt."

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Instruction Mgt.", 'OnShowPostedDocumentOnBeforePageRun', '', false, false)]
    local procedure OnShowPostedDocumentOnBeforePageRun(RecVariant: Variant; var PageId: Integer)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecVariant);
        case RecRef.Number of
            DataBase::"Service Invoice Header":
                PageId := Page::"Posted Service Invoice";
            DataBase::"Service Cr.Memo Header":
                PageId := Page::"Posted Service Credit Memo";
        end;
    end;

    // Table "Error Handling Parameters"

    [EventSubscriber(ObjectType::Table, Database::"Error Handling Parameters", 'OnAfterFromArgs', '', false, false)]
    local procedure OnAfterFromArgs(var ErrorHandlingParameters: Record "Error Handling Parameters" temporary; var Args: Dictionary of [Text, Text])
    begin
        ErrorHandlingParameters."Service Document Type" := GetServiceDocTypeParameterValue(Args, ErrorHandlingParameters.FieldName("Service Document Type"));
    end;

    local procedure GetServiceDocTypeParameterValue(Args: Dictionary of [Text, Text]; ParameterName: Text) ServiceDocType: Enum "Service Document Type"
    var
        ParamValueAsText: Text;
    begin
        ParamValueAsText := Args.Get(ParameterName);
        Evaluate(ServiceDocType, ParamValueAsText);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Error Handling Parameters", 'OnAfterToArgs', '', false, false)]
    local procedure OnAfterToArgs(var ErrorHandlingParameters: Record "Error Handling Parameters" temporary; var Args: Dictionary of [Text, Text])
    begin
        Args.Add(ErrorHandlingParameters.FieldName("Service Document Type"), Format(ErrorHandlingParameters."Service Document Type"));
    end;

    // Table "Certificate of Supply"

    [EventSubscriber(ObjectType::Table, Database::"Certificate of Supply", 'OnBeforeInitRecord', '', false, false)]
    local procedure CertificateofSupplyOnBeforeInitRecord(var CertificateOfSupply: Record "Certificate of Supply"; DocumentType: Option; DocumentNo: Code[20]; var IsHandled: Boolean)
    var
        ServiceShipmentHeader: Record "Service Shipment Header";
    begin
        case Microsoft.Foundation.Enums."Supply Document Type".FromInteger(DocumentType) of
            CertificateOfSupply."Document Type"::"Service Shipment":
                begin
                    ServiceShipmentHeader.Get(DocumentNo);
                    CertificateOfSupply.InitRecord(DocumentType, DocumentNo);
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Certificate of Supply", 'OnPrint', '', false, false)]
    local procedure CertificateofSupplyOnPrint(var CertificateOfSupply: Record "Certificate of Supply")
    begin
        if CertificateOfSupply."Document Type" = CertificateOfSupply."Document Type"::"Service Shipment" then
            Report.RunModal(Report::"Service Certificate of Supply", true, false, CertificateOfSupply);
    end;

    // Codeunit "Report Selection Mgt."
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Report Selection Mgt.", 'OnBeforeInitReportSelectionServ', '', false, false)]
    local procedure OnBeforeInitReportSelectionServ()
    var
        ReportSelectionMgt: Codeunit "Report Selection Mgt.";
    begin
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Quote");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Order");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Invoice");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Credit Memo");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Shipment");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Contract Quote");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Contract");
        ReportSelectionMgt.InitReportSelection("Report Selection Usage"::"SM.Test");
    end;

    // Codeunit AvailabilityManagement

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AvailabilityManagement, 'OnAfterShouldCalculateAvailableToPromise', '', false, false)]
    local procedure OnAfterShouldCalculateAvailableToPromise(var OrderPromisingLine: Record "Order Promising Line"; var ShouldCalculate: Boolean)
    begin
        ShouldCalculate := ShouldCalculate or (OrderPromisingLine."Source Type" = OrderPromisingLine."Source Type"::"Service Order");
    end;

    // Codeunit "Available Management"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available Management", 'OnCalcAvailableQtyOnAfterCalculation', '', false, false)]
    local procedure OnCalcAvailableQtyOnAfterCalculation(var CopyOfItem: Record Item; var AvailableQty: Decimal)
    begin
        CopyOfItem.CalcFields("Qty. on Service Order");
        AvailableQty -= CopyOfItem."Qty. on Service Order";
    end;

    // Codeunit "Available To Promise"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnAfterCalcGrossRequirement', '', false, false)]
    local procedure OnAfterCalcGrossRequirement(var Item: Record Item; var GrossRequirement: Decimal)
    begin
        Item.CalcFields("Qty. on Service Order");
        GrossRequirement += Item."Qty. on Service Order";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnAfterCalcReservedRequirement', '', false, false)]
    local procedure OnAfterCalcReservedRequirement(var Item: Record Item; var ReservedRequirement: Decimal)
    begin
        Item.CalcFields("Res. Qty. on Service Orders");
        ReservedRequirement += Item."Res. Qty. on Service Orders";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnAfterCalcReservedRequirement', '', false, false)]
    local procedure OnCalcAllItemFieldsOnAfterItemCalcFields(var Item: Record Item)
    begin
        Item.CalcFields("Qty. on Service Order", "Res. Qty. on Service Orders");
    end;

    // Codeunit "Calc. Availability Overview"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calc. Availability Overview", 'OnAfterCalcDemandRunningTotal', '', false, false)]
    local procedure OnAfterCalcDemandRunningTotal(var Item: Record Item; var DemandRunningTotal: Decimal)
    begin
        Item.CalcFields("Qty. on Service Order", "Res. Qty. on Service Orders");
        DemandRunningTotal -= (Item."Qty. on Service Order" + Item."Res. Qty. on Service Orders");
    end;

    // Codeunit "Item Availability Forms Mgt"

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Availability Forms Mgt", 'OnCalculateNeedOnAfterCalcGrossRequirement', '', false, false)]
    local procedure OnCalculateNeedOnAfterCalcGrossRequirement(var Item: Record Item; var GrossRequirement: Decimal)
    begin
        GrossRequirement += Item."Qty. on Service Order";
    end;

    // Page "Item Availability Line List"

    [EventSubscriber(ObjectType::Page, Page::"Item Availability Line List", 'OnItemCalcFields', '', false, false)]
    local procedure OnItemCalcFields(var Item: Record Item)
    begin
        Item.CalcFields("Qty. on Service Order");
    end;

    // Page "Item Availability Lines"

    [EventSubscriber(ObjectType::Page, Page::"Item Availability Lines", 'OnAfterCalcAvailQuantities', '', false, false)]
    local procedure OnAfterCalcAvailQuantities(var Item: Record Item; var ItemAvailabilityBuffer: Record "Item Availability Buffer")
    begin
        ItemAvailabilityBuffer."Qty. on Service Order" := Item."Qty. on Service Order";
    end;
}