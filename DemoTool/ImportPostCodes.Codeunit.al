codeunit 160804 "Import Post Codes"
{

    trigger OnRun()
    begin
        lesfil;
    end;

    var
        byte: Code[30];
        int: Integer;
        postcode: Record "Post Code";
        konverter: Codeunit "Ansi - Ascii Conversion";

    procedure convert(tekst: Text[1024])
    var
        test: Text[30];
    begin
        with postcode do begin
            Reset();
            Init();
            Validate(Code, konverter.Ansi2Ascii(Format(CopyStr(tekst, 1, 20))));
            Evaluate(byte, konverter.Ansi2Ascii(CopyStr(tekst, 30, 20)));
            Validate(City, UpperCase(byte));
            if Insert then;
        end;
    end;

    procedure lesfil()
    var
        f: File;
        strin: InStream;
        txt: Text[1024];
    begin
        f.TextMode(true);
        f.WriteMode(false);
        f.Open('localfiles\PostNrSS.txt');

        f.CreateInStream(strin);
        //Starting a loop
        while not (strin.EOS()) do begin
            int := strin.ReadText(txt);
            convert(txt);
        end;
        f.Close();
    end;
}

