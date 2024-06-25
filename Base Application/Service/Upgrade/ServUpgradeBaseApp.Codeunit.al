// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Upgrade;

using Microsoft.Inventory.Item;
using Microsoft.Service.Document;
using Microsoft.Service.History;
using Microsoft.Service.Item;
using System.Upgrade;
using System.Environment;

codeunit 104059 "Serv. Upgrade BaseApp"
{
    Subtype = Upgrade;

    var
        HybridDeployment: Codeunit "Hybrid Deployment";
        ServiceBlockedAlreadySetLbl: Label 'CopyItemSalesBlockedToServiceBlocked skipped. %1 already set for at least one record in table %2.', Comment = '%1 = Field Caption, %2 = Table Caption', Locked = true;

    trigger OnCheckPreconditionsPerDatabase()
    begin
        HybridDeployment.VerifyCanStartUpgrade('');
    end;

    trigger OnCheckPreconditionsPerCompany()
    begin
        HybridDeployment.VerifyCanStartUpgrade(CompanyName());
    end;

    trigger OnUpgradePerCompany()
    begin
        if not HybridDeployment.VerifyCanStartUpgrade(CompanyName()) then
            exit;

        UpdateServiceLineOrderNo();
        CopyItemSalesBlockedToServiceBlocked();
        UpgradeServiceHeaderJournalTemplateName();
    end;

    local procedure UpdateServiceLineOrderNo()
    var
        ServiceLine: Record "Service Line";
        ServiceShipmentLine: Record "Service Shipment Line";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefinitions: Codeunit "Upgrade Tag Definitions";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefinitions.GetServiceLineOrderNoUpgradeTag()) then
            exit;

        ServiceLine.SetLoadFields("Shipment No.", "Shipment Line No.");
        ServiceLine.SetRange("Document Type", ServiceLine."Document Type"::Invoice);
        ServiceLine.SetFilter("Shipment No.", '<>%1', '');
        ServiceLine.SetFilter("Shipment Line No.", '<>%1', 0);
        if ServiceLine.FindSet(true) then
            repeat
                ServiceShipmentLine.SetLoadFields("Order No.");
                if ServiceShipmentLine.Get(ServiceLine."Shipment No.", ServiceLine."Shipment Line No.") then begin
                    ServiceLine."Order No." := ServiceShipmentLine."Order No.";
                    ServiceLine.Modify();
                end;
            until ServiceLine.Next() = 0;

        UpgradeTag.SetUpgradeTag(UpgradeTagDefinitions.GetServiceLineOrderNoUpgradeTag());
    end;

    local procedure CopyItemSalesBlockedToServiceBlocked()
    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        ItemTempl: Record "Item Templ.";
        ServiceItem: Record "Service Item";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefinitions: Codeunit "Upgrade Tag Definitions";
        DataTransfer: DataTransfer;
        SkipUpgrade: Boolean;
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefinitions.GetCopyItemSalesBlockedToServiceBlockedUpgradeTag()) then
            exit;

        SkipUpgrade := ServiceItem.IsEmpty();

        if not SkipUpgrade then begin
            Item.SetRange("Service Blocked", true);
            SkipUpgrade := not Item.IsEmpty();
            if SkipUpgrade then
                Session.LogMessage('0000LZQ', StrSubstNo(ServiceBlockedAlreadySetLbl, Item.FieldCaption("Service Blocked"), Item.TableCaption()), Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'AL SaaS Upgrade');
        end;
        if not SkipUpgrade then begin
            ItemVariant.SetRange("Service Blocked", true);
            SkipUpgrade := not ItemVariant.IsEmpty();
            if SkipUpgrade then
                Session.LogMessage('0000LZR', StrSubstNo(ServiceBlockedAlreadySetLbl, ItemVariant.FieldCaption("Service Blocked"), ItemVariant.TableCaption()), Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'AL SaaS Upgrade');
        end;
        if not SkipUpgrade then begin
            ItemTempl.SetRange("Service Blocked", true);
            SkipUpgrade := not ItemTempl.IsEmpty();
            if SkipUpgrade then
                Session.LogMessage('0000LZS', StrSubstNo(ServiceBlockedAlreadySetLbl, ItemTempl.FieldCaption("Service Blocked"), ItemTempl.TableCaption()), Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', 'AL SaaS Upgrade');
        end;

        if not SkipUpgrade then begin
            DataTransfer.SetTables(Database::"Item", Database::"Item");
            DataTransfer.AddSourceFilter(Item.FieldNo("Sales Blocked"), '=%1', true);
            DataTransfer.AddFieldValue(Item.FieldNo("Sales Blocked"), Item.FieldNo("Service Blocked"));
            DataTransfer.UpdateAuditFields := false;
            DataTransfer.CopyFields();
            Clear(DataTransfer);

            DataTransfer.SetTables(Database::"Item Variant", Database::"Item Variant");
            DataTransfer.AddSourceFilter(ItemVariant.FieldNo("Sales Blocked"), '=%1', true);
            DataTransfer.AddFieldValue(ItemVariant.FieldNo("Sales Blocked"), ItemVariant.FieldNo("Service Blocked"));
            DataTransfer.UpdateAuditFields := false;
            DataTransfer.CopyFields();
            Clear(DataTransfer);

            DataTransfer.SetTables(Database::"Item Templ.", Database::"Item Templ.");
            DataTransfer.AddSourceFilter(ItemTempl.FieldNo("Sales Blocked"), '=%1', true);
            DataTransfer.AddFieldValue(ItemTempl.FieldNo("Sales Blocked"), ItemTempl.FieldNo("Service Blocked"));
            DataTransfer.UpdateAuditFields := false;
            DataTransfer.CopyFields();
            Clear(DataTransfer);
        end;

        UpgradeTag.SetUpgradeTag(UpgradeTagDefinitions.GetCopyItemSalesBlockedToServiceBlockedUpgradeTag());
    end;

    local procedure UpgradeServiceHeaderJournalTemplateName()
    var
        ServiceHeader: Record "Service Header";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefinitions: Codeunit "Upgrade Tag Definitions";
        ServiceHeaderDataTransfer: DataTransfer;
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefinitions.GetServiceHeaderJournalTemplateNameUpgradeTag()) then
            exit;

        ServiceHeader.SetRange("Journal Templ. Name", '<>%1', '');
        if not ServiceHeader.IsEmpty() then
            exit;

        ServiceHeaderDataTransfer.SetTables(Database::"Service Header", Database::"Service Header");
        ServiceHeaderDataTransfer.AddSourceFilter(ServiceHeader.FieldNo("Journal Template Name"), '<>%1', '');
        ServiceHeaderDataTransfer.AddFieldValue(ServiceHeader.FieldNo("Journal Template Name"), ServiceHeader.FieldNo("Journal Templ. Name"));
        ServiceHeaderDataTransfer.UpdateAuditFields := false;
        ServiceHeaderDataTransfer.CopyFields();

        UpgradeTag.SetUpgradeTag(UpgradeTagDefinitions.GetServiceHeaderJournalTemplateNameUpgradeTag());
    end;
}
