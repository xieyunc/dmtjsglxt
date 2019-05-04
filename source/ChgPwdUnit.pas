unit ChgPwdUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, Mask, RzEdit, ExtCtrls, RzLabel, RzPanel;

type
  TChgPwdForm = class(TForm)
    rzgrpbx1: TRzGroupBox;
    lbl_1: TRzLabel;
    RzLabel1: TRzLabel;
    img1: TImage;
    edt_User: TRzEdit;
    edt_Pwd: TRzEdit;
    btn_OK: TRzBitBtn;
    btn_Exit: TRzBitBtn;
    RzLabel2: TRzLabel;
    edt_newPwd: TRzEdit;
    RzLabel3: TRzLabel;
    edt_newSePwd: TRzEdit;
    procedure edt_UserChange(Sender: TObject);
    procedure btn_ExitClick(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}

procedure TChgPwdForm.edt_UserChange(Sender: TObject);
begin
  btn_OK.Enabled := TEdit(Sender).Text<>'';
end;

procedure TChgPwdForm.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TChgPwdForm.btn_OKClick(Sender: TObject);
var
  sError:WideString;
begin
  if not Connect_Srv then
     Exit;

  if edt_newPwd.Text<>edt_newSePwd.Text then
  begin
    MessageBox(Handle, '两次新密码不一致！请重新输入！　　', '密码不一致',MB_OK + MB_ICONSTOP);
    edt_newPwd.SetFocus;
    Exit;
  end;

  //if vobj.Teacher_Pwd_Is_OK(edt_User.Text,edt_Pwd.Text) then
  if vobj.Change_Teacher_Pwd(edt_User.Text,edt_Pwd.Text,edt_newPwd.Text,sError) then
  begin
    //vobj.Change_Teacher_Pwd(edt_User.Text,edt_newPwd.Text);
    MessageBox(Handle, PChar('操作完成！你的密码已更改！　　'), '操作成功',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  //if vobj.Xs_Pwd_Is_OK(edt_User.Text,edt_Pwd.Text) then
  if vobj.Change_Xs_Pwd(edt_User.Text,edt_Pwd.Text,edt_newPwd.Text,sError) then
  begin
    //vobj.Change_Xs_Pwd(edt_User.Text,edt_newPwd.Text);
    MessageBox(Handle, PChar('操作完成！你的密码已更改！　　'), '操作成功',MB_OK + MB_ICONINFORMATION);
  end else
    MessageBox(Handle, PChar(string(sError)+'　　'), '操作失败', MB_OK +MB_ICONSTOP);
end;

procedure TChgPwdForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChgPwdForm.FormCreate(Sender: TObject);
begin
  edt_User.Text := CUR_USER_ID;
end;

end.
