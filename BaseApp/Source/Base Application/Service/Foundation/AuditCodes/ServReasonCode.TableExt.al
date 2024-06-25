namespace Microsoft.Foundation.AuditCodes;

using Microsoft.Service.Contract;

tableextension 6469 "Serv. Reason Code" extends "Reason Code"
{
    fields
    {
        field(5901; "Contract Gain/Loss Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Contract Gain/Loss Entry".Amount where("Reason Code" = field(Code),
                                                                       "Change Date" = field("Date Filter")));
            Caption = 'Contract Gain/Loss Amount';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}