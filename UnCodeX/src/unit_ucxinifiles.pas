{*******************************************************************************
  Name:
    unit_ucxinifiles
  Author(s):
    Erik Wachtmeester (erikw@hotelconcepts.com)
    Michiel 'El Muerte' Hendriks
  Purpose:
    Modified IniFile classes which are better than the standard Delphi
    classes. The code is mostly based on the FreePascalCompiler implementation.
    Most of changes for UCX have been put in the subclass TUCXIniFile.
    Changes to the original code include:
    - configurable delayed file update

  $Id: unit_ucxinifiles.pas,v 1.3 2005-04-05 07:58:08 elmuerte Exp $
*******************************************************************************}

{
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit unit_ucxinifiles;
{$I defines.inc}

interface

uses
  Classes, SysUtils;

type
  TIniFileKey = class
  protected
    FIdent: string;
    FValue: string;
  public
    constructor Create(AIdent, AValue: string);
    property Ident: string read FIdent write FIdent;
    property Value: string read FValue write FValue;
  end;

  TIniFileKeyList = class(TList)
  protected
    function GetItem(Index: integer): TIniFileKey;
    function KeyByName(AName: string): TIniFileKey;
  public
    destructor Destroy; override;
    procedure Clear; override;
    property Items[Index: integer]: TIniFileKey read GetItem; default;
  end;

  TIniFileSection = class
  protected
    FName: string;
    FKeyList: TIniFileKeyList;
  public
    constructor Create(AName: string);
    destructor Destroy; override;
    property Name: string read FName;
    property KeyList: TIniFileKeyList read FKeyList;
  end;

  TIniFileSectionList = class(TList)
  protected
    function GetItem(Index: integer): TIniFileSection;
    function SectionByName(AName: string): TIniFileSection;
  public
    destructor Destroy; override;
    procedure Clear;override;
    property Items[Index: integer]: TIniFileSection read GetItem; default;
  end;

  TCustomIniFile = class
  protected
    FFileName: string;
    FSectionList: TIniFileSectionList;
    FEscapeLineFeeds: boolean;
    FDelayedUpdate: boolean;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    function SectionExists(const Section: string): Boolean; virtual;
    function ReadString(const Section, Ident, Default: string): string; virtual; abstract;
    procedure WriteString(const Section, Ident, Value: String); virtual; abstract;
    function ReadInteger(const Section, Ident: string; Default: Longint): Longint; virtual;
    procedure WriteInteger(const Section, Ident: string; Value: Longint); virtual;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
    function ReadDate(const Section, Ident: string; Default: TDateTime): TDateTime; virtual;
    function ReadDateTime(const Section, Ident: string; Default: TDateTime): TDateTime; virtual;
    function ReadFloat(const Section, Ident: string; Default: Double): Double; virtual;
    function ReadTime(const Section, Ident: string; Default: TDateTime): TDateTime; virtual;
    procedure WriteDate(const Section, Ident: string; Value: TDateTime); virtual;
    procedure WriteDateTime(const Section, Ident: string; Value: TDateTime); virtual;
    procedure WriteFloat(const Section, Ident: string; Value: Double); virtual;
    procedure WriteTime(const Section, Ident: string; Value: TDateTime); virtual;
    procedure ReadSection(const Section: string; Strings: TStrings); virtual; abstract;
    procedure ReadSections(Strings: TStrings); virtual; abstract;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); virtual; abstract;
    procedure EraseSection(const Section: string); virtual; abstract;
    procedure DeleteKey(const Section, Ident: String); virtual; abstract;
    procedure UpdateFile; virtual; abstract;
    function ValueExists(const Section, Ident: string): Boolean; virtual;
    property FileName: string read FFileName;
    property EscapeLineFeeds: boolean read FEscapeLineFeeds write FEscapeLineFeeds;
    property DelayedUpdate: boolean read FDelayedUpdate write FDelayedUpdate;
  end;

  TIniFile = class(TCustomIniFile)
  protected
    FStream: TStream;
    procedure FillSectionList(AStrings: TStrings);
  public
    constructor Create(const AFileName: string); overload;
    constructor Create(AStream: TStream); overload;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSectionRaw(const Section: string; Strings: TStrings);
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    procedure EraseSection(const Section: string); override;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure UpdateFile; override;
    property Stream: TStream read FStream;
  end;

  TMemIniFile = class(TIniFile)
  public
    procedure Clear;
    procedure GetStrings(List: TStrings);
    procedure Rename(const AFileName: string; Reload: Boolean);
    procedure SetStrings(List: TStrings);
  end;

  TUCXIniFile = class(TMemIniFile)
  public
    procedure WriteSectionRaw(const Section: string; Strings: TStrings); virtual;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure ReadStringArray(const section, ident: string; output: TStrings; append: boolean = false);
    procedure WriteStringArray(const section, ident: string; input: TStrings);
    procedure AddToStringArray(const section, ident: string; entry: string);
    function RemoveFromStringArray(const section, ident: string; entry: string): boolean;
    
    procedure WriteBinaryStream(const Section, Name: string; Value: TStream); virtual;
    function ReadBinaryStream(const Section, Name: string; Value: TStream): Integer; virtual;
  end;

implementation

const
   Brackets  : array[0..1] of Char = ('[', ']');
   Separator : Char = '=';
   Comment   : Char = ';';
   LF_Escape : Char = '\';

function CharToBool(AChar: char): boolean;
begin
  Result := (Achar = '1');
end;

function BoolToChar(ABool: boolean): char;
begin
  if ABool then
    Result := '1'
  else
    Result := '0';
end;

function IsComment(AString: string): boolean;
begin
  Result := False;
  if AString > '' then
    Result := (Copy(AString, 1, 1) = Comment);
end;

{ TIniFileKey }

constructor TIniFileKey.Create(AIdent, AValue: string);
begin
  FIdent := AIdent;
  FValue := AValue;
end;

{ TIniFileKeyList }

function TIniFileKeyList.GetItem(Index: integer): TIniFileKey;
begin
  Result := nil;
  if (Index >= 0) and (Index < Count) then
    Result := TIniFileKey(inherited Items[Index]);
end;

function TIniFileKeyList.KeyByName(AName: string): TIniFileKey;
var
  i: integer;
begin
  Result := nil;
  if (AName > '') and not IsComment(AName) then
    for i := 0 to Count-1 do
      if CompareText(Items[i].Ident, AName) = 0 then begin
        Result := Items[i];
        Break;
      end;
end;

destructor TIniFileKeyList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TIniFileKeyList.Clear;
var
  i: integer;
begin
  for i := Count-1 downto 0 do
    Items[i].Free;
  inherited Clear;
end;

{ TIniFileSection }

constructor TIniFileSection.Create(AName: string);
begin
  FName := AName;
  FKeyList := TIniFileKeyList.Create;
end;

destructor TIniFileSection.Destroy;
begin
  FKeyList.Free;
end;

{ TIniFileSectionList }

function TIniFileSectionList.GetItem(Index: integer): TIniFileSection;
begin
  Result := nil;
  if (Index >= 0) and (Index < Count) then
    Result := TIniFileSection(inherited Items[Index]);
end;

function TIniFileSectionList.SectionByName(AName: string): TIniFileSection;
var
  i: integer;
begin
  Result := nil;
  if (AName > '') and not IsComment(AName) then
    for i := 0 to Count-1 do
      if CompareText(Items[i].Name, AName) = 0 then begin
        Result := Items[i];
        Break;
      end;
end;

destructor TIniFileSectionList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TIniFileSectionList.Clear;
var
  i: integer;
begin
  for i := Count-1 downto 0 do
    Items[i].Free;
  inherited Clear;
end;

{ TCustomIniFile }

constructor TCustomIniFile.Create(const AFileName: string);
begin
  FFileName := AFileName;
  FSectionList := TIniFileSectionList.Create;
  FEscapeLineFeeds := False;
end;

destructor TCustomIniFile.Destroy;
begin
  FSectionList.Free;
  inherited Destroy;
end;

function TCustomIniFile.SectionExists(const Section: string): Boolean;
begin
  Result := (FSectionList.SectionByName(Section) <> nil);
end;

function TCustomIniFile.ReadInteger(const Section, Ident: string; Default: Longint): Longint;
var
  s: string;
begin
  Result := Default;
  s := ReadString(Section, Ident, '');
  if s > '' then try
    // convert hex string
    if Pos('0X', UpperCase(s)) = 1 then
      s := '$' + Copy(s, 3, Length(s) - 2);
    Result := StrToInt(s);
  except
    on EConvertError do
    else raise;
  end;
end;

procedure TCustomIniFile.WriteInteger(const Section, Ident: string; Value: Longint);
begin
  WriteString(Section, Ident, IntToStr(Value));
end;

function TCustomIniFile.ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
var
  s: string;
begin
  Result := Default;
  s := ReadString(Section, Ident, '');
  if s > '' then
    Result := CharToBool(s[1]);
end;

procedure TCustomIniFile.WriteBool(const Section, Ident: string; Value: Boolean);
begin
  WriteString(Section, Ident, BoolToChar(Value));
end;

function TCustomIniFile.ReadDate(const Section, Ident: string; Default: TDateTime): TDateTime;
var
  s: string;
begin
  Result := Default;
  s := ReadString(Section, Ident, '');
  if s > '' then try
    Result := StrToDate(s);
  except
    on EConvertError do
    else raise;
  end;
end;

function TCustomIniFile.ReadDateTime(const Section, Ident: string; Default: TDateTime): TDateTime;
var
  s: string;
begin
  Result := Default;
  s := ReadString(Section, Ident, '');
  if s > '' then try
    Result := StrToDateTime(s);
  except
    on EConvertError do
    else raise;
  end;
end;

function TCustomIniFile.ReadFloat(const Section, Ident: string; Default: Double): Double;
var
  s: string;
begin
  Result := Default;
  s := ReadString(Section, Ident, '');
  if s > '' then try
    Result := StrToFloat(s);
  except
    on EConvertError do
    else raise;
  end;
end;

function TCustomIniFile.ReadTime(const Section, Ident: string; Default: TDateTime): TDateTime;
var
  s: string;
begin
  Result := Default;
  s := ReadString(Section, Ident, '');
  if s > '' then try
    Result := StrToTime(s);
  except
    on EConvertError do
    else raise;
  end;
end;

procedure TCustomIniFile.WriteDate(const Section, Ident: string; Value: TDateTime);
begin
  WriteString(Section, Ident, DateToStr(Value));
end;

procedure TCustomIniFile.WriteDateTime(const Section, Ident: string; Value: TDateTime);
begin
  WriteString(Section, Ident, DateTimeToStr(Value));
end;

procedure TCustomIniFile.WriteFloat(const Section, Ident: string; Value: Double);
begin
  WriteString(Section, Ident, FloatToStr(Value));
end;

procedure TCustomIniFile.WriteTime(const Section, Ident: string; Value: TDateTime);
begin
  WriteString(Section, Ident, TimeToStr(Value));
end;

function TCustomIniFile.ValueExists(const Section, Ident: string): Boolean;
var
  oSection: TIniFileSection;
begin
  Result := False;
  oSection := FSectionList.SectionByName(Section);
  if oSection <> nil then
    Result := (oSection.KeyList.KeyByName(Ident) <> nil);
end;

{ TIniFile }

constructor TIniFile.Create(const AFileName: string);
var
  slLines: TStringList;
begin
  inherited Create(AFileName);
  FStream := nil;
  slLines := TStringList.Create;
  try
    if FileExists(FFileName) then begin
      // read the ini file values
      slLines.LoadFromFile(FFileName);
      FillSectionList(slLines);
    end else
      // create a new ini file
      slLines.SaveToFile(FFileName);
  finally
    slLines.Free;
  end;
end;

constructor TIniFile.Create(AStream: TStream);
var
  slLines: TStringList;
begin
  inherited Create('');
  FStream := AStream;
  slLines := TStringList.Create;
  try
    // read the ini file values
    slLines.LoadFromStream(FStream);
    FillSectionList(slLines);
  finally
    slLines.Free;
  end;
end;

procedure TIniFile.FillSectionList(AStrings: TStrings);
var
  i,j: integer;
  sLine, sIdent, sValue: string;
  oSection: TIniFileSection;

  procedure RemoveBackslashes;
  var
    i: integer;
    s: string;
    bAppendNextLine, bAppended: boolean;
  begin
    AStrings.BeginUpdate;
    try
      i := 0;
      bAppendNextLine := False;
      while i < AStrings.Count do begin
        s := AStrings[i];
        bAppended := False;
        if bAppendNextLine then begin
          // add line to previous line
          AStrings[i-1] := AStrings[i-1] + Trim(s);
          AStrings.Delete(i);
          s := AStrings[i-1];
          bAppended := True;
        end;
        bAppendNextLine := (Copy(s, Length(s), 1) = LF_Escape);
        if bAppendNextLine then
          // remove backslash
          AStrings[i] := Copy(s, 1, Length(s) - 1);
        if not bAppended then
          Inc(i);
      end;
    finally
      AStrings.EndUpdate;
    end;
  end;

begin
  oSection := nil;
  FSectionList.Clear;
  if FEscapeLineFeeds then
    RemoveBackslashes;
  for i := 0 to AStrings.Count-1 do begin
    sLine := Trim(AStrings[i]);
    if sLine > '' then
      begin
      if IsComment(sLine) and (oSection = nil) then begin
        // comment at the beginning of the ini file
        oSection := TIniFileSection.Create(sLine);
        FSectionList.Add(oSection);
        continue;
      end;
      if (Copy(sLine, 1, 1) = Brackets[0]) and (Copy(sLine, length(sLine), 1) = Brackets[1]) then begin
        // regular section
        oSection := TIniFileSection.Create(Copy(sLine, 2, Length(sLine) - 2));
        FSectionList.Add(oSection);
      end else if oSection <> nil then begin
        if IsComment(sLine) then begin
          // comment within a section
          sIdent := sLine;
          sValue := '';
        end else begin
          // regular key
          j:=Pos(Separator, sLine);
          if j=0 then
           begin
             sIdent:='';
             sValue:=sLine
           end
          else
           begin
             sIdent:=Trim(Copy(sLine, 1,  j - 1));
             sValue:=Trim(Copy(sLine, j + 1, Length(sLine) - j));
           end;
        end;
        oSection.KeyList.Add(TIniFileKey.Create(sIdent, sValue));
      end;
      end;
  end;
end;

function TIniFile.ReadString(const Section, Ident, Default: string): string;
var
  oSection: TIniFileSection;
  oKey: TIniFileKey;
begin
  Result := Default;
  oSection := FSectionList.SectionByName(Section);
  if oSection <> nil then begin
    oKey := oSection.KeyList.KeyByName(Ident);
    if oKey <> nil then
      Result := oKey.Value;
  end;
end;

procedure TIniFile.WriteString(const Section, Ident, Value: String);
var
  oSection: TIniFileSection;
  oKey: TIniFileKey;
begin
  if (Section > '') and (Ident > '') then begin
    // update or add key
    oSection := FSectionList.SectionByName(Section);
    if (Value > '') then begin
      if oSection = nil then begin
        oSection := TIniFileSection.Create(Section);
        FSectionList.Add(oSection);
      end;
      with oSection.KeyList do begin
        oKey := KeyByName(Ident);
        if oKey <> nil then
          oKey.Value := Value
        else
          oSection.KeyList.Add(TIniFileKey.Create(Ident, Value));
      end;
    end else if oSection <> nil then begin
      // remove key
      oKey := oSection.KeyList.KeyByName(Ident);
      if oKey <> nil then begin
        oSection.KeyList.Remove(oKey);
        oKey.Free;
      end;
    end;
    if (not FDelayedUpdate) then UpdateFile;
  end;
end;

procedure TIniFile.ReadSection(const Section: string; Strings: TStrings);
var
  oSection: TIniFileSection;
  i: integer;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    oSection := FSectionList.SectionByName(Section);
    if oSection <> nil then with oSection.KeyList do
      for i := 0 to Count-1 do
        if not IsComment(Items[i].Ident) then
          Strings.Add(Items[i].Ident);
  finally
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.ReadSectionRaw(const Section: string; Strings: TStrings);
var
  oSection: TIniFileSection;
  i: integer;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    oSection := FSectionList.SectionByName(Section);
    if oSection <> nil then with oSection.KeyList do
      for i := 0 to Count-1 do
        if not IsComment(Items[i].Ident) then
         begin
           if Items[i].Ident<>'' then
            Strings.Add(Items[i].Ident + Separator +Items[i].Value)
           else
            Strings.Add(Items[i].Value);
         end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.ReadSections(Strings: TStrings);
var
  i: integer;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    for i := 0 to FSectionList.Count-1 do
      if not IsComment(FSectionList[i].Name) then
        Strings.Add(FSectionList[i].Name);
  finally
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  oSection: TIniFileSection;
  s: string;
  i: integer;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    oSection := FSectionList.SectionByName(Section);
    if oSection <> nil then with oSection.KeyList do
      for i := 0 to Count-1 do begin
        s := Items[i].Value;
        if s > '' then
          Strings.Add(s);
      end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.EraseSection(const Section: string);
var
  oSection: TIniFileSection;
begin
  oSection := FSectionList.SectionByName(Section);
  if oSection <> nil then begin
    { It is needed so UpdateFile doesn't find a defunct section }
    { and cause the program to crash }
    FSectionList.Remove(oSection);
    oSection.Free;
    if (not FDelayedUpdate) then UpdateFile;
  end;
end;

procedure TIniFile.DeleteKey(const Section, Ident: String);
var
  oSection: TIniFileSection;
  oKey: TIniFileKey;
begin
  oSection := FSectionList.SectionByName(Section);
  if oSection <> nil then begin
    oKey := oSection.KeyList.KeyByName(Ident);
    if oKey <> nil then begin
      oSection.KeyList.Remove(oKey);
      oKey.Free;
      if (not FDelayedUpdate) then UpdateFile;
    end;
  end;
end;

procedure TIniFile.UpdateFile;
var
  slLines: TStringList;
  i, j: integer;
begin
  slLines := TStringList.Create;
  try
    for i := 0 to FSectionList.Count-1 do
      with FSectionList[i] do begin
        if IsComment(Name) then
          // comment
          slLines.Add(Name)
        else
          // regular section
          slLines.Add(Brackets[0] + Name + Brackets[1]);
        for j := 0 to KeyList.Count-1 do
          if IsComment(KeyList[j].Ident) then
            // comment
            slLines.Add(KeyList[j].Ident)
          else
            // regular key
            slLines.Add(KeyList[j].Ident + Separator + KeyList[j].Value);
        if (i < FSectionList.Count-1) and not IsComment(Name) then
          slLines.Add('');
      end;
    if FFileName > '' then
      slLines.SaveToFile(FFileName)
    else if FStream <> nil then
      slLines.SaveToStream(FStream);
    FillSectionList(slLines);
  finally
    slLines.Free;
  end;
end;

{ TMemIniFile }

procedure TMemIniFile.Clear;
begin
  FSectionList.Clear;
end;

procedure TMemIniFile.GetStrings(List: TStrings);
var
  i, j: integer;
  oSection: TIniFileSection;
begin
  List.BeginUpdate;
  try
    for i := 0 to FSectionList.Count-1 do begin
      oSection := FSectionList[i];
      with oSection do begin
        if IsComment(Name) then
          List.Add(Name)
        else
          List.Add(Brackets[0] + Name + Brackets[1]);
        for j := 0 to KeyList.Count-1 do begin
          if IsComment(KeyList[j].Ident) then
            List.Add(KeyList[j].Ident)
          else
            List.Add(KeyList[j].Ident + Separator + KeyList[j].Value);
        end;
      end;
      if i < FSectionList.Count-1 then
        List.Add('');
    end;
  finally
    List.EndUpdate;
  end;
end;

procedure TMemIniFile.Rename(const AFileName: string; Reload: Boolean);
var
  slLines: TStringList;
begin
  FFileName := AFileName;
  FStream := nil;
  if Reload then begin
    slLines := TStringList.Create;
    try
      slLines.LoadFromFile(FFileName);
      FillSectionList(slLines);
    finally
      slLines.Free;
    end;
  end;
end;

procedure TMemIniFile.SetStrings(List: TStrings);
begin
  FillSectionList(List);
end;

{ TUCXIniFile }

procedure TUCXIniFile.WriteSectionRaw(const Section: string; Strings: TStrings);
var
  oSection: TIniFileSection;
  oKey: TIniFileKey;
  i: integer;
begin
  if (section = '') then exit;
  oSection := FSectionList.SectionByName(Section);
  if (oSection = nil) then begin
    oSection := TIniFileSection.Create(Section);
    FSectionList.Add(oSection);
  end;
  oSection.KeyList.Clear;
  for i := 0 to Strings.count-1 do begin
    oKey := TIniFileKey.Create(Strings.Names[i], Strings.Values[Strings.Names[i]]);
    oSection.KeyList.Add(oKey);
  end;
  if (not FDelayedUpdate) then UpdateFile;
end;

procedure TUCXIniFile.DeleteKey(const Section, Ident: String);
var
  oSection: TIniFileSection;
  oKey: TIniFileKey;
begin
  oSection := FSectionList.SectionByName(Section);
  if oSection <> nil then begin
    repeat
      oKey := oSection.KeyList.KeyByName(Ident);
      if oKey <> nil then begin
        oSection.KeyList.Remove(oKey);
        oKey.Free;
      end;
    until (oKey = nil);
  end;
  if (not FDelayedUpdate) then UpdateFile;
end;

procedure TUCXIniFile.ReadStringArray(const section, ident: string; output: TStrings; append: boolean = false);
var
  i: integer;
  oSection: TIniFileSection;
begin
  output.BeginUpdate;
  try
    if (not append) then output.Clear;
    oSection := FSectionList.SectionByName(section);
    if (oSection = nil) then exit;
    for i := 0 to oSection.KeyList.Count-1 do begin
      if (SameText(oSection.KeyList[i].Ident, ident)) then output.Add(oSection.KeyList[i].value);
    end;
  finally
    output.EndUpdate;
  end;
end;

procedure TUCXIniFile.WriteStringArray(const section, ident: string; input: TStrings);
var
  i: integer;
  oSection: TIniFileSection;
  oKey: TIniFileKey;
begin
  if ((section = '') or (ident = '')) then exit;
  oSection := FSectionList.SectionByName(section);
  if (oSection = nil) then begin
    oSection := TIniFileSection.Create(section);
    FSectionList.Add(oSection);
  end;
  repeat
    oKey := oSection.KeyList.KeyByName(Ident);
    if oKey <> nil then begin
      oSection.KeyList.Remove(oKey);
      oKey.Free;
    end;
  until (oKey = nil);
  for i := 0 to input.count-1 do begin
    if (input[i] = '') then continue;
    oKey := TIniFileKey.Create(ident, input[i]);
    oSection.KeyList.Add(oKey);
  end;
  if (not FDelayedUpdate) then UpdateFile;
end;

procedure TUCXIniFile.AddToStringArray(const section, ident: string; entry: string);
var
  oSection: TIniFileSection;
  oKey: TIniFileKey;
begin
  if ((section = '') or (ident = '') or (entry = '')) then exit;
  oSection := FSectionList.SectionByName(section);
  if (oSection = nil) then exit;
  oKey := TIniFileKey.Create(ident, entry);
  oSection.KeyList.Add(oKey);
  if (not FDelayedUpdate) then UpdateFile;
end;

function TUCXIniFile.RemoveFromStringArray(const section, ident: string; entry: string): boolean;
var
  i: integer;
  oSection: TIniFileSection;
begin
  result := false;
  oSection := FSectionList.SectionByName(section);
  if (oSection = nil) then exit;
  for i := 0 to oSection.KeyList.Count-1 do begin
    if (SameText(oSection.KeyList[i].Ident, ident) and (oSection.KeyList[i].Value = entry)) then begin
      oSection.KeyList[i].Free;
      result := true;
      if (not FDelayedUpdate) then UpdateFile;
      exit;
    end;
  end;
end;

procedure TUCXIniFile.WriteBinaryStream(const Section, Name: string; Value: TStream);
var
  data: string;
  ms: TMemoryStream;
begin
  SetLength(data, (Value.Size - Value.Position) * 2);
  if (length(data) > 0) then begin
    if (value is TMemoryStream) then ms := TMemoryStream(value)
    else ms := TMemoryStream.Create;
    try
      if (ms <> Value) then begin
        ms.CopyFrom(Value, Value.Size - Value.Position);
        ms.Position := 0;
      end;
      BinToHex(PChar(Integer(ms.Memory) + ms.Position), PChar(data), ms.Size - ms.Position);
    finally
      if (value <> ms) then ms.Free;
    end;
  end;
  WriteString(section, name, data);
end;

function TUCXIniFile.ReadBinaryStream(const Section, Name: string; Value: TStream): Integer;
var
  data: string;
  ms: TMemoryStream;
  pos: int64;
begin
  data := ReadString(section, name, '');
  if (data <> '') then begin
    if (value is TMemoryStream) then ms := TMemoryStream(value)
    else ms := TMemoryStream.Create;
    try
      pos := ms.Position;
      ms.SetSize(ms.Size + length(data) div 2);
      HexToBin(PChar(data), PChar(Integer(ms.Memory) + ms.Position), length(data) div 2);
      ms.Position := pos;
      if (Value <> ms) then Value.CopyFrom(ms, length(data) div 2);
      result := ms.Size-pos;
    finally
      if (value <> ms) then ms.Free;
    end;
  end
  else result := 0;
end;

end.

