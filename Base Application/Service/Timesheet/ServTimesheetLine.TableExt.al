namespace Microsoft.Projects.TimeSheet;

using Microsoft.Service.Document;

tableextension 6464 "Serv. Time Sheet Line" extends "Time Sheet Line"
{
    fields
    {
        field(13; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = CustomerContent;
            TableRelation = if (Posted = const(false)) "Service Header"."No." where("Document Type" = const(Order));

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header";
            begin
                if "Service Order No." <> '' then begin
                    TestField(Type, Type::Service);
                    ServiceHeader.Get(ServiceHeader."Document Type"::Order, "Service Order No.");
                    Description := CopyStr(
                        StrSubstNo(DescriptionTxt, "Service Order No.", ServiceHeader."Customer No."),
                        1,
                        MaxStrLen(Description));
                end else
                    Description := '';
            end;
        }
        field(14; "Service Order Line No."; Integer)
        {
            Caption = 'Service Order Line No.';
            DataClassification = CustomerContent;
        }
    }

    var
        DescriptionTxt: Label 'Service order %1 for customer %2', Comment = '%1 - order number, %2 - customer number';
}