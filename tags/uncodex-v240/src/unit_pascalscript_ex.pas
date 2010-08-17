{*******************************************************************************
  Name:
    unit_pascalscript_ex.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Defines additional PascalScript objects and functions. (Generation is
    automated)

  $Id: unit_pascalscript_ex.pas,v 1.17 2005/04/30 07:45:02 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003-2005  Michiel Hendriks

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

unit unit_pascalscript_ex;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_miscclasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TUCXIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TList(CL: TPSPascalCompiler);
procedure SIRegister_TLogEntry(CL: TPSPascalCompiler);
procedure SIRegister_miscclasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TUCXIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLogEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_miscclasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,unit_UCXIniFiles
  ,unit_definitions
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_miscclasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TUCXIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TUCXIniFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TUCXIniFile') do
  begin
    RegisterMethod('Constructor Create( const AFileName : string)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Function SectionExists( const Section : string) : Boolean');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionRaw( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure WriteSectionRaw( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Function ValueExists( const Section, Ident : string) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Longint) : Longint');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Longint)');
    RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
    RegisterMethod('Function ReadFloat( const Section, Ident : string; Default : Double) : Double');
    RegisterMethod('Procedure WriteFloat( const Section, Ident : string; Value : Double)');
    RegisterMethod('Function ReadDate( const Section, Ident : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadDateTime( const Section, Ident : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadTime( const Section, Ident : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Procedure WriteDate( const Section, Ident : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteDateTime( const Section, Ident : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteTime( const Section, Ident : string; Value : TDateTime)');
    RegisterMethod('Procedure ReadStringArray( const section, ident : string; output : TStrings; append : boolean)');
    RegisterMethod('Procedure WriteStringArray( const section, ident : string; input : TStrings)');
    RegisterMethod('Procedure AddToStringArray( const section, ident : string; entry : string)');
    RegisterMethod('Function RemoveFromStringArray( const section, ident : string; entry : string) : boolean');
    RegisterMethod('Procedure WriteBinaryStream( const Section, Name : string; Value : TStream)');
    RegisterMethod('Function ReadBinaryStream( const Section, Name : string; Value : TStream) : Integer');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Procedure Rename( const AFileName : string; Reload : Boolean)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure GetStrings( List : TStrings)');
    RegisterMethod('Procedure SetStrings( List : TStrings)');
    RegisterProperty('FileName', 'string', iptr);
    RegisterProperty('EscapeLineFeeds', 'boolean', iptrw);
    RegisterProperty('DelayedUpdate', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TObjectList') do
  with CL.AddClassN(CL.FindClass('TList'),'TObjectList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Procedure Pack');
    RegisterMethod('Procedure Sort( Compare : TListSortCompare)');
    RegisterMethod('Function Add( AObject : TObject) : Integer');
    RegisterMethod('Function Extract( Item : TObject) : TObject');
    RegisterMethod('Function Remove( AObject : TObject) : Integer');
    RegisterMethod('Function IndexOf( AObject : TObject) : Integer');
    RegisterMethod('Function FindInstanceOf( AClass : TClass; AExact : Boolean; AStartAt : Integer) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; AObject : TObject)');
    RegisterMethod('Function First : TObject');
    RegisterMethod('Function Last : TObject');
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
    RegisterProperty('Items', 'TObject Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TList') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLogEntry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TLogEntry') do
  with CL.AddClassN(CL.FindClass('TObject'),'TLogEntry') do
  begin
    RegisterProperty('mt', 'TLogType', iptrw);
    RegisterProperty('obj', 'TObject', iptrw);
    RegisterProperty('filename', 'string', iptrw);
    RegisterProperty('line', 'integer', iptrw);
    RegisterProperty('pos', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_miscclasses(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLogType', '( ltInfo, ltWarn, ltError, ltSearch )');
  SIRegister_TLogEntry(CL);
  SIRegister_TList(CL);
  SIRegister_TObjectList(CL);
  SIRegister_TUCXIniFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TUCXIniFileDelayedUpdate_W(Self: TUCXIniFile; const T: boolean);
begin Self.DelayedUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TUCXIniFileDelayedUpdate_R(Self: TUCXIniFile; var T: boolean);
begin T := Self.DelayedUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TUCXIniFileEscapeLineFeeds_W(Self: TUCXIniFile; const T: boolean);
begin Self.EscapeLineFeeds := T; end;

(*----------------------------------------------------------------------------*)
procedure TUCXIniFileEscapeLineFeeds_R(Self: TUCXIniFile; var T: boolean);
begin T := Self.EscapeLineFeeds; end;

(*----------------------------------------------------------------------------*)
procedure TUCXIniFileFileName_R(Self: TUCXIniFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListCount_W(Self: TObjectList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListCount_R(Self: TObjectList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListCapacity_W(Self: TObjectList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListCapacity_R(Self: TObjectList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListItems_W(Self: TObjectList; const T: TObject; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListItems_R(Self: TObjectList; var T: TObject; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListOwnsObjects_W(Self: TObjectList; const T: Boolean);
begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectListOwnsObjects_R(Self: TObjectList; var T: Boolean);
begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntrypos_W(Self: TLogEntry; const T: integer);
Begin Self.pos := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntrypos_R(Self: TLogEntry; var T: integer);
Begin T := Self.pos; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntryline_W(Self: TLogEntry; const T: integer);
Begin Self.line := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntryline_R(Self: TLogEntry; var T: integer);
Begin T := Self.line; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntryfilename_W(Self: TLogEntry; const T: string);
Begin Self.filename := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntryfilename_R(Self: TLogEntry; var T: string);
Begin T := Self.filename; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntryobj_W(Self: TLogEntry; const T: TObject);
Begin Self.obj := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntryobj_R(Self: TLogEntry; var T: TObject);
Begin T := Self.obj; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntrymt_W(Self: TLogEntry; const T: TLogType);
Begin Self.mt := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogEntrymt_R(Self: TLogEntry; var T: TLogType);
Begin T := Self.mt; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUCXIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUCXIniFile) do
  begin
    RegisterConstructor(@TUCXIniFile.Create, 'Create');
    RegisterMethod(@TUCXIniFile.ReadSections, 'ReadSections');
    RegisterMethod(@TUCXIniFile.SectionExists, 'SectionExists');
    RegisterMethod(@TUCXIniFile.ReadSection, 'ReadSection');
    RegisterMethod(@TUCXIniFile.EraseSection, 'EraseSection');
    RegisterMethod(@TUCXIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterMethod(@TUCXIniFile.ReadSectionRaw, 'ReadSectionRaw');
    RegisterMethod(@TUCXIniFile.WriteSectionRaw, 'WriteSectionRaw');
    RegisterMethod(@TUCXIniFile.DeleteKey, 'DeleteKey');
    RegisterMethod(@TUCXIniFile.ValueExists, 'ValueExists');
    RegisterMethod(@TUCXIniFile.ReadString, 'ReadString');
    RegisterMethod(@TUCXIniFile.WriteString, 'WriteString');
    RegisterMethod(@TUCXIniFile.ReadInteger, 'ReadInteger');
    RegisterMethod(@TUCXIniFile.WriteInteger, 'WriteInteger');
    RegisterMethod(@TUCXIniFile.ReadBool, 'ReadBool');
    RegisterMethod(@TUCXIniFile.WriteBool, 'WriteBool');
    RegisterMethod(@TUCXIniFile.ReadFloat, 'ReadFloat');
    RegisterMethod(@TUCXIniFile.WriteFloat, 'WriteFloat');
    RegisterMethod(@TUCXIniFile.ReadDate, 'ReadDate');
    RegisterMethod(@TUCXIniFile.ReadDateTime, 'ReadDateTime');
    RegisterMethod(@TUCXIniFile.ReadTime, 'ReadTime');
    RegisterMethod(@TUCXIniFile.WriteDate, 'WriteDate');
    RegisterMethod(@TUCXIniFile.WriteDateTime, 'WriteDateTime');
    RegisterMethod(@TUCXIniFile.WriteTime, 'WriteTime');
    RegisterMethod(@TUCXIniFile.ReadStringArray, 'ReadStringArray');
    RegisterMethod(@TUCXIniFile.WriteStringArray, 'WriteStringArray');
    RegisterMethod(@TUCXIniFile.AddToStringArray, 'AddToStringArray');
    RegisterMethod(@TUCXIniFile.RemoveFromStringArray, 'RemoveFromStringArray');
    RegisterMethod(@TUCXIniFile.WriteBinaryStream, 'WriteBinaryStream');
    RegisterMethod(@TUCXIniFile.ReadBinaryStream, 'ReadBinaryStream');
    RegisterMethod(@TUCXIniFile.UpdateFile, 'UpdateFile');
    RegisterMethod(@TUCXIniFile.Rename, 'Rename');
    RegisterMethod(@TUCXIniFile.Clear, 'Clear');
    RegisterMethod(@TUCXIniFile.GetStrings, 'GetStrings');
    RegisterMethod(@TUCXIniFile.SetStrings, 'SetStrings');
    RegisterPropertyHelper(@TUCXIniFileFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TUCXIniFileEscapeLineFeeds_R,@TUCXIniFileEscapeLineFeeds_W,'EscapeLineFeeds');
    RegisterPropertyHelper(@TUCXIniFileDelayedUpdate_R,@TUCXIniFileDelayedUpdate_W,'DelayedUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TObjectList) do
  begin
    RegisterConstructor(@TObjectList.Create, 'Create');
    RegisterVirtualMethod(@TObjectList.Clear, 'Clear');
    RegisterMethod(@TObjectList.Delete, 'Delete');
    RegisterMethod(@TObjectList.Exchange, 'Exchange');
    RegisterMethod(@TObjectList.Move, 'Move');
    RegisterMethod(@TObjectList.Pack, 'Pack');
    RegisterMethod(@TObjectList.Sort, 'Sort');
    RegisterMethod(@TObjectList.Add, 'Add');
    RegisterMethod(@TObjectList.Extract, 'Extract');
    RegisterMethod(@TObjectList.Remove, 'Remove');
    RegisterMethod(@TObjectList.IndexOf, 'IndexOf');
    RegisterMethod(@TObjectList.FindInstanceOf, 'FindInstanceOf');
    RegisterMethod(@TObjectList.Insert, 'Insert');
    RegisterMethod(@TObjectList.First, 'First');
    RegisterMethod(@TObjectList.Last, 'Last');
    RegisterPropertyHelper(@TObjectListOwnsObjects_R,@TObjectListOwnsObjects_W,'OwnsObjects');
    RegisterPropertyHelper(@TObjectListItems_R,@TObjectListItems_W,'Items');
    RegisterPropertyHelper(@TObjectListCapacity_R,@TObjectListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TObjectListCount_R,@TObjectListCount_W,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TList) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLogEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLogEntry) do
  begin
    RegisterPropertyHelper(@TLogEntrymt_R,@TLogEntrymt_W,'mt');
    RegisterPropertyHelper(@TLogEntryobj_R,@TLogEntryobj_W,'obj');
    RegisterPropertyHelper(@TLogEntryfilename_R,@TLogEntryfilename_W,'filename');
    RegisterPropertyHelper(@TLogEntryline_R,@TLogEntryline_W,'line');
    RegisterPropertyHelper(@TLogEntrypos_R,@TLogEntrypos_W,'pos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_miscclasses(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLogEntry(CL);
  RIRegister_TList(CL);
  RIRegister_TObjectList(CL);
  RIRegister_TUCXIniFile(CL);
end;

 
 
{ TPSImport_miscclasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_miscclasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_miscclasses(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
