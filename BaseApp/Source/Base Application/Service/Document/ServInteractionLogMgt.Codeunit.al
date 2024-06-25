namespace Microsoft.CRM.Interaction;

using Microsoft.Service.Contract;
using Microsoft.Service.Document;

codeunit 6467 "Serv. Interaction Log Mgt."
{

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnBeforeShowDocument', '', false, false)]
    local procedure OnBeforeShowDocument(var InteractionLogEntry: Record "Interaction Log Entry"; var IsHandled: Boolean)
    var
        ServiceHeader: Record "Service Header";
        ServiceContractHeader: Record "Service Contract Header";
    begin
        case InteractionLogEntry."Document Type" of
            InteractionLogEntry."Document Type"::"Serv. Ord. Create":
                begin
                    ServiceHeader.Get(ServiceHeader."Document Type"::Order, InteractionLogEntry."Document No.");
                    PAGE.Run(PAGE::"Service Order", ServiceHeader)
                end;
            InteractionLogEntry."Document Type"::"Service Contract":
                begin
                    ServiceContractHeader.Get(ServiceContractHeader."Contract Type"::Contract, InteractionLogEntry."Document No.");
                    PAGE.Run(PAGE::"Service Contract", ServiceContractHeader);
                end;
            InteractionLogEntry."Document Type"::"Service Contract Quote":
                begin
                    ServiceContractHeader.Get(ServiceContractHeader."Contract Type"::Quote, InteractionLogEntry."Document No.");
                    PAGE.Run(PAGE::"Service Contract Quote", ServiceContractHeader);
                end;
            InteractionLogEntry."Document Type"::"Service Quote":
                begin
                    ServiceHeader.Get(ServiceHeader."Document Type"::Quote, InteractionLogEntry."Document No.");
                    PAGE.Run(PAGE::"Service Quote", ServiceHeader);
                end;
        end;
    end;

}