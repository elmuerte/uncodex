unit unit_pseditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ToolWin, ComCtrls, ActnList, StdActns, Menus;

type
  Tfrm_PSEditor = class(TForm)
    mm_Editor: TMemo;
    lb_Output: TListBox;
    spl_Split: TSplitter;
    tb_PSBar: TToolBar;
    btn_Load: TToolButton;
    btn_Save: TToolButton;
    btn_Spl1: TToolButton;
    btn_Compile: TToolButton;
    btn_Run: TToolButton;
    al_PSEditor: TActionList;
    ac_Compile: TAction;
    ac_Run: TAction;
    btn_Spl2: TToolButton;
    btn_HTMLscript: TToolButton;
    sb_EditorBar: TStatusBar;
    btn_New: TToolButton;
    btn_Sep3: TToolButton;
    ac_New: TAction;
    EditSelectAll1: TEditSelectAll;
    od_Open: TOpenDialog;
    sd_Save: TSaveDialog;
    ac_Save: TAction;
    ac_Load: TAction;
    btn_Abort: TToolButton;
    ac_Abort: TAction;
    pm_Macros: TPopupMenu;
    N1: TMenuItem;
    procedure ac_CompileExecute(Sender: TObject);
    procedure ac_RunExecute(Sender: TObject);
    procedure mm_EditorChange(Sender: TObject);
    procedure mm_EditorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mm_EditorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ac_NewExecute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure ac_SaveExecute(Sender: TObject);
    procedure ac_LoadExecute(Sender: TObject);
    procedure ac_AbortExecute(Sender: TObject);
  private
    ScriptSaved: boolean;
    procedure ReopenFile(Sender: TObject);
  public
    function SaveFile: boolean;
  end;

var
  frm_PSEditor: Tfrm_PSEditor;

implementation

uses unit_main, unit_definitions;

{$R *.dfm}

function Tfrm_PSEditor.SaveFile: boolean;
begin
	sd_Save.FileName := sb_EditorBar.Panels[2].Text;
	result := sd_Save.Execute;
  if (result) then begin
    mm_Editor.Lines.SaveToFile(sd_Save.FileName);
  	sb_EditorBar.Panels[2].Text := sd_Save.FileName;
    sb_EditorBar.Panels[1].Text := '';
    ScriptSaved := true;
  end;
end;

procedure Tfrm_PSEditor.ReopenFile(Sender: TObject);
begin
  if (not (Sender is TMenuItem)) then exit;
  if (not FileExists(TMenuItem(Sender).Hint)) then exit;
  mm_Editor.Lines.LoadFromFile(TMenuItem(Sender).Hint);
  sb_EditorBar.Panels[2].Text := TMenuItem(Sender).Hint;
  ScriptSaved := true;
end;

procedure Tfrm_PSEditor.ac_CompileExecute(Sender: TObject);
var
	res: boolean;
  i: integer;
begin
  frm_UnCodeX.ps_Main.Script.Assign(mm_Editor.Lines);
  lb_Output.Items.Clear;
  res := frm_UnCodeX.ps_Main.Compile;
  for i := 0 to frm_UnCodeX.ps_Main.CompilerMessageCount-1 do begin
    lb_Output.Items.Add(frm_UnCodeX.ps_Main.CompilerMessages[i].MessageToString);
  end;
  if (not res) then begin
  	MessageBeep(MB_ICONHAND);
    lb_Output.Items.Add('Compile failed!');
  end
  else begin
  	MessageBeep(MB_ICONEXCLAMATION);
  	lb_Output.Items.Add('Compile succesfull');
  end;
  ac_Run.Enabled := res;
end;

procedure Tfrm_PSEditor.ac_RunExecute(Sender: TObject);
var
	t: Cardinal;
begin
	lb_Output.Items.Clear;
  lb_Output.Items.Add('Execution started');
  ac_Abort.Enabled := true;
  ac_Run.Enabled := false;
  t := GetTickCount;
	if (not frm_UnCodeX.ps_Main.Execute) then begin
    lb_Output.Items.Add(frm_UnCodeX.ps_Main.ExecErrorToString);
    lb_Output.Items.Add(format('Execution failed @ %d:%d', [frm_UnCodeX.ps_Main.ExecErrorRow, frm_UnCodeX.ps_Main.ExecErrorCol]));
  end
  else begin
		lb_Output.Items.Add(format('Execution finished in %f seconds', [(GetTickCount-t)/1000]));
  end;
  ac_Run.Enabled := true;
  ac_Abort.Enabled := false;
end;

procedure Tfrm_PSEditor.mm_EditorChange(Sender: TObject);
begin
  ac_Run.Enabled := false;
  ScriptSaved := false;
  sb_EditorBar.Panels[1].Text := 'changed';
end;

procedure Tfrm_PSEditor.mm_EditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
	row, col: integer;
begin
	row := SendMessage(mm_Editor.Handle, EM_LINEFROMCHAR, mm_Editor.SelStart, 0);
  col := mm_Editor.SelStart - SendMessage(mm_Editor.Handle, EM_LINEINDEX, SendMessage(mm_Editor.Handle, EM_LINEFROMCHAR, mm_Editor.SelStart, 0), 0);
  sb_EditorBar.Panels[0].Text := Format('%d:%d', [row+1, col+1]);
end;

procedure Tfrm_PSEditor.mm_EditorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
	row, col: integer;
begin
	row := SendMessage(mm_Editor.Handle, EM_LINEFROMCHAR, mm_Editor.SelStart, 0);
  col := mm_Editor.SelStart - SendMessage(mm_Editor.Handle, EM_LINEINDEX, SendMessage(mm_Editor.Handle, EM_LINEFROMCHAR, mm_Editor.SelStart, 0), 0);
  sb_EditorBar.Panels[0].Text := Format('%d:%d', [row+1, col+1]);
end;

procedure Tfrm_PSEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
	if (not ScriptSaved) then begin
		case MessageDlg('The current script has not been saved.'+#13+#10+'Do you want to save it now?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    	mrYes:		CanClose := SaveFile;
	    mrNo:   	CanClose := true;
  	  mrCancel: CanClose := false;
	  end;
  end;
end;

procedure Tfrm_PSEditor.FormCreate(Sender: TObject);
var
	sl: TStringList;
  i: integer;
  mi: TMenuItem;
begin
	ScriptSaved := true;
  sd_Save.InitialDir := ExtractFilePath(ParamStr(0));
  od_Open.InitialDir := ExtractFilePath(ParamStr(0));
  sl := TStringList.Create;
  try
	  if (GetFiles(ExtractFilePath(ParamStr(0))+'*.ups', faAnyfile, sl)) then begin
    	sl.Sort;
  		for i := 0 to sl.count-1 do begin
	  	  mi := TMenuItem.Create(pm_Macros);
	  	  mi.Caption := ExtractFilename(sl[i]);
  	  	mi.Hint := sl[i];
        mi.OnClick := ReopenFile;
        n1.Parent.Add(mi);
    	end;
	  end;
  finally
		sl.Free;
  end;
end;

procedure Tfrm_PSEditor.ac_NewExecute(Sender: TObject);
begin
	if (not ScriptSaved) then begin
  	case MessageDlg('The current script has not been saved.'+#13+#10+'Do you want to save it now?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    	mrYes:	begin
								if (SaveFile) then begin
                  mm_Editor.Lines.Clear;
	    	  				ScriptSaved := true;
                  sb_EditorBar.Panels[2].Text := 'untitled.ups';
                end;
      				end;
	    mrNo:   begin
		     				mm_Editor.Lines.Clear;
    	  				ScriptSaved := true;
                sb_EditorBar.Panels[2].Text := 'untitled.ups';
      				end;
	  end;
  end
  else begin
		mm_Editor.Lines.Clear;
		ScriptSaved := true;
    sb_EditorBar.Panels[2].Text := 'untitled.ups';
  end;
end;

procedure Tfrm_PSEditor.EditSelectAll1Execute(Sender: TObject);
begin
	mm_Editor.SelectAll;
end;

procedure Tfrm_PSEditor.ac_SaveExecute(Sender: TObject);
begin
	SaveFile;
end;

procedure Tfrm_PSEditor.ac_LoadExecute(Sender: TObject);
begin
	if (od_Open.Execute) then begin
    mm_Editor.Lines.LoadFromFile(od_Open.FileName);
    sb_EditorBar.Panels[2].Text := od_Open.FileName;
    ScriptSaved := true;
  end;
end;

procedure Tfrm_PSEditor.ac_AbortExecute(Sender: TObject);
begin
	if (frm_UnCodeX.ps_Main.Running) then begin
    ac_Abort.Enabled := false;
    frm_UnCodeX.ps_Main.Stop;
		lb_Output.Items.Add('Abort requested, waiting to finish...');
    exit;
  end;
end;

end.
