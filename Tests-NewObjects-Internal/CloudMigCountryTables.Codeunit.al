codeunit 135161 "Cloud Mig Country Tables"
{
    procedure GetTablesThatShouldBeCloudMigrated(var ListOfTablesToMigrate: List of [Integer])
    begin
#if not CLEAN22
        ListOfTablesToMigrate.Add(Database::"Automatic Acc. Header");
        ListOfTablesToMigrate.Add(Database::"Automatic Acc. Line");
#endif
        ListOfTablesToMigrate.Add(Database::"Depr. Diff. Posting Buffer");
        ListOfTablesToMigrate.Add(Database::"Foreign Payment Types");
#if not CLEAN22
        ListOfTablesToMigrate.Add(Database::"Intrastat - File Setup");
#endif
        ListOfTablesToMigrate.Add(Database::"Ref. Payment - Exported Buffer");
        ListOfTablesToMigrate.Add(Database::"Ref. Payment - Exported");
        ListOfTablesToMigrate.Add(Database::"Ref. Payment - Imported");
        ListOfTablesToMigrate.Add(Database::"Reference File Setup");
    end;
}