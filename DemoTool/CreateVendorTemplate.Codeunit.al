codeunit 101999 "Create Vendor Template"
{

    trigger OnRun()
    begin
    end;

    var
        xCashDescriptionTxt: Label 'Cash-Payment Vendor (Cash, VAT)', Comment = 'Translate.';
        DemoDataSetup: Record "Demo Data Setup";
        Vendor: Record Vendor;
        xBusinessDescriptionTxt: Label 'Business-to-Business Vendor (Bank, VAT)', Comment = 'Translate.';
        xManualTxt: Label 'Manual';
        xCODTxt: Label 'COD';
        X1M8DTxt: Label '1M(8D)';
        xBANKTxt: Label 'BANK', Comment = 'To be translated.';
        xCASHCAPTxt: Label 'CASH', Comment = 'Translated.';
        CreateTemplateHelper: Codeunit "Create Template Helper";
        xVENDPERSONTxt: Label 'VENDPERSON', Comment = 'Stands for Vendor Person, keep capitalized.';
        xVENDCOMPNYTxt: Label 'VENDCOMPNY', Comment = 'Stands for Vendor Company, keep capitalized.';

    procedure InsertMiniAppData()
    var
        ConfigTemplateHeader: Record "Config. Template Header";
    begin
        with DemoDataSetup do begin
            Get();

            // Cash-Payment vendor template
            InsertTemplate(ConfigTemplateHeader,
              xCashDescriptionTxt, "Country/Region Code", DomesticCode, DomesticCode, DomesticCode, xVENDPERSONTxt, true, false);
            InsertPaymentsInfo(ConfigTemplateHeader, xManualTxt, xCODTxt, xCASHCAPTxt);

            CreateTemplateHelper.CreateTemplateSelectionRule(
              DATABASE::Vendor, ConfigTemplateHeader.Code, '', 0, 0);

            // Business-to-Business vendor template
            InsertTemplate(ConfigTemplateHeader,
              xBusinessDescriptionTxt, "Country/Region Code", DomesticCode, DomesticCode, DomesticCode, xVENDCOMPNYTxt, false, false);
            InsertPaymentsInfo(ConfigTemplateHeader, xManualTxt, X1M8DTxt, xBANKTxt);
        end;
    end;

    local procedure InsertTemplate(var ConfigTemplateHeader: Record "Config. Template Header"; Description: Text[50]; CountryCode: Text[50]; GenBusGroup: Code[20]; VATBusGroup: Code[20]; VendorGroup: Code[20]; TemplateHeaderCode: Code[10]; PriceWithVAT: Boolean; ValidateEUVatRegNo: Boolean)
    begin
        CreateTemplateHelper.CreateTemplateHeader(
          ConfigTemplateHeader, TemplateHeaderCode, Description, DATABASE::Vendor);
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Country/Region Code"), CountryCode);
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Gen. Bus. Posting Group"), GenBusGroup);
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("VAT Bus. Posting Group"), VATBusGroup);
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Prices Including VAT"), Format(PriceWithVAT));
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Vendor Posting Group"), VendorGroup);
        CreateTemplateHelper.CreateTemplateLine(
          ConfigTemplateHeader, Vendor.FieldNo("Validate EU Vat Reg. No."), Format(ValidateEUVatRegNo));
    end;

    local procedure InsertPaymentsInfo(var ConfigTemplateHeader: Record "Config. Template Header"; ApplMethod: Text[20]; PaymentTerms: Code[20]; PaymentMethod: Code[20])
    begin
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Application Method"), ApplMethod);
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Payment Terms Code"), PaymentTerms);
        CreateTemplateHelper.CreateTemplateLine(ConfigTemplateHeader, Vendor.FieldNo("Payment Method Code"), PaymentMethod);
    end;
}

