unit uABOUT;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CnAAFont, CnAACtrls,ShellAPI, dxGDIPlusClasses;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    albl_Title: TCnAALabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SrvCode: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  AboutBox: TAboutBox;

implementation
uses Net;
{$R *.dfm}

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  if ParamCount>1 then
    Version.Caption := 'Version '+ParamStr(1)
  else
    Version.Caption := 'Version '+Get_Version;
end;

procedure TAboutBox.Label2Click(Sender: TObject);
begin
  ShellExecute(0,'open',PChar(TLabel(Sender).Caption),nil,nil,SW_SHOW);
end;

procedure TAboutBox.Label2MouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clBlue;
  TLabel(Sender).Font.Style := [fsUnderline];
end;

procedure TAboutBox.Label2MouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clBlack;
  TLabel(Sender).Font.Style := [];
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

end.
 
