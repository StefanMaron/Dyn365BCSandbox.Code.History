codeunit 101931 "Create Local RapidStart Pack"
{
    // Extension for codeunit 101995 Create RapidStart Package


    trigger OnRun()
    begin
    end;

    var
        CreateConfigPackageHelper: Codeunit "Create Config. Package Helper";
        XLocalSettingsTxt: Label 'Local Settings', Locked = true;

    procedure CreateTables()
    begin
        CreateTable(DATABASE::"Fin. Charge Interest Rate");
#if not CLEAN23
        CreateTable(DATABASE::"Payment Period Setup");
#endif
    end;

    procedure CreateTable(TableID: Integer)
    begin
        CreateConfigPackageHelper.CreateTable(TableID);
        SetFieldsAndFilters(TableID);
    end;

    procedure CreateWorksheetLines()
    var
        CreateConfigWorksheet: Codeunit "Create Config. Worksheet";
    begin
        with CreateConfigWorksheet do begin
            CreateConfigGroup(XLocalSettingsTxt);
            CreateConfigLine(DATABASE::"Fin. Charge Interest Rate");
        end;
    end;

    procedure SetFieldsAndFilters(TableID: Integer)
    begin
        case TableID of
        end;
    end;
}

