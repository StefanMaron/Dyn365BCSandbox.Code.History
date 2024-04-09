codeunit 5126 "Create Common CountryOrRegion"
{
    InherentEntitlements = X;
    InherentPermissions = X;
    Description = 'Should contain all country or region where BC is available, updated as of 2023-08-02.';
    // https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/compliance/apptest-countries-and-translations

    trigger OnRun()
    var
        ContosoCountryOrRegion: Codeunit "Contoso Country Or Region";
    begin
        // order by ISONumericCode
        ContosoCountryOrRegion.InsertCountryOrRegion('AL', AlbaniaLbl, '008');
        ContosoCountryOrRegion.InsertCountryOrRegion('DZ', AlgeriaLbl, '012');
        ContosoCountryOrRegion.InsertCountryOrRegion('AD', AndorraLbl, '020');
        ContosoCountryOrRegion.InsertCountryOrRegion('AO', AngolaLbl, '024');
        ContosoCountryOrRegion.InsertCountryOrRegion('AZ', AzerbaijanLbl, '031');
        ContosoCountryOrRegion.InsertCountryOrRegion('AR', ArgentinaLbl, '032');
        ContosoCountryOrRegion.InsertCountryOrRegion('AU', AustraliaLbl, '036');
        ContosoCountryOrRegion.InsertCountryOrRegion('AT', AustriaLbl, '040');
        ContosoCountryOrRegion.InsertCountryOrRegion('BS', BahamasLbl, '044');
        ContosoCountryOrRegion.InsertCountryOrRegion('BH', BahrainLbl, '048');
        ContosoCountryOrRegion.InsertCountryOrRegion('BD', BangladeshLbl, '050');
        ContosoCountryOrRegion.InsertCountryOrRegion('AM', ArmeniaLbl, '051');
        ContosoCountryOrRegion.InsertCountryOrRegion('BE', BelgiumLbl, '056');
        ContosoCountryOrRegion.InsertCountryOrRegion('BM', BermudaLbl, '060');
        ContosoCountryOrRegion.InsertCountryOrRegion('BO', BoliviaLbl, '068');
        ContosoCountryOrRegion.InsertCountryOrRegion('BA', BosniaAndHerzegovinaLbl, '070');
        ContosoCountryOrRegion.InsertCountryOrRegion('BW', BotswanaLbl, '072');
        ContosoCountryOrRegion.InsertCountryOrRegion('BR', BrazilLbl, '076');
        ContosoCountryOrRegion.InsertCountryOrRegion('SB', SolomonIslandsLbl, '090');
        ContosoCountryOrRegion.InsertCountryOrRegion('VG', BritishVirginIslandsLbl, '092');
        ContosoCountryOrRegion.InsertCountryOrRegion('BN', BruneiDarussalamLbl, '096');
        ContosoCountryOrRegion.InsertCountryOrRegion('BG', BulgariaLbl, '100');
        ContosoCountryOrRegion.InsertCountryOrRegion('KH', CambodiaLbl, '116');
        ContosoCountryOrRegion.InsertCountryOrRegion('CM', CameroonLbl, '120');
        ContosoCountryOrRegion.InsertCountryOrRegion('CA', CanadaLbl, '124');
        ContosoCountryOrRegion.InsertCountryOrRegion('KY', CaymanIslandsLbl, '136');
        ContosoCountryOrRegion.InsertCountryOrRegion('LK', SriLankaLbl, '144');
        ContosoCountryOrRegion.InsertCountryOrRegion('CL', ChileLbl, '152');
        ContosoCountryOrRegion.InsertCountryOrRegion('CN', ChinaTxtLbl, '156');
        ContosoCountryOrRegion.InsertCountryOrRegion('TW', TaiwanLbl, '158');
        ContosoCountryOrRegion.InsertCountryOrRegion('CO', ColombiaLbl, '170');
        ContosoCountryOrRegion.InsertCountryOrRegion('CR', CostaRicaLbl, '188');
        ContosoCountryOrRegion.InsertCountryOrRegion('HR', CroatiaLbl, '191');
        ContosoCountryOrRegion.InsertCountryOrRegion('CY', CyprusLbl, '196');
        ContosoCountryOrRegion.InsertCountryOrRegion('CZ', CzechiaLbl, '203');
        ContosoCountryOrRegion.InsertCountryOrRegion('DK', DenmarkLbl, '208');
        ContosoCountryOrRegion.InsertCountryOrRegion('DO', DominicanRepublicLbl, '214');
        ContosoCountryOrRegion.InsertCountryOrRegion('EC', EcuadorLbl, '218');
        ContosoCountryOrRegion.InsertCountryOrRegion('SV', ElSalvadorLbl, '222');
        ContosoCountryOrRegion.InsertCountryOrRegion('ET', EthiopiaLbl, '231');
        ContosoCountryOrRegion.InsertCountryOrRegion('EE', EstoniaLbl, '233');
        ContosoCountryOrRegion.InsertCountryOrRegion('FO', FaroeIslandsLbl, '234');
        ContosoCountryOrRegion.InsertCountryOrRegion('FJ', FijiIslandsLbl, '242');
        ContosoCountryOrRegion.InsertCountryOrRegion('FI', FinlandLbl, '246');
        ContosoCountryOrRegion.InsertCountryOrRegion('FR', FranceLbl, '250');
        ContosoCountryOrRegion.InsertCountryOrRegion('DE', GermanyLbl, '276');
        ContosoCountryOrRegion.InsertCountryOrRegion('GE', GeorgiaLbl, '268');
        ContosoCountryOrRegion.InsertCountryOrRegion('GH', GhanaLbl, '288');
        ContosoCountryOrRegion.InsertCountryOrRegion('EL', GreeceLbl, '300');
        ContosoCountryOrRegion.InsertCountryOrRegion('GL', GreenlandLbl, '304');
        ContosoCountryOrRegion.InsertCountryOrRegion('GT', GuatemalaLbl, '320');
        ContosoCountryOrRegion.InsertCountryOrRegion('HN', HondurasLbl, '340');
        ContosoCountryOrRegion.InsertCountryOrRegion('HK', HongKongLbl, '344');
        ContosoCountryOrRegion.InsertCountryOrRegion('HU', HungaryLbl, '348');
        ContosoCountryOrRegion.InsertCountryOrRegion('IS', IcelandLbl, '352');
        ContosoCountryOrRegion.InsertCountryOrRegion('IN', IndiaLbl, '356');
        ContosoCountryOrRegion.InsertCountryOrRegion('ID', IndonesiaLbl, '360');
        ContosoCountryOrRegion.InsertCountryOrRegion('IE', IrelandLbl, '372');
        ContosoCountryOrRegion.InsertCountryOrRegion('IL', IsraelLbl, '376');
        ContosoCountryOrRegion.InsertCountryOrRegion('IT', ItalyLbl, '380');
        ContosoCountryOrRegion.InsertCountryOrRegion('JM', JamaicaLbl, '388');
        ContosoCountryOrRegion.InsertCountryOrRegion('JP', JapanLbl, '392');
        ContosoCountryOrRegion.InsertCountryOrRegion('KZ', KazakhstanLbl, '398');
        ContosoCountryOrRegion.InsertCountryOrRegion('JO', JordanLbl, '400');
        ContosoCountryOrRegion.InsertCountryOrRegion('KE', KenyaLbl, '404');
        ContosoCountryOrRegion.InsertCountryOrRegion('KR', SouthKoreaLbl, '410');
        ContosoCountryOrRegion.InsertCountryOrRegion('KW', KuwaitLbl, '414');
        ContosoCountryOrRegion.InsertCountryOrRegion('LB', LebanonLbl, '422');
        ContosoCountryOrRegion.InsertCountryOrRegion('LV', LatviaLbl, '428');
        ContosoCountryOrRegion.InsertCountryOrRegion('LI', LiechtensteinLbl, '438');
        ContosoCountryOrRegion.InsertCountryOrRegion('LT', LithuaniaLbl, '440');
        ContosoCountryOrRegion.InsertCountryOrRegion('LU', LuxembourgLbl, '442');
        ContosoCountryOrRegion.InsertCountryOrRegion('MY', MalaysiaLbl, '458');
        ContosoCountryOrRegion.InsertCountryOrRegion('MO', MacaoLbl, '446');
        ContosoCountryOrRegion.InsertCountryOrRegion('MG', MadagascarLbl, '450');
        ContosoCountryOrRegion.InsertCountryOrRegion('MW', MalawiLbl, '454');
        ContosoCountryOrRegion.InsertCountryOrRegion('MV', MaldivesLbl, '462');
        ContosoCountryOrRegion.InsertCountryOrRegion('MT', MaltaLbl, '470');
        ContosoCountryOrRegion.InsertCountryOrRegion('MU', MauritiusLbl, '480');
        ContosoCountryOrRegion.InsertCountryOrRegion('MX', MexicoLbl, '484');
        ContosoCountryOrRegion.InsertCountryOrRegion('MC', MonacoLbl, '492');
        ContosoCountryOrRegion.InsertCountryOrRegion('MN', MongoliaLbl, '496');
        ContosoCountryOrRegion.InsertCountryOrRegion('ME', MontenegroLbl, '499');
        ContosoCountryOrRegion.InsertCountryOrRegion('MA', MoroccoLbl, '504');
        ContosoCountryOrRegion.InsertCountryOrRegion('MZ', MozambiqueLbl, '508');
        ContosoCountryOrRegion.InsertCountryOrRegion('OM', OmanLbl, '512');
        ContosoCountryOrRegion.InsertCountryOrRegion('NA', NamibiaLbl, '516');
        ContosoCountryOrRegion.InsertCountryOrRegion('NP', NepalLbl, '524');
        ContosoCountryOrRegion.InsertCountryOrRegion('NL', NetherlandsLbl, '528');
        ContosoCountryOrRegion.InsertCountryOrRegion('VU', VanuatuLbl, '548');
        ContosoCountryOrRegion.InsertCountryOrRegion('NZ', NewZealandLbl, '554');
        ContosoCountryOrRegion.InsertCountryOrRegion('NI', NicaraguaLbl, '558');
        ContosoCountryOrRegion.InsertCountryOrRegion('NG', NigeriaLbl, '566');
        ContosoCountryOrRegion.InsertCountryOrRegion('NO', NorwayLbl, '578');
        ContosoCountryOrRegion.InsertCountryOrRegion('PK', PakistanLbl, '586');
        ContosoCountryOrRegion.InsertCountryOrRegion('PA', PanamaLbl, '591');
        ContosoCountryOrRegion.InsertCountryOrRegion('PY', ParaguayLbl, '600');
        ContosoCountryOrRegion.InsertCountryOrRegion('PE', PeruLbl, '604');
        ContosoCountryOrRegion.InsertCountryOrRegion('PH', PhilippinesLbl, '608');
        ContosoCountryOrRegion.InsertCountryOrRegion('PL', PolandLbl, '616');
        ContosoCountryOrRegion.InsertCountryOrRegion('PT', PortugalLbl, '620');
        ContosoCountryOrRegion.InsertCountryOrRegion('PR', PuertoRicoLbl, '630');
        ContosoCountryOrRegion.InsertCountryOrRegion('QA', QatarLbl, '634');
        ContosoCountryOrRegion.InsertCountryOrRegion('RO', RomaniaLbl, '642');
        ContosoCountryOrRegion.InsertCountryOrRegion('RU', RussiaLbl, '643');
        ContosoCountryOrRegion.InsertCountryOrRegion('SM', SanMarinoLbl, '674');
        ContosoCountryOrRegion.InsertCountryOrRegion('ST', SaoTomeandPrincipeLbl, '678');
        ContosoCountryOrRegion.InsertCountryOrRegion('SA', SaudiArabiaLbl, '682');
        ContosoCountryOrRegion.InsertCountryOrRegion('SN', SenegalLbl, '686');
        ContosoCountryOrRegion.InsertCountryOrRegion('RS', SerbiaLbl, '688');
        ContosoCountryOrRegion.InsertCountryOrRegion('SG', SingaporeLbl, '702');
        ContosoCountryOrRegion.InsertCountryOrRegion('SK', SlovakiaLbl, '703');
        ContosoCountryOrRegion.InsertCountryOrRegion('VN', VietnamLbl, '704');
        ContosoCountryOrRegion.InsertCountryOrRegion('SI', SloveniaLbl, '705');
        ContosoCountryOrRegion.InsertCountryOrRegion('ZA', SouthAfricaLbl, '710');
        ContosoCountryOrRegion.InsertCountryOrRegion('ZW', ZimbabweLbl, '716');
        ContosoCountryOrRegion.InsertCountryOrRegion('ES', SpainLbl, '724');
        ContosoCountryOrRegion.InsertCountryOrRegion('SZ', SwazilandLbl, '748');
        ContosoCountryOrRegion.InsertCountryOrRegion('SE', SwedenLbl, '752');
        ContosoCountryOrRegion.InsertCountryOrRegion('CH', SwitzerlandLbl, '756');
        ContosoCountryOrRegion.InsertCountryOrRegion('TH', ThailandLbl, '764');
        ContosoCountryOrRegion.InsertCountryOrRegion('TT', TrinidadandTobagoLbl, '780');
        ContosoCountryOrRegion.InsertCountryOrRegion('AE', UnitedArabEmiratesLbl, '784');
        ContosoCountryOrRegion.InsertCountryOrRegion('TN', TunisiaLbl, '788');
        ContosoCountryOrRegion.InsertCountryOrRegion('TR', TurkeyLbl, '792');
        ContosoCountryOrRegion.InsertCountryOrRegion('UG', UgandaLbl, '800');
        ContosoCountryOrRegion.InsertCountryOrRegion('UA', UkraineLbl, '804');
        ContosoCountryOrRegion.InsertCountryOrRegion('MK', NorthMacedoniaLbl, '807');
        ContosoCountryOrRegion.InsertCountryOrRegion('EG', EgyptLbl, '818');
        ContosoCountryOrRegion.InsertCountryOrRegion('GB', GreatBritainLbl, '826');
        ContosoCountryOrRegion.InsertCountryOrRegion('GG', GuernseyLbl, '831');
        ContosoCountryOrRegion.InsertCountryOrRegion('JE', JerseyLbl, '832');
        ContosoCountryOrRegion.InsertCountryOrRegion('IM', IsleofManLbl, '833');
        ContosoCountryOrRegion.InsertCountryOrRegion('TZ', TanzaniaLbl, '834');
        ContosoCountryOrRegion.InsertCountryOrRegion('US', USALbl, '840');
        ContosoCountryOrRegion.InsertCountryOrRegion('UY', UruguayLbl, '858');
        ContosoCountryOrRegion.InsertCountryOrRegion('WS', SamoaLbl, '882');
        ContosoCountryOrRegion.InsertCountryOrRegion('ZM', ZambiaLbl, '894');
        ContosoCountryOrRegion.InsertCountryOrRegion('XK', KosovoLbl, '');
    end;

    var
        AlbaniaLbl: Label 'Albania', MaxLength = 50;
        AustriaLbl: Label 'Austria', MaxLength = 50;
        AndorraLbl: Label 'Andorra', MaxLength = 50;
        ArgentinaLbl: Label 'Argentina', MaxLength = 50;
        AngolaLbl: Label 'Angola', MaxLength = 50;
        ArmeniaLbl: Label 'Armenia', MaxLength = 50;
        BahamasLbl: Label 'Bahamas', MaxLength = 50;
        AzerbaijanLbl: Label 'Azerbaijan', MaxLength = 50;
        CameroonLbl: Label 'Cameroon', MaxLength = 50;
        BahrainLbl: Label 'Bahrain', MaxLength = 50;
        BangladeshLbl: Label 'Bangladesh', MaxLength = 50;
        BermudaLbl: Label 'Bermuda', MaxLength = 50;
        BosniaandHerzegovinaLbl: Label 'Bosnia and Herzegovina', MaxLength = 50;
        FaroeIslandsLbl: Label 'Faroe Islands', MaxLength = 50;
        BritishVirginIslandsLbl: Label 'British Virgin Islands', MaxLength = 50;
        BoliviaLbl: Label 'Bolivia', MaxLength = 50;
        ChileLbl: Label 'Chile', MaxLength = 50;
        CambodiaLbl: Label 'Cambodia', MaxLength = 50;
        HongKongLbl: Label 'Hong Kong', MaxLength = 50;
        BotswanaLbl: Label 'Botswana', MaxLength = 50;
        CaymanIslandsLbl: Label 'Cayman Islands', MaxLength = 50;
        ColombiaLbl: Label 'Colombia', MaxLength = 50;
        DominicanRepublicLbl: Label 'Dominican Republic', MaxLength = 50;
        GuernseyLbl: Label 'Guernsey', MaxLength = 50;
        EcuadorLbl: Label 'Ecuador', MaxLength = 50;
        HondurasLbl: Label 'Honduras', MaxLength = 50;
        EgyptLbl: Label 'Egypt', MaxLength = 50;
        ElSalvadorLbl: Label 'El Salvador', MaxLength = 50;
        GeorgiaLbl: Label 'Georgia', MaxLength = 50;
        EthiopiaLbl: Label 'Ethiopia', MaxLength = 50;
        GreenlandLbl: Label 'Greenland', MaxLength = 50;
        GhanaLbl: Label 'Ghana', MaxLength = 50;
        GuatemalaLbl: Label 'Guatemala', MaxLength = 50;
        IsleofManLbl: Label 'Isle of Man', MaxLength = 50;
        JamaicaLbl: Label 'Jamaica', MaxLength = 50;
        IsraelLbl: Label 'Israel', MaxLength = 50;
        JerseyLbl: Label 'Jersey', MaxLength = 50;
        JordanLbl: Label 'Jordan', MaxLength = 50;
        KazakhstanLbl: Label 'Kazakhstan', MaxLength = 50;
        KuwaitLbl: Label 'Kuwait', MaxLength = 50;
        LebanonLbl: Label 'Lebanon', MaxLength = 50;
        LiechtensteinLbl: Label 'Liechtenstein', MaxLength = 50;
        MadagascarLbl: Label 'Madagascar', MaxLength = 50;
        MalawiLbl: Label 'Malawi', MaxLength = 50;
        MongoliaLbl: Label 'Mongolia', MaxLength = 50;
        NepalLbl: Label 'Nepal', MaxLength = 50;
        PakistanLbl: Label 'Pakistan', MaxLength = 50;
        PanamaLbl: Label 'Panama', MaxLength = 50;
        ParaguayLbl: Label 'Paraguay', MaxLength = 50;
        PeruLbl: Label 'Peru', MaxLength = 50;
        QatarLbl: Label 'Qatar', MaxLength = 50;
        SanMarinoLbl: Label 'San Marino', MaxLength = 50;
        SaoTomeandPrincipeLbl: Label 'Sao Tome and Principe', MaxLength = 50;
        TaiwanLbl: Label 'Taiwan', MaxLength = 50;
        VietnamLbl: Label 'Vietnam', MaxLength = 50;
        ZambiaLbl: Label 'Zambia', MaxLength = 50;
        ZimbabweLbl: Label 'Zimbabwe', MaxLength = 50;
        MacaoLbl: Label 'Macao', MaxLength = 50;
        MaldivesLbl: Label 'Maldives', MaxLength = 50;
        MauritiusLbl: Label 'Mauritius', MaxLength = 50;
        MonacoLbl: Label 'Monaco', MaxLength = 50;
        NamibiaLbl: Label 'Namibia', MaxLength = 50;
        NicaraguaLbl: Label 'Nicaragua', MaxLength = 50;
        NorthMacedoniaLbl: Label 'North Macedonia', MaxLength = 50;
        OmanLbl: Label 'Oman', MaxLength = 50;
        PuertoRicoLbl: Label 'Puerto Rico', MaxLength = 50;
        SenegalLbl: Label 'Senegal', MaxLength = 50;
        SouthKoreaLbl: Label 'South Korea', MaxLength = 50;
        SriLankaLbl: Label 'Sri Lanka', MaxLength = 50;
        TrinidadandTobagoLbl: Label 'Trinidad and Tobago', MaxLength = 50;
        UkraineLbl: Label 'Ukraine', MaxLength = 50;
        UruguayLbl: Label 'Uruguay', MaxLength = 50;
        KosovoLbl: Label 'Kosovo', MaxLength = 50;
        AustraliaLbl: Label 'Australia', MaxLength = 50;
        BelgiumLbl: Label 'Belgium', MaxLength = 50;
        BulgariaLbl: Label 'Bulgaria', MaxLength = 50;
        BrazilLbl: Label 'Brazil', MaxLength = 50;
        CanadaLbl: Label 'Canada', MaxLength = 50;
        ChinaTxtLbl: Label 'China', MaxLength = 50;
        CroatiaLbl: Label 'Croatia', MaxLength = 50;
        CyprusLbl: Label 'Cyprus', MaxLength = 50;
        SwitzerlandLbl: Label 'Switzerland', MaxLength = 50;
        MontenegroLbl: Label 'Montenegro', MaxLength = 50;
        SerbiaLbl: Label 'Serbia', MaxLength = 50;
        CzechiaLbl: Label 'Czechia', MaxLength = 50;
        GermanyLbl: Label 'Germany', MaxLength = 50;
        DenmarkLbl: Label 'Denmark', MaxLength = 50;
        SpainLbl: Label 'Spain', MaxLength = 50;
        EstoniaLbl: Label 'Estonia', MaxLength = 50;
        FranceLbl: Label 'France', MaxLength = 50;
        GreatBritainLbl: Label 'Great Britain', MaxLength = 50;
        IndonesiaLbl: Label 'Indonesia', MaxLength = 50;
        IndiaLbl: Label 'India', MaxLength = 50;
        IcelandLbl: Label 'Iceland', MaxLength = 50;
        ItalyLbl: Label 'Italy', MaxLength = 50;
        LuxembourgLbl: Label 'Luxembourg', MaxLength = 50;
        LithuaniaLbl: Label 'Lithuania', MaxLength = 50;
        LatviaLbl: Label 'Latvia', MaxLength = 50;
        MalaysiaLbl: Label 'Malaysia', MaxLength = 50;
        MexicoLbl: Label 'Mexico', MaxLength = 50;
        NetherlandsLbl: Label 'Netherlands', MaxLength = 50;
        NorwayLbl: Label 'Norway', MaxLength = 50;
        NewZealandLbl: Label 'New Zealand', MaxLength = 50;
        PolandLbl: Label 'Poland', MaxLength = 50;
        PortugalLbl: Label 'Portugal', MaxLength = 50;
        RussiaLbl: Label 'Russia', MaxLength = 50;
        SingaporeLbl: Label 'Singapore', MaxLength = 50;
        SwedenLbl: Label 'Sweden', MaxLength = 50;
        SloveniaLbl: Label 'Slovenia', MaxLength = 50;
        ThailandLbl: Label 'Thailand', MaxLength = 50;
        TurkeyLbl: Label 'Türkiye', MaxLength = 50;
        USALbl: Label 'United States of America', MaxLength = 50;
        SouthAfricaLbl: Label 'South Africa', MaxLength = 50;
        MoroccoLbl: Label 'Morocco', MaxLength = 50;
        AlgeriaLbl: Label 'Algeria', MaxLength = 50;
        TunisiaLbl: Label 'Tunisia', MaxLength = 50;
        KenyaLbl: Label 'Kenya', MaxLength = 50;
        UgandaLbl: Label 'Uganda', MaxLength = 50;
        UnitedArabEmiratesLbl: Label 'United Arab Emirates', MaxLength = 50;
        MozambiqueLbl: Label 'Mozambique', MaxLength = 50;
        SwazilandLbl: Label 'Swaziland', MaxLength = 50;
        FinlandLbl: Label 'Finland', MaxLength = 50;
        HungaryLbl: Label 'Hungary', MaxLength = 50;
        RomaniaLbl: Label 'Romania', MaxLength = 50;
        GreeceLbl: Label 'Greece', MaxLength = 50;
        IrelandLbl: Label 'Ireland', MaxLength = 50;
        NigeriaLbl: Label 'Nigeria', MaxLength = 50;
        PhilippinesLbl: Label 'Philippines', MaxLength = 50;
        TanzaniaLbl: Label 'Tanzania', MaxLength = 50;
        MaltaLbl: Label 'Malta', MaxLength = 50;
        SlovakiaLbl: Label 'Slovakia', MaxLength = 50;
        BruneiDarussalamLbl: Label 'Brunei Darussalam', MaxLength = 50;
        FijiIslandsLbl: Label 'Fiji Islands', MaxLength = 50;
        JapanLbl: Label 'Japan', MaxLength = 50;
        SaudiArabiaLbl: Label 'Saudi Arabia', MaxLength = 50;
        SolomonIslandsLbl: Label 'Solomon Islands', MaxLength = 50;
        VanuatuLbl: Label 'Vanuatu', MaxLength = 50;
        SamoaLbl: Label 'Samoa', MaxLength = 50;
        CostaRicaLbl: Label 'Costa Rica', MaxLength = 50;
}