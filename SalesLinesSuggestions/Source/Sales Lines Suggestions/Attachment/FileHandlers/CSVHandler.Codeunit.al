// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Sales.Document.Attachment;

using Microsoft.Sales.Document;
using System.IO;

codeunit 7293 "Csv Handler" implements "File Handler"
{
    Access = Internal;

    var
        CsvFileHandlerResult: Codeunit "File Handler Result";
        CsvFileStream: InStream;
        isIntialized: Boolean;
        FirstLineAsHash: Text;
        ConcatTwoLinesLbl: Label '%1\n%2', Comment = '%1 = first line, %2 = second line.';
        InvalidCsvDataErr: Label 'Cannot process input data. Either the data is not in a valid CSV format or data is missing.';

    internal procedure Process(var FileInputStream: InStream): Codeunit "File Handler Result"
    var
        MappingCacheManagement: Codeunit "Mapping Cache Management";
        CsvInput: Text;
        FirstLine: Text;
        SavedMappingAsText: Text;
        JsonObject: JsonObject;
    begin
        CsvFileStream := FileInputStream;

        // Load mappings from csv if available
        FirstLine := ReadLines(CsvFileStream, 1, true);
        FirstLineAsHash := MappingCacheManagement.GenerateFileHashInHex(FirstLine);

        if MappingCacheManagement.GetMapping(FirstLineAsHash, SavedMappingAsText) then begin
            JsonObject.ReadFrom(SavedMappingAsText);
            CsvFileHandlerResult.FromJson(JsonObject);
            isIntialized := true;
            exit(CsvFileHandlerResult);
        end;

        // Else get LLM to generate mapping
        CsvInput := ReadLines(CsvFileStream, 11, true); // Read first 11 lines assuming first line is header line
        GenerateCsvMappingSuggestionFromAttachment(CsvInput);
        isIntialized := true;
        exit(CsvFileHandlerResult);
    end;

    internal procedure GetFileData(FileHandlerResult: Codeunit "File Handler Result"): List of [List of [Text]]
    var
        TempCSVBuffer: Record "CSV Buffer" temporary;
        ColumnSeparatorChar: Char;
        Row: List of [Text];
        AllRows: List of [List of [Text]];
        i: Integer;
        j: Integer;
    begin
        if not isIntialized then
            Error('Handler not initialized');
        begin
            CsvFileStream.ResetPosition();

            ColumnSeparatorChar := CsvFileHandlerResult.GetColumnDelimiter() [1];

            TempCSVBuffer.InitializeReaderFromStream(CsvFileStream, ColumnSeparatorChar);

            if TempCSVBuffer.ReadLines(0) then begin // reads all lines
                                                     // Assuming the first line is header.
                                                     // Rows
                for i := 1 to TempCSVBuffer.GetNumberOfLines() do begin
                    Clear(Row);

                    // Columns
                    for j := 1 to TempCSVBuffer.GetNumberOfColumns() do
                        Row.Add(TempCSVBuffer.GetValue(i, j));
                    AllRows.Add(Row);
                end;

                if AllRows.Count <= 1 then
                    Error(InvalidCsvDataErr);
                exit(AllRows);
            end;
        end;

    end;

    internal procedure Finalize(FileHandlerResult: Codeunit "File Handler Result")
    var
        MappingCacheManagement: Codeunit "Mapping Cache Management";
        JsonObject: JsonObject;
        JsonAsText: Text;
    begin
        if not FileHandlerResult.GetContainsHeaderRow() then
            exit;
        JsonObject := FileHandlerResult.ToJson();
        JsonObject.WriteTo(JsonAsText);
        MappingCacheManagement.SaveMapping(FirstLineAsHash, JsonAsText);
    end;

    local procedure ReadLines(var FileInStream: InStream; NoOfLinesToRead: Integer; FromBeginning: Boolean): Text
    begin
        if FromBeginning then
            FileInStream.ResetPosition();
        exit(ReadLines(FileInStream, NoOfLinesToRead));
    end;

    local procedure ReadLines(var FileInStream: InStream; NoOfLinesToRead: Integer): Text
    var
        Line: Text;
        LineCounter: Integer;
        Lines: Text;
    begin
        while not FileInStream.EOS() do begin
            FileInStream.ReadText(Line);
            Lines := StrSubstNo(ConcatTwoLinesLbl, Lines, Line);
            LineCounter += 1;
            if LineCounter >= NoOfLinesToRead then
                exit(Lines);
        end;
        exit(Lines);
    end;

    local procedure GenerateCsvMappingSuggestionFromAttachment(CsvData: Text)
    var
        Prompt: Codeunit "SLS Prompts";
        LookupItemsFromCsvFunction: Codeunit "Lookup Items From Csv Function";
        SalesLineAISuggestionImpl: Codeunit "Sales Lines Suggestions Impl.";
        UserInput: Text;
        CompletionText: Text;
    begin
        UserInput := StrSubstNo(Prompt.GetParsingCsvTemplateUserInputPrompt(), CsvData);
        CsvFileHandlerResult := SalesLineAISuggestionImpl.AICall(Prompt.GetAttachmentSystemPrompt(), UserInput, LookupItemsFromCsvFunction, CompletionText);
    end;
}