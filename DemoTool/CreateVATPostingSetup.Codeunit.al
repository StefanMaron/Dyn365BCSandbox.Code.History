codeunit 101325 "Create VAT Posting Setup"
{

    trigger OnRun()
    begin
        with DemoDataSetup do begin
            Get();
            case "Company Type" of
                "Company Type"::VAT:
                    begin
                        InsertData('', ServicesVATCode, 0, 0, 'E');
                        InsertData('', GoodsVATCode, 0, 0, 'E');
                        if "Reduced VAT Rate" > 0 then
                            InsertData('', ReducedVATCode, 0, 0, 'E');
                        InsertData('', NoVATCode, 0, 0, 'E');
                        InsertData(DomesticCode, ServicesVATCode, "Services VAT Rate", 0, 'S');
                        InsertData(DomesticCode, GoodsVATCode, "Goods VAT Rate", 0, 'S');
                        InsertData(DomesticCode, NoVATCode, 0, 0, 'E');
                        if "Data Type" = "Data Type"::Extended then
                            InsertData(EUCode, ServicesVATCode, "Services VAT Rate", 1, 'S')
                        else begin
                            InsertData(EUCode, ServicesVATCodeSRV, "Services VAT Rate", 1, 'S');
                            InsertData(EUCode, GoodsVATCodeSRV, "Goods VAT Rate", 1, 'S');
                            InsertData(DomesticCode, ServicesVATCodeSRV, "Services VAT Rate", 0, 'S');
                        end;
                        InsertData(EUCode, GoodsVATCode, "Goods VAT Rate", 1, 'S');
                        InsertData(EUCode, NoVATCode, 0, 0, 'E');
                        InsertData(ExportCode, ServicesVATCode, 0, 0, 'E');
                        InsertData(ExportCode, GoodsVATCode, 0, 0, 'E');
                        InsertData(ExportCode, NoVATCode, 0, 0, 'E');
                        if "Reduced VAT Rate" > 0 then begin
                            InsertData(DomesticCode, ReducedVATCode, "Reduced VAT Rate", 0, 'S');
                            InsertData(EUCode, ReducedVATCode, "Reduced VAT Rate", 1, 'S');
                            InsertData(ExportCode, ReducedVATCode, 0, 0, 'E');
                        end;
                        InsertData(DomesticCode, FullServicesVATCode, 100, 2, 'S');
                        InsertData(DomesticCode, FullGoodsVATCode, 100, 2, 'S');
                    end;
                "Company Type"::"Sales Tax":
                    InsertSalesTaxData('E');
            end;
        end;
    end;

    var
        DemoDataSetup: Record "Demo Data Setup";
        CA: Codeunit "Make Adjustments";
        XPostingSetupTxt: Label 'Setup for %1 / %2', Comment = '%1 = Business Group; %2 = Product Group';

    procedure InsertSalesTaxData(TaxCategory: Code[10])
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.Init();
        VATPostingSetup.Validate("VAT Bus. Posting Group", '');
        VATPostingSetup.Validate("VAT Prod. Posting Group", '');
        VATPostingSetup.Validate("VAT Calculation Type", VATPostingSetup."VAT Calculation Type"::"Sales Tax");
        VATPostingSetup.Validate("Tax Category", TaxCategory);
        VATPostingSetup.Insert();
    end;

    procedure InsertData("VAT Bus. Posting Group": Code[20]; "VAT Prod. Posting Group": Code[20]; "VAT %": Decimal; "VAT Calculation Type": Option; TaxCategory: Code[10])
    var
        VATPostingSetup: Record "VAT Posting Setup";
        CreateGLAccount: Codeunit "Create G/L Account";
    begin
        VATPostingSetup.Init();
        VATPostingSetup.Validate("VAT Bus. Posting Group", "VAT Bus. Posting Group");
        VATPostingSetup.Validate("VAT Prod. Posting Group", "VAT Prod. Posting Group");
        VATPostingSetup.Validate(Description,
          CopyStr(
            StrSubstNo(XPostingSetupTxt, "VAT Bus. Posting Group", "VAT Prod. Posting Group"),
            1, MaxStrLen(VATPostingSetup.Description)));
        VATPostingSetup.Validate("VAT %", "VAT %");
        VATPostingSetup.Validate("VAT Calculation Type", "VAT Calculation Type");
        VATPostingSetup."VAT Identifier" := VATPostingSetup."VAT Prod. Posting Group";
        VATPostingSetup.Validate("Tax Category", TaxCategory);
        VATPostingSetup.Validate("Adjust for Payment Discount", DemoDataSetup."Adjust for Payment Discount");
        if DemoDataSetup."Advanced Setup" then
            VATPostingSetup.Validate("Unrealized VAT Type", VATPostingSetup."Unrealized VAT Type"::Percentage);

        if DemoDataSetup."Company Type" = DemoDataSetup."Company Type"::VAT then
            case VATPostingSetup."VAT Prod. Posting Group" of
                DemoDataSetup.GoodsVATCode:
                    if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then
                        SetAccounts(VATPostingSetup, '995610', '995630', '995620', '995615', '995635', '995625')
                    else
                        SetAccounts(VATPostingSetup, CreateGLAccount.SalesVATNormalPayable(), CreateGLAccount.PurchaseVATNormal(), CreateGLAccount.PurchaseVATNormal(), '995615', '995635', '995625');
                DemoDataSetup.GoodsVATCodeSRV:
                    begin
                        if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then
                            SetAccounts(VATPostingSetup, '995610', '995630', '995620', '995615', '995635', '995625')
                        else
                            SetAccounts(VATPostingSetup, CreateGLAccount.SalesVATNormalPayable(), CreateGLAccount.PurchaseVATNormal(), CreateGLAccount.PurchaseVATNormal(), '995615', '995635', '995625');
                        VATPostingSetup.Validate("EU Service", true);
                    end;
                DemoDataSetup.ServicesVATCode,
                DemoDataSetup.ServicesVATCodeSRV,
                DemoDataSetup.ReducedVATCode:
                    begin
                        if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then
                            SetAccounts(VATPostingSetup, '995611', '995631', '995621', '995616', '995636', '995626')
                        else
                            SetAccounts(VATPostingSetup, CreateGLAccount.SalesVATReducedPayable(), CreateGLAccount.PurchaseVATReduced(), CreateGLAccount.PurchaseVATReduced(), '995616', '995636', '995626');
                        if VATPostingSetup."VAT Bus. Posting Group" = DemoDataSetup.EUCode then
                            VATPostingSetup.Validate("EU Service", true);
                    end;
                DemoDataSetup.NoVATCode:
                    if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then
                        SetAccounts(VATPostingSetup, '995610', '995630', '995620', '995615', '995635', '995625')
                    else
                        SetAccounts(VATPostingSetup, CreateGLAccount.SalesVATNormalPayable(), CreateGLAccount.PurchaseVATReduced(), CreateGLAccount.PurchaseVATNormal(), '995615', '995635', '995625');
                DemoDataSetup.FullServicesVATCode:
                    if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then begin
                        VATPostingSetup.Validate("Sales VAT Account", CA.Convert('995612'));
                        VATPostingSetup.Validate("Purchase VAT Account", CA.Convert('995632'));
                    end else begin
                        VATPostingSetup.Validate("Sales VAT Account", CA.Convert(CreateGLAccount.SalesVATReducedPayable()));
                        VATPostingSetup.Validate("Purchase VAT Account", CA.Convert(CreateGLAccount.PurchaseVATReduced()));
                    end
                    ;
                DemoDataSetup.FullGoodsVATCode:
                    if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then begin
                        VATPostingSetup.Validate("Sales VAT Account", CA.Convert('995613'));
                        VATPostingSetup.Validate("Purchase VAT Account", CA.Convert('995633'));
                    end else begin
                        VATPostingSetup.Validate("Sales VAT Account", CA.Convert(CreateGLAccount.SalesVATNormalPayable()));
                        VATPostingSetup.Validate("Purchase VAT Account", CA.Convert(CreateGLAccount.PurchaseVATNormal()));
                    end
                    ;
            end;

        VATPostingSetup.Insert();
    end;

    local procedure SetAccounts(var VATPostingSetup: Record "VAT Posting Setup"; SalesVATAccount: Code[20]; PurchaseVATAccount: Code[20]; ReverseChargeVATAcc: Code[20]; SalesVATUnrealAccount: Code[20]; PurchaseVATUnrealAccount: Code[20]; ReverseChargeVATUnrealAcc: Code[20])
    begin
        VATPostingSetup.Validate("Sales VAT Account", CA.Convert(SalesVATAccount));
        VATPostingSetup.Validate("Purchase VAT Account", CA.Convert(PurchaseVATAccount));
        if VATPostingSetup."VAT Calculation Type" = 1 then
            VATPostingSetup.Validate("Reverse Chrg. VAT Acc.", CA.Convert(ReverseChargeVATAcc));
        if VATPostingSetup."Unrealized VAT Type" > 0 then begin
            VATPostingSetup.Validate("Sales VAT Unreal. Account", CA.Convert(SalesVATUnrealAccount));
            VATPostingSetup.Validate("Purch. VAT Unreal. Account", CA.Convert(PurchaseVATUnrealAccount));
            if VATPostingSetup."VAT Calculation Type" = 1 then
                VATPostingSetup.Validate("Reverse Chrg. VAT Unreal. Acc.", CA.Convert(ReverseChargeVATUnrealAcc));
        end;
    end;
}

