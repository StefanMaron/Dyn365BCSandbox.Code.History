namespace Microsoft.Foundation.AuditCodes;

tableextension 6467 "Serv. Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(5900; "Service Management"; Code[10])
        {
            Caption = 'Service Management';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
    }
}