unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms, Graphics,
  Controls, StdCtrls, ExtCtrls,Dialogs,Menus,
  CoolTrayIcon, RzCommon, ImgList, AnyHint, HideProcess, 
  CnAAFont, pngimage, frxpngimage, CnAACtrls, DBGridEhGrouping, GridsEh,
  DBGridEh, dxGDIPlusClasses, DB, ADODB;

type
  TMainForm = class(TForm)
    pm1: TPopupMenu;
    mm_Reboot: TMenuItem;
    mm_ShutDown: TMenuItem;
    mm_SysManager: TMenuItem;
    ImageList1: TImageList;
    tmr_time: TTimer;
    rzmncntrlr1: TRzMenuController;
    CoolTrayIcon1: TCoolTrayIcon;
    mm_About: TMenuItem;
    iml_CoolTray: TImageList;
    lbl_time: TLabel;
    lbl_Author: TLabel;
    btn_Close: TButton;
    lbl_Ver: TLabel;
    lbl_Yzdw: TLabel;
    lbl_DWMC: TLabel;
    img_Bottom: TImage;
    img_Top: TImage;
    img_Logon: TImage;
    img_main: TImage;
    btn_Start: TImage;
    mm_Exit: TMenuItem;
    mm_break: TMenuItem;
    mm_Show: TMenuItem;
    pnl_Kb: TPanel;
    img_Kb: TImage;
    lbl_Date: TLabel;
    img1: TImage;
    img2: TImage;
    img3: TImage;
    img_ShutDown: TImage;
    img_Reboot: TImage;
    img_Login: TImage;
    img_Kbset: TImage;
    img_Closedevice: TImage;
    img_About: TImage;
    lbl_a: TLabel;
    lbl_b: TLabel;
    lbl_c: TLabel;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_LoginClick(Sender: TObject);
    procedure btn_ShutDownClick(Sender: TObject);
    procedure btn_RebootClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mm_RebootClick(Sender: TObject);
    procedure mm_ShutDownClick(Sender: TObject);
    procedure tmr_timeTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CoolTrayIcon1Startup(Sender: TObject;
      var ShowMainForm: Boolean);
    procedure FormShow(Sender: TObject);
    procedure CoolTrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pm1Popup(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CoolTrayIcon1DblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mm_AboutClick(Sender: TObject);
    procedure btn_StartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mm_ExitClick(Sender: TObject);
    procedure mm_SysManagerClick(Sender: TObject);
    procedure mm_ShowClick(Sender: TObject);
    procedure CoolTrayIcon1BalloonHintTimeout(Sender: TObject);
    procedure CoolTrayIcon1MinimizeToTray(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img_LoginClick(Sender: TObject);
    procedure img_AboutClick(Sender: TObject);
    procedure img_RebootClick(Sender: TObject);
    procedure img_ShutDownClick(Sender: TObject);
    procedure img_ClosedeviceClick(Sender: TObject);
  private
    { Private declarations }
    aImg:array [0..6] of TImage; //上午
    bImg:array [0..6] of TImage; //下午
    cImg:array [0..6] of TImage; //晚上
    Is_Show_Balloon :Boolean;
    Old_x,Old_y :Integer;
    procedure QueryEndSession(var Msg:TMessage);Message WM_QueryEndSession;
    function  InputCheckUser:String;
    procedure SetComponentPos;
    procedure ShowHintMsg(const msg:string;bShowBalloonHint:Boolean=False);
  public
    { Public declarations }
    procedure DisplayKbState;
  end;

var
  MainForm: TMainForm;
  gbCanClose:Boolean;

implementation
uses udm,LoginUnit,uShutDown,Net,uabout,uSystemSet,uKillProcess;
{$R *.dfm}

procedure TMainForm.btn_CloseClick(Sender: TObject);
begin
  gbCanClose := True;
  Close;
end;

{ TClientHandleThread }

procedure TMainForm.ShowHintMsg(const msg:string;bShowBalloonHint:Boolean=False);
begin
  if gb_Logined or bShowBalloonHint then
    CoolTrayIcon1.ShowBalloonHint('系统提示：',msg,bitInfo,10);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not gbCanClose then
    CanClose := gb_Logined  //登录成功
  else
  begin
    dm.CloseDevice;
    CanClose := True;
  end;
end;

procedure TMainForm.btn_LoginClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    if not gb_Logined then
      gb_Logined := dm.AllowSj;

    if (not gb_Logined) then
       gb_Logined := TLoginForm.Create(Application).ShowModal=mrOk;

    if gb_Logined then
    begin
      //SaveLog('开始解锁');
      if not MyHideProcess then
        MyHideProcess;
      tmr_time.Enabled := False;
      Application.MainForm.Hide;
    end;
    if TestMode then
       SendNoSoldierMsg;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.btn_ShutDownClick(Sender: TObject);
begin
  ShutDownComputer;
end;

procedure TMainForm.btn_StartMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pm1.Popup(20,Self.Height-50);
end;

procedure TMainForm.btn_RebootClick(Sender: TObject);
begin
  RebootComputer;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  gbCanClose := False;
  dm.tmr_Check.Enabled := True;

  Left := 0;
  Top := 0;
  Width := Screen.Width;
  Height := Screen.Height;

  for I := Low(aImg) to High(aImg) do
  begin
    aImg[i] := TImage.Create(nil);
    aImg[i].Parent := pnl_Kb;
    aImg[i].Picture.Assign(img1.Picture);
    aImg[i].Top := img1.Top;
    aImg[i].Visible := False;
  end;
  for I := Low(bImg) to High(bImg) do
  begin
    bImg[i] := TImage.Create(nil);
    bImg[i].Parent := pnl_Kb;
    bImg[i].Picture.Assign(img2.Picture);
    bImg[i].Top := img2.Top;
    bImg[i].Visible := False;
  end;
  for I := Low(cImg) to High(cImg) do
  begin
    cImg[i] := TImage.Create(nil);
    cImg[i].Parent := pnl_Kb;
    cImg[i].Picture.Assign(img3.Picture);
    cImg[i].Top := img3.Top;
    cImg[i].Visible := False;
  end;

  DisplayKbState;
  CoolTrayIcon1.Hint := Application.Title;
  lbl_Ver.Caption := 'Ver '+Get_Version;
  lbl_time.Left := 100;
  lbl_time.Caption := FormatDateTime('yyyy.mm.dd hh:nn:ss',Now);
  tmr_time.Enabled := True;

  //Connect_Srv(False);//连接机房管理系统服务器

  btn_Close.Visible := TestMode;

  if not TestMode then
  begin
    FormStyle := fsStayOnTop;

    SetWindowPos(Application.Handle,HWND_TOPMOST,Left,Top,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    ShowWindow(Application.Handle,SW_HIDE);
  end else
     FormStyle := fsNormal;

  if dm.AllowSj then
  begin
    gb_Logined := True;

    Application.ShowMainForm := False;
    CoolTrayIcon1.OnMinimizeToTray(Self);
    UnLockSystemByXXX;
    //dm.OpenDevice;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i:Integer;
begin
  for i := Low(aImg) to High(aImg) do
  begin
    if Assigned(aImg[i]) then
      FreeAndNil(aImg[i]);
  end;

  for i := Low(bImg) to High(bImg) do
  begin
    if Assigned(bImg[i]) then
      FreeAndNil(bImg[i]);
  end;

  for i := Low(cImg) to High(cImg) do
  begin
    if Assigned(cImg[i]) then
      FreeAndNil(cImg[i]);
  end;
end;

procedure TMainForm.mm_RebootClick(Sender: TObject);
var
  bl:Boolean;
begin
  bl := dm.tmr_Check.Enabled;
  dm.tmr_Check.Enabled := False;
  try
    if MessageBox(Handle, '真的要重新启动计算机吗？　　',
      PChar(Application.Title), MB_YESNO + MB_ICONQUESTION+MB_DEFBUTTON2) = IDYES then
    begin
      if not TestMode then
      begin
        LockSystemByXXX;
        SetWindowPos(Application.Handle,HWND_TOPMOST,Left,Top,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
        //ShowWindow(Application.Handle,SW_HIDE);
      end;
      RebootComputer;
    end;
  finally
    dm.tmr_Check.Enabled := bl;
  end;
end;

procedure TMainForm.mm_ShowClick(Sender: TObject);
begin
  CoolTrayIcon1.ShowMainForm;
  UnLockSystemByXXX;
  SendSoldierMsg;
  dm.tmr_Check.Enabled := True;
  dm.CloseDevice;
end;

procedure TMainForm.mm_ShutDownClick(Sender: TObject);
var
  bl:Boolean;
begin
  bl := dm.tmr_Check.Enabled;
  dm.tmr_Check.Enabled := False;
  try
    if MessageBox(Handle, '真的要关闭计算机吗？　　',
      PChar(Application.Title), MB_YESNO + MB_ICONQUESTION+MB_DEFBUTTON2) = IDYES then
    begin
      if not TestMode then
      begin
        LockSystemByXXX;
        SetWindowPos(Application.Handle,HWND_TOPMOST,Left,Top,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
        //ShowWindow(Application.Handle,SW_HIDE);
      end;
      ShutDownComputer;
    end;
  finally
    dm.tmr_Check.Enabled := bl;
  end;
end;

procedure TMainForm.mm_SysManagerClick(Sender: TObject);
var
  bl:Boolean;
begin
  bl := dm.tmr_Check.Enabled;
  dm.tmr_Check.Enabled := False;
  try
    if TestMode or CheckLogin then
    begin
      dm.tmr_Check.Enabled := False;
      if not Self.Showing then
      begin
        TSystemSet.Create(nil).ShowModal;
        DisplayKbState;
      end
      else
      begin
        gb_Logined := True;
        Application.MainForm.Hide;
        CoolTrayIcon1.OnMinimizeToTray(Self);
      end;
    end;
  finally
    dm.tmr_Check.Enabled := bl;
  end;
end;

procedure TMainForm.pm1Popup(Sender: TObject);
begin
  mm_SysManager.Enabled := True;//not Self.Showing;
  mm_Show.Visible := not Self.Showing;
  mm_Exit.Enabled := not Self.Showing;
end;

procedure TMainForm.QueryEndSession(var Msg: TMessage);
begin
  gbCanClose := True;
  Msg.Result := 1;  //0：不允许关机 1：允许关机
  dm.CloseDevice;
end;

procedure TMainForm.SetComponentPos;
var
  ii:Integer;
begin
  Self.Left := 0;          
  Self.Width := Screen.Width+2;
  Self.Top := 0;
  Self.Height := Screen.Height+2;

  lbl_time.Left := Screen.Width-lbl_time.Width-24;

  img_Logon.Left := 10;//Trunc((img_main.Width-img_Logon.Width)/2);  //
  img_Logon.Top := img_bottom.Top-img_Logon.Height-50;//img_main.Top+Trunc((img_main.Height-img_Logon.Height)/2); //

  pnl_Kb.Left := Trunc((img_main.Width-pnl_Kb.Width)/2)-50;  //
  pnl_Kb.Top := img_main.Top+Trunc((img_main.Height-pnl_Kb.Height)/2)-30; //

  btn_Start.Top := img_Bottom.Top+10;

  ii := Trunc((img_main.Height-img_login.Height)/11);
  //img_Login.Top := img_Login.Top+(img_Login.Height+ii)*2;
  img_KbSet.Top := img_Login.Top+(img_Login.Height+ii)*1;
  img_CloseDevice.Top := img_Login.Top+(img_Login.Height+ii)*2;
  img_Reboot.Top := img_Login.Top+(img_Login.Height+ii)*3;
  img_ShutDown.Top := img_Login.Top+(img_Login.Height+ii)*4;
  img_About.Top := img_Login.Top+(img_Login.Height+ii)*5;
end;

procedure TMainForm.tmr_timeTimer(Sender: TObject);
begin
  lbl_time.Caption := FormatDateTime('yyyy.mm.dd hh:nn:ss',Now);
  btn_Close.Caption := IntToStr(lbl_time.Top)+','+IntToStr(lbl_time.Left);
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  UnLockSystemByXXX;
end;

{ TtoMngTcpThread }

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{  if Shift <> [] then Exit;
  case Key of
    VK_F2:
      btn_Login.OnClick(Sender);
    VK_F3:
      btn_Logout.OnClick(Sender);
    VK_F4:
      btn_ChgPwd.OnClick(Sender);
    VK_F5:
      btn_LogBrowse.OnClick(Sender);
    VK_F6:
      btn_PostMoney.OnClick(Sender);
    VK_F7:
      btn_Reboot.OnClick(Sender);
    VK_F8:
      btn_ShutDown.OnClick(Sender);
  end;
}  
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  SetComponentPos;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  dm.tmr_Check.Enabled := True;
  SetComponentPos;
end;

procedure TMainForm.img_AboutClick(Sender: TObject);
begin
  mm_AboutClick(Self);
end;

procedure TMainForm.img_ClosedeviceClick(Sender: TObject);
var
  bl:Boolean;
begin
  bl := dm.tmr_Check.Enabled;
  dm.tmr_Check.Enabled := False;
  try
    dm.CloseDevice(True);
  finally
    dm.tmr_Check.Enabled := bl;
  end;
end;

procedure TMainForm.img_LoginClick(Sender: TObject);
begin
  mm_SysManagerClick(Self);
end;

procedure TMainForm.img_RebootClick(Sender: TObject);
begin
  mm_RebootClick(Self);
end;

procedure TMainForm.img_ShutDownClick(Sender: TObject);
begin
  mm_ShutDownClick(Self);
end;

function TMainForm.InputCheckUser: String;
begin
end;

procedure TMainForm.CoolTrayIcon1BalloonHintTimeout(Sender: TObject);
begin
  Is_Show_Balloon := False;
end;

procedure TMainForm.CoolTrayIcon1DblClick(Sender: TObject);
begin
  SetForegroundWindow(MainForm.Handle);
  MainForm.pm1.Popup(Screen.Width-250,Screen.Height-25);
  MainForm.CoolTrayIcon1.HideBalloonHint;
end;

procedure TMainForm.CoolTrayIcon1MinimizeToTray(Sender: TObject);
begin
  if not Is_Show_Balloon then
  begin
    Is_Show_Balloon := True;
    ShowHintMsg(CoolTrayIcon1.Hint+' Ver '+Get_Version);
  end;
end;

procedure TMainForm.CoolTrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  str:string;
begin
  if not gb_Logined or (Button<>mbLeft) then
  begin
    Exit;
  end;

  Is_Show_Balloon := True;
end;

procedure TMainForm.CoolTrayIcon1Startup(Sender: TObject;
  var ShowMainForm: Boolean);
begin
  ShowMainForm := True;
end;

procedure TMainForm.DisplayKbState;
var
  adoquery1:Tadoquery;
  i: Integer;
  fld,dd:string;
  imgarr:TImage;
  aLabel:TLabel;
begin
  adoquery1 := TAdoquery.Create(nil);
  adoquery1.Connection := dm.conn_DB;
  try
    adoquery1.sql.Text := 'select * from 上课时间表';
    adoquery1.Open;
    while not adoquery1.Eof do
    begin
      for i := 0 to 6 do
      begin
        if Pos('上午',adoquery1.fieldbyname('说明').asstring)>0 then
        begin
          imgarr := aImg[i];
          aLabel := lbl_a;
        end
        else if Pos('下午',adoquery1.fieldbyname('说明').asstring)>0 then
        begin
          imgarr := bImg[i];
          aLabel := lbl_b;
        end
        else if Pos('晚上',adoquery1.fieldbyname('说明').asstring)>0 then
        begin
          imgarr := cImg[i];
          aLabel := lbl_c;
        end;
        imgarr.Left := 93+i*70+Trunc((70-34)/2);
        //imgarr[i].Top := 111+(46-34)/2;
        fld := WeekList[i];
        dd := adoquery1.FieldByName('开始时间').AsString+'-'+
              adoquery1.FieldByName('结束时间').AsString;
        aLabel.Caption := dd;
        if adoquery1.fieldbyname(fld).AsBoolean then
          imgarr.Visible := True
        else
          imgarr.Visible := False;
      end;
      adoquery1.Next;
    end;
  finally
    adoquery1.free;
  end;
end;

procedure TMainForm.mm_AboutClick(Sender: TObject);
var
  bl:Boolean;
begin
  bl := dm.tmr_Check.Enabled;
  dm.tmr_Check.Enabled := False;
  try
    TAboutBox.Create(nil).ShowModal;
  finally
    dm.tmr_Check.Enabled := bl;
  end;
end;

procedure TMainForm.mm_ExitClick(Sender: TObject);
begin
  if CheckLogin then
  begin
    UnLockSystemByXXX;
    if Self.Showing then
    begin
      Application.MainForm.Hide;
    end else
      Self.Close;
  end;
end;

end.

