codeunit 1883 "Sandbox Cleanup local"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Environment Cleanup", 'OnClearCompanyConfig', '', false, false)]
    local procedure OnClearConfiguration(CompanyName: Text; SourceEnv: Enum "Environment Type"; DestinationEnv: Enum "Environment Type")
    var
        GovTalkSetup: Record "GovTalk Setup";
        nullGUID: Guid;
    begin
        GovTalkSetup.ModifyAll(Password, nullGUID);
    end;
}

