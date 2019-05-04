unit LoginUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzPanel, Buttons, pngimage, frxpngimage;

type
  TLoginForm = class(TForm)
    rzgrpbx1: TRzGroupBox;
    edt_User: TEdit;
    edt_Pwd: TEdit;
    lbl_user: TLabel;
    lbl_pwd: TLabel;
    img1: TImage;
    btn_OK: TBitBtn;
    btn_Exit: TBitBtn;
    procedure btn_ExitClick(Sender: TObject);
    procedure edt_UserChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_OKClick(Sender: TObject);
    procedure edt_PwdKeyPress(Sender: TObject; var Key: Char);
    procedure edt_UserKeyPress(Sender: TObject; var Key: Char);
    procedure img1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function CheckLogin:Boolean;

implementation
uses udm,uChgMasterCode,uKillProcess;
{$R *.dfm}

function CheckLogin:Boolean;
begin
  Result := TLoginForm.Create(Application).ShowModal = mrOk;
end;

procedure TLoginForm.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TLoginForm.img1DblClick(Sender: TObject);
begin
  if edt_User.Text<>'master' then Exit;
  if not dm.MasterPwdIsOK(edt_Pwd.Text) then Exit;
  TChgMasterCode.Create(nil).ShowModal;
end;

procedure TLoginForm.edt_UserChange(Sender: TObject);
begin
  btn_OK.Enabled := Trim(TEdit(Sender).Text)<>'';
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLoginForm.btn_OKClick(Sender: TObject);
var
  res_str:WideString;
  sMsg:string;
begin
  try
    btn_OK.Enabled := False;

    if dm.MasterPwdIsOK(edt_Pwd.Text) then
    begin
      //MessageBox(Handle,'系统管理员登录！请慎用此功能！！　　', PChar(Application.Title),MB_OK + MB_ICONINFORMATION);
      SendNoSoldierMsg;
      btn_OK.ModalResult := mrOk;
      Self.ModalResult := mrOk;
      SaveLog('系统管理员登录！');

      Exit;
    end else
    begin
      MessageBox(Handle,'密码错误！管理员登录失败！　　', PChar(Application.Title),MB_OK + MB_ICONSTOP);
      edt_Pwd.SetFocus;
      Exit;
    end;
  finally
    btn_OK.Enabled := True;
  end;
end;

procedure TLoginForm.edt_PwdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    btn_OK.SetFocus;
    btn_OK.Click;
  end;
end;

procedure TLoginForm.edt_UserKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    edt_Pwd.SetFocus;
end;

end.
