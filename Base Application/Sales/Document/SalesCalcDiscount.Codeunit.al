namespace Microsoft.Sales.Document;

using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Pricing;
using Microsoft.Sales.Setup;
using Microsoft.Utilities;

codeunit 60 "Sales-Calc. Discount"
{
    Permissions = tabledata "Sales Header" = rm,
                  tabledata "Sales Line" = rm;
    TableNo = "Sales Line";

    trigger OnRun()
    var
        IsHandled: Boolean;
    begin
        SalesLine.Copy(Rec);

        TempSalesHeader.Get(Rec."Document Type", Rec."Document No.");
        UpdateHeader := true;

        IsHandled := false;
        OnRunOnBeforeCalculateInvoiceDiscount(SalesLine, TempSalesHeader, TempSalesLine, UpdateHeader, IsHandled);
        if not IsHandled then
            CalculateInvoiceDiscount(TempSalesHeader, TempSalesLine);

        if Rec.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then;
    end;

    var
        TempSalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line";
        CustInvDisc: Record "Cust. Invoice Disc.";
        CustPostingGr: Record "Customer Posting Group";
        Currency: Record Currency;
        InvDiscBase: Decimal;
        ChargeBase: Decimal;
        CurrencyDate: Date;
        UpdateHeader: Boolean;
        GLSetup: Record "General Ledger Setup";
        CustInvDiscFound: Boolean;
        InvAllow: Boolean;

        Text000: Label 'Service Charge';

    local procedure CalculateInvoiceDiscount(var SalesHeader: Record "Sales Header"; var SalesLine2: Record "Sales Line")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        TempServiceChargeLine: Record "Sales Line" temporary;
        GLAcc: Record "G/L Account";
        TempSalesLine: Record "Sales Line" temporary;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        DiscountNotificationMgt: Codeunit "Discount Notification Mgt.";
        ShouldGetCustInvDisc: Boolean;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateInvoiceDiscount(SalesHeader, SalesLine2, UpdateHeader);

        SalesSetup.Get();
        if UpdateHeader then
            SalesHeader.Find(); // To ensure we have the latest - otherwise update fails.

        IsHandled := false;
        OnBeforeCalcSalesDiscount(SalesHeader, IsHandled, SalesLine2, UpdateHeader);
        if IsHandled then
            exit;

        with SalesLine do begin
            LockTable();
            SalesHeader.TestField("Customer Posting Group");
            CustPostingGr.Get(SalesHeader."Customer Posting Group");

            SalesLine2.Reset();
            SalesLine2.SetRange("Document Type", "Document Type");
            SalesLine2.SetRange("Document No.", "Document No.");
            SalesLine2.SetRange("System-Created Entry", true);
            SalesLine2.SetRange(Type, SalesLine2.Type::"G/L Account");
            SalesLine2.SetRange("No.", CustPostingGr."Service Charge Acc.");
            SalesLine2.SetLoadFields("Unit Price", "Shipment No.", "Qty. Shipped Not Invoiced");
            if SalesLine2.FindSet(true) then
                repeat
                    SalesLine2."Unit Price" := 0;
                    SalesLine2.Modify();
                    TempServiceChargeLine := SalesLine2;
                    TempServiceChargeLine.Insert();
                until SalesLine2.Next() = 0;

            SalesLine2.Reset();
            SalesLine2.SetLoadFields();
            SalesLine2.SetRange("Document Type", "Document Type");
            SalesLine2.SetRange("Document No.", "Document No.");
            SalesLine2.SetFilter(Type, '<>0');
            OnCalculateInvoiceDiscountOnBeforeSalesLine2FindFirst(SalesLine2);
            if SalesLine2.FindFirst() then;
            SalesLine2.CalcVATAmountLines(0, SalesHeader, SalesLine2, TempVATAmountLine);
            InvDiscBase :=
              TempVATAmountLine.GetTotalInvDiscBaseAmount(
                SalesHeader."Prices Including VAT", SalesHeader."Currency Code");
            ChargeBase :=
              TempVATAmountLine.GetTotalLineAmount(
                SalesHeader."Prices Including VAT", SalesHeader."Currency Code");

            if UpdateHeader then
                SalesHeader.Modify();

            if SalesHeader."Posting Date" = 0D then
                CurrencyDate := WorkDate()
            else
                CurrencyDate := SalesHeader."Posting Date";

            CustInvDiscFound := false;

            CustInvDisc.GetRec(
              SalesHeader."Invoice Disc. Code", SalesHeader."Currency Code", CurrencyDate, ChargeBase, CustInvDiscFound);

            OnCalculateInvoiceDiscountOnBeforeCheckCustInvDiscServiceCharge(CustInvDisc, SalesHeader, CurrencyDate, ChargeBase);
            if CustInvDiscFound and (CustInvDisc."Service Charge" <> 0) then begin
                OnCalculateInvoiceDiscountOnBeforeCurrencyInitialize(CustPostingGr);
                Currency.Initialize(SalesHeader."Currency Code");
                if not UpdateHeader then
                    SalesLine2.SetSalesHeader(SalesHeader);
                if not TempServiceChargeLine.IsEmpty() then begin
                    TempServiceChargeLine.FindLast();
                    SalesLine2.Get("Document Type", "Document No.", TempServiceChargeLine."Line No.");
                    SetSalesLineServiceCharge(SalesHeader, SalesLine2);
                    SalesLine2.Modify();
                end else begin
                    IsHandled := false;
                    OnCalculateInvoiceDiscountOnBeforeUpdateSalesLine2(SalesHeader, SalesLine2, UpdateHeader, CustInvDisc, IsHandled);
                    if not IsHandled then begin
                        SalesLine2.Reset();
                        SalesLine2.SetRange("Document Type", "Document Type");
                        SalesLine2.SetRange("Document No.", "Document No.");
                        SalesLine2.FindLast();
                        SalesLine2.Init();
                        if not UpdateHeader then
                            SalesLine2.SetSalesHeader(SalesHeader);
                        SalesLine2."Line No." := SalesLine2."Line No." + 10000;
                        SalesLine2."System-Created Entry" := true;
                        SalesLine2.Type := SalesLine2.Type::"G/L Account";
                        SalesLine2.Validate("No.", CustPostingGr.GetServiceChargeAccount());
                        SalesLine2.Description := Text000;
                        SalesLine2.Validate(Quantity, 1);

                        OnAfterValidateSalesLine2Quantity(SalesHeader, SalesLine2, CustInvDisc);

                        if SalesLine2."Document Type" in
                            [SalesLine2."Document Type"::"Return Order", SalesLine2."Document Type"::"Credit Memo"]
                        then
                            SalesLine2.Validate("Return Qty. to Receive", SalesLine2.Quantity)
                        else
                            SalesLine2.Validate("Qty. to Ship", SalesLine2.Quantity);
                        SetSalesLineServiceCharge(SalesHeader, SalesLine2);
                        OnCalculateInvoiceDiscountOnBeforeSalesLineInsert(SalesLine2, SalesHeader);
                        SalesLine2.Insert();
                    end;
                end;
                SalesLine2.CalcVATAmountLines(0, SalesHeader, SalesLine2, TempVATAmountLine);
            end else
                if TempServiceChargeLine.FindSet(false, false) then
                    repeat
                        if (TempServiceChargeLine."Shipment No." = '') and (TempServiceChargeLine."Qty. Shipped Not Invoiced" = 0) then begin
                            SalesLine2.Get("Document Type", "Document No.", TempServiceChargeLine."Line No.");
                            IsHandled := false;
                            OnCalculateInvoiceDiscountOnBeforeSalesLine2DeleteTrue(UpdateHeader, SalesLine2, IsHandled);
                            if not IsHandled then
                                SalesLine2.Delete(true);
                        end;
                    until TempServiceChargeLine.Next() = 0;

            OnCalculateInvoiceDiscountOnBeforeGetGLSetup(CustInvDisc, SalesHeader);        

            GLSetup.Get();
            if GLSetup."Payment Discount Type" <> GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines"
            then
                SalesLine2.SetRange("Allow Invoice Disc.", true);
            if SalesLine2.Find('-') then begin
                if UpdateHeader then
                    SalesLine2.SetSalesHeader(SalesHeader);
                repeat
                    InvAllow := false;
                    if SalesLine2.Type = SalesLine2.Type::"G/L Account" then
                        InvAllow := GLAcc.InvoiceDiscountAllowed(SalesLine2."No.");
                    if (SalesLine2.Quantity <> 0) and not InvAllow then begin
                        SalesLine2."Pmt. Discount Amount" := 0;
                        if (SalesLine2.Type <> SalesLine2.Type::"Charge (Item)") and
                          (SalesLine2."Prepayment %" = 0)
                        then
                            SalesLine2.Validate("Inv. Discount Amount");
                        if (SalesLine2."Allow Invoice Disc.") and (SalesLine2."Line Discount %" < 100) then begin
                            case GLSetup."Discount Calculation" of
                                GLSetup."Discount Calculation"::" ",
                                GLSetup."Discount Calculation"::"Line Disc. * Inv. Disc. + Payment Disc.",
                                GLSetup."Discount Calculation"::"Line Disc. * Inv. Disc. * Payment Disc.":
                                    begin
                                        TempSalesLine."Inv. Discount Amount" :=
                                          TempSalesLine."Inv. Discount Amount" +
                                          SalesLine2."Line Amount" * CustInvDisc."Discount %" / 100;
                                        SalesLine2."Inv. Discount Amount" := Round(TempSalesLine."Inv. Discount Amount", 0.00001);
                                    end;
                                GLSetup."Discount Calculation"::"Line Disc. + Inv. Disc. + Payment Disc.",
                                GLSetup."Discount Calculation"::"Line Disc. + Inv. Disc. * Payment Disc.":
                                    begin
                                        TempSalesLine."Inv. Discount Amount" :=
                                          TempSalesLine."Inv. Discount Amount" +
                                          (SalesLine2."Line Amount" + SalesLine2."Line Discount Amount") *
                                          CustInvDisc."Discount %" / 100;
                                        SalesLine2."Inv. Discount Amount" := Round(TempSalesLine."Inv. Discount Amount", 0.00001);
                                    end;
                            end;
                            TempSalesLine."Inv. Discount Amount" :=
                              TempSalesLine."Inv. Discount Amount" - SalesLine2."Inv. Discount Amount";
                        end;
                        if GLSetup."Payment Discount Type" =
                            GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines"
                        then begin
                            GLSetup.TestField("Discount Calculation");
                            case GLSetup."Discount Calculation" of
                                GLSetup."Discount Calculation"::"Line Disc. + Inv. Disc. + Payment Disc.",
                                GLSetup."Discount Calculation"::"Line Disc. * Inv. Disc. + Payment Disc.":
                                    begin
                                        if SalesLine2."Line Amount" <> 0 then begin
                                            TempSalesLine."Pmt. Discount Amount" :=
                                              TempSalesLine."Pmt. Discount Amount" +
                                              (SalesLine2."Line Amount" + SalesLine2."Line Discount Amount") *
                                              SalesHeader."Payment Discount %" / 100;
                                            SalesLine2."Pmt. Discount Amount" := Round(TempSalesLine."Pmt. Discount Amount", 0.01);
                                        end;
                                    end;
                                GLSetup."Discount Calculation"::"Line Disc. + Inv. Disc. * Payment Disc.",
                                GLSetup."Discount Calculation"::"Line Disc. * Inv. Disc. * Payment Disc.":
                                    begin
                                        if SalesLine2."Line Amount" <> 0 then begin
                                            TempSalesLine."Pmt. Discount Amount" :=
                                              TempSalesLine."Pmt. Discount Amount" +
                                              (SalesLine2."Line Amount" - SalesLine2."Inv. Discount Amount") *
                                              SalesHeader."Payment Discount %" / 100;
                                            SalesLine2."Pmt. Discount Amount" := Round(TempSalesLine."Pmt. Discount Amount", 0.01);
                                        end;
                                    end;
                            end;
                            TempSalesLine."Pmt. Discount Amount" :=
                              TempSalesLine."Pmt. Discount Amount" - SalesLine2."Pmt. Discount Amount";
                        end;

                        if (SalesLine2.Type <> SalesLine2.Type::"Charge (Item)") and
                          (SalesLine2."Prepayment %" = 0)
                        then
                            SalesLine2.Validate("Inv. Discount Amount");
                        SalesLine2."Recalculate Invoice Disc." := false;
                        SalesLine2.Modify();
                    end;
                until SalesLine2.Next() = 0;
            end;

            IsHandled := false;
            OnCalculateInvoiceDiscountOnBeforeCustInvDiscRecExists(SalesHeader, SalesLine2, UpdateHeader, InvDiscBase, ChargeBase, TempVATAmountLine, IsHandled);
            If IsHandled then
                exit;

            if CustInvDiscRecExists(SalesHeader."Invoice Disc. Code") then begin
                ShouldGetCustInvDisc := InvDiscBase <> ChargeBase;
                OnAfterCustInvDiscRecExists(SalesHeader, CustInvDisc, InvDiscBase, ChargeBase, ShouldGetCustInvDisc);
                if ShouldGetCustInvDisc then
                    CustInvDisc.GetRec(
                      SalesHeader."Invoice Disc. Code", SalesHeader."Currency Code", CurrencyDate, InvDiscBase, CustInvDiscFound);

                SalesSetup.Get();
                DiscountNotificationMgt.NotifyAboutMissingSetup(
                  SalesSetup.RecordId, SalesHeader."Gen. Bus. Posting Group", SalesLine2."Gen. Prod. Posting Group",
                  SalesSetup."Discount Posting", SalesSetup."Discount Posting"::"Line Discounts");

                UpdateSalesHeaderInvoiceDiscount(SalesHeader, TempVATAmountLine, SalesSetup."Calc. Inv. Disc. per VAT ID");

                SalesLine2.SetSalesHeader(SalesHeader);
                SalesLine2.UpdateVATOnLines(0, SalesHeader, SalesLine2, TempVATAmountLine);
                UpdatePrepmtLineAmount(SalesHeader);
            end else begin
                SalesHeader."Invoice Discount Calculation" := SalesHeader."Invoice Discount Calculation"::"%";
                SalesHeader."Invoice Discount Value" := CustInvDisc."Discount %";
                if UpdateHeader then
                    SalesHeader.Modify();

                TempVATAmountLine.SetInvoiceDiscountPercent(
                  CustInvDisc."Discount %", SalesHeader."Currency Code",
                  SalesHeader."Prices Including VAT", SalesSetup."Calc. Inv. Disc. per VAT ID",
                  SalesHeader."VAT Base Discount %");

                SalesLine2.SetSalesHeader(SalesHeader);
                SalesLine2.UpdateVATOnLines(0, SalesHeader, SalesLine2, TempVATAmountLine);
                UpdatePrepmtLineAmount(SalesHeader);
            end;
        end;

        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SalesHeader);
        OnAfterCalcSalesDiscount(SalesHeader, TempVATAmountLine, SalesLine2);
    end;

    local procedure UpdateSalesHeaderInvoiceDiscount(var SalesHeader: Record "Sales Header"; var TempVATAmountLine: Record "VAT Amount Line" temporary; CalcInvDiscPerVATID: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateSalesHeaderInvoiceDiscount(CustInvDisc, SalesHeader, TempVATAmountLine, UpdateHeader, IsHandled);
        if IsHandled then
            exit;

        SalesHeader."Invoice Discount Calculation" := SalesHeader."Invoice Discount Calculation"::"%";
        SalesHeader."Invoice Discount Value" := CustInvDisc."Discount %";
        if UpdateHeader then
            SalesHeader.Modify();

        TempVATAmountLine.SetInvoiceDiscountPercent(
          CustInvDisc."Discount %", SalesHeader."Currency Code",
          SalesHeader."Prices Including VAT", CalcInvDiscPerVATID,
          SalesHeader."VAT Base Discount %");
    end;

    local procedure SetSalesLineServiceCharge(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetSalesLineServiceCharge(SalesHeader, SalesLine, CustInvDisc, IsHandled);
        if IsHandled then
            exit;

        if SalesHeader."Prices Including VAT" then
            SalesLine.Validate(
                "Unit Price",
                Round((1 + SalesLine."VAT %" / 100) * CustInvDisc."Service Charge", Currency."Unit-Amount Rounding Precision"))
        else
            SalesLine.Validate("Unit Price", CustInvDisc."Service Charge");
    end;

    procedure CustInvDiscRecExists(InvDiscCode: Code[20]) Result: Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCustInvDiscRecExists(InvDiscCode, Result, IsHandled);
        if IsHandled then
            exit(Result);

        CustInvDisc.SetRange(Code, InvDiscCode);
        exit(CustInvDisc.FindFirst())
    end;

    procedure CalculateWithSalesHeader(var TempSalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line")
    var
        FilterSalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalculateWithSalesHeader(SalesLine, TempSalesHeader, TempSalesLine, UpdateHeader, IsHandled); // <-- NEW EVENT
        if IsHandled then
            exit;

        FilterSalesLine.Copy(TempSalesLine);
        SalesLine := TempSalesLine;

        UpdateHeader := false;
        CalculateInvoiceDiscount(TempSalesHeader, TempSalesLine);

        TempSalesLine.Copy(FilterSalesLine);
    end;

    procedure CalculateInvoiceDiscountOnLine(var SalesLineToUpdate: Record "Sales Line")
    begin
        SalesLine.Copy(SalesLineToUpdate);

        TempSalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        UpdateHeader := false;
        CalculateInvoiceDiscount(TempSalesHeader, SalesLine);

        if SalesLineToUpdate.Get(SalesLineToUpdate."Document Type", SalesLineToUpdate."Document No.", SalesLineToUpdate."Line No.") then;
    end;

    procedure CalculateIncDiscForHeader(var TempSalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalculateIncDiscForHeader(TempSalesHeader, IsHandled, SalesLine, TempSalesLine, UpdateHeader);
        if IsHandled then
            exit;

        SalesSetup.Get();
        if not SalesSetup."Calc. Inv. Discount" then
            exit;

        SalesLine."Document Type" := TempSalesHeader."Document Type";
        SalesLine."Document No." := TempSalesHeader."No.";
        UpdateHeader := true;
        CalculateInvoiceDiscount(TempSalesHeader, TempSalesLine);
    end;

    procedure UpdatePrepmtLineAmount(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if (SalesHeader."Invoice Discount Calculation" = SalesHeader."Invoice Discount Calculation"::"%") and
           (SalesHeader."Prepayment %" > 0) and (SalesHeader."Invoice Discount Value" > 0) and
           (SalesHeader."Invoice Discount Value" + SalesHeader."Prepayment %" >= 100)
        then
            with SalesLine do begin
                SetRange("Document Type", SalesHeader."Document Type");
                SetRange("Document No.", SalesHeader."No.");
                SetLoadFields(Type, Quantity, "Unit Price", "Qty. to Invoice", "Prepayment %", "Prepmt. Line Amount", Amount);
                if FindSet(true) then
                    repeat
                        if not ZeroAmountLine(0) and ("Prepayment %" = SalesHeader."Prepayment %") then begin
                            "Prepmt. Line Amount" := Amount;
                            Modify();
                        end;
                    until Next() = 0;
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcSalesDiscount(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SalesLine: Record "Sales Line"; var UpdateHeader: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcSalesDiscount(var SalesHeader: Record "Sales Header"; var TempVATAmountLine: Record "VAT Amount Line" temporary; var SalesLine2: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCustInvDiscRecExists(var SalesHeader: Record "Sales Header"; var CustInvDisc: Record "Cust. Invoice Disc."; InvDiscBase: Decimal; ChargeBase: Decimal; var ShouldGetCustInvDisc: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateSalesLine2Quantity(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CustInvoiceDisc: Record "Cust. Invoice Disc.")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateIncDiscForHeader(var TempSalesHeader: Record "Sales Header" temporary; var IsHandled: Boolean; var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; var UpdateHeader: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetSalesLineServiceCharge(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CustInvoiceDisc: Record "Cust. Invoice Disc."; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateSalesHeaderInvoiceDiscount(var CustInvoiceDisc: Record "Cust. Invoice Disc."; var SalesHeader: Record "Sales Header"; var TempVATAmountLine: Record "VAT Amount Line" temporary; var UpdateHeader: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeCurrencyInitialize(var CustomerPostingGroup: Record "Customer Posting Group")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeCheckCustInvDiscServiceCharge(var CustInvoiceDisc: Record "Cust. Invoice Disc."; var SalesHeader: Record "Sales Header"; CurrencyDate: Date; ChargeBase: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeCustInvDiscRecExists(var SalesHeader: Record "Sales Header"; var SalesLine2: Record "Sales Line"; var UpdateHeader: Boolean; var InvDiscBase: Decimal; var ChargeBase: Decimal; var TempVATAmountLine: Record "VAT Amount Line" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeSalesLine2FindFirst(var SalesLine2: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeSalesLineInsert(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateWithSalesHeader(var SalesLine: Record "Sales Line"; var TempSalesHeader: Record "Sales Header" temporary; var TempSalesLine: Record "Sales Line"; var UpdateHeader: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeSalesLine2DeleteTrue(UpdateHeader: Boolean; var SalesLine2: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnBeforeCalculateInvoiceDiscount(var SalesLine: Record "Sales Line"; var TempSalesHeader: Record "Sales Header" temporary; var TempSalesLine: Record "Sales Line" temporary; var UpdateHeader: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeUpdateSalesLine2(var SalesHeader: Record "Sales Header"; var SalesLine2: Record "Sales Line"; UpdateHeader: Boolean; CustInvDisc: Record "Cust. Invoice Disc."; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustInvDiscRecExists(InvDiscCode: Code[20]; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateInvoiceDiscount(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var UpdateHeader: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalculateInvoiceDiscountOnBeforeGetGLSetup(var CustInvoiceDisc: Record "Cust. Invoice Disc."; var SalesHeader: Record "Sales Header")
    begin
    end;
}

