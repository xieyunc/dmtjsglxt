unit CheckUser_LoginUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, ExtCtrls, StdCtrls, RzLabel, Mask, RzEdit, RzPanel;

type
  TCheckUser_LoginForm = class(TForm)
    rzgrpbx1: TRzGroupBox;
    edt_User: TRzEdit;
    edt_Pwd: TRzEdit;
    lbl_1: TRzLabel;
    RzLabel1: TRzLabel;
    img1: TImage;
    btn_OK: TRzBitBtn;
    btn_Exit: TRzBitBtn;
    procedure btn_ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edt_UserChange(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
  private
    { Private declarations }
    pUserID:String;
  public
    { Public declarations }
    function Get_UserID:String;
  end;

implementation
uses DMUnit,jfglClientIntf;
{$R *.dfm}

procedure TCheckUser_LoginForm.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TCheckUser_LoginForm.FormCreate(Sender: TObject);
begin
  pUserID := '';
end;

function TCheckUser_LoginForm.Get_UserID: String;
begin
  Result := pUserID;
end;

procedure TCheckUser_LoginForm.edt_UserChange(Sender: TObject);
begin
  btn_OK.Enabled := Trim(TEdit(Sender).Text)<>'';
end;

procedure TCheckUser_LoginForm.btn_OKClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;

    if vobj.Xs_Pwd_Is_OK(edt_User.Text,edt_Pwd.Text) then
    begin
      pUserID := edt_User.Text;
      btn_OK.ModalResult := mrOk;
      Self.ModalResult := mrOK;
    end else
    begin
      MessageBox(Handle, PChar('上机证号或密码不正确！请检查后重输！　　'), '系统提示', MB_OK +MB_ICONSTOP);
      btn_OK.ModalResult := mrCancel;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
