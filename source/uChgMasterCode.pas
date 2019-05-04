unit uChgMasterCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TChgMasterCode = class(TForm)
    lbledt1: TLabeledEdit;
    lbledt2: TLabeledEdit;
    btn_OK: TBitBtn;
    btn_Cancel: TBitBtn;
    pnl1: TPanel;
    procedure lbledt1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChgMasterCode: TChgMasterCode;

implementation
uses udm;
{$R *.dfm}

procedure TChgMasterCode.btn_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TChgMasterCode.btn_OKClick(Sender: TObject);
begin
  if not dm.SetMasterNewCode(lbledt1.Text,lbledt2.Text) then
    MessageBox(Handle, 'MASTER旧密码认证失败，请检查后重新设置！　',
      '系统提示', MB_OK + MB_ICONSTOP + MB_TOPMOST)
  else
    MessageBox(Handle, 'MASTER密码设置成功，请牢记新密码！　', '系统提示', MB_OK
      + MB_ICONINFORMATION + MB_TOPMOST);

end;

procedure TChgMasterCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChgMasterCode.lbledt1Change(Sender: TObject);
begin
  btn_OK.Enabled := TLabeledEdit(Sender).Text<>'';
end;

end.
