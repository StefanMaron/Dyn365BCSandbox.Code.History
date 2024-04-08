codeunit 161613 "Create Acc. Sched. Line RLG"
{

    trigger OnRun()
    begin
        InsertData(XBALANCE, '', 'AKTIVA', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', 'A. Anlagevermögen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  I. Immaterielle Vermögensgegenstände:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Konzessionen, gewerbliche Schutzrechte und', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        ähnliche Rechte und Vorteile sowie daraus', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        abgeleitete Lizenzen;', '0110', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. Geschäfts(Firmen)wert;', '0150', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. geleistete Anzahlungen;', '0180', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  II. Sachanlagen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Grundstücke, grundstücksgleiche Rechte und', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '         Bauten einschließlich der Bauten auf fremden', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '         Grund;', '0399', 1, false, false, false, false);
        InsertData(XBALANCE, '', '    2. technische Anlagen und Maschinen;', '0629', 1, false, false, false, false);
        InsertData(XBALANCE, '', '    3. andere Anlagen, Betriebs- und', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        Geschäftsaustattung;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    4. geleistete Anzahlungen und Anlagen in Bau;', '0710..0720', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  III. Finanzanlagen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Anteile an verbundenen Unternehmen;', '0810', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. Ausleihungen an verbundene Unternehmen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. Beteiligungen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    4. Ausleihungen an Unternehmen, mit denen ein', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        Beteiligungsverhältnis besteht;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    5. Wertpapiere des Anlagevermögens;', '0910', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    6. sonstige Ausleihungen.', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, true, false, false, false);
        InsertData(XBALANCE, '', 'B. Umlaufvermögen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  I. Vorräte:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Roh-, Hilfs- und Betriebsstoffe;', '1110..1130|1310..1330', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. unfertige Erzeugnisse;', '1499', 1, false, false, false, false);
        InsertData(XBALANCE, '', '    3. fertige Erzeugnisse und Waren;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    4. noch nicht abrechenbare Leistungen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    5. geleistete Anzahlungen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  II. Forderungen und sonstige', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '      Vermögensgegenstände:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Forderungen aus Lieferungen und Leistungen;', '2499', 1, false, false, false, false);
        InsertData(XBALANCE, '', '    2. Forderungen gegen verbundene Unternehmen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. Forderungen gegen Unternehmen, mit denen ein', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        Beteiligungsverhältnis besteht;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    4. sonstige Forderungen und Vermögensgegenstände;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  III. Wertpapiere und Anteile:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Anteile an verbundenen Unternehmen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. sonstige Wertpapiere und Anteile;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  IV. Kassenbestand, Schecks, Guthaben', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '        bei Kreditinstituten.', '2899', 1, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', 'C. Rechnungsabgrenzungsposten.', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, true, false, false, false);
        InsertData(XBALANCE, '', 'PASSIVA', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', 'A. Eigenkapital', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  I. Nennkapital (Grund-, Stammkapital);', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  II. Kapitalrücklagen;', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '       1.  gebundene;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '       2.  nicht gebundene', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  III. Gewinnrücklagen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. gesetzliche Rücklage;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. satzungsmäßige Rücklagen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. andere Rücklagen (freie Rücklagen);', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '  IV. Bilanzgewinn (Bilanzverlust), davon Gewinn-', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '       vortrag / Verlustvortrag.', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', 'B. Unversteuerte Rücklagen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Bewertungsreserve auf Grund von', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        Sonderabschreibungen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. sonstige unversteuerte Rücklagen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', 'C. Rückstellungen:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '    1. Rückstellungen für Abfertigungen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. Rückstellungen für Pensionen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. Steuerrückstellungen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    4. sonstige Rückstellungen.', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, true, false, false, false);
        InsertData(XBALANCE, '', 'D. Verbindlichkeiten:', '', 0, false, true, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    1. Anleihen, davon konvertibel,', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    2. Verbindlichkeiten gegenüber Kreditinstituten;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    3. erhaltene Anzahlungen auf Bestellungen;', '3290', 1, false, false, false, false);
        InsertData(XBALANCE, '', '    4. Verbindlichkeiten aus Lieferungen und Leistungen;', '3499', 1, false, false, false, false);
        InsertData(XBALANCE, '', '    5. Verbindlichkeiten aus der Annahme gezogener', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '         Wechsel und der Ausstellung eigener Wechsel;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    6. Verbindlichkeiten gegenüber verbundenen', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '         Unternehmen;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    7. Verbindlichkeiten gegenüber Unternehmen,', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        mit denen ein Beteiligungsverhältnis besteht;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '    8. sonstige Verbindlichkeiten;', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        davon aus Steuern,', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '        davon im Rahmen der sozialen Sicherheit.', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', '', '', 0, false, false, false, false);
        InsertData(XBALANCE, '', 'D. Rechnungsabgrenzungsposten.', '', 0, false, true, false, false);
        InsertData(XPL1, '', 'Gewinn / Verlustrechnung', '', 0, false, true, false, false);
        InsertData(XPL1, '', '', '', 0, false, false, false, false);
        InsertData(XPL1, '', '1.     Umsatzerlöse', '', 0, false, false, false, false);
        InsertData(XPL1, '', '2.     Veränderung des Bestandes an fertigen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        und unfertigen Erzeugnissen sowie an', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        noch nicht anrechenbaren Leistungen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '3.    andere aktivierte Eigenleistungen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '4.    sonstige betriebliche Erträge:', '', 0, false, false, false, false);
        InsertData(XPL1, '', '       a) Erträge aus dem Abgang vom und', '', 0, false, false, false, false);
        InsertData(XPL1, '', '           der Zuschreibung zum Anlagevermögen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '           mit Ausnahme der Finanzanlagen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '       b) Erträge aus der Auflösung von', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            Rückstellungen,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '       c) übrige;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '5.    Aufwendungen für Material und sonstige', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        bezogene Herstellungsleistungen:', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        a) Materialaufwand,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        b) Aufwendungen für bezogene', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            Leistungen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '6.    Personalaufwand:', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        a) Löhne,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        b) Gehälter,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        c) Aufwendungen für Abfertigungen,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        d) Aufwendungen für Altersversorgung,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        e) Aufwendungen für gesetzliche vorgeschriebene', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            Sozialabgaben sowie vom Entgelt abhängige', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            Abgaben und Pflichtbeiträge,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        f) sonstige Sozialaufwendungen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '7.     Abschreibungen:', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        a) auf immaterielle Gegenstände des Anlage-', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            vermögens und Sachanlagen sowie auf', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            aktivierte Aufwendungen für das Ingangsetzen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '            und Erweitern des Betriebes,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        b) auf Gegenstände des Umlaufvermögens, soweit', '', 0, false, false, false, false);
        InsertData(XPL1, '', '             diese die im im Unternehmen üblichen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '             Abschreibungen überschreiten;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '8.     sonstige betriebliche Aufwendungen:', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        a) Steuern, soweit sie nicht unter Z 21 fallen,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        b) übrige;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '9.     Zwischensumme aus Z1 bis 8;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        ------------------------------------------------------------------------', '', 0, true, false, false, false);
        InsertData(XPL1, '', '', '', 0, false, false, false, false);
        InsertData(XPL1, '', '10.   Erträge aus Beteiligungen, davon aus verbundenen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        Unternehmen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '11.   Erträge aus anderen Wertpapieren und', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        Ausleihungen des Finanzanlagevermögens,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        davon aus verbundenen Unternehmen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '12.   sonstige Zinsen und ähnliche Erträge, davon aus', '', 0, false, false, false, false);
        InsertData(XPL1, '', '         verbundenen Unternehmen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '13.   Erträge aus dem Abgang von und der Zuschreibung', '', 0, false, false, false, false);
        InsertData(XPL1, '', '         zu Finanzanlagen und Wertpapieren des', '', 0, false, false, false, false);
        InsertData(XPL1, '', '         Umlaufvermögens;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '14.   Aufwendungen aus Finanzanlagen und aus', '', 0, false, false, false, false);
        InsertData(XPL1, '', '         Wertpapieren des Umlaufvermögens,', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        davon sind gesondert auszuweisen:', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        a) Abschreibungen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        b) Aufwendungen aus verbundenen Unternehmen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '15.   Zinsen und ähnliche Aufwendungen, davon', '', 0, false, false, false, false);
        InsertData(XPL1, '', '          betreffend verbundene Unternehmen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '16.   Zwischensumme aus Z 10 bis 15;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        ---------------------------------------------------------------------', '', 0, false, false, false, false);
        InsertData(XPL1, '', '', '', 0, false, false, false, false);
        InsertData(XPL1, '', '17.   Ergebnis der gewöhnlichen Geschäftstätigkeit', '', 0, false, false, false, false);
        InsertData(XPL1, '', '18.   außerordentliche Erträge', '', 0, false, false, false, false);
        InsertData(XPL1, '', '19.   außerordentliche Aufwendungen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '20.   außerordentliches Ergebnis;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '21.   Steuern vom Einkommen und vom Ertrag;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '22.   Jahresüberschuß / Jahresfehlbetrag;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '23.   Auflösung unversteuerter Rücklagen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '24.   Auflösung von Kapitalrücklagen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '25.   Auflösung von Gewinnrücklagen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '26.   Zuweisung zu unversteuerten Rücklagen;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '27.   Zuweisung zu Gewinnrücklagen. Die Auflösungen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        und Zuweisungen gemäß Z23 bis 27 sind', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        entsprechend den in der Bilanz ausgewiesenen', '', 0, false, false, false, false);
        InsertData(XPL1, '', '        Unterposten aufzugliedern;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '28.   Gewinnvortrag / Verlustvortrag aus dem Vorjahr;', '', 0, false, false, false, false);
        InsertData(XPL1, '', '29.   Bilanzgewinn / Bilanzverlust.', '', 0, false, false, false, false);
    end;

    var
        XBALANCE: Label 'BALANCE';
        XPL1: Label 'P&L';
        "Line No.": Integer;
        "Previous Schedule Name": Code[10];
        CA: Codeunit "Make Adjustments";

    procedure InsertData("Schedule Name": Code[10]; "Row No.": Code[10]; Description: Text[80]; Totaling: Text[80]; "Totaling Type": Option; NewPage: Boolean; Bold: Boolean; Underline: Boolean; ShowOppositeSign: Boolean)
    var
        "Acc. Schedule Line": Record "Acc. Schedule Line";
    begin
        "Acc. Schedule Line".Init();
        "Acc. Schedule Line".Validate("Schedule Name", "Schedule Name");
        if "Previous Schedule Name" <> "Schedule Name" then begin
            "Line No." := 10000;
            "Previous Schedule Name" := "Schedule Name";
        end else
            "Line No." := "Line No." + 10000;
        "Acc. Schedule Line".Validate("Line No.", "Line No.");
        "Acc. Schedule Line".Validate("Row No.", "Row No.");
        "Acc. Schedule Line".Validate(Description, Description);
        "Acc. Schedule Line".Totaling := Totaling;
        "Acc. Schedule Line".Validate("Totaling Type", "Totaling Type");
        "Acc. Schedule Line"."New Page" := NewPage;
        "Acc. Schedule Line".Bold := Bold;
        "Acc. Schedule Line".Underline := Underline;
        "Acc. Schedule Line"."Show Opposite Sign" := ShowOppositeSign;
        "Acc. Schedule Line".Insert();
    end;
}

