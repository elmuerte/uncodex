{-----------------------------------------------------------------------------
 Unit Name: unit_treestate
 Author:    elmuerte
 Copyright: 2003 Michiel 'El Muerte' Hendriks
 Purpose:   loading/saving the tree state
 $Id: unit_treestate.pas,v 1.20 2004-03-30 09:46:18 elmuerte Exp $
-----------------------------------------------------------------------------}
{
    UnCodeX - UnrealScript source browser & documenter
    Copyright (C) 2003  Michiel Hendriks

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

unit unit_treestate;

interface

uses
  SysUtils, Classes, ComCtrls, ComStrs, Forms, unit_uclasses, unit_definitions;

type
  TUnCodeXState = class(TStrings)
  private
    FClassTree: TTreeView;
    FClassList: TUClassList;
    FPackageList: TUPackageList;
    FPackageTree: TTreeView;
  protected
    function GetState(name: string; uclass: TUClass): TUState;
    function GetPackage(name: string): TUPackage;
    procedure SavePackageToStream(upackage: TUPackage; stream: TStream);
    procedure SaveClassToStream(uclass: TUClass; stream: TStream);
    procedure LoadClassesFromStream(stream: TStream; version: integer);
    procedure LoadPackagesFromStream(stream: TStream; version: integer);
  public
    constructor Create(AOwner: TUClassList; CTree: TTreeView; PList: TUPackageList; PTree: TTreeView); overload;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    function LoadTreeFromStream(Stream: TStream): boolean;
    procedure SaveTreeToStream(Stream: TStream);
  end;

implementation

uses unit_rtfhilight;

const
  TabChar = #9;
  EndOfLine = #13#10;
  UnitSeperator = #31;
  StartOfText = #02;
  EndOfText = #03;
  StartOfHeader = #01;

type
  ETreeViewError = class(Exception);

procedure TreeViewError(const Msg: string);
begin
  raise ETreeViewError.Create(Msg);
end;

procedure TreeViewErrorFmt(const Msg: string; Format: array of const);
begin
  raise ETreeViewError.CreateFmt(Msg, Format);
end;

function GetUnit(const rec: string; offset: integer): string;
var
  i,j: integer;
begin
  i := 1;
  while ((offset > 0) and (i <= Length(rec))) do begin
    if (rec[i] = UnitSeperator) then Dec(offset);
    Inc(i);
  end;
  if (offset > 0) then result := ''
  else begin
    j := i;
    while ((rec[j] <> UnitSeperator) and (j <= Length(rec))) do begin
      Inc(j);
    end;
    Result := Copy(rec, i, j-i);
  end;
end;

{ TUnCodeXState }

const
  UCXHeader    = 'UCX';
  UCXHTail     = #13#10#0;
  UCXheader059 = UCXheader+'059'+UCXHTail;
  UCXheader150 = UCXheader+'150'+UCXHTail;
  UCXheader151 = UCXheader+'151'+UCXHTail;
  UCXheader153 = UCXheader+'153'+UCXHTail;
  UCXheader156 = UCXheader+'156'+UCXHTail;
  UCXheader171 = UCXheader+'171'+UCXHTail;

procedure TUnCodeXState.SavePackageToStream(upackage: TUPackage; stream: TStream);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(stream, 4096);
  try
    Writer.WriteString(upackage.name);
    Writer.WriteInteger(upackage.priority);
    Writer.WriteString(upackage.path);
    Writer.WriteBoolean(upackage.tagged);
    Writer.WriteString(upackage.comment);
  finally
    Writer.Free;
  end;
end;

procedure TUnCodeXState.SaveClassToStream(uclass: TUClass; stream: TStream);
var
  Writer: TWriter;
  i, j: integer;
begin
  Writer := TWriter.Create(stream, 4096);
  try
    Writer.WriteString(uclass.name);
    Writer.WriteInteger(TTreeNode(uclass.treenode).Level); // position in the tree
    Writer.WriteString(uclass.package.name);
    Writer.WriteString(uclass.parentname);
    Writer.WriteString(uclass.filename);
    Writer.WriteString(uclass.modifiers);
    Writer.WriteInteger(uclass.filetime);
    Writer.WriteString(uclass.comment);
    Writer.WriteString(uclass.defaultproperties);
    Writer.WriteInteger(uclass.consts.Count);
    for i := 0 to uclass.consts.Count-1 do begin
      Writer.WriteString(uclass.consts[i].name);
      Writer.WriteString(uclass.consts[i].value);
      Writer.WriteInteger(uclass.consts[i].srcline);
      Writer.WriteString(uclass.consts[i].comment);
    end;
    Writer.WriteInteger(uclass.properties.Count);
    for i := 0 to uclass.properties.Count-1 do begin
      Writer.WriteString(uclass.properties[i].name);
      Writer.WriteString(uclass.properties[i].ptype);
      Writer.WriteString(uclass.properties[i].modifiers);
      Writer.WriteString(uclass.properties[i].tag);
      Writer.WriteInteger(uclass.properties[i].srcline);
      Writer.WriteString(uclass.properties[i].comment);
    end;
    Writer.WriteInteger(uclass.enums.Count);
    for i := 0 to uclass.enums.Count-1 do begin
      Writer.WriteString(uclass.enums[i].name);
      Writer.WriteString(uclass.enums[i].options);
      Writer.WriteInteger(uclass.enums[i].srcline);
      Writer.WriteString(uclass.enums[i].comment);
    end;
    Writer.WriteInteger(uclass.structs.Count);
    for i := 0 to uclass.structs.Count-1 do begin
      Writer.WriteString(uclass.structs[i].name);
      Writer.WriteString(uclass.structs[i].parent);
      Writer.WriteString(uclass.structs[i].modifiers);
      Writer.WriteString(uclass.structs[i].data);
      Writer.WriteInteger(uclass.structs[i].srcline);
      Writer.WriteString(uclass.structs[i].comment);
      // struct vars
      Writer.WriteInteger(uclass.structs[i].properties.Count);
      for j := 0 to uclass.structs[i].properties.Count-1 do begin
        Writer.WriteString(uclass.structs[i].properties[j].name);
        Writer.WriteString(uclass.structs[i].properties[j].ptype);
        Writer.WriteString(uclass.structs[i].properties[j].modifiers);
        Writer.WriteString(uclass.structs[i].properties[j].tag);
        Writer.WriteInteger(uclass.structs[i].properties[j].srcline);
        Writer.WriteString(uclass.structs[i].properties[j].comment);
      end;
    end;
    Writer.WriteInteger(uclass.states.Count);
    for i := 0 to uclass.states.Count-1 do begin
      Writer.WriteString(uclass.states[i].name);
      Writer.WriteString(uclass.states[i].extends);
      Writer.WriteString(uclass.states[i].modifiers);
      Writer.WriteInteger(uclass.states[i].srcline);
      Writer.WriteString(uclass.states[i].comment);
    end;
    Writer.WriteInteger(uclass.delegates.Count);
    for i := 0 to uclass.delegates.Count-1 do begin
      Writer.WriteString(uclass.delegates[i].name);
      Writer.WriteInteger(Ord(uclass.delegates[i].ftype));
      Writer.WriteString(uclass.delegates[i].return);
      Writer.WriteString(uclass.delegates[i].modifiers);
      Writer.WriteString(uclass.delegates[i].params);
      Writer.WriteInteger(uclass.delegates[i].srcline);
      Writer.WriteString(uclass.delegates[i].comment);
    end;
    Writer.WriteInteger(uclass.functions.Count);
    for i := 0 to uclass.functions.Count-1 do begin
      Writer.WriteString(uclass.functions[i].name);
      Writer.WriteInteger(Ord(uclass.functions[i].ftype));
      Writer.WriteString(uclass.functions[i].return);
      Writer.WriteString(uclass.functions[i].modifiers);
      Writer.WriteString(uclass.functions[i].params);
      if (uclass.functions[i].state = nil) then Writer.WriteString('')
        else Writer.WriteString(uclass.functions[i].state.name);
      Writer.WriteInteger(uclass.functions[i].srcline);
      Writer.WriteString(uclass.functions[i].comment);
    end;
  finally
    Writer.Free;
  end;
end;

procedure TUnCodeXState.LoadClassesFromStream(stream: TStream; version: integer);
var
  Reader: TReader;
  NumClasses: Cardinal;
  ALevel, n, m, i, o, j: integer;
  ANode, NextNode: TTreeNode;
  uclass, puclass: TUClass;
  uconst: TUConst;
  uprop: TUProperty;
  uenum: TUEnum;
  ustruct: TUStruct;
  ustate: TUstate;
  ufunc: TUFunction;
begin
  ANode := nil;
  puclass := nil;
  Reader := TReader.Create(stream, 4096);
  try
    Stream.Read(NumClasses, 4);
    for n := 0 to NumClasses-1 do begin
      uclass := TUClass.Create;
      uclass.name := Reader.ReadString;
      unit_rtfhilight.ClassesHash.Items[LowerCase(uclass.name)] := '-';
      ALevel := Reader.ReadInteger;
      uclass.package := GetPackage(Reader.ReadString);
      uclass.tagged := uclass.package.tagged;
      uclass.parentname := Reader.ReadString;
      uclass.filename := Reader.ReadString;
      uclass.modifiers := Reader.ReadString;
      uclass.filetime := Reader.ReadInteger;
      if (version >= 150) then uclass.comment := Reader.ReadString;
      if (version >= 151) then uclass.defaultproperties := Reader.ReadString;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        uconst := TUconst.Create;
        uconst.name := Reader.ReadString;
        uconst.value := Reader.ReadString;
        uconst.srcline := Reader.ReadInteger;
        if (version >= 150) then uconst.comment := Reader.ReadString;
        uclass.consts.Add(uconst)
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        uprop := TUProperty.Create;
        uprop.name := Reader.ReadString;
        uprop.ptype := Reader.ReadString;
        uprop.modifiers := Reader.ReadString;
        uprop.tag := Reader.ReadString;
        uprop.srcline := Reader.ReadInteger;
        if (version >= 150) then uprop.comment := Reader.ReadString;
        uclass.properties.Add(uprop);
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        uenum := TUEnum.Create;
        uenum.name := Reader.ReadString;
        uenum.options := Reader.ReadString;
        uenum.srcline := Reader.ReadInteger;
        if (version >= 150) then uenum.comment := Reader.ReadString;
        uclass.enums.Add(uenum);
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        ustruct := TUStruct.Create;
        ustruct.name := Reader.ReadString;
        ustruct.parent := Reader.ReadString;
        ustruct.modifiers := Reader.ReadString;
        ustruct.data := Reader.ReadString;
        ustruct.srcline := Reader.ReadInteger;
        if (version >= 150) then ustruct.comment := Reader.ReadString;
        uclass.structs.Add(ustruct);
        if (version >= 150) then begin
          // struct properties
          o := Reader.ReadInteger;
          for j := 0 to o-1 do begin
            uprop := TUProperty.Create;
            uprop.name := Reader.ReadString;
            uprop.ptype := Reader.ReadString;
            uprop.modifiers := Reader.ReadString;
            uprop.tag := Reader.ReadString;
            uprop.srcline := Reader.ReadInteger;
            uprop.comment := Reader.ReadString;
            ustruct.properties.Add(uprop);
          end;
          // struct enums
          if ((version >= 150) and (version <= 151)) then begin
            o := Reader.ReadInteger;
            for j := 0 to o-1 do begin
              uenum := TUEnum.Create;
              uenum.name := Reader.ReadString;
              uenum.options := Reader.ReadString;
              uenum.srcline := Reader.ReadInteger;
              uenum.comment := Reader.ReadString;
              uclass.enums.Add(uenum);
            end;
          end;
        end;
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        ustate := TUstate.Create;
        ustate.name := Reader.ReadString;
        ustate.extends := Reader.ReadString;
        ustate.modifiers := Reader.ReadString;
        ustate.srcline := Reader.ReadInteger;
        if (version >= 150) then ustate.comment := Reader.ReadString;
        uclass.states.Add(ustate);
      end;
      if (version >= 171) then begin
				m := Reader.ReadInteger;
      	for i := 0 to m-1 do begin
        	ufunc := TUFunction.Create;
        	ufunc.name := Reader.ReadString;
        	ufunc.ftype := TUFunctionType(Reader.ReadInteger);
        	ufunc.return := Reader.ReadString;
        	ufunc.modifiers := Reader.ReadString;
        	ufunc.params := Reader.ReadString;
        	ufunc.srcline := Reader.ReadInteger;
        	if (version >= 150) then ufunc.comment := Reader.ReadString;
        	uclass.delegates.Add(ufunc);
      	end;
      end;
      m := Reader.ReadInteger;
      for i := 0 to m-1 do begin
        ufunc := TUFunction.Create;
        ufunc.name := Reader.ReadString;
        ufunc.ftype := TUFunctionType(Reader.ReadInteger);
        ufunc.return := Reader.ReadString;
        ufunc.modifiers := Reader.ReadString;
        ufunc.params := Reader.ReadString;
        ufunc.state := GetState(Reader.ReadString, uclass);
        if (ufunc.state <> nil) then begin
          ufunc.state.functions.Add(ufunc);
        end;
        ufunc.srcline := Reader.ReadInteger;
        if (version >= 150) then ufunc.comment := Reader.ReadString;
        uclass.functions.Add(ufunc);
      end;
      if ANode = nil then // root
        ANode := FClassTree.Items.AddChildObject(nil, uclass.name, uclass)
      else if ANode.Level = ALevel then begin // same level
        uclass.parent := puclass.parent;
        ANode := FClassTree.Items.AddChildObject(ANode.Parent, uclass.name, uclass);
      end
      else if ANode.Level = (ALevel - 1) then begin // child
        uclass.parent := puclass;
        ANode := FClassTree.Items.AddChildObject(ANode, uclass.name, uclass);
      end
      else if ANode.Level > ALevel then // parent level
      begin
        NextNode := ANode.Parent;
        while NextNode.Level > ALevel do
          NextNode := NextNode.Parent;
        if (NextNode.Parent = nil) then uclass.parent := nil
          else uclass.parent := TUClass(NextNode.Parent.Data);
        ANode := FClassTree.Items.AddChildObject(NextNode.Parent, uclass.name, uclass);
      end
      else TreeViewErrorFmt(sInvalidLevelEx, [ALevel, uclass.name]);
      uclass.treenode := ANode;
      if (uclass.parent <> nil) then uclass.parent.children.Add(uclass);
      if (uclass.tagged) then begin
        TTreeNode(uclass.treenode).ImageIndex := ICON_CLASS_TAGGED;
        TTreeNode(uclass.treenode).StateIndex := ICON_CLASS_TAGGED;
        TTreeNode(uclass.treenode).SelectedIndex := ICON_CLASS_TAGGED;
      end
      else begin
        TTreeNode(uclass.treenode).ImageIndex := ICON_CLASS;
        TTreeNode(uclass.treenode).StateIndex := ICON_CLASS;
        TTreeNode(uclass.treenode).SelectedIndex := ICON_CLASS;
      end;
      FClassList.Add(uclass);
      uclass.package.classes.Add(uclass);
      uclass.treenode2 := FPackageTree.Items.AddChildObject(TTreeNode(uclass.package.treenode), uclass.name, uclass);
      with TTreenode(uclass.treenode2) do begin
        ImageIndex := TTreeNode(uclass.treenode).ImageIndex;
        StateIndex := TTreeNode(uclass.treenode).StateIndex;
        SelectedIndex := TTreeNode(uclass.treenode).SelectedIndex;
      end;
      puclass := uclass;
    end;
    Reader.FlushBuffer;
  finally
    Reader.Free;
  end;
end;

procedure TUnCodeXState.LoadPackagesFromStream(stream: TStream; version: integer);
var
  Reader: TReader;
  NumPackages: Cardinal;
  n: Integer;
  package: TUPackage;
begin
  Reader := TReader.Create(stream, 4096);
  try
    Stream.Read(NumPackages, 4);
    for n := 0 to NumPackages-1 do begin
      package := TUPackage.Create;
      package.name := Reader.ReadString;
      package.priority := Reader.ReadInteger;
      package.path := Reader.ReadString;
      package.tagged := Reader.ReadBoolean;
      package.treenode := FPackageTree.Items.AddObject(nil, package.name, package);
      if (package.tagged) then begin
        TTreeNode(package.treenode).ImageIndex := ICON_PACKAGE_TAGGED;
        TTreeNode(package.treenode).StateIndex := ICON_PACKAGE_TAGGED;
        TTreeNode(package.treenode).SelectedIndex := ICON_PACKAGE_TAGGED;
      end
      else begin
        TTreeNode(package.treenode).ImageIndex := ICON_PACKAGE;
        TTreeNode(package.treenode).StateIndex := ICON_PACKAGE;
        TTreeNode(package.treenode).SelectedIndex := ICON_PACKAGE;
      end;
      if (version > 155) then begin
        package.comment := Reader.ReadString;
      end;
      FPackageList.Add(package);
    end;
  finally
    Reader.Free;
  end;
end;

procedure TUnCodeXState.Clear;
begin
  FClassTree.Items.Clear;
  FClassList.Clear;
  FPackageTree.Items.Clear;
  FPackageList.Clear;
end;

procedure TUnCodeXState.Delete(Index: Integer);
begin

end;

procedure TUnCodeXState.Insert(Index: Integer; const S: string);
begin

end;

function TUnCodeXState.GetPackage(name: string): TUPackage;
var
  i: integer;
begin
  for i := 0 to FPackageList.Count-1 do begin
    if (CompareText(name, FPackageList[i].name) = 0) then begin
      result := FPackageList[i];
      exit;
    end;
  end;
  result := nil;
end;

function TUnCodeXState.GetState(name: string; uclass: TUClass): TUState;
var
  i: integer;
begin
  for i := 0 to uclass.states.Count-1 do begin
    if (CompareText(name, uclass.states[i].name) = 0) then begin
      result := uclass.states[i];
      exit;
    end;
  end;
  result := nil;
end;

constructor TUnCodeXState.Create(AOwner: TUClassList; CTree: TTreeView; PList: TUPackageList; PTree: TTreeView);
begin
  inherited Create;
  FClassTree := CTree;
  FClassList := AOwner;
  FPackageList := PList;
  FPackageTree := PTree;
end;

function TUnCodeXState.LoadTreeFromStream(Stream: TStream): boolean;
var
  tmp: array[0..8] of char;
  fversion: integer;
begin
  Stream.Position := 0;
  Stream.Read(tmp, 9);
  result := false;
  if (StrLComp(tmp, UCXHeader, 3) = 0) then begin
    if (StrComp(tmp, UCXHeader059) = 0) then fversion := 59
    else if (StrComp(tmp, UCXHeader150) = 0) then fversion := 150
    else if (StrComp(tmp, UCXHeader151) = 0) then fversion := 151
    else if (StrComp(tmp, UCXHeader153) = 0) then fversion := 153
    else if (StrComp(tmp, UCXHeader156) = 0) then fversion := 156
    else if (StrComp(tmp, UCXHeader171) = 0) then fversion := 171
    else begin
      Log('Unsupported file version, header: '+tmp);
      exit;
    end;
    Clear;
    LoadPackagesFromStream(stream, fversion);
    unit_rtfhilight.ClassesHash.Clear;
    LoadClassesFromStream(stream, fversion);
    FClassList.Sort;
    FPackageList.Sort;
    result := true;
  end
  else Log('State file corrupt or unsupported version');
end;

procedure TUnCodeXState.SaveTreeToStream(Stream: TStream);
var
  i: integer;
  c: cardinal;
begin
  try
    stream.WriteBuffer(UCXHeader171, 9);
    // packages
    c := FPackageList.Count;
    stream.WriteBuffer(c, 4);
    for i := 0 to FPackageList.Count-1 do begin
      SavePackageToStream(FPackageList[i] , stream);
    end;
    // classes
    c := FClassTree.Items.Count;
    stream.WriteBuffer(c, 4);
    for i := 0 to FClassTree.Items.Count-1 do begin
      SaveClassToStream(TUClass(FClassTree.Items[i].Data), stream);
    end;
  except
  end;
end;

{ TUnCodeXState -- END }

end.
