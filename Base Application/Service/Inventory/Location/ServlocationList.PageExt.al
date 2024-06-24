namespace Microsoft.Inventory.Location;

using Microsoft.Service.Resources;

pageextension 6459 "Serv. Location List" extends "Location List"
{
    actions
    {
        addafter("&Bins")
        {
            action("&Resource Locations")
            {
                ApplicationArea = Location;
                Caption = '&Resource Locations';
                Image = Resource;
                RunObject = Page "Resource Locations";
                RunPageLink = "Location Code" = field(Code);
                ToolTip = 'View or edit information about where resources are located. In this window, you can assign resources to locations.';
            }
        }
        addafter("&Bins_Promoted")
        {
            actionref("&Resource Locations_Promoted"; "&Resource Locations")
            {
            }
        }
    }
}