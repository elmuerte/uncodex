{*******************************************************************************
  Name:
    unit_pascalscript_ex.pas
  Author(s):
    Michiel 'El Muerte' Hendriks
  Purpose:
    Defines additional PascalScript objects and functions. (Generation is
    automated)

  $Id: unit_pascalscript_ex.pas,v 1.9 2004-12-28 15:55:58 elmuerte Exp $
*******************************************************************************}
{
  UnCodeX - UnrealScript source browser & documenter
  Copyright (C) 2003, 2004  Michiel Hendriks

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
This file has been generated by UnitParser v0.6, written by M. Knight
and updated by NP. v/d Spek.
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok''s conv unility

}
{$I PascalScript.inc}
{$I defines.inc}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
  TPSImport_miscclasses = class(TPSPlugin)
  protected
  procedure CompOnUses(CompExec: TPSScript); override;
  procedure ExecOnUses(CompExec: TPSScript); override;
  procedure CompileImport1(CompExec: TPSScript); override;
  procedure CompileImport2(CompExec: TPSScript); override;
  procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

  procedure Register; 
 
implementation

uses
   Contnrs
  ,IniFiles
  ,IFSI_unit_uclasses, unit_definitions
  ;

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_miscclasses]);
  RegisterComponents('Pascal Script', [TPSImport_unit_uclasses]);
end;
 
{ compile-time importer function }
(*----------------------------------------------------------------------------
 Sometimes the CL.AddClassN() fails to correctly register a class, 
 for unknown (at least to me) reasons
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls 
 ----------------------------------------------------------------------------*)
function RegClassS(CL: TPSPascalCompiler; const InheritsFrom, Classname: string): TPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
  Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;
  
  
(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMemIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMemIniFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMemIniFile') do
  begin
  RegisterMethod('Constructor Create( const FileName : string)');
  RegisterMethod('Function SectionExists( const Section : string) : Boolean');
  RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
  RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
  RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Longint) : Longint');
  RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Longint)');
  RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
  RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
  RegisterMethod('Function ReadBinaryStream( const Section, Name : string; Value : TStream) : Integer');
  RegisterMethod('Function ReadDate( const Section, Name : string; Default : TDateTime) : TDateTime');
  RegisterMethod('Function ReadDateTime( const Section, Name : string; Default : TDateTime) : TDateTime');
  RegisterMethod('Function ReadFloat( const Section, Name : string; Default : Double) : Double');
  RegisterMethod('Function ReadTime( const Section, Name : string; Default : TDateTime) : TDateTime');
  RegisterMethod('Procedure WriteBinaryStream( const Section, Name : string; Value : TStream)');
  RegisterMethod('Procedure WriteDate( const Section, Name : string; Value : TDateTime)');
  RegisterMethod('Procedure WriteDateTime( const Section, Name : string; Value : TDateTime)');
  RegisterMethod('Procedure WriteFloat( const Section, Name : string; Value : Double)');
  RegisterMethod('Procedure WriteTime( const Section, Name : string; Value : TDateTime)');
  RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
  RegisterMethod('Procedure ReadSections( Strings : TStrings)');
  RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
  RegisterMethod('Procedure EraseSection( const Section : string)');
  RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
  RegisterMethod('Procedure UpdateFile');
  RegisterMethod('Function ValueExists( const Section, Ident : string) : Boolean');
  RegisterMethod('Procedure Clear');
  RegisterMethod('Procedure GetStrings( List : TStrings)');
  RegisterMethod('Procedure Rename( const FileName : string; Reload : Boolean)');
  RegisterMethod('Procedure SetStrings( List : TStrings)');
  RegisterProperty('CaseSensitive', 'Boolean', iptrw);
  RegisterProperty('FileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TObjectList') do
  with CL.AddClassN(CL.FindClass('TList'),'TObjectList') do
  begin
  RegisterMethod('Constructor Create;');
  RegisterMethod('Constructor Create2( AOwnsObjects : Boolean);');
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
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TList') do
  begin
  RegisterMethod('Function Add( Item : Pointer) : Integer');
  RegisterMethod('Procedure Clear');
  RegisterMethod('Procedure Delete( Index : Integer)');
  RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
  RegisterMethod('Function Expand : TList');
  RegisterMethod('Function Extract( Item : Pointer) : Pointer');
  RegisterMethod('Function First : Pointer');
  RegisterMethod('Function IndexOf( Item : Pointer) : Integer');
  RegisterMethod('Procedure Insert( Index : Integer; Item : Pointer)');
  RegisterMethod('Function Last : Pointer');
  RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
  RegisterMethod('Function Remove( Item : Pointer) : Integer');
  RegisterMethod('Procedure Pack');
  RegisterMethod('Procedure Sort( Compare : TListSortCompare)');
  RegisterMethod('Procedure Assign( ListA : TList; AOperator : TListAssignOp; ListB : TList)');
  RegisterProperty('Capacity', 'Integer', iptrw);
  RegisterProperty('Count', 'Integer', iptrw);
  RegisterProperty('Items', 'Pointer Integer', iptrw);
  SetDefaultPropery('Items');
  RegisterProperty('List', 'PPointerList', iptr);
  end;
end;

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
  SIRegister_TList(CL);
  SIRegister_TObjectList(CL);
  SIRegister_TMemIniFile(CL);
  SIRegister_TLogEntry(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMemIniFileFileName_R(Self: TMemIniFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TMemIniFileCaseSensitive_W(Self: TMemIniFile; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TMemIniFileCaseSensitive_R(Self: TMemIniFile; var T: Boolean);
begin T := Self.CaseSensitive; end;

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
Function TObjectListCreate2_P(Self: TClass; CreateNewInstance: Boolean;  AOwnsObjects : Boolean):TObject;
Begin Result := TObjectList.Create(AOwnsObjects); END;

(*----------------------------------------------------------------------------*)
Function TObjectListCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TObjectList.Create; END;

(*----------------------------------------------------------------------------*)
procedure TListList_R(Self: TList; var T: PPointerList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TListItems_W(Self: TList; const T: Pointer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItems_R(Self: TList; var T: Pointer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TListCount_W(Self: TList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TListCount_R(Self: TList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TListCapacity_W(Self: TList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TListCapacity_R(Self: TList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMemIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMemIniFile) do
  begin
  RegisterConstructor(@TMemIniFile.Create, 'Create');
  RegisterMethod(@TMemIniFile.SectionExists, 'SectionExists');
  RegisterMethod(@TMemIniFile.ReadString, 'ReadString');
  RegisterMethod(@TMemIniFile.WriteString, 'WriteString');
  RegisterMethod(@TMemIniFile.ReadInteger, 'ReadInteger');
  RegisterMethod(@TMemIniFile.WriteInteger, 'WriteInteger');
  RegisterMethod(@TMemIniFile.ReadBool, 'ReadBool');
  RegisterMethod(@TMemIniFile.WriteBool, 'WriteBool');
  RegisterMethod(@TMemIniFile.ReadBinaryStream, 'ReadBinaryStream');
  RegisterMethod(@TMemIniFile.ReadDate, 'ReadDate');
  RegisterMethod(@TMemIniFile.ReadDateTime, 'ReadDateTime');
  RegisterMethod(@TMemIniFile.ReadFloat, 'ReadFloat');
  RegisterMethod(@TMemIniFile.ReadTime, 'ReadTime');
  RegisterMethod(@TMemIniFile.WriteBinaryStream, 'WriteBinaryStream');
  RegisterMethod(@TMemIniFile.WriteDate, 'WriteDate');
  RegisterMethod(@TMemIniFile.WriteDateTime, 'WriteDateTime');
  RegisterMethod(@TMemIniFile.WriteFloat, 'WriteFloat');
  RegisterMethod(@TMemIniFile.WriteTime, 'WriteTime');
  RegisterMethod(@TMemIniFile.ReadSection, 'ReadSection');
  RegisterMethod(@TMemIniFile.ReadSections, 'ReadSections');
  RegisterMethod(@TMemIniFile.ReadSectionValues, 'ReadSectionValues');
  RegisterMethod(@TMemIniFile.EraseSection, 'EraseSection');
  RegisterMethod(@TMemIniFile.DeleteKey, 'DeleteKey');
  RegisterMethod(@TMemIniFile.UpdateFile, 'UpdateFile');
  RegisterMethod(@TMemIniFile.ValueExists, 'ValueExists');
  RegisterMethod(@TMemIniFile.Clear, 'Clear');
  RegisterMethod(@TMemIniFile.GetStrings, 'GetStrings');
  RegisterMethod(@TMemIniFile.Rename, 'Rename');
  RegisterMethod(@TMemIniFile.SetStrings, 'SetStrings');
  RegisterPropertyHelper(@TMemIniFileCaseSensitive_R,@TMemIniFileCaseSensitive_W,'CaseSensitive');
  RegisterPropertyHelper(@TMemIniFileFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TObjectList) do
  begin
  RegisterConstructor(@TObjectListCreate_P, 'Create');
  RegisterConstructor(@TObjectListCreate2_P, 'Create2');
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
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TList) do
  begin
  RegisterMethod(@TList.Add, 'Add');
  RegisterVirtualMethod(@TList.Clear, 'Clear');
  RegisterMethod(@TList.Delete, 'Delete');
  RegisterMethod(@TList.Exchange, 'Exchange');
  RegisterMethod(@TList.Expand, 'Expand');
  RegisterMethod(@TList.Extract, 'Extract');
  RegisterMethod(@TList.First, 'First');
  RegisterMethod(@TList.IndexOf, 'IndexOf');
  RegisterMethod(@TList.Insert, 'Insert');
  RegisterMethod(@TList.Last, 'Last');
  RegisterMethod(@TList.Move, 'Move');
  RegisterMethod(@TList.Remove, 'Remove');
  RegisterMethod(@TList.Pack, 'Pack');
  RegisterMethod(@TList.Sort, 'Sort');
  RegisterMethod(@TList.Assign, 'Assign');
  RegisterPropertyHelper(@TListCapacity_R,@TListCapacity_W,'Capacity');
  RegisterPropertyHelper(@TListCount_R,@TListCount_W,'Count');
  RegisterPropertyHelper(@TListItems_R,@TListItems_W,'Items');
  RegisterPropertyHelper(@TListList_R,nil,'List');
  end;
end;

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
  RIRegister_TList(CL);
  RIRegister_TObjectList(CL);
  RIRegister_TMemIniFile(CL);
  RIRegister_TLogEntry(CL);
end;

 
 
{ TPSImport_miscclasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.CompOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.ExecOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_miscclasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.CompileImport2(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_miscclasses(ri);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_miscclasses.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing } 
end;
 
 
end.
