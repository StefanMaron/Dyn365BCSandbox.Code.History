// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Sales.Document.Attachment;

codeunit 7295 "File Handler Result"
{
    Access = Internal;

    var
        ColumnDelimiter: Text;
        DecimalSeparator: Text;
        ProductColumnIndex: List of [Integer];
        QuantityColumnIndex: Integer;
        UoMColumnIndex: Integer;
        ContainsHeaderRow: Boolean;
        ColumnNames: List of [Text];
        ColumnTypes: List of [Text];

    internal procedure AddProductColumnIndex(ColumnIndex: Integer)
    begin
        ProductColumnIndex.Add(ColumnIndex);
    end;

    internal procedure SetProductColumnIndex(ColumnIndex: Integer)
    begin
        Clear(ProductColumnIndex);
        ProductColumnIndex.Add(ColumnIndex);
    end;

    internal procedure SetProductColumnIndex(ColumnIndex: List of [Integer])
    begin
        Clear(ProductColumnIndex);
        ProductColumnIndex := ColumnIndex;
    end;

    internal procedure SetQuantityColumnIndex(ColumnIndex: Integer)
    begin
        QuantityColumnIndex := ColumnIndex;
    end;

    internal procedure SetUoMColumnIndex(ColumnIndex: Integer)
    begin
        UoMColumnIndex := ColumnIndex;
    end;

    internal procedure GetProductColumnIndex(): List of [Integer]
    begin
        exit(ProductColumnIndex);
    end;

    internal procedure GetQuantityColumnIndex(): Integer
    begin
        exit(QuantityColumnIndex);
    end;

    internal procedure GetUoMColumnIndex(): Integer
    begin
        exit(UoMColumnIndex);
    end;

    internal procedure SetColumnDelimiter(Delimiter: Text)
    begin
        ColumnDelimiter := Delimiter;
    end;

    internal procedure GetColumnDelimiter(): Text
    begin
        exit(ColumnDelimiter);
    end;

    internal procedure SetDecimalSeparator(Separator: Text)
    begin
        DecimalSeparator := Separator;
    end;

    internal procedure GetDecimalSeparator(): Text
    begin
        exit(DecimalSeparator);
    end;

    internal procedure SetContainsHeaderRow(ContainsHeader: Boolean)
    begin
        ContainsHeaderRow := ContainsHeader;
    end;

    internal procedure GetContainsHeaderRow(): Boolean
    begin
        exit(ContainsHeaderRow);
    end;

    internal procedure SetColumnNames(Names: List of [Text])
    begin
        ColumnNames := Names;
    end;

    internal procedure GetColumnNames(): List of [Text]
    begin
        exit(ColumnNames);
    end;

    internal procedure SetColumnTypes(Types: List of [Text])
    begin
        ColumnTypes := Types;
    end;

    internal procedure GetColumnTypes(): List of [Text]
    begin
        exit(ColumnTypes);
    end;
}