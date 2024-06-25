namespace Microsoft.Service.Setup;

using Microsoft.Service.Comment;
using Microsoft.Service.Contract;
using Microsoft.Service.Document;
using Microsoft.Service.Email;
using Microsoft.Service.History;
using Microsoft.Service.Item;
using Microsoft.Service.Ledger;
using Microsoft.Service.Loaner;
using Microsoft.Service.Maintenance;
using Microsoft.Service.Pricing;
using Microsoft.Service.Resources;
using Microsoft.Service.RoleCenters;
using Microsoft.Utilities;
using System.Privacy;

codeunit 1767 "Service-Data Classification"
{
    var
        DataClassificationMgt: Codeunit "Data Classification Mgt.";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Data Classification Eval. Data", 'OnCreateEvaluationDataOnAfterClassifyTablesToNormal', '', false, false)]
    local procedure OnClassifyTables()
    begin
        ClassifyTables();
    end;


    local procedure ClassifyTables()
    begin
        ClassifyServiceInvoiceHeader();
        ClassifyServiceInvoiceLine();
        ClassifyServiceShipmentHeader();
        ClassifyServiceShipmentLine();
        ClassifyServiceContractHeader();
        ClassifyServiceItemLog();
        ClassifyServiceCrMemoHeader();
        ClassifyServiceRegister();
        ClassifyLoanerEntry();
        ClassifyServiceDocumentLog();
        ClassifyWarrantyLedgerEntry();
        ClassifyServiceLedgerEntry();
        ClassifyServiceLine();
        ClassifyServiceHeader();
        ClassifyServiceCrMemoLine();
        ClassifyFiledServiceContractHeader();
        ClassifyContractChangeLog();
        ClassifyContractGainLossEntry();

        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Item Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Order Type");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Item Group");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Cost");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Comment Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Hour");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Mgt. Setup");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::Loaner);
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Fault Area");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Symptom Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Fault Reason Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Fault Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Resolution Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Fault/Resol. Cod. Relationship");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Fault Area/Symptom Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Repair Status");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Status Priority Setup");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Shelf");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Email Queue");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Document Register");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Item");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Item Component");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Troubleshooting Header");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Troubleshooting Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Troubleshooting Setup");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Order Allocation");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Resource Location");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Work-Hour Template");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Skill Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Resource Skill");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Zone");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Resource Service Zone");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Contract Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Contract Group");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Contract Template");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Filed Contract Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Contract/Service Discount");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Contract Account Group");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Shipment Item Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Standard Service Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Standard Service Line");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Standard Service Item Gr. Code");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Price Group");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Serv. Price Group Setup");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Price Adjustment Group");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Serv. Price Adjustment Detail");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Line Price Adjmt.");
        DataClassificationMgt.SetTableFieldsToNormal(DATABASE::"Service Cue");
    end;

    local procedure ClassifyServiceInvoiceLine()
    var
        DummyServiceInvoiceLine: Record "Service Invoice Line";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Invoice Line";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceLine.FieldNo("Tax Area Code"));
    end;

    local procedure ClassifyServiceInvoiceHeader()
    var
        DummyServiceInvoiceHeader: Record "Service Invoice Header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Invoice Header";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Phone 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Tax Area Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("User ID"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo(County));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Contact Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo(City));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo(Address));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo(Name));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("VAT Registration No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Phone No. 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Phone"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Phone No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Ship-to Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceInvoiceHeader.FieldNo("Bill-to Name"));
    end;

    local procedure ClassifyServiceShipmentLine()
    var
        DummyServiceShipmentLine: Record "Service Shipment Line";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Shipment Line";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentLine.FieldNo("Tax Area Code"));
    end;

    local procedure ClassifyServiceShipmentHeader()
    var
        DummyServiceShipmentHeader: Record "Service Shipment Header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Shipment Header";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Phone 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Tax Area Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("User ID"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo(County));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Contact Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo(City));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo(Address));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo(Name));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("VAT Registration No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Phone No. 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Phone"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Phone No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Ship-to Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceShipmentHeader.FieldNo("Bill-to Name"));
    end;

    local procedure ClassifyContractChangeLog()
    var
        DummyContractChangeLog: Record "Contract Change Log";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Contract Change Log";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyContractChangeLog.FieldNo("User ID"));
    end;

    local procedure ClassifyServiceContractHeader()
    var
        DummyServiceContractHeader: Record "Service Contract Header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Contract Header";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceContractHeader.FieldNo("Bill-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceContractHeader.FieldNo("E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceContractHeader.FieldNo("Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceContractHeader.FieldNo("Phone No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceContractHeader.FieldNo("Contact Name"));
    end;

    local procedure ClassifyServiceItemLog()
    var
        DummyServiceItemLog: Record "Service Item Log";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Item Log";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceItemLog.FieldNo("User ID"));
    end;

    local procedure ClassifyServiceCrMemoHeader()
    var
        DummyServiceCrMemoHeader: Record "Service Cr.Memo Header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Cr.Memo Header";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Phone 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Tax Area Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("User ID"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo(County));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Contact Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo(City));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo(Address));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo(Name));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("VAT Registration No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Phone No. 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Phone"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Phone No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Ship-to Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoHeader.FieldNo("Bill-to Name"));
    end;

    local procedure ClassifyServiceRegister()
    var
        DummyServiceRegister: Record "Service Register";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Register";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceRegister.FieldNo("User ID"));
    end;

    local procedure ClassifyLoanerEntry()
    var
        DummyLoanerEntry: Record "Loaner Entry";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Loaner Entry";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Document Type"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo(Lent));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Time Received"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Date Received"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Time Lent"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Date Lent"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Customer No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Service Item Group Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Service Item No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Service Item Line No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Document No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Loaner No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyLoanerEntry.FieldNo("Entry No."));
    end;

    local procedure ClassifyServiceDocumentLog()
    var
        DummyServiceDocumentLog: Record "Service Document Log";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Document Log";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceDocumentLog.FieldNo("User ID"));
    end;

    local procedure ClassifyWarrantyLedgerEntry()
    var
        DummyWarrantyLedgerEntry: Record "Warranty Ledger Entry";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Warranty Ledger Entry";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Dimension Set ID"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Service Order Line No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Variant Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Vendor Item No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Vendor No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo(Open));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Global Dimension 2 Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Global Dimension 1 Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Gen. Prod. Posting Group"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Gen. Bus. Posting Group"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo(Description));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo(Amount));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Unit of Measure Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Work Type Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo(Quantity));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo(Type));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Resolution Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Symptom Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Fault Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Fault Area Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Fault Reason Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Service Contract No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Service Order No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Service Item Group (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Serial No. (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Item No. (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Service Item No. (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Variant Code (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Bill-to Customer No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Ship-to Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Customer No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Posting Date"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Document No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyWarrantyLedgerEntry.FieldNo("Entry No."));
    end;

    local procedure ClassifyServiceLedgerEntry()
    var
        DummyServiceLedgerEntry: Record "Service Ledger Entry";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Ledger Entry";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Dimension Set ID"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Job Posted"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Job Line Type"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Job Task No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo(Amount));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Applies-to Entry No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Apply Until Entry No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo(Prepaid));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Service Price Group Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Serv. Price Adjmt. Gr. Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo(Open));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Entry Type"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Variant Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Responsibility Center"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Bin Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Work Type Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Unit of Measure Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Location Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Gen. Prod. Posting Group"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Gen. Bus. Posting Group"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Job No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Service Order No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Service Order Type"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo(Description));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Fault Reason Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Bill-to Customer No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Contract Disc. Amount"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Discount %"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Unit Price"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Charged Qty."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo(Quantity));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Unit Cost"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Discount Amount"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Cost Amount"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo(Type));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Contract Group Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Variant Code (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Service Item No. (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Global Dimension 2 Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Global Dimension 1 Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Contract Invoice Period"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceLedgerEntry.FieldNo("User ID"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Serial No. (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Item No. (Serviced)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Ship-to Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Customer No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Amount (LCY)"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Posting Date"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Moved from Prepaid Acc."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Document Line No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Serv. Contract Acc. Gr. Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Document No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Document Type"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Service Contract No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyServiceLedgerEntry.FieldNo("Entry No."));
    end;

    local procedure ClassifyServiceLine()
    var
        DummyServiceLine: Record "Service Line";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Line";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceLine.FieldNo("Tax Area Code"));
    end;

    local procedure ClassifyServiceHeader()
    var
        DummyServiceHeader: Record "Service Header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Header";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Assigned User ID"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Phone 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Phone"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Phone No. 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Phone No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Tax Area Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo(County));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Contact Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo(City));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo(Address));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo(Name));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("VAT Registration No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Ship-to Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceHeader.FieldNo("Bill-to Name"));
    end;

    local procedure ClassifyFiledServiceContractHeader()
    var
        DummyFiledServiceContractHeader: Record "Filed Service Contract Header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Filed Service Contract Header";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to Contact"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Filed By"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Name 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo(County));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to County"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("E-Mail"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Fax No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Phone No."));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Ship-to Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to City"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to Address"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Bill-to Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Contact Name"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo(City));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Post Code"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo("Address 2"));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo(Address));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyFiledServiceContractHeader.FieldNo(Name));
    end;

    local procedure ClassifyServiceCrMemoLine()
    var
        DummyServiceCrMemoLine: Record "Service Cr.Memo Line";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Service Cr.Memo Line";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyServiceCrMemoLine.FieldNo("Tax Area Code"));
    end;

    local procedure ClassifyContractGainLossEntry()
    var
        DummyContractGainLossEntry: Record "Contract Gain/Loss Entry";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Contract Gain/Loss Entry";
        DataClassificationMgt.SetTableFieldsToNormal(TableNo);
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo(Amount));
        DataClassificationMgt.SetFieldToPersonal(TableNo, DummyContractGainLossEntry.FieldNo("User ID"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Ship-to Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Customer No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Responsibility Center"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Type of Change"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Reason Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Change Date"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Contract Group Code"));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Contract No."));
        DataClassificationMgt.SetFieldToCompanyConfidential(TableNo, DummyContractGainLossEntry.FieldNo("Entry No."));
    end;

}