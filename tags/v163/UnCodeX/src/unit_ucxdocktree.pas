unit unit_ucxdocktree;

interface

uses
	Types, Controls, Messages, Windows;

type
	TOnChangeVisibility = procedure(client: TControl; visible: boolean; var CanChange: boolean) of object;

	TUCXDockTree = class(TDockTree)
  private
  	FOldWindowProc: TWndMethod;
  	procedure NewWindowProc(var Message: TMessage);
  public
  	constructor Create(DockSite: TWinControl); override;
    destructor Destroy; override;
  end;

var
	OnChangeVisibility: TOnChangeVisibility;

implementation

constructor TUCXDockTree.Create(DockSite: TWinControl);
begin
	inherited;
  FOldWindowProc := DockSite.WindowProc;
  DockSite.WindowProc := NewWindowProc;
end;

destructor TUCXDockTree.Destroy;
begin
  if @FOldWindowProc <> nil then
  begin
    DockSite.WindowProc := FOldWindowProc;
    FOldWindowProc := nil;
  end;
  inherited Destroy;
end;

procedure TUCXDockTree.NewWindowProc(var Message: TMessage);
var
	CanChange: boolean;
  P: TPoint;
  client: TControl;
  HitTestValue: Integer;
begin
	if (Message.Msg = CM_DOCKNOTIFICATION) then begin
  	with TCMDockNotification(Message) do begin
			if (NotifyRec.ClientMsg = CM_VISIBLECHANGED) then begin
        CanChange := true;
        if (Assigned(OnChangeVisibility)) then OnChangeVisibility(client, boolean(NotifyRec.MsgWParam) , CanChange);
        if (CanChange) then FOldWindowProc(Message)
        else Client.Visible := not boolean(NotifyRec.MsgWParam);
			end
    end;
  end
  // fix dragging
  else if (Message.Msg = WM_LBUTTONDOWN) then begin
    P := SmallPointToPoint(TWMMouse(Message).Pos);
    client := HitTest(P, HitTestValue);
    if (client <> nil) then begin
      if HitTestValue = HTCAPTION then begin
        client.BeginDrag(False);
      end
      else FOldWindowProc(Message);
		end
    else FOldWindowProc(Message);
  end
  // prevent close button
  else if (Message.Msg = WM_LBUTTONUP) then begin
		P := SmallPointToPoint(TWMMouse(Message).Pos);
		client := HitTest(P, HitTestValue);
		if (client <> nil) and (HitTestValue = HTCLOSE) then begin
      CanChange := true;
      if (Assigned(OnChangeVisibility)) then OnChangeVisibility(client, false, CanChange);
			if (not CanChange) then begin
      	TWMMouse(Message).XPos := -1;
        TWMMouse(Message).YPos := -1;
      end;
      FOldWindowProc(Message)
		end
    else FOldWindowProc(Message);
  end
  // disable floating
  else if (Message.Msg = WM_LBUTTONUP) then begin
		client := HitTest(SmallPointToPoint(TWMMouse(Message).Pos), HitTestValue);
		if client <> nil then CancelDrag;
	end
  else FOldWindowProc(Message);
end;

end.
