{*******************************************************************************
	Name:
        unit_htmlout.pas
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        HTML documentation generator.

	$Id: unit_htmlout.pas,v 1.59 2004-10-20 13:00:40 elmuerte Exp $
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
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA	02111-1307	USA
}

unit unit_htmlout;

{$I defines.inc}

interface

uses
	Classes, SysUtils, unit_uclasses, StrUtils, Hashes, DateUtils, IniFiles,
    unit_outputdefs, unit_clpipe;

type
	TGlossaryItem = class(TObject)
		classname: string;
		link: string;
	end;

	TGlossaryInfo = class(TObject)
		item: string;
		glossay: TStringList;
		next, prev: string;
	end;

	TInheritenceData = class(TObject)
		itype: string;
		items: string;
		uclass: TUClass;
	end;

	THTMLoutConfig = record
		PackageList: TUPackageList;
		ClassList: TUClassList;
		outputdir, TemplateDir: string;
		CreateSource: boolean;
		TabsToSpaces: integer;
		TargetExtention: string;
		CPP: string;
		DefaultTitle: string;
	end;

	// General replace function
	TReplacement = function(var replacement: string; data: TObject = nil): boolean of Object;

	THTMLOutput = class(TThread)
	protected
		MaxInherit: integer;
		HTMLOutputDir: string;
		TemplateDir: string;
		CreateSource: boolean;
		TabsToSpaces: integer;
		CPP: string;
		IsCPP: boolean;
		TypeCache: Hashes.TStringHash;
		ConstCache: Hashes.TStringHash;
		VarCache: Hashes.TStringHash;
		EnumCache: Hashes.TStringHash;
		StructCache: Hashes.TStringHash;
		FunctionCache: Hashes.TStringHash;
		DelegateCache: Hashes.TStringHash;
		CPPPipe: TCLPipe;
		ConfDefaultTitle: string;
		
		PackageList: TUPackageList;
		ClassList: TUClassList;
		status: TStatusReport;
		ini: TMemIniFile;

		procedure parseTemplate(input, output: TStream; replace: TReplacement; data: TObject = nil);
		function replaceDefault(var replacement: string; data: TObject = nil): boolean;
		procedure htmlIndex; // creates index.html
		function replaceIndex(var replacement: string; data: TObject = nil): boolean;
		procedure htmlOverview; // creates overview.html
		function replaceOverview(var replacement: string; data: TObject = nil): boolean;
		procedure htmlPackagesList; // creates packages.html
		function replacePackagesList(var replacement: string; data: TObject = nil): boolean;
		function replacePackagesListEntry(var replacement: string; data: TObject = nil): boolean;
		procedure htmlClassesList; // creates classes.html
		function replaceClassesList(var replacement: string; data: TObject = nil): boolean;
		procedure htmlPackageClasses; // creates PackageClasses.html
		function replacePackageClassesList(var replacement: string; data: TObject = nil): boolean;
		procedure htmlPackageOverview; // creates <packagename>.html
		function replacePackageOverview(var replacement: string; data: TObject = nil): boolean;
		procedure htmlClassOverview; // creates <packagename>_<classname>.html
		function replaceClass(var replacement: string; data: TObject = nil): boolean;
		function replaceClassConst(var replacement: string; data: TObject = nil): boolean;
		function replaceClassVar(var replacement: string; data: TObject = nil): boolean;
		function replaceVarTag(var replacement: string; data: TObject = nil): boolean;
		function replaceClassEnum(var replacement: string; data: TObject = nil): boolean;
		function replaceClassStruct(var replacement: string; data: TObject = nil): boolean;
		function replaceClassFunction(var replacement: string; data: TObject = nil): boolean;
		function replaceClassState(var replacement: string; data: TObject = nil): boolean;
		function replaceInherited(var replacement: string; data: TObject = nil): boolean;
		function GetTypeLink(name: string): string;
		function TypeLink(name: string; uclass: TUClass): string;
		procedure htmlTree;
		procedure ProcTreeNode(var replacement: string; uclass: TUClass; basestring: string);
		function replaceClasstree(var replacement: string; data: TObject = nil): boolean;
		procedure htmlGlossary;
		function replaceGlossary(var replacement: string; data: TObject = nil): boolean;
		procedure CopyFiles;
		function ProcComment(input: string): string;
		procedure SourceCode;
		procedure parseCode(input, output: TStream; nolineno: boolean = false; notable: boolean = false; nopre: boolean = false);
		function CommentPreprocessor(input: string): string;
		function GetPackage(curpack: TUPackage; offset: integer; wrap: boolean = true): TUPackage;
		function GetClass(curclass: TUClass; offset: integer; wrap: boolean = true): TUClass;
	public
		constructor Create(config: THTMLoutConfig; status: TStatusReport);
		destructor Destroy; override;
		procedure Execute; override;
	end;

	function ClassLink(uclass: TUClass; DOSPath: boolean = false): string;
	function PackageLink(upackage: TUPackage; DOSPath: boolean = false): string;
	function PackageListLink(upackage: TUPackage; DOSPath: boolean = false): string;

const
	default_title 			= 'UnCodeX';
	packages_list_filename 	= 'packages.';
	classes_list_filename 	= 'classes.';
	overview_filename 		= 'overview.';
	classtree_filename 		= 'classtree.';
	glossary_filename 		= 'glossary_A.';
	SOURCEPRE 				= 'Source_';
	IGNORE_KEYWORD 			= '@ignore';
	ASCII_GLOSSARY_ELIPSE 	= '... ';
	ASCII_TREE_NONE 		= '		';
	ASCII_TREE_T 			= '+-- ';
	ASCII_TREE_L 			= '+-- ';
	ASCII_TREE_I 			= '|	 ';

var
	TargetExtention: string;

implementation

uses
	unit_definitions, unit_copyparser, unit_sourceparser
{$IFDEF FPC}
	, unit_fpc_compat
{$ENDIF}
	;

var
	currentClass: 	TUClass;
	curPos, maxPos: integer;
	GlossaryElipse: string;
	TreeNone: 		string;
	TreeT: 			string;
	TreeL: 			string;
	TreeI: 			string;
	subDirDepth: 	integer;

function ClassLink(uclass: TUClass; DOSPath: boolean = false): string;
var
	path: string;
begin
	if (DOSPath) then path := PathDelim else path := '/';
	result := LowerCase(uclass.package.name+path+uclass.name+'.'+TargetExtention);
end;

function PackageLink(upackage: TUPackage; DOSPath: boolean = false): string;
var
	path: string;
begin
	if (DOSPath) then path := PathDelim else path := '/';
	result := LowerCase(upackage.name+path+upackage.name+'-overview.'+TargetExtention);
end;

function PackageListLink(upackage: TUPackage; DOSPath: boolean = false): string;
var
	path: string;
begin
	if (DOSPath) then path := PathDelim else path := '/';
	result := LowerCase(upackage.name+path+upackage.name+'-list.'+TargetExtention);
end;

function IsReplacement(replacement, check: string): boolean;
begin
	result := CompareText(Copy(replacement, 1, Length(check)), check) = 0;
end;

// convert to HTML chars
function HTMLChars(line: string): string;
begin
	result := StringReplace(line, '<', '&lt;', [rfReplaceAll]);
	result := StringReplace(result, '>', '&gt;', [rfReplaceAll]);
	result := StringReplace(result, '"', '&quot;', [rfReplaceAll]);
end;

function functionTypeToString(ftype: TUFunctionType): string;
begin
	case ftype of
		uftFunction:	 result := 'function';
		uftEvent:		 result := 'event';
		uftOperator:	 result := 'operator';
		uftPreOperator:	 result := 'preoperator';
		uftPostOperator: result := 'postoperator';
		uftDelegate:	 result := 'delegate';
	end;
end;

function IgnoreComment(cmt: string): boolean;
begin
	result := Pos(IGNORE_KEYWORD, LowerCase(Copy(trim(cmt), 1, 8))) = 1;
end;

{ THTMLOutput }

constructor THTMLOutput.Create(config: THTMLoutConfig; status: TStatusReport);
begin
	resetguard;
	Self.PackageList := Config.PackageList;
	Self.ClassList := Config.ClassList;
	Self.status := status;
	Self.HTMLOutputDir := Config.outputdir;
	iFindDir(Config.TemplateDir+PATHDELIM, Self.TemplateDir);
	Self.CreateSource := config.CreateSource;
	Self.TabsToSpaces := config.TabsToSpaces;
	Self.CPP := config.CPP;
	Self.ConfDefaultTitle := config.DefaultTitle;
	TargetExtention := config.TargetExtention;
	TypeCache := Hashes.TStringHash.Create;
	ConstCache := Hashes.TStringHash.Create;
	VarCache := Hashes.TStringHash.Create;
	EnumCache := Hashes.TStringHash.Create;
	StructCache := Hashes.TStringHash.Create;
	FunctionCache := Hashes.TStringHash.Create;
	DelegateCache := Hashes.TStringHash.Create;
	ini := TMemIniFile.Create(iFindFile(TemplateDir+'template.ini'));
	{$IFNDEF FPC}
	ini.CaseSensitive := false;
	{$ENDIF}
	MaxInherit := ini.ReadInteger('Settings', 'MaxInherit', MaxInt);
	if (TargetExtention = '') then TargetExtention := ini.ReadString('Settings', 'TargetExt', 'html');
	if (MaxInherit <= 0) then MaxInherit := MaxInt;
	// 0 = use template default
	// -1 = disable
	if (TabsToSpaces = 0) then TabsToSpaces := ini.ReadInteger('Settings', 'TabsToSpaces', TabsToSpaces);
	if (Self.CPP = '') then begin
		Self.CPP := Ini.ReadString('Setting', 'CPP', '');
		if (Self.CPP <> '') then Self.CPP := TemplateDir+Self.CPP;
	end;
	if (CompareText(trim(Self.CPP), 'none') = 0) then Self.CPP := '';
	if (CPP <> '') then begin
		if (FileExists(CPP)) then begin
			CPPPipe := TCLPipe.Create(Self.CPP);
			IsCPP := CPPPipe.Open;
		end
		else Log('Comment Preprocessor "'+CPP+'" not found');
	end;
	GlossaryElipse := ini.ReadString('Settings', 'GlossaryElipse', ASCII_GLOSSARY_ELIPSE);
	TreeNone := ini.ReadString('Settings', 'TreeNone', ASCII_TREE_NONE);
	TreeT := ini.ReadString('Settings', 'TreeT', ASCII_TREE_T);
	TreeL := ini.ReadString('Settings', 'TreeL', ASCII_TREE_L);
	TreeI := ini.ReadString('Settings', 'TreeI', ASCII_TREE_I);
	inherited Create(true);
end;

destructor THTMLOutput.Destroy;
begin
	if (IsCPP and (CPPPipe <> nil)) then CPPPipe.Destroy; 
	//TypeCache.Free; <-- will crash the system
	TypeCache.Clear;
	ConstCache.Clear;
	VarCache.Clear;
	EnumCache.Clear;
	StructCache.Clear;
	FunctionCache.Clear;
	DelegateCache.Clear;
	ini.Free;
end;

procedure THTMLOutput.Execute;
var
	stime: 	TDateTime;
	i: 		integer;
begin
	try
		curPos := 0;
		maxPos := (PackageList.Count*2)+ClassList.Count;
		if (ini.ReadBool('Settings', 'CreateClassTree', true)) then maxPos := maxPos+1;
		if (ini.ReadBool('Settings', 'CreateGlossary', true)) then maxPos := maxPos+26;
		if (ini.ReadBool('Settings', 'SourceCode', true)) then maxPos := maxPos+ClassList.Count;
		Status('Working ...', 0);
		stime := Now();
		forcedirectories(htmloutputdir);
		PackageList.AlphaSort;
		ClassList.Sort;
		TypeCache.Items['int'] := '-';
		TypeCache.Items['string'] := '-';
		TypeCache.Items['float'] := '-';
		TypeCache.Items['bool'] := '-';
		TypeCache.Items['byte'] := '-';
		TypeCache.Items['class'] := '-';
		TypeCache.Items['name'] := '-';
		for i := 0 to ClassList.Count-1 do begin
			if (not TypeCache.Exists(LowerCase(ClassList[i].Name))) then
				TypeCache.Items[LowerCase(ClassList[i].Name)] := ClassLink(ClassList[i])
				else Log('Type already cached '+ClassList[i].Name);
		end;

		if (not Self.Terminated) then CopyFiles;
		subDirDepth := 0;
		if (not Self.Terminated) then htmlIndex;
		if (not Self.Terminated) then htmlOverview;
		if (not Self.Terminated) then htmlPackagesList;
		if (not Self.Terminated) then htmlClassesList;
		subDirDepth := 1;
		if (not Self.Terminated) then htmlPackageClasses;
		if (not Self.Terminated) then htmlPackageOverview;
		if (not Self.Terminated) then htmlClassOverview;
		subDirDepth := 0;
		if (ini.ReadBool('Settings', 'CreateClassTree', true) and (not Self.Terminated)) then htmlTree; // create class tree
		if (ini.ReadBool('Settings', 'CreateGlossary', true) and (not Self.Terminated)) then htmlGlossary; // iglossery
		subDirDepth := 1;
		if (ini.ReadBool('Settings', 'SourceCode', true) and (not Self.Terminated) and CreateSource) then SourceCode; //
		if (IsCPP and (CPPPipe <> nil)) then CPPPipe.Close;
		Status('Operation completed in '+Format('%.3f', [Millisecondsbetween(Now(), stime)/1000])+' seconds');
	except
		on E: Exception do begin
			Log('Unhandled exception: '+E.Message);
			Log('History:');
			for i := 0 to GuardStack.Count-1 do begin
				log('		'+GuardStack[i]);
			end;
		end;
	end;
	resetguard;
end;

procedure THTMLOutput.parseTemplate(input, output: TStream; replace: TReplacement; data: TObject = nil);
var
	p: 				TCopyParser;
	replacement: 	string;
begin
	guard('parseTemplate');
	p := TCopyParser.Create(input, output);
	try
		while (p.Token <> toEOF) do begin
			if (p.Token = '%') then begin
				replacement := p.SkipToToken('%');
				if (replacement = '') then begin // %% = %
					replacement := '%';
					p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				end
				else if (replace(replacement, data)) then begin
					p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				end
				else begin // put back old
					replacement := '%'+replacement+'%';
					p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				end;
			end
			else begin
				p.CopyTokenToOutput;
			end;
			p.SkipToken(true);
		end;
	finally
		p.Free;
	end;
	unguard;
end;

function THTMLOutput.replaceDefault(var replacement: string; data: TObject = nil): boolean;
var
	fs: 	TFileStream;
	ss: 	TStringStream;
	tmp: 	string;
begin
	guard('replaceDefault '+replacement);
	result := false;
	if (CompareText(replacement, 'default_title') = 0) then begin
		if (ConfDefaultTitle <> '') then replacement := ConfDefaultTitle
		else replacement := ini.ReadString('titles', 'DefaultTitle', default_title);
		result := true;
	end
	else if (CompareText(replacement, 'create_time') = 0) then begin
		DateTimeToString(replacement, ini.ReadString('Settings', 'DateFormat', 'c'), Now);
		result := true;
	end
	else if (CompareText(replacement, 'glossary_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+glossary_filename+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'glossary_title') = 0) then begin
		replacement := ini.ReadString('Titles', 'Glossary', 'Glossary');
		result := true;
	end
	else if (CompareText(replacement, 'classtree_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+classtree_filename+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'classtree_title') = 0) then begin
		replacement := ini.ReadString('Titles', 'ClassTree', 'ClassTree');
		result := true;
	end
	else if (CompareText(replacement, 'index_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+overview_filename+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'index_title') = 0) then begin
		replacement := ini.ReadString('Titles', 'Overview', 'Overview');
		result := true;
	end
	else if (CompareText(replacement, 'VERSION') = 0) then begin
		replacement := APPVERSION;
		result := true;
	end
	else if (CompareText(replacement, 'UNCODEX') = 0) then begin
		replacement := APPTITLE;
		result := true;
	end
	else if (CompareText(replacement, 'PLATFORM') = 0) then begin
		replacement := APPPLATFORM;
		result := true;
	end
	else if (CompareText(replacement, 'packages_list_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+packages_list_filename+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'classes_list_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+classes_list_filename+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'overview_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+overview_filename+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'parentdir') = 0) then begin
		replacement := StrRepeat('../', subDirDepth);
		result := true;
	end
	else if (CompareText(replacement, 'targetext') = 0) then begin
		replacement := TargetExtention;
		result := true;
	end
	else if (IsReplacement(replacement, 'include:')) then begin
		tmp := Copy(replacement, Length('include:')+1, MaxInt);
		if (not FileExists(TemplateDir+tmp)) then begin
			Log('Can''t include file: '+tmp);
		end
		else begin
			//Log('Including '+replacement+' AS IS');
			fs := TFileStream.Create(TemplateDir+tmp, fmOpenRead or fmShareDenyWrite);
			ss := TStringStream.Create('');
			try
				parseTemplate(fs, ss, replaceDefault);
				replacement := ss.DataString;
				result := true;
			finally
				fs.Free;
				ss.Free;
			end;
		end;
	end;
	unguard;
end;

procedure THTMLOutput.htmlIndex;
var
	template, target: TFileStream;
begin
	guard('htmlIndex');
	Status('Creating index.'+TargetExtention);
	template := TFileStream.Create(templatedir+'index.html', fmOpenRead or fmShareDenyWrite);
	target := TFileStream.Create(htmloutputdir+PATHDELIM+'index.'+TargetExtention, fmCreate);
	try
		parseTemplate(template, target, replaceIndex);
	finally
		template.Free;
		target.Free;
	end;
	unguard;
end;

function THTMLOutput.replaceIndex(var replacement: string; data: TObject = nil): boolean;
begin
	result := replaceDefault(replacement);
end;

procedure THTMLOutput.htmlOverview;
var
	template, target: TFileStream;
begin
	guard('htmlOverview');
	Status('Creating '+overview_filename+TargetExtention);
	template := TFileStream.Create(templatedir+'overview.html', fmOpenRead or fmShareDenyWrite);
	target := TFileStream.Create(htmloutputdir+PATHDELIM+overview_filename+TargetExtention, fmCreate);
	try
		parseTemplate(template, target, replaceOverview);
	finally
		template.Free;
		target.Free;
	end;
	unguard;
end;

function THTMLOutput.replaceOverview(var replacement: string; data: TObject = nil): boolean;
var
	template: 	TFileStream;
	target: 	TStringStream;
	i: 			integer;
begin
	guard('replaceOverview '+replacement);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'packages_table') = 0) then begin
		template := TFileStream.Create(templatedir+'packages_table_entry.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to PackageList.Count-1 do begin
				template.Position := 0;
				parseTemplate(template, target, replacePackagesListEntry, PackageList[i]);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end;
	unguard;
end;

procedure THTMLOutput.htmlPackagesList;
var
	template, target: TFileStream;
begin
	guard('htmlPackagesList');
	Status('Creating '+packages_list_filename+TargetExtention);
	template := TFileStream.Create(templatedir+'packages_list.html', fmOpenRead or fmShareDenyWrite);
	target := TFileStream.Create(htmloutputdir+PATHDELIM+packages_list_filename+TargetExtention, fmCreate);
	try
		parseTemplate(template, target, replacePackagesList);
	finally
		template.Free;
		target.Free;
	end;
	unguard;
end;

function THTMLOutput.replacePackagesList(var replacement: string; data: TObject = nil): boolean;
var
	template: 	TFileStream;
	target: 	TStringStream;
	i: 			integer;
begin
	guard('replacePackagesList '+replacement);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'packages_list') = 0) then begin
		template := TFileStream.Create(templatedir+'packages_list_entry.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to PackageList.Count-1 do begin
				template.Position := 0;
				parseTemplate(template, target, replacePackagesListEntry, PackageList[i]);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end;
	unguard;
end;

function THTMLOutput.replacePackagesListEntry(var replacement: string; data: TObject = nil): boolean;
begin
	guard('replacePackagesListEntry '+replacement+' '+TUPackage(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'package_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+PackageLink(TUPackage(data));
		result := true;
	end
	else if (CompareText(replacement, 'package_classes_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+PackageListLink(TUPackage(data));
		result := true;
	end
	else if (CompareText(replacement, 'package_name') = 0) then begin
		replacement := TUPackage(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'package_class_count') = 0) then begin
		replacement := IntToStr(TUPackage(data).classes.count);
		result := true;
	end
	else if (CompareText(replacement, 'package_path') = 0) then begin
		replacement := TUPackage(data).path;
		result := true;
	end
	else if (CompareText(replacement, 'package_comment') = 0) then begin
		replacement := CommentPreprocessor(TUPackage(data).comment);
		result := true;
	end
	else if (CompareText(replacement, 'package_next') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+PackageLink(GetPackage(TUPackage(data),1));
		result := true;
	end
	else if (CompareText(replacement, 'package_previous') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+PackageLink(GetPackage(TUPackage(data),-1));
		result := true;
	end;
	unguard;
end;

procedure THTMLOutput.htmlClassesList;
var
	template, target: TFileStream;
begin
	guard('htmlClassesList');
	Status('Creating '+classes_list_filename+TargetExtention);
	template := TFileStream.Create(templatedir+'classes_list.html', fmOpenRead or fmShareDenyWrite);
	target := TFileStream.Create(htmloutputdir+PATHDELIM+classes_list_filename+TargetExtention, fmCreate);
	try
		parseTemplate(template, target, replaceClassesList);
	finally
		template.Free;
		target.Free;
	end;
	unguard;
end;

procedure THTMLOutput.htmlPackageClasses;
var
	pfname: 	string;
	template,
    target: 	TFileStream;
	i: 			integer;
begin
	guard('htmlPackageClasses');
	template := TFileStream.Create(templatedir+'packageclasses_list.html', fmOpenRead or fmShareDenyWrite);
	Status('Creating '+classes_list_filename+TargetExtention);
	try
		for i := 0 to PackageList.Count-1 do begin
			pfname := PackageListLink(PackageList[i], true);
			ForceDirectories(ExtractFilePath(htmloutputdir+PATHDELIM+pfname));
			Status('Creating '+pfname, round(curPos/maxPos*100));
			curPos := curPos+1;
			PackageList[i].classes.Sort;
			target := TFileStream.Create(htmloutputdir+PATHDELIM+pfname, fmCreate);
			try
				template.Position := 0;
				parseTemplate(template, target, replacePackageClassesList, PackageList[i]);
			finally
				target.Free;
			end;
			if (Self.Terminated) then break;
		end;
	finally
		template.Free;
	end;
	unguard;
end;

function THTMLOutput.replaceClassesList(var replacement: string; data: TObject = nil): boolean;
var
	template: 	TFileStream;
	target: 	TStringStream;
	i: 			integer;
begin
	guard('replaceClassesList '+replacement);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'classes_list') = 0) then begin
		template := TFileStream.Create(templatedir+'classes_list_entry.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to ClassList.Count-1 do begin
				template.Position := 0;
				parseTemplate(template, target, replaceClass, ClassList[i]);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end;
	unguard;
end;

function THTMLOutput.replacePackageClassesList(var replacement: string; data: TObject = nil): boolean;
var
	template: 	TFileStream;
	target: 	TStringStream;
	i: 			integer;
begin
	guard('replacePackageClassesList '+replacement+' '+TUPackage(data).name);
	result := replaceDefault(replacement, data) or replacePackagesListEntry(replacement, data);
	if (result) then else
	if (CompareText(replacement, 'classes_list') = 0) then begin
		template := TFileStream.Create(templatedir+'packageclasses_list_entry.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to (data as TUPackage).classes.Count-1 do begin
				template.Position := 0;
				parseTemplate(template, target, replaceClass, (data as TUPackage).classes[i]);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end;
	unguard;
end;

procedure THTMLOutput.htmlPackageOverview;
var
	pfname: 	string;
	template,
    target: 	TFileStream;
	i: 			integer;
begin
	guard('htmlPackageOverview');
	template := TFileStream.Create(templatedir+'package_overview.html', fmOpenRead or fmShareDenyWrite);
	try
		for i := 0 to PackageList.Count-1 do begin
			pfname := PackageLink(PackageList[i], true);
			ForceDirectories(ExtractFilePath(htmloutputdir+PATHDELIM+pfname));
			Status('Creating '+pfname, round(curPos/maxPos*100));
			curPos := curPos+1;
			PackageList[i].classes.Sort;
			target := TFileStream.Create(htmloutputdir+PATHDELIM+pfname, fmCreate);
			try
				template.Position := 0;
				parseTemplate(template, target, replacePackageOverview, PackageList[i]);
			finally
				target.Free;
			end;
			if (Self.Terminated) then break;
		end;
	finally
		template.Free;
	end;
	unguard;
end;

function THTMLOutput.replacePackageOverview(var replacement: string; data: TObject = nil): boolean;
var
	template: 	TFileStream;
	target: 	TStringStream;
	i: 			integer;
begin
	guard('replacePackageOverview '+replacement+' '+TUPackage(data).name);
	result := replaceDefault(replacement) or replacePackagesListEntry(replacement, data);
	if (result) then else
	if (CompareText(replacement, 'package_classes_table') = 0) then begin
		template := TFileStream.Create(templatedir+'package_classes_table_entry.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUPackage(data).classes.Count-1 do begin
				// ignore class when comment = @ignore
				if (not IgnoreComment(TUPackage(data).classes[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClass, TUPackage(data).classes[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end;
	unguard;
end;

procedure THTMLOutput.htmlClassOverview;
var
	template,
    target: 	TFileStream;
	i,j: 		integer;
begin
	guard('htmlClassOverview');
	template := TFileStream.Create(templatedir+'class.html', fmOpenRead or fmShareDenyWrite);
	try
		for i := 0 to ClassList.Count-1 do begin
			// ignore class when comment = @ignore
			if (not IgnoreComment(ClassList[i].comment)) then begin
				Status('Creating '+ClassLink(ClassList[i]), round(curPos/maxPos*100));
				curPos := curPos+1;
				currentClass := ClassList[i];
				for j := 0 to currentClass.enums.Count-1 do begin
					TypeCache.Items[LowerCase(currentClass.enums[j].name)] := ClassLink(currentClass)+'#'+currentClass.enums[j].name;
				end;
				for j := 0 to currentClass.structs.Count-1 do begin
					TypeCache.Items[LowerCase(currentClass.structs[j].name)] := ClassLink(currentClass)+'#'+currentClass.structs[j].name;
				end;
				target := TFileStream.Create(htmloutputdir+PATHDELIM+ClassLink(ClassList[i]), fmCreate);
				try
					template.Position := 0;
					parseTemplate(template, target, replaceClass, ClassList[i]);
					if (Self.Terminated) then break;
				finally
					target.Free;
				end;
			end;
		end;
	finally
		template.Free;
	end;
	unguard;
end;

function CreateClassTree(uclass: TUClass; var level: integer): string;
begin
	if (uclass.parent <> nil) then begin
		result := CreateClassTree(uclass.parent, level);
	end;
	if (level > 0) then begin
		result := result+DupeString(TreeNone, (Level-1))+TreeI+#10;
		result := result+DupeString(TreeNone, (Level-1))+TreeL;
	end;
	result := result+'<a href="'+StrRepeat('../', subDirDepth)+PackageLink(uclass.package)+'">'+uclass.package.name+'</a>.<a href="'+StrRepeat('../', subDirDepth)+ClassLink(uclass)+'">'+uclass.name+'</a>'+#10;
	Inc(level);
end;

function THTMLOutput.replaceClass(var replacement: string; data: TObject = nil): boolean;
var
	i, cnt: 	integer;
	uclass,
    up: 		TUClass;
	template,
    template2: 	TFileStream;
	target,
    source: 	TStringStream;
	tmp, last: 	string;
	idata: 		TInheritenceData;
	VarOnTag: 	boolean;
begin
	guard('replaceClass '+replacement+' '+TUClass(data).name);
	result := replaceDefault(replacement) or replacePackageOverview(replacement, TUClass(data).package);
	if (result) then else
	currentClass := TUClass(data);
	if (CompareText(replacement, 'class_link') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+ClassLink(TUClass(data));
		result := true;
	end
	else if (CompareText(replacement, 'class_name') = 0) then begin
		replacement := TUClass(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'class_modifiers') = 0) then begin
		replacement := TUClass(data).modifiers;
		result := true;
	end
	else if (CompareText(replacement, 'class_parent') = 0) then begin
		if (TUClass(data).parent <> nil) then
			replacement := '<a href="'+StrRepeat('../', subDirDepth)+ClassLink(TUClass(data).parent)+'">'+TUClass(data).parent.name+'</a>'
			else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_parent_plain') = 0) then begin
		if (TUClass(data).parent <> nil) then
			replacement := StrRepeat('../', subDirDepth)+ClassLink(TUClass(data).parent)
			else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_parent_tree') = 0) then begin
		i := 0;
		replacement := CreateClassTree(TUClass(data), i);
		result := true;
	end
	else if (CompareText(replacement, 'class_filename') = 0) then begin
		replacement := TUClass(data).filename;
		result := true;
	end
	else if (CompareText(replacement, 'class_fileage') = 0) then begin
		DateTimeToString(replacement, ini.ReadString('Settings', 'DateFormat', 'c'), FileDateToDateTime(TUClass(data).filetime));
		result := true;
	end
	else if (CompareText(replacement, 'class_defaultproperties') = 0) then begin
		source := TStringStream.Create('defaultproperties'+#13#10+TUClass(data).defaultproperties);
		target := TStringStream.Create('');
		try
			parseCode(source, target, true);
			replacement := target.DataString;
			result := true;
		finally
			target.Free;
			source.Free;
		end;
	end
	else if (CompareText(replacement, 'class_defaultproperties_plain') = 0) then begin
		if (TabsToSpaces >= 0) then begin
			replacement := StringReplace(TUClass(data).defaultproperties, #9, StrRepeat(' ', TabsToSpaces), [rfReplaceAll]);
		end
		else replacement := TUClass(data).defaultproperties;
		result := true;
	end
	else if (CompareText(replacement, 'class_comment') = 0) then begin
		if (Copy(TUClass(data).comment, 1, 2) = '//') then replacement := ProcComment(TUClass(data).comment)
		else replacement := TUClass(data).comment;
		replacement := CommentPreprocessor(replacement);
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(TUClass(data));
		result := true;
	end
	else if (CompareText(replacement, 'class_children') = 0) then begin
		replacement := '';
		TUClass(data).children.Sort;
		for i := 0 to TUClass(data).children.count-1 do begin
			uclass := TUClass(data).children[i];
			if (uclass <> nil) then begin
				// ignore class when comment = @ignore
				if (not IgnoreComment(uclass.comment)) then begin
					if (replacement <> '') then replacement := replacement+', ';
					replacement := replacement+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(uclass)+'">'+uclass.name+'</a>'
				end;
			end;
			if (Self.Terminated) then break;
		end;
		if (replacement <> '') then begin
			replacement := ini.ReadString('titles', 'DirectSubclasses', '')+replacement;
		end;
		result := true;
	end
	///////////////////// new templates //////////////////////
	else if (IsReplacement(replacement, 'class_block_children')) then begin
		if (TUClass(data).children.Count = 0) then begin
			replacement := '';
			result := true;
		end
		else begin
			template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
			target := TStringStream.Create('');
			try
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
				result := true;
			finally
				template.Free;
				target.Free;
			end;
		end;
	end
	else if (CompareText(replacement, 'class_previous') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+ClassLink(GetClass(TUClass(data), -1));
		result := true;
	end
	else if (CompareText(replacement, 'class_next') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+ClassLink(GetClass(TUClass(data), 1));
		result := true;
	end
	else if (CompareText(replacement, 'class_source_previous') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(GetClass(TUClass(data), -1));
		result := true;
	end
	else if (CompareText(replacement, 'class_source_next') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(GetClass(TUClass(data), 1));
		result := true;
	end
	// Constants
	else if (IsReplacement(replacement, 'class_block_const')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			up := TUClass(data);
			cnt := -1;
			result := false;
			i := ini.ReadInteger('InheritCheck', replacement, 0);
			if (i = -1) then i := MaxInherit;
			while ((up <> nil) and (cnt < i)) do begin
				if (up.consts.Count > 0) then begin
					result := true;
					break;
				end;
				up := up.parent;
				Inc(cnt);
			end;
			if (result) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_const')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUClass(data).consts.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).consts[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassConst, TUClass(data).consts[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'inherited_entries_const')) then begin
		template := TFileStream.Create(templatedir+'class_entry_inherited.html', fmOpenRead);
		target := TStringStream.Create('');
		idata := TInheritenceData.Create;
		replacement := '';
		cnt := 0;
		try
			up := TUClass(data).parent;
			idata.itype := ini.ReadString('titels', 'Contants', 'Contants');
			while ((up <> nil) and (cnt < MaxInherit)) do begin
				if (not IgnoreComment(up.comment)) then begin
					template.Position := 0;
					idata.uclass := up;
					if (ConstCache.Exists(up.FullName)) then begin
						idata.items := ConstCache[up.FullName];
					end
					else begin
						tmp := '';
						for i := 0 to up.consts.Count-1 do begin
							// ignore const when comment = @ignore
							if (not IgnoreComment(up.consts[i].comment)) then begin
								if (i > 0) then tmp := tmp+', ';
								tmp := tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(up)+'#'+up.consts[i].name+'">'+up.consts[i].name+'</a>';
							end;
						end;
						if (tmp = '') then tmp := '-';
						ConstCache[up.FullName] := tmp;
						idata.items := tmp;
					end;
					if (idata.items <> '-') then parseTemplate(template, target, replaceInherited, idata);
				end;
				up := up.parent;
				Inc(cnt);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			idata.Free;
			template.Free;
			target.Free;
		end;
	end
	// variables
	else if (IsReplacement(replacement, 'class_block_variable')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			up := TUClass(data);
			cnt := -1;
			result := false;
			i := ini.ReadInteger('InheritCheck', replacement, 0);
			if (i = -1) then i := MaxInherit;
			while ((up <> nil) and (cnt < i)) do begin
				if (up.properties.Count > 0) then begin
					result := true;
					break;
				end;
				up := up.parent;
				Inc(cnt);
			end;
			if (result) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_variable')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		VarOnTag := ini.ReadBool('VariablesSortOnTag', replacement, false);
		if (VarOnTag) then TUClass(data).properties.SortOnTag
			else TUClass(data).properties.Sort;
		try
			tmp := '';
			for i := 0 to TUClass(data).properties.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).properties[i].comment)) then begin
					if ((CompareText(tmp, TUClass(data).properties[i].tag) <> 0) and VarOnTag) then begin
						template2 := TFileStream.Create(templatedir+LowerCase(replacement)+'_tag.html', fmOpenRead);
						try
							parseTemplate(template2, target, replaceVarTag, TUClass(data).properties[i]);
						finally
							template2.free;
						end;
						tmp := TUClass(data).properties[i].tag;
					end;
					template.Position := 0;
					parseTemplate(template, target, replaceClassVar, TUClass(data).properties[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'inherited_entries_variable')) then begin
		template := TFileStream.Create(templatedir+'class_entry_inherited.html', fmOpenRead);
		target := TStringStream.Create('');
		idata := TInheritenceData.Create;
		replacement := '';
		cnt := 0;
		try
			up := TUClass(data).parent;
			idata.itype := ini.ReadString('titels', 'Variables', 'Variables');
			while ((up <> nil) and (cnt < MaxInherit)) do begin
				if (not IgnoreComment(up.comment)) then begin
					template.Position := 0;
					idata.uclass := up;
					if (VarCache.Exists(up.FullName)) then begin
						idata.items := VarCache[up.FullName];
					end
					else begin
						tmp := '';
						up.properties.Sort;
						for i := 0 to up.properties.Count-1 do begin
							// ignore const when comment = @ignore
							if (not IgnoreComment(up.properties[i].comment)) then begin
								if (i > 0) then tmp := tmp+', ';
								tmp := tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(up)+'#'+up.properties[i].name+'">'+up.properties[i].name+'</a>';
							end;
						end;
						if (tmp = '') then tmp := '-';
						VarCache[up.FullName] := tmp;
						idata.items := tmp;
					end;
					if (idata.items <> '-') then parseTemplate(template, target, replaceInherited, idata);
				end;
				up := up.parent;
				Inc(cnt);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			idata.Free;
			template.Free;
			target.Free;
		end;
	end
	// enums
	else if (IsReplacement(replacement, 'class_block_enum')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			up := TUClass(data);
			cnt := -1;
			result := false;
			i := ini.ReadInteger('InheritCheck', replacement, 0);
			if (i = -1) then i := MaxInherit;
			while ((up <> nil) and (cnt < i)) do begin
				if (up.enums.Count > 0) then begin
					result := true;
					break;
				end;
				up := up.parent;
				Inc(cnt);
			end;
			if (result) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_enum')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUClass(data).enums.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).enums[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassEnum, TUClass(data).enums[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'inherited_entries_enum')) then begin
		template := TFileStream.Create(templatedir+'class_entry_inherited.html', fmOpenRead);
		target := TStringStream.Create('');
		idata := TInheritenceData.Create;
		replacement := '';
		cnt := 0;
		try
			up := TUClass(data).parent;
			idata.itype := ini.ReadString('titels', 'Enumerations', 'Enumerations');
			while ((up <> nil) and (cnt < MaxInherit)) do begin
				if (not IgnoreComment(up.comment)) then begin
					template.Position := 0;
					idata.uclass := up;
					if (EnumCache.Exists(up.FullName)) then begin
						idata.items := EnumCache[up.FullName];
					end
					else begin
						tmp := '';
						for i := 0 to up.enums.Count-1 do begin
							// ignore const when comment = @ignore
							if (not IgnoreComment(up.enums[i].comment)) then begin
								if (i > 0) then tmp := tmp+', ';
								tmp := tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(up)+'#'+up.enums[i].name+'">'+up.enums[i].name+'</a>';
							end;
						end;
						if (tmp = '') then tmp := '-';
						EnumCache[up.FullName] := tmp;
						idata.items := tmp;
					end;
					if (idata.items <> '-') then parseTemplate(template, target, replaceInherited, idata);
				end;
				up := up.parent;
				Inc(cnt);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			idata.Free;
			template.Free;
			target.Free;
		end;
	end
	// struct
	else if (IsReplacement(replacement, 'class_block_struct')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			up := TUClass(data);
			cnt := -1;
			result := false;
			i := ini.ReadInteger('InheritCheck', replacement, 0);
			if (i = -1) then i := MaxInherit;
			while ((up <> nil) and (cnt < i)) do begin
				if (up.structs.Count > 0) then begin
					result := true;
					break;
				end;
				up := up.parent;
				Inc(cnt);
			end;
			if (result) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_struct')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUClass(data).structs.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).structs[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassStruct, TUClass(data).structs[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'inherited_entries_struct')) then begin
		template := TFileStream.Create(templatedir+'class_entry_inherited.html', fmOpenRead);
		target := TStringStream.Create('');
		idata := TInheritenceData.Create;
		replacement := '';
		cnt := 0;
		try
			up := TUClass(data).parent;
			idata.itype := ini.ReadString('titels', 'Structures', 'Structures');
			while ((up <> nil) and (cnt < MaxInherit)) do begin
				if (not IgnoreComment(up.comment)) then begin
					template.Position := 0;
					idata.uclass := up;
					if (StructCache.Exists(up.FullName)) then begin
						idata.items := StructCache[up.FullName];
					end
					else begin
						tmp := '';
						for i := 0 to up.structs.Count-1 do begin
							// ignore const when comment = @ignore
							if (not IgnoreComment(up.structs[i].comment)) then begin
								if (i > 0) then tmp := tmp+', ';
								tmp := tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(up)+'#'+up.structs[i].name+'">'+up.structs[i].name+'</a>';
							end;
						end;
						if (tmp = '') then tmp := '-';
						StructCache[up.FullName] := tmp;
						idata.items := tmp;
					end;
					if (idata.items <> '-') then parseTemplate(template, target, replaceInherited, idata);
				end;
				up := up.parent;
				Inc(cnt);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			idata.Free;
			template.Free;
			target.Free;
		end;
	end
	// delegates
	else if (IsReplacement(replacement, 'class_block_delegate')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			up := TUClass(data);
			cnt := -1;
			result := false;
			i := ini.ReadInteger('InheritCheck', replacement, 0);
			if (i = -1) then i := MaxInherit;
			while ((up <> nil) and (cnt < i)) do begin
				if (up.delegates.Count > 0) then begin
					result := true;
					break;
				end;
				up := up.parent;
				Inc(cnt);
			end;
			if (result) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_delegate')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUClass(data).delegates.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).delegates[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassFunction, TUClass(data).delegates[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'inherited_entries_delegate')) then begin
		template := TFileStream.Create(templatedir+'class_entry_inherited.html', fmOpenRead);
		target := TStringStream.Create('');
		idata := TInheritenceData.Create;
		replacement := '';
		cnt := 0;
		try
			up := TUClass(data).parent;
			idata.itype := ini.ReadString('titels', 'Delegates', 'Delegates');
			while ((up <> nil) and (cnt < MaxInherit)) do begin
				if (not IgnoreComment(up.comment)) then begin
					template.Position := 0;
					idata.uclass := up;
					if (DelegateCache.Exists(up.FullName)) then begin
						idata.items := DelegateCache[up.FullName];
					end
					else begin
						tmp := '';
						last := '';
						for i := 0 to up.delegates.Count-1 do begin
							if (CompareText(last, up.delegates[i].name) = 0) then continue;
							last := up.delegates[i].name;
							// ignore const when comment = @ignore
							if (not IgnoreComment(up.delegates[i].comment)) then begin
								if (i > 0) then tmp := tmp+', ';
								tmp := tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(up)+'#'+HTMLChars(up.delegates[i].name)+'">'+HTMLChars(up.delegates[i].name)+'</a>';
							end;
						end;
						if (tmp = '') then tmp := '-';
						DelegateCache[up.FullName] := tmp;
						idata.items := tmp;
					end;
					if (idata.items <> '-') then parseTemplate(template, target, replaceInherited, idata);
				end;
				up := up.parent;
				Inc(cnt);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			idata.Free;
			template.Free;
			target.Free;
		end;
	end
	// function
	else if (IsReplacement(replacement, 'class_block_function')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			up := TUClass(data);
			cnt := -1;
			result := false;
			i := ini.ReadInteger('InheritCheck', replacement, 0);
			if (i = -1) then i := MaxInherit;
			while ((up <> nil) and (cnt < i)) do begin
				if (up.functions.Count > 0) then begin
					result := true;
					break;
				end;
				up := up.parent;
				Inc(cnt);
			end;
			if (result) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_function')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUClass(data).functions.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).functions[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassFunction, TUClass(data).functions[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'inherited_entries_function')) then begin
		template := TFileStream.Create(templatedir+'class_entry_inherited.html', fmOpenRead);
		target := TStringStream.Create('');
		idata := TInheritenceData.Create;
		replacement := '';
		cnt := 0;
		try
			up := TUClass(data).parent;
			idata.itype := ini.ReadString('titels', 'Functions', 'Functions');
			while ((up <> nil) and (cnt < MaxInherit)) do begin
				if (not IgnoreComment(up.comment)) then begin
					template.Position := 0;
					idata.uclass := up;
					if (FunctionCache.Exists(up.FullName)) then begin
						idata.items := FunctionCache[up.FullName];
					end
					else begin
						tmp := '';
						last := '';
						for i := 0 to up.functions.Count-1 do begin
							if (CompareText(last, up.functions[i].name) = 0) then continue;
							last := up.functions[i].name;
							// ignore const when comment = @ignore
							if (not IgnoreComment(up.functions[i].comment)) then begin
								if (i > 0) then tmp := tmp+', ';
								tmp := tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(up)+'#'+HTMLChars(up.functions[i].name)+'">'+HTMLChars(up.functions[i].name)+'</a>';
							end;
						end;
						if (tmp = '') then tmp := '-';
						FunctionCache[up.FullName] := tmp;
						idata.items := tmp;
					end;
					if (idata.items <> '-') then parseTemplate(template, target, replaceInherited, idata);
				end;
				up := up.parent;
				Inc(cnt);
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			idata.Free;
			template.Free;
			target.Free;
		end;
	end
	// states
	else if (IsReplacement(replacement, 'class_block_state')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			if (TUClass(data).states.Count > 0) then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'class_entry_state')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			for i := 0 to TUClass(data).states.Count-1 do begin
				// ignore const when comment = @ignore
				if (not IgnoreComment(TUClass(data).states[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassState, TUClass(data).states[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	// defaultprops
	else if (IsReplacement(replacement, 'class_block_defaultproperties')) then begin
		template := TFileStream.Create(templatedir+LowerCase(replacement)+'.html', fmOpenRead);
		target := TStringStream.Create('');
		try
			if (TUClass(data).defaultproperties <> '') then begin
				parseTemplate(template, target, replaceClass, data);
				replacement := target.DataString;
			end
			else replacement := '';
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end;
	unguard;
end;

function THTMLOutput.replaceClassConst(var replacement: string; data: TObject = nil): boolean;
var
	source, target: TStringStream;
begin
	guard('replaceClassConst '+replacement+' '+TUConst(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'const_name') = 0) then begin
		replacement := TUConst(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'const_value') = 0) then begin
		replacement := TUConst(data).value;
		result := true;
	end
	else if (CompareText(replacement, 'const_srcline') = 0) then begin
		replacement := IntToStr(TUConst(data).srcline);
		result := true;
	end
	else if (CompareText(replacement, 'const_comment') = 0) then begin
		replacement := CommentPreprocessor(TUConst(data).comment);
		result := true;
	end
	else if (CompareText(replacement, 'const_declaration') = 0) then begin
		source := TStringStream.Create('const '+TUConst(data).name+' = '+TUConst(data).value+';');
		target := TStringStream.Create('');
		try
			parseCode(source, target, true, true, true);
			replacement := target.DataString;
			result := true;
		finally
			target.Free;
			source.Free;
		end;
	end
	else if (CompareText(replacement, 'has_comment_?') = 0) then begin
		if (TUConst(data).comment <> '') then replacement := ini.ReadString('titles', 'HasCommentValue', '')
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(currentClass);
		result := true;
	end;
	unguard;
end;

function THTMLOutput.replaceClassVar(var replacement: string; data: TObject = nil): boolean;
var
	source,target: 	TStringStream;
	tmp: 			string;
begin
	guard('replaceClassVar '+replacement+' '+TUProperty(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'var_name') = 0) then begin
		replacement := TUProperty(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'var_type') = 0) then begin
		replacement := GetTypeLink(TUProperty(data).ptype);
		result := true;
	end
	else if (CompareText(replacement, 'var_type_plain') = 0) then begin
		replacement := TUProperty(data).ptype;
		result := true;
	end
	else if (CompareText(replacement, 'var_modifiers') = 0) then begin
		replacement := TUProperty(data).modifiers;
		result := true;
	end
	else if (CompareText(replacement, 'var_tag') = 0) then begin
		replacement := TUProperty(data).tag;
		result := true;
	end
	else if (CompareText(replacement, 'var_srcline') = 0) then begin
		replacement := IntToStr(TUProperty(data).srcline);
		result := true;
	end
	else if (CompareText(replacement, 'var_comment') = 0) then begin
		replacement := CommentPreprocessor(TUProperty(data).comment);
		result := true;
	end
	else if (CompareText(replacement, 'var_declaration') = 0) then begin
		tmp := 'var';
		if (TUProperty(data).tag <> '') then tmp := tmp+'('+TUProperty(data).tag+')';
		if (TUProperty(data).modifiers <> '') then tmp := tmp+' '+TUProperty(data).modifiers;
		tmp := tmp+' '+TUProperty(data).ptype+' '+TUProperty(data).name+';';
		source := TStringStream.Create(tmp);
		target := TStringStream.Create('');
		try
			parseCode(source, target, true, true, true);
			replacement := target.DataString;
			result := true;
		finally
			target.Free;
			source.Free;
		end;
	end
	else if (CompareText(replacement, 'has_comment_?') = 0) then begin
		if (TUProperty(data).comment <> '') then replacement := ini.ReadString('titles', 'HasCommentValue', '')
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(currentClass);
		result := true;
	end;
	unguard;
end;

function THTMLOutput.replaceVarTag(var replacement: string; data: TObject = nil): boolean;
begin
	result := false;
	if (CompareText(replacement, 'tag_name') = 0) then begin
		replacement := TUProperty(data).tag;
		result := true;
	end
end;

function THTMLOutput.replaceClassEnum(var replacement: string; data: TObject = nil): boolean;
var
	source,target: TStringStream;
begin
	guard('replaceClassEnum '+replacement+' '+TUEnum(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'enum_name') = 0) then begin
		replacement := TUEnum(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'enum_options') = 0) then begin
		replacement := TUEnum(data).options;
		result := true;
	end
	else if (CompareText(replacement, 'enum_options_newline') = 0) then begin
		replacement := StringReplace(TUEnum(data).options, ',', ','+#10, [rfReplaceAll]);
		result := true;
	end
	else if (CompareText(replacement, 'enum_options_break') = 0) then begin
		replacement := StringReplace(TUEnum(data).options, ',', ',<br />', [rfReplaceAll]);
		result := true;
	end
	else if (CompareText(replacement, 'enum_srcline') = 0) then begin
		replacement := IntToStr(TUEnum(data).srcline);
		result := true;
	end
	else if (CompareText(replacement, 'enum_comment') = 0) then begin
		replacement := CommentPreprocessor(TUEnum(data).comment);
		result := true;
	end
	else if (CompareText(replacement, 'enum_declaration') = 0) then begin
		source := TStringStream.Create('enum '+TUEnum(data).name);
		target := TStringStream.Create('');
		try
			parseCode(source, target, true, true, true);
			replacement := target.DataString;
			result := true;
		finally
			target.Free;
			source.Free;
		end;
	end
	else if (CompareText(replacement, 'has_comment_?') = 0) then begin
		if (TUEnum(data).comment <> '') then replacement := ini.ReadString('titles', 'HasCommentValue', '')
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(currentClass);
		result := true;
	end;
	unguard;
end;

function THTMLOutput.replaceClassStruct(var replacement: string; data: TObject = nil): boolean;
var
	i: 			integer;
	template: 	TFileStream;
	source,
    target: 	TStringStream;
	tmp: 		string;
begin
	guard('replaceClassStruct '+replacement+' '+TUStruct(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'struct_name') = 0) then begin
		replacement := TUStruct(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'struct_extends_plain') = 0) then begin
		replacement := TUStruct(data).parent;
		result := true;
	end
	else if (CompareText(replacement, 'struct_extends_link') = 0) then begin
		replacement := GetTypeLink(TUStruct(data).parent);
		result := true;
	end
	else if (CompareText(replacement, 'struct_extends_label') = 0) then begin
		if (TUStruct(data).parent <> '') then replacement := 'extends'
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'struct_modifiers') = 0) then begin
		replacement := TUStruct(data).modifiers;
		result := true;
	end
	else if (CompareText(replacement, 'struct_srcline') = 0) then begin
		replacement := IntToStr(TUStruct(data).srcline);
		result := true;
	end
	else if (CompareText(replacement, 'struct_comment') = 0) then begin
		replacement := CommentPreprocessor(TUStruct(data).comment);
		result := true;
	end
	else if (CompareText(replacement, 'struct_properties_newline') = 0) then begin
		replacement := '';
		for i := 0 to TUStruct(data).properties.Count-1 do begin
			if (replacement <> '') then replacement := replacement+', ';
			replacement := replacement+TUStruct(data).properties[i].name;
		end;
		result := true;
	end
	else if (CompareText(replacement, 'struct_properties_break') = 0) then begin
		replacement := '';
		for i := 0 to TUStruct(data).properties.Count-1 do begin
			if (replacement <> '') then replacement := replacement+'<br />';
			replacement := replacement+TUStruct(data).properties[i].name;
		end;
		result := true;
	end
	else if (IsReplacement(replacement, 'struct_properties_detail')) then begin
		template := TFileStream.Create(templatedir+replacement+'.html', fmOpenRead);
		target := TStringStream.Create('');
		TUStruct(data).properties.Sort;
		try
			for i := 0 to TUStruct(data).properties.Count-1 do begin
				// ignore var when comment = @ignore
				if (not IgnoreComment(TUStruct(data).properties[i].comment)) then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassVar, TUStruct(data).properties[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (IsReplacement(replacement, 'struct_declaration')) then begin
		tmp := 'struct';
		if (TUStruct(data).modifiers <> '') then tmp := tmp+' '+TUStruct(data).modifiers;
		tmp := tmp+' '+TUStruct(data).name;
		if (TUStruct(data).parent <> '') then tmp := tmp+' extends '+TUStruct(data).parent;
		source := TStringStream.Create(tmp);
		target := TStringStream.Create('');
		try
			parseCode(source, target, true, true, true);
			replacement := target.DataString;
			result := true;
		finally
			target.Free;
			source.Free;
		end;
	end
	// same as above except only vars _with_ comments
	else if (IsReplacement(replacement, 'struct_properties_comment')) then begin
		template := TFileStream.Create(templatedir+replacement+'.html', fmOpenRead);
		target := TStringStream.Create('');
		TUStruct(data).properties.Sort;
		try
			for i := 0 to TUStruct(data).properties.Count-1 do begin
				// ignore var when comment = @ignore
				if ((not IgnoreComment(TUStruct(data).properties[i].comment)) and
					(TUStruct(data).properties[i].comment <> ''))then begin
					template.Position := 0;
					parseTemplate(template, target, replaceClassVar, TUStruct(data).properties[i]);
				end;
				if (Self.Terminated) then break;
			end;
			replacement := target.DataString;
			result := true;
		finally
			template.Free;
			target.Free;
		end;
	end
	else if (CompareText(replacement, 'has_comment_?') = 0) then begin
		if (TUStruct(data).comment <> '') then replacement := ini.ReadString('titles', 'HasCommentValue', '')
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(currentClass);
		result := true;
	end;
	unguard;
end;

function THTMLOutput.replaceClassFunction(var replacement: string; data: TObject = nil): boolean;
var
	source,
    target: 	TStringStream;
	tmp,
    tmp2,
    tmp3: 		string;
	i, j: 		integer;
	pclass: 	TUClass;
begin
	guard('replaceClassFunction '+replacement+' '+TUFunction(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'function_name') = 0) then begin
		replacement := HTMLChars(TUFunction(data).name);
		result := true;
	end
	else if (CompareText(replacement, 'function_type') = 0) then begin
		replacement := functionTypeToString(TUFunction(data).ftype);
		result := true;
	end
	else if (CompareText(replacement, 'function_type_image') = 0) then begin
		case TUFunction(data).ftype of
			uftFunction:			replacement := StrRepeat('../', subDirDepth)+ini.ReadString('FunctionTypeImages','function','');
			uftEvent:				 replacement := StrRepeat('../', subDirDepth)+ini.ReadString('FunctionTypeImages','event','');
			uftOperator:			replacement := StrRepeat('../', subDirDepth)+ini.ReadString('FunctionTypeImages','operator','');
			uftPreOperator:	 replacement := StrRepeat('../', subDirDepth)+ini.ReadString('FunctionTypeImages','preoperator','');
			uftPostOperator:	replacement := StrRepeat('../', subDirDepth)+ini.ReadString('FunctionTypeImages','postoperator','');
			uftDelegate:			replacement := StrRepeat('../', subDirDepth)+ini.ReadString('FunctionTypeImages','delegate','');
		end;
		result := true;
	end
	else if (CompareText(replacement, 'function_return') = 0) then begin
		replacement := GetTypeLink(TUFunction(data).return);
		result := true;
	end
	else if (CompareText(replacement, 'function_return_plain') = 0) then begin
		replacement := TUFunction(data).return;
		result := true;
	end
	else if (CompareText(replacement, 'function_params') = 0) then begin
		replacement := '';
		tmp := TUFunction(data).params;
		while (tmp <> '') do begin
			if (replacement <> '') then replacement := replacement+', ';
			i := Pos(',', tmp);
			if (i = 0) then i := Length(tmp)+1;
			tmp2 := trim(Copy(tmp, 1, i-1));
			Delete(tmp, 1, i+1);
			i := LastDelimiter(' ', tmp2);
			tmp3 := Copy(tmp2, i, MaxInt); // param name
			Delete(tmp2, i, MaxInt);
			i := LastDelimiter(' ', tmp2); // type
			replacement := replacement+Copy(tmp2, 1, i)+GetTypeLink(Copy(tmp2, i+1, MaxInt))+tmp3;
		end;
		result := true;
	end
	else if (CompareText(replacement, 'function_params_plain') = 0) then begin
		replacement := HTMLChars(TUFunction(data).params);
		result := true;
	end
	else if (CompareText(replacement, 'function_modifiers') = 0) then begin
		replacement := TUFunction(data).modifiers;
		result := true;
	end
	else if (CompareText(replacement, 'function_state') = 0) then begin
		if (TUFunction(data).state <> nil) then replacement := TUFunction(data).state.name
			else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'function_srcline') = 0) then begin
		replacement := IntToStr(TUFunction(data).srcline);
		result := true;
	end
	else if (CompareText(replacement, 'function_comment') = 0) then begin
		replacement := CommentPreprocessor(TUFunction(data).comment);
		result := true;
	end
	else if (CompareText(replacement, 'function_declaration') = 0) then begin
		tmp := '';
		if (TUFunction(data).modifiers <> '') then tmp := tmp+TUFunction(data).modifiers;
		if (tmp <> '') then tmp := tmp+' ';
		tmp := functionTypeToString(TUFunction(data).ftype);
		if (TUFunction(data).return <> '') then tmp := tmp+' '+TUFunction(data).return;
		tmp := tmp+' '+TUFunction(data).name+' ('+TUFunction(data).params+')';
		source := TStringStream.Create(tmp);
		target := TStringStream.Create('');
		try
			parseCode(source, target, true, true, true);
			replacement := target.DataString;
			result := true;
		finally
			target.Free;
			source.Free;
		end;
	end
	else if (CompareText(replacement, 'function_init') = 0) then begin
		replacement := '';
		pclass := currentClass.parent;
		while (pclass <> nil) do begin
			for i := 0 to pclass.functions.Count-1 do begin
				j := CompareText(pclass.functions[i].name, TUFunction(data).name);
				if (j = 0) then begin
					replacement := '<a href="'+StrRepeat('../', subDirDepth)+ClassLink(pclass)+'#'+TUFunction(data).name+'">'+ini.ReadString('titles', 'FunctionInit', 'i')+'</a>';
					break;
				end;
				if (j > 0) then break; // current function is greater than the compare one, break
			end;
			pclass := pclass.parent;
		end;
		result := true;
	end
	else if (CompareText(replacement, 'has_comment_?') = 0) then begin
		if (TUFunction(data).comment <> '') then replacement := ini.ReadString('titles', 'HasCommentValue', '?')
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(currentClass);
		result := true;
	end;
	unguard;
end;

function THTMLOutput.replaceClassState(var replacement: string; data: TObject = nil): boolean;
var
	i: integer;
begin
	guard('replaceClassState '+replacement+' '+TUState(data).name);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'state_name') = 0) then begin
		replacement := TUState(data).name;
		result := true;
	end
	else if (CompareText(replacement, 'state_extends') = 0) then begin
		replacement := TUState(data).extends;
		result := true;
	end
	else if (CompareText(replacement, 'state_extends_label') = 0) then begin
		if (TUState(data).extends <> '') then replacement := 'extends'
		else replacement := '';
		result := true;
	end
	else if (CompareText(replacement, 'state_modifiers') = 0) then begin
		replacement := TUState(data).modifiers;
		result := true;
	end
	else if (CompareText(replacement, 'state_comment') = 0) then begin
		replacement := TUState(data).comment;
		result := true;
	end
	else if (CompareText(replacement, 'state_srcline') = 0) then begin
		replacement := IntToStr(TUState(data).srcline);
		result := true;
	end
	else if (CompareText(replacement, 'class_source') = 0) then begin
		replacement := StrRepeat('../', subDirDepth)+SOURCEPRE+ClassLink(currentClass);
		result := true;
	end
	else if (CompareText(replacement, 'state_functions') = 0) then begin
		replacement := '';
		TUState(data).functions.Sort;
		for i := 0 to TUState(data).functions.Count-1 do begin
			if (replacement <> '') then replacement := replacement+', ';
			replacement := replacement+'<a href="#_'+TUState(data).functions[i].name+'+'+TUState(data).name+'">'+TUState(data).functions[i].name+'</a>';
		end;
		result := true;
	end;
	unguard;
end;

function THTMLOutput.replaceInherited(var replacement: string; data: TObject = nil): boolean;
begin
	result := replaceClass(replacement, TInheritenceData(data).uclass);
	if (result) then exit;
	if (CompareText(replacement, 'inherited_type') = 0) then begin
		replacement := TInheritenceData(data).itype;
		result := true;
	end
	else if (CompareText(replacement, 'inherited_items') = 0) then begin
		replacement := TInheritenceData(data).items;
		result := true;
	end
end;

function THTMLOutput.GetTypeLink(name: string): string;
var
	tname: 	string;
	i, j: 	integer;
	uclass: TUClass;
begin
	name := Trim(name);
	if (name = '') then exit;
	guard('GetTypeLink '+name);
	i := Pos('<', name);
	if (i > 0) then begin
		tname := Copy(name, 1, i-1);
		result := tname+'&lt;'+GetTypeLink(Copy(name,i+1, Length(name)-i-1))+'&gt;';
		unguard;
		exit;
	end;

	// Class.type
	i := Pos('.', name);
	if (i > 0) then begin
		if (TypeCache.Exists(name)) then begin
			result := TypeCache.Items[name];
		end
		else begin
			uclass := nil;
			tname := Copy(name, 1, i-1);
			// search in package
			for j := 0 to currentClass.package.classes.Count-1 do begin
				if (CompareText(currentClass.package.classes[j].name, tname) = 0) then begin
					uclass := currentClass.package.classes[j];
					break;
				end;
			end;
			// search in parent classes
			if (uclass = nil) then begin
				uclass := currentClass;
				while (uclass <> nil) do begin
					if (CompareText(uclass.name, tname) = 0) then break;
					uclass := uclass.parent;
				end;
			end;
			// if we found a class
			if (uclass <> nil) then begin
				result := TypeLink(Copy(name,i+1, MaxInt), uclass);
				if (result <> '') then TypeCache.Items[name] := result;
			end;
		end;
		if (result <> '') then result := '<a href="'+StrRepeat('../', subDirDepth)+result+'">'+HTMLChars(name)+'</a>'
		else result := HTMLChars(name);
		unguard;
		exit;
	end;

	tname := LowerCase(name);
	if (not TypeCache.Exists(tname)) then begin
		result := TypeLink(name, currentClass);
		if (result = '') then result := '-';
		TypeCache.Items[tname] := result;
	end
	else result := TypeCache.Items[tname];
	if (result = '-') then result := HTMLChars(name)
	else result := '<a href="'+StrRepeat('../', subDirDepth)+result+'">'+HTMLChars(name)+'</a>';
	unguard;
end;

function THTMLOutput.TypeLink(name: string; uclass: TUClass): string;
var
	i: integer;
begin
	for i := 0 to uclass.enums.Count-1 do begin
		if (CompareText(uclass.enums[i].name, name) = 0) then begin
			result := ClassLink(uclass)+'#'+uclass.enums[i].name;
			exit;
		end;
	end;
	for i := 0 to uclass.structs.Count-1 do begin
		if (CompareText(uclass.structs[i].name, name) = 0) then begin
			result := ClassLink(uclass)+'#'+uclass.structs[i].name;
			exit;
		end;
	end;
	if (uclass.parent <> nil) then begin
		result := TypeLink(name, uclass.parent);
	end;
end;

procedure THTMLOutput.CopyFiles;
var
	tmp: 	string;
	sl: 	TStringList;
	i: 		integer;
begin
	guard('CopyFiles');
	sl := TStringList.Create;
	try
		ini.ReadSectionValues('CopyFiles', sl);
		for i := 0 to sl.Count-1 do begin
			tmp := sl[i];
			Delete(tmp, 1, Pos('=', tmp));
			Log('Copy template file '+tmp);
			CopyFile(TemplateDir+tmp, HTMLOutputDir+PATHDELIM+tmp);
		end;
	finally
		sl.Free;
	end;
	unguard;
end;

procedure THTMLOutput.htmlTree;
var
	template, target: TFileStream;
begin
	guard('htmlTree');
	Status('Creating '+classtree_filename+TargetExtention);
	template := TFileStream.Create(templatedir+'classtree.html', fmOpenRead or fmShareDenyWrite);
	target := TFileStream.Create(htmloutputdir+PATHDELIM+classtree_filename+TargetExtention, fmCreate);
	try
		parseTemplate(template, target, replaceClasstree);
	finally
		template.Free;
		target.Free;
	end;
	unguard;
end;

procedure THTMLOutput.ProcTreeNode(var replacement: string; uclass: TUClass; basestring: string);
var
	i: 		integer;
	tmp: 	string;
begin
	// ignore class when comment = @ignore
	if (IgnoreComment(uclass.comment)) then exit; 
	guard('ProcTreeNode '+uclass.Name);
	Status('Creating '+classtree_filename+TargetExtention+' class: '+uclass.Name);
	for i := 0 to uclass.children.Count-1 do begin
		if (i < uclass.children.Count-1) then tmp := TreeT else tmp := TreeL;
		replacement := replacement+basestring+tmp+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(uclass.children[i])+'" name="'+uclass.children[i].name+'">'+uclass.children[i].name+'</a>'+#13#10;
		if (i < uclass.children.Count-1)
			then ProcTreeNode(replacement, uclass.children[i], basestring+TreeI)
			else ProcTreeNode(replacement, uclass.children[i], basestring+TreeNone);
	end;
	unguard;
end;

function THTMLOutput.replaceClasstree(var replacement: string; data: TObject = nil): boolean;
var
	uclass: TUClass;
begin
	guard('replaceClasstree '+replacement);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'classtree') = 0) then begin
		replacement := '';
		if (ClassList.Count > 0) then begin
			uclass := ClassList[0];
			while (uclass.parent <> nil) do uclass := uclass.parent;
			replacement := replacement+'<a href="'+StrRepeat('../', subDirDepth)+ClassLink(uclass)+'" name="'+uclass.name+'">'+uclass.name+'</a>'+#13#10;
			ProcTreeNode(replacement, uclass, '');
		end;
		result := true;
	end;
	unguard;
end;

function GlossaryListSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
	result := AnsiCompareText(List[index1], List[index2]);
	if (result = 0) then begin
		result := AnsiCompareText(TGlossaryItem(List.Objects[Index1]).classname, TGlossaryItem(List.Objects[Index2]).classname);
	end;
end;

procedure THTMLOutput.htmlGlossary;
var
	template,
    target: 	TFileStream;
	i,j: 		integer;
	gl: 		TStringList;
	gi, cgi: 	TGlossaryItem;
	gli: 		TGlossaryInfo;
const
	glossaryitems : array[0..25] of char = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
											'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
											'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
begin
	guard('htmlGlossary');
	Status('Creating glossay');
	template := TFileStream.Create(templatedir+'glossary.html', fmOpenRead or fmShareDenyWrite);
	gl := TStringList.Create;
	gli := TGlossaryInfo.Create;
	try
		// create table
		for i := 0 to ClassList.Count-1 do begin
			// ignore class when comment = @ignore
			if (IgnoreComment(classlist[i].comment)) then continue;
			gi := TGlossaryItem.Create;
			cgi := gi;
			gi.classname := classlist[i].name;
			gi.link := StrRepeat('../', subDirDepth)+ClassLink(classlist[i]);
			gl.AddObject(classlist[i].name, gi);
			for j := 0 to ClassList[i].consts.Count-1 do begin
				// ignore class when comment = @ignore
				if (IgnoreComment(ClassList[i].consts[j].comment)) then continue;
				gi := TGlossaryItem.Create;
				gi.classname := cgi.classname;
				gi.link := cgi.link+'#'+classlist[i].consts[j].name;
				gl.AddObject(classlist[i].consts[j].name, gi);
			end;
			for j := 0 to ClassList[i].properties.Count-1 do begin
				// ignore class when comment = @ignore
				if (IgnoreComment(ClassList[i].properties[j].comment)) then continue;
				gi := TGlossaryItem.Create;
				gi.classname := cgi.classname;
				gi.link := cgi.link+'#'+classlist[i].properties[j].name;
				gl.AddObject(classlist[i].properties[j].name, gi);
			end;
			for j := 0 to ClassList[i].enums.Count-1 do begin
				// ignore class when comment = @ignore
				if (IgnoreComment(ClassList[i].enums[j].comment)) then continue;
				gi := TGlossaryItem.Create;
				gi.classname := cgi.classname;
				gi.link := cgi.link+'#'+classlist[i].enums[j].name;
				gl.AddObject(classlist[i].enums[j].name, gi);
			end;
			for j := 0 to ClassList[i].structs.Count-1 do begin
				// ignore class when comment = @ignore
				if (IgnoreComment(ClassList[i].structs[j].comment)) then continue;
				gi := TGlossaryItem.Create;
				gi.classname := cgi.classname;
				gi.link := cgi.link+'#'+classlist[i].structs[j].name;
				gl.AddObject(classlist[i].structs[j].name, gi);
			end;
			for j := 0 to ClassList[i].functions.Count-1 do begin
				// ignore class when comment = @ignore
				if (IgnoreComment(ClassList[i].functions[j].comment)) then continue;
				gi := TGlossaryItem.Create;
				gi.classname := cgi.classname;
				gi.link := cgi.link+'#'+classlist[i].functions[j].name;
				gl.AddObject(classlist[i].functions[j].name, gi);
			end;
			if (Self.Terminated) then break;
		end;
		gl.CustomSort(GlossaryListSort);
		// create table -- end
		gli.glossay := gl;
		for i := Low(glossaryitems) to high(glossaryitems) do begin
			if (Self.Terminated) then break;
			gli.item := glossaryitems[i];
			gli.next := glossaryitems[(i + 1) mod (high(glossaryitems) + 1)];
			gli.prev := glossaryitems[(i + high(glossaryitems)) mod (high(glossaryitems) + 1)];
			Status('Creating glossary_'+glossaryitems[i]+'.'+TargetExtention, round(curPos/maxPos*100));
			curPos := curPos+1;
			template.Position := 0;
			target := TFileStream.Create(htmloutputdir+PATHDELIM+'glossary_'+glossaryitems[i]+'.'+TargetExtention, fmCreate);
			try
				parseTemplate(template, target, replaceGlossary, gli);
			finally
				target.Free;
			end;
		end;
	finally
		gli.Free;
		gl.Free;
		template.Free;
	end;
	unguard;
end;

function THTMLOutput.replaceGlossary(var replacement: string; data: TObject = nil): boolean;
var
	i: 			integer;
	lastname: 	string;
	gl : 		TStringlist;
begin
	guard('replaceGlossary '+replacement+' '+TGlossaryInfo(data).item);
	result := replaceDefault(replacement);
	if (result) then else
	if (CompareText(replacement, 'glossary_item') = 0) then begin
		replacement := TGlossaryInfo(data).item;
		result := true;
	end
	else if (CompareText(replacement, 'glossary_items') = 0) then begin
		replacement := '';
		gl := TGlossaryInfo(data).glossay;
		i := 0;
		while ((i < gl.Count) and (UpperCase(gl[i][1]) <> TGlossaryInfo(data).item)) do Inc(i);
		while ((i < gl.Count) and (UpperCase(gl[i][1]) = TGlossaryInfo(data).item)) do begin
			if ((i < (gl.Count-1)) and (CompareText(lastname, gl[i]) <> 0)) then begin
				if (CompareText(gl[i+1], gl[i]) = 0) then begin
					replacement := replacement+gl[i]+'<br>'+#13#10;
					lastname := gl[i];
				end;
			end;
			if (CompareText(lastname, gl[i]) = 0) then begin
				replacement := replacement+GlossaryElipse+'<a href="'+TGlossaryItem(gl.Objects[i]).link+'">'+TGlossaryItem(gl.Objects[i]).classname+'</a><br>';
			end
			else begin
				replacement := replacement+'<a href="'+TGlossaryItem(gl.Objects[i]).link+'">'+gl[i]+'</a><br>'+#13#10;
			end;
			lastname := gl[i];
			TGlossaryItem(gl.Objects[i]).Free;
			Inc(i);
		end;
		result := true;
	end
	else if (CompareText(replacement, 'glossary_prev') = 0) then begin
		replacement := 'glossary_'+TGlossaryInfo(data).prev+'.'+TargetExtention;
		result := true;
	end
	else if (CompareText(replacement, 'glossary_next') = 0) then begin
		replacement := 'glossary_'+TGlossaryInfo(data).next+'.'+TargetExtention;
		result := true;
	end;
	unguard;
end;

function THTMLOutput.ProcComment(input: string): string;
var
	sl: 		TStringList;
	tmp: 		string;
	i: 			integer;
	hadblank: 	boolean;
begin
	guard('ProcComment');
	hadblank := false;
	sl := TStringList.Create;
	try
		sl.Text := input;
		for i := sl.Count-1 downto 0 do begin
			tmp := sl[i];
			// possible HRs: // -- ==
			Delete(tmp, 1, 2);
			if (Length(tmp) > 0) then begin
				while (tmp[1] = '/') do begin
					Delete(tmp, 1, 1);
					if (Length(tmp) = 0) then break;
				end;
			end;
			tmp := trim(tmp);
			if ((tmp <> '') and (ReverseString(tmp) = tmp)) then sl.Delete(i) // HR ignore
			else if (tmp = '') then begin
				if (hadblank) then sl.Delete(i)
				else begin
					hadblank := true;
					sl[i] := '<br />';
				end;
			end
			else begin
				hadblank := false;
				sl[i] := tmp;
				if (i < (sl.Count-1)) then sl[i] := sl[i]+'<br />';
			end;
		end;
		result := sl.Text;
	finally
		sl.Free;
	end;
	unguard;
end;

procedure THTMLOutput.SourceCode;
var
	fname: 		string;
	template1,
    template2,
    target,
    source: 	TFileStream;
	i: 			integer;
begin
	guard('SourceCode');
	template1 := TFileStream.Create(templatedir+'sourcecode-1.html', fmOpenRead or fmShareDenyWrite);
	template2 := TFileStream.Create(templatedir+'sourcecode-2.html', fmOpenRead or fmShareDenyWrite);
	try
		for i := 0 to ClassList.Count-1 do begin
			// ignore class when comment = @ignore
			fname := SOURCEPRE+ClassLink(ClassList[i], true);
			ForceDirectories(ExtractFilePath(htmloutputdir+PATHDELIM+fname));
			if (IgnoreComment(ClassList[i].comment)) then continue;
			Status('Creating source '+fname, round(curPos/maxPos*100));
			curPos := curPos+1;
			currentClass := ClassList[i];
			target := TFileStream.Create(htmloutputdir+PATHDELIM+fname, fmCreate);
			try
				template1.Position := 0;
				parseTemplate(template1, target, replaceClass, ClassList[i]);
				if (Self.Terminated) then break;
				if (not fileexists(ClassList[i].package.path+PATHDELIM+ClassList[i].filename)) then continue;
				source := TFileStream.Create(ClassList[i].package.path+PATHDELIM+ClassList[i].filename, fmOpenRead or fmShareDenyWrite);
				try
					parseCode(source, target);
				finally
					source.Free;
				end;
				if (Self.Terminated) then break;
				template2.Position := 0;
				parseTemplate(template2, target, replaceClass, ClassList[i]);
			finally
				target.Free;
			end;
		end;
	finally
		template1.Free;
		template2.Free;
	end;
	unguard;
end;

procedure THTMLOutput.parseCode(input, output: TStream; nolineno: boolean = false; notable: boolean = false; nopre: boolean = false);
var
	p: 				TSourceParser;
	replacement,
    tmp: 			string;
	ms: 			TMemoryStream;
	i: 				integer;
	incomment: 		boolean;
begin
	guard('parseCode');
	ms := TMemoryStream.Create;
	p := TSourceParser.Create(input, ms, false);
	try
		replacement := '';
		if (not nopre) then replacement := '<pre class="source">';
		if (not nolineno) then replacement := replacement+'<a name="'+IntToStr(p.SourceLine-1)+'"></a>';
		p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
		incomment := false;
		while (p.Token <> toEOF) do begin
			if (p.Token = toMCommentBegin) then begin
				replacement := '<font class="source_comment">'+p.TokenString; // cf2 = comment
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				incomment := true;
			end
			else if (p.Token = toMCommentEnd) then begin
				replacement := p.TokenString+'</font>'; // close it
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				incomment := false;
			end
			else if (incomment) then begin

				if (p.Token = toEOL) then begin
					if (nolineno) then replacement := p.TokenString
					else replacement := p.TokenString+'<a name="'+IntToStr(p.SourceLine)+'"></a>';
					p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				end
				else if (p.Token = #9) then begin
					// tabs to spaces
					if (TabsToSpaces >= 0) then begin
						i := TabsToSpaces - ((p.LinePos-1) mod TabsToSpaces);
						replacement := StrRepeat(' ', i);
			 		 	p.LinePos := p.LinePos+(i-1);
						p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
					end
					else p.CopyTokenToOutput;
				end
				else begin
					replacement := p.TokenString;
					replacement := StringReplace(replacement, '<', '&lt;', [rfReplaceAll]);
					replacement := StringReplace(replacement, '>', '&gt;', [rfReplaceAll]);
					p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				end;

			end
			else if (p.Token = '<') then begin
				replacement := '&lt;';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = '>') then begin
				replacement := '&gt;';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toString) then begin
				replacement := p.TokenString;
				replacement := StringReplace(replacement, '<', '&lt;', [rfReplaceAll]);
				replacement := StringReplace(replacement, '>', '&gt;', [rfReplaceAll]);
				replacement := '<font class="source_string">'+replacement+'</font>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toComment) then begin
				replacement := p.TokenString;
				replacement := StringReplace(replacement, '<', '&lt;', [rfReplaceAll]);
				replacement := StringReplace(replacement, '>', '&gt;', [rfReplaceAll]);
				replacement := '<font class="source_comment">'+replacement+'</font>';
				replacement := replacement+'<a name="'+IntToStr(p.SourceLine)+'"></a>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toInteger) then begin
				replacement := '<font class="source_int">'+p.TokenString+'</font>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toFloat) then begin
				replacement := '<font class="source_int">'+p.TokenString+'</font>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toName) then begin
				replacement := '<font class="source_name">'+p.TokenString+'</font>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toMacro) then begin
				replacement := p.TokenString;
				replacement := StringReplace(replacement, '<', '&lt;', [rfReplaceAll]);
				replacement := StringReplace(replacement, '>', '&gt;', [rfReplaceAll]);
				replacement := '<font class="source_macro">'+replacement+'</font>';
				replacement := replacement+'<a name="'+IntToStr(p.SourceLine)+'"></a>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toSymbol) then begin
				tmp := LowerCase(p.TokenString);
				replacement := p.TokenString;
				if (Keywords1.Exists(tmp)) then begin
					replacement := '<font class="source_keyword">'+replacement+'</font>';
				end
				else if (Keywords2.Exists(tmp)) then begin
					replacement := '<font class="source_keyword2">'+replacement+'</font>';
				end
				else if (TypeCache.Exists(tmp)) then begin
					if (TypeCache.Items[tmp] <> '-') then replacement := '<font class="source_type"><a href="'+StrRepeat('../', subDirDepth)+TypeCache.Items[tmp]+'" class="source">'+replacement+'</a></font>'
					else replacement := '<font class="source_type">'+replacement+'</font>';
				end;
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = toEOL) then begin
				if (nolineno) then replacement := p.TokenString
				else replacement := p.TokenString+'<a name="'+IntToStr(p.SourceLine)+'"></a>';
				p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
			end
			else if (p.Token = #9) then begin
				// tabs to spaces
				if (TabsToSpaces >= 0) then begin
					i := TabsToSpaces - ((p.LinePos-1) mod TabsToSpaces);
					replacement := StrRepeat(' ', i);
					p.LinePos := p.LinePos+(i-1);
					p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
				end
				else p.CopyTokenToOutput;
			end
			else p.CopyTokenToOutput;
			p.SkipToken(true);
		end;
		if (not nopre) then begin
			replacement := '</pre>';
			p.OutputStream.WriteBuffer(PChar(replacement)^, Length(replacement));
		end;

		// finalize
		if (not notable) then begin
			replacement := '<div class="source"><table class="source"><tr>';
			output.WriteBuffer(PChar(replacement)^, Length(replacement));
		end;
		if (not nolineno) then begin
			replacement := '<td class="source_lineno"><font class="source_lineno">';
			output.WriteBuffer(PChar(replacement)^, Length(replacement));
			for i := 1 to p.SourceLine do begin
				replacement := format('%.5d<br>'+#10, [i]);
				output.WriteBuffer(PChar(replacement)^, Length(replacement));
			end;
			replacement := '</font></td>';
			output.WriteBuffer(PChar(replacement)^, Length(replacement));
		end;
		if (not notable) then begin
			replacement := '<td class="source">';
			output.WriteBuffer(PChar(replacement)^, Length(replacement));
		end;
		ms.SaveToStream(output);
		if (not notable) then begin
			replacement := '</td></tr></table></div>';
			output.WriteBuffer(PChar(replacement)^, Length(replacement));
		end;
	finally
		p.Free;
		ms.Free;
	end;
	unguard;
end;

function Min(i,j: integer): integer;
begin
	if (i < j) then result := i
	else result := j;
end;

function THTMLOutput.CommentPreprocessor(input: string): string;
var
	i: 		integer;
	tmp: 	string;
begin
	if (input = '') then exit;
	if (IsCPP) then begin
		//Log('input: '+input);
		result := CPPPipe.Pipe(input);
		//Log('result: '+result);
		exit;
	end;
	guard('CommentPreprocessor');
	i := Pos('http://', LowerCase(input));
	while (i > 0) do begin
		// copy up to link
		result := result+Copy(input, 1, i-1);
		// check if already a link
		if ((CompareText(Copy(input, i-6, 5), 'href=') = 0) or
			(CompareText(Copy(input, i-1, 1), '>') = 0)) then begin
			// is a link
			result := result+Copy(input, i, i+7);
			Delete(input, 1, i+7);
		end
		else begin
			// delete up to location
			Delete(input, 1, i-1);
			i := pos('<br', input); // <br /> work around
			i := Min(pos(' ', input), i);
			i := Min(pos(#9, input), i);
			i := Min(pos(#13, input), i);
			i := Min(pos(#10, input), i);
			if (i = 0) then begin
				i := Length(input)+1;
			end;
			tmp := copy(input, 1, i-1);
			Delete(input, 1, i-1);
			result := result+'<a href="'+trim(tmp)+'" target="_blank">'+tmp+'</a>';
		end;
		i := Pos('http://', LowerCase(input));
	end;
	result := result+input;
	unguard;
end;

function THTMLOutput.GetPackage(curpack: TUPackage; offset: integer; wrap: boolean = true): TUPackage;
var
	i, j: integer;
begin
	result := nil;
	for i := 0 to PackageList.Count-1 do begin
		if (PackageList[i] = curpack) then begin
			j := i+offset;
			if (not wrap) then begin
				if ((j < 0) or (j > PackageList.Count)) then exit;
			end;
			j := j+PackageList.Count;
			result := PackageList[j mod PackageList.Count];
			exit;
		end;
	end;
end;

function THTMLOutput.GetClass(curclass: TUClass; offset: integer; wrap: boolean = true): TUClass;
var
	i, j: integer;
begin
	result := nil;
	for i := 0 to curclass.package.classes.Count-1 do begin
		if (curclass.package.classes[i] = curclass) then begin
			j := i+offset;
			if (not wrap) then begin
				if ((j < 0) or (j > curclass.package.classes.Count)) then exit;
			end;
			j := j+curclass.package.classes.Count;
			result := curclass.package.classes[j mod curclass.package.classes.Count];
			exit;
		end;
	end;
end;

{ THTMLOutput -- END }

end.
