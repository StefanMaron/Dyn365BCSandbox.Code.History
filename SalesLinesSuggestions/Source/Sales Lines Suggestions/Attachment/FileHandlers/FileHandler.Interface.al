// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Sales.Document.Attachment;

interface "File Handler"
{
    Access = Internal;
    procedure Process(var FileInputStream: InStream): Variant
    procedure GetFileData(FileHandlerResult: Codeunit "File Handler Result"): List of [List of [Text]]
}