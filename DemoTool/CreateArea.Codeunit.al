codeunit 161002 "Create Area"
{

    trigger OnRun()
    begin
        InsertData('01', XAlava, XES01);
        InsertData('02', XAlbacete, XES02);
        InsertData('03', XAlicante, XES03);
        InsertData('04', XAlmeria, XES04);
        InsertData('05', XAvila, XES05);
        InsertData('06', XBadajoz, XES06);
        InsertData('07', XBaleares, XES07);
        InsertData('08', XBarcelona, XES08);
        InsertData('09', XBurgos, XES09);
        InsertData('10', XCaceres, XES10);
        InsertData('11', XCadiz, XES11);
        InsertData('12', XCastellon, XES12);
        InsertData('13', XCReal, XES13);
        InsertData('14', XCordoba, XES14);
        InsertData('15', XLaCorunaTxt, XES15);
        InsertData('16', XCuenca, XES16);
        InsertData('17', XGirona, XES17);
        InsertData('18', XGranada, XES18);
        InsertData('19', XGuadalajara, XES19);
        InsertData('20', XGuipuzcoa, XES20);
        InsertData('21', XHuelva, XES21);
        InsertData('22', XHuesca, XES22);
        InsertData('23', XJaen, XES23);
        InsertData('24', XLeon, XES24);
        InsertData('25', XLerida, XES25);
        InsertData('26', XLogrodoTxt, XES26);
        InsertData('27', XLugo, XES27);
        InsertData('28', XMadrid, XES28);
        InsertData('29', XMalaga, XES29);
        InsertData('30', XMurcia, XES30);
        InsertData('31', XNavarra, XES31);
        InsertData('32', XOurense, XES32);
        InsertData('33', XPAsturias, XES33);
        InsertData('34', XPalencia, XES34);
        InsertData('35', XLasPalmas, XES35);
        InsertData('36', XPontevedra, XES36);
        InsertData('37', XSalamanca, XES37);
        InsertData('38', XStaCruzTenerife, XES38);
        InsertData('39', XSantander, XES39);
        InsertData('40', XSegovia, XES40);
        InsertData('41', XSevilla, XES41);
        InsertData('42', XSoria, XES42);
        InsertData('43', XTarragona, XES43);
        InsertData('44', XTeruel, XES44);
        InsertData('45', XToledo, XES45);
        InsertData('46', XValencia, XES46);
        InsertData('47', XValladolid, XES47);
        InsertData('48', XVizcaya, XES48);
        InsertData('49', XZamora, XES49);
        InsertData('50', XZaragoza, XES50);
    end;

    var
        Provincia: Record "Area";
        XAlava: Label 'Alava';
        XAlbacete: Label 'Albacete';
        XAlicante: Label 'Alicante/Alacant';
        XAlmeria: Label 'Almería';
        XAvila: Label 'Avila';
        XBadajoz: Label 'Badajoz';
        XBarcelona: Label 'Barcelona';
        XBaleares: Label 'Baleares';
        XBurgos: Label 'Burgos';
        XCaceres: Label 'Cáceres';
        XCadiz: Label 'Cádiz';
        XCastellon: Label 'Castellón';
        XCReal: Label 'C. Real';
        XCordoba: Label 'Córdoba';
        XLaCorunaTxt: Label 'La Coruña';
        XCuenca: Label 'Cuenca';
        XGirona: Label 'Girona';
        XGranada: Label 'Granada';
        XGuadalajara: Label 'Guadalajara';
        XGuipuzcoa: Label 'Guipúzcoa';
        XHuelva: Label 'Huelva';
        XHuesca: Label 'Huesca';
        XJaen: Label 'Jaen';
        XLeon: Label 'León';
        XLerida: Label 'Lérida';
        XLogrodoTxt: Label 'Logroño';
        XLugo: Label 'Lugo';
        XMadrid: Label 'Madrid';
        XMalaga: Label 'Málaga';
        XMurcia: Label 'Murcia';
        XNavarra: Label 'Navarra';
        XOurense: Label 'Ourense';
        XPAsturias: Label 'P. Asturias';
        XPalencia: Label 'Palencia';
        XLasPalmas: Label 'Las Palmas';
        XPontevedra: Label 'Pontevedra';
        XSalamanca: Label 'Salamanca';
        XStaCruzTenerife: Label 'Sta. Cruz Tenerife';
        XSantander: Label 'Santander';
        XSegovia: Label 'Segovia';
        XSevilla: Label 'Sevilla';
        XSoria: Label 'Soria';
        XTarragona: Label 'Tarragona';
        XTeruel: Label 'Teruel';
        XToledo: Label 'Toledo';
        XValencia: Label 'Valencia';
        XValladolid: Label 'Valladolid';
        XVizcaya: Label 'Vizcaya';
        XZamora: Label 'Zamora';
        XZaragoza: Label 'Zaragoza';
        XES01: Label 'ES-01';
        XES02: Label 'ES-02';
        XES03: Label 'ES-03';
        XES04: Label 'ES-04';
        XES05: Label 'ES-05';
        XES06: Label 'ES-06';
        XES07: Label 'ES-07';
        XES08: Label 'ES-08';
        XES09: Label 'ES-09';
        XES10: Label 'ES-10';
        XES11: Label 'ES-11';
        XES12: Label 'ES-12';
        XES13: Label 'ES-13';
        XES14: Label 'ES-14';
        XES15: Label 'ES-15';
        XES16: Label 'ES-16';
        XES17: Label 'ES-17';
        XES18: Label 'ES-18';
        XES19: Label 'ES-19';
        XES20: Label 'ES-20';
        XES21: Label 'ES-21';
        XES22: Label 'ES-22';
        XES23: Label 'ES-23';
        XES24: Label 'ES-24';
        XES25: Label 'ES-25';
        XES26: Label 'ES-26';
        XES27: Label 'ES-27';
        XES28: Label 'ES-28';
        XES29: Label 'ES-29';
        XES30: Label 'ES-30';
        XES31: Label 'ES-31';
        XES32: Label 'ES-32';
        XES33: Label 'ES-33';
        XES34: Label 'ES-34';
        XES35: Label 'ES-35';
        XES36: Label 'ES-36';
        XES37: Label 'ES-37';
        XES38: Label 'ES-38';
        XES39: Label 'ES-39';
        XES40: Label 'ES-40';
        XES41: Label 'ES-41';
        XES42: Label 'ES-42';
        XES43: Label 'ES-43';
        XES44: Label 'ES-44';
        XES45: Label 'ES-45';
        XES46: Label 'ES-46';
        XES47: Label 'ES-47';
        XES48: Label 'ES-48';
        XES49: Label 'ES-49';
        XES50: Label 'ES-50';

    procedure InsertData("Code": Code[10]; Text: Text[50]; "Post Code Prefix": Code[20])
    begin
        Provincia.Init();
        Provincia.Validate(Code, Code);
        Provincia.Validate(Text, Text);
        Provincia.Validate("Post Code Prefix", "Post Code Prefix");
        Provincia.Insert();
    end;
}
