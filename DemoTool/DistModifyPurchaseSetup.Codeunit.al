codeunit 118821 "Dist. Modify Purchase Setup"
{

    trigger OnRun()
    begin
        with "Purchases & Payables Setup" do begin
            Get();
            "Create No. Series".InitTempSeries("Order Nos.", XPORDD, XPurchaseOrderDist, 6);
            "Order Nos." := XPORDD;
            Modify();
        end;
    end;

    var
        "Purchases & Payables Setup": Record "Purchases & Payables Setup";
        "Create No. Series": Codeunit "Create No. Series";
        XPORDD: Label 'P-ORD-D';
        XPurchaseOrderDist: Label 'Purchase Order (Dist)';
        XPORD: Label 'P-ORD';

    procedure Finalize()
    begin
        with "Purchases & Payables Setup" do begin
            Get();
            "Order Nos." := XPORD;
            Modify();
        end;
    end;
}

