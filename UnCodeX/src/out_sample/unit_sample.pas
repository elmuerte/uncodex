unit unit_sample;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_OutputSample = class(TForm)
    lb_Packages: TListBox;
    lb_Classes: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_OutputSample: Tfrm_OutputSample;

implementation

{$R *.dfm}

end.
