codeunit 135161 "Cloud Mig Country Tables"
{
    procedure GetTablesThatShouldBeCloudMigrated(var ListOfTablesToMigrate: List of [Integer])
    begin
        ListOfTablesToMigrate.Add(Database::"Accounting Period GB");
        ListOfTablesToMigrate.Add(Database::"BACS Ledger Entry");
        ListOfTablesToMigrate.Add(Database::"BACS Register");
        ListOfTablesToMigrate.Add(Database::"Fin. Charge Interest Rate");
        ListOfTablesToMigrate.Add(Database::"GovTalk Message Parts");
        ListOfTablesToMigrate.Add(Database::"GovTalk Setup");
        ListOfTablesToMigrate.Add(Database::"GovTalkMessage");
        ListOfTablesToMigrate.Add(Database::"MTD-Default Fraud Prev. Hdr");
#if not CLEAN25
        ListOfTablesToMigrate.Add(Database::"MTD-Liability");
#endif
        ListOfTablesToMigrate.Add(Database::"MTD-Missing Fraud Prev. Hdr");
#if not CLEAN25
        ListOfTablesToMigrate.Add(Database::"MTD-Payment");
        ListOfTablesToMigrate.Add(Database::"MTD-Return Details");
#endif
        ListOfTablesToMigrate.Add(Database::"MTD-Session Fraud Prev. Hdr");
#if not CLEAN23
        ListOfTablesToMigrate.Add(Database::"Payment Application Buffer");
        ListOfTablesToMigrate.Add(Database::"Payment Period Setup");
#endif
        ListOfTablesToMigrate.Add(Database::"Postcode Notification Memory");
    end;
}