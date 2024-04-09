codeunit 101277 "Create Bank Acc. Posting Group"
{

    trigger OnRun()
    var
        GetGLAccNo: Codeunit "Create G/L Account";
    begin
        DemoDataSetup.Get();
        if DemoDataSetup."Data Type" = DemoDataSetup."Data Type"::Extended then begin
            InsertData(XLCY, '992920');
            InsertData(XLCY2, '992940');
            InsertData(XCURRENCIES, '992930');
            InsertData(XOPERATING, '995310');
        end else begin
            InsertData(XFCY, GetGLAccNo.BankCurrencies());
            InsertData(XLCY, GetGLAccNo.BankLCY());
            InsertData(XCASH, GetGLAccNo.Cash());
            InsertData(XOPERATING, GetGLAccNo.RevolvingCredit())
        end;
    end;

    var
        DemoDataSetup: Record "Demo Data Setup";
        "Bank Acc. Posting Group": Record "Bank Account Posting Group";
        CA: Codeunit "Make Adjustments";
        XLCY: Label 'LCY';
        XLCY2: Label 'LCY2';
        XFCY: Label 'FCY';
        XCURRENCIES: Label 'CURRENCIES';
        XOPERATING: Label 'OPERATING', Comment = 'To be translated.';
        XCASH: Label 'CASH', Comment = 'To be translated.';

    procedure InsertData("Code": Code[20]; "G/L Account No.": Code[20])
    begin
        "Bank Acc. Posting Group".Init();
        "Bank Acc. Posting Group".Validate(Code, Code);
        "Bank Acc. Posting Group".Validate("G/L Account No.", CA.Convert("G/L Account No."));
        "Bank Acc. Posting Group".Insert();
    end;
}

