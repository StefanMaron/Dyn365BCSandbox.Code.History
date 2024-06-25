namespace Microsoft.Service.Setup;

using Microsoft.Foundation.Company;

codeunit 6475 "Service Company Initialize"
{
    Permissions = tabledata "Service Mgt. Setup" = i;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnAfterInitSetupTables', '', false, false)]
    local procedure OnAfterInitSetupTables()
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
    begin
        if not ServiceMgtSetup.FindFirst() then begin
            ServiceMgtSetup.Init();
            ServiceMgtSetup.Insert();
        end;
    end;
}