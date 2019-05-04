unit udm;

interface

uses
  SysUtils, Classes,IniFiles,Controls,Forms,Windows, DB, ADODB, ExtCtrls,
  OoMisc, AdPort,TypInfo,Messages,ShellAPI;

type
  Tdm = class(TDataModule)
    conn_DB: TADOConnection;
    tmr_Check: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure tmr_CheckTimer(Sender: TObject);
    procedure ApdComPort1Trigger(CP: TObject; Msg, TriggerHandle, Data: Word);
  private
    { Private declarations }
    iTimeCount:Cardinal;
    function  GetMasterCode:string;
    procedure SetMasterCode(const Code:string);
    function  MasterCodeIsOK(const Code:string):Boolean;
    function  DateIsOK:Boolean;
    function  TimeIsOK:Boolean;
    function  SendCOMCommand(const iType:Integer;const ShowDialog:Boolean=False):Boolean;
    function  GetDeviceExeFileName:string;
    function  GetDeviceExeTitle:string;
    function  SendDeviceCommand(const iType:Integer;const ShowDialog:Boolean=False):Boolean;
  public
    { Public declarations }
    function  GetWeek:string;
    function  SetMasterNewCode(const OldCode,NewCode:string):Boolean;
    function  MasterPwdIsOK(const Pwd:string):Boolean;
    function  AllowSj:Boolean;
    function  OpenDevice(const ShowDialog:Boolean=False):Boolean;
    function  CloseDevice(const ShowDialog:Boolean=False):Boolean;
    function  OpenDevice1(const ShowDialog:Boolean=False):Boolean;
    function  CloseDevice1(const ShowDialog:Boolean=False):Boolean;
    function  OpenDevice2(const ShowDialog:Boolean=False):Boolean;
    function  CloseDevice2(const ShowDialog:Boolean=False):Boolean;
  end;

const
  TestMode = False;//True;//
  DeviceMode = 1; //0:代码控制 1:外部程序控制
  AppName = '多媒体教室管理系统';
  WeekList:Array [0..6] of ShortString = ('周日','周一','周二','周三','周四','周五','周六');
  
var
  dm: Tdm;
  gb_Logined:Boolean;

  function  GetWeekNo:string;
  procedure DisableTaskMgr; //1:禁止任务管理器 0:打开任务管理器
  procedure EnableTaskMgr; //1:禁止任务管理器 0:打开任务管理器
  procedure LockSystemByXXX;
  procedure UnLockSystemByXXX;
  procedure SaveLog(const s:string);

implementation
uses PwdFunUnit,uHook,uKillProcess;
{$R *.dfm}

{ Tdm }

function Tdm.AllowSj: Boolean;
begin
  Result :=  TimeIsOK and DateIsOK;
end;

procedure Tdm.ApdComPort1Trigger(CP: TObject; Msg, TriggerHandle, Data: Word);
var
  i: Integer;
  s:string;
begin
  for i := 1 to Data do
    s:=s+TApdComPort(CP).GetChar;
  MessageBox(0, PChar(s), '系统提示', MB_OK + MB_ICONSTOP +
    MB_TOPMOST);
    ;
end;

function Tdm.CloseDevice(const ShowDialog:Boolean=False): Boolean;
begin
  if DeviceMode=0 then
    CloseDevice1(ShowDialog)
  else
    CloseDevice2(ShowDialog);
end;

function Tdm.CloseDevice1(const ShowDialog: Boolean): Boolean;
begin
  SendCOMCommand(0,ShowDialog);
end;

function Tdm.CloseDevice2(const ShowDialog: Boolean): Boolean;
begin
  SendDeviceCommand(0,ShowDialog);
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  conn_DB.Close;
  conn_DB.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+
                               ExtractFilePath(ParamStr(0))+'data.dll;Persist Security Info=False;';
  conn_DB.Connected := True;
  gb_Logined := False;
  SendSoldierMsg;
  LockSystemByXXX;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  conn_DB.Close;
end;

function  GetWeekNo:string;
begin
  Result := IntToStr(DayOfWeek(Now)-1);
end;

function Tdm.DateIsOK: Boolean;
var
  iCount:Integer;
  sd,ed:TDateTime;
  adoQuery:TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := conn_DB;
    adoQuery.SQL.Text := 'select * from 上课日期表';
    adoQuery.Open;
    iCount := adoQuery.FieldByName('次数').AsInteger;
    if iCount=0 then
      Result := False
    else if iCount<>-1 then
    begin
      sd := adoQuery.FieldByName('开始日期').AsDateTime;
      ed := adoQuery.FieldByName('开始日期').AsDateTime+iCount*7;
      Result := (date()>=sd) and (Date()<=ed); // and (Pos(GetWeekNo,w)>0);
    end else
      Result := True;
  finally
    adoQuery.Free;
  end;
end;

function Tdm.GetDeviceExeFileName: string;
var
  adoQuery:TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := conn_DB;
    adoQuery.SQL.Text := 'select 控制程序 from 投影控制设置表';
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsString;
  finally
    adoQuery.Free;
  end;
end;

function Tdm.GetDeviceExeTitle: string;
var
  adoQuery:TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := conn_DB;
    adoQuery.SQL.Text := 'select 程序标题 from 投影控制设置表';
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsString;
  finally
    adoQuery.Free;
  end;
end;

function Tdm.GetMasterCode: string;
var
  fn:string;
begin
  fn := ExtractFilePath(ParamStr(0))+'SysSet.DLL';
  with TIniFile.Create(fn) do
  begin
    try
      Result := ReadString('SrvSet','Code','');
      if Result='' then
      begin
        Result := EnCrypt('lgxy_admin&');
        WriteString('SrvSet','Code',Result);
      end;

      Result := DeCrypt(Result);
    finally
      Free;
    end;
  end;
end;

function Tdm.GetWeek: string;
var
  mytime:SYSTEMTIME;
begin
  GetLocalTime(mytime);
  //Result := WeekList[mytime.wDayOfWeek];
  case mytime.wDayOfWeek of
    0: Result:='周日';
    1: Result:='周一';
    2: Result:='周二';
    3: Result:='周三';
    4: Result:='周四';
    5: Result:='周五';
    6: Result:='周六';
  end;
end;

function Tdm.MasterCodeIsOK(const Code: string): Boolean;
begin
  Result := Code=GetMasterCode;
end;

function Tdm.MasterPwdIsOK(const Pwd: string): Boolean;
begin
  Result := Pwd=GetMasterCode+FormatDateTime('hhnn',Now);
end;

function Tdm.OpenDevice(const ShowDialog:Boolean=False): Boolean;
begin
  if DeviceMode=0 then
    OpenDevice1(ShowDialog)
  else
    OpenDevice2(ShowDialog);
end;

function Tdm.OpenDevice1(const ShowDialog: Boolean): Boolean;
begin
  SendCOMCommand(1,ShowDialog);
end;

function Tdm.OpenDevice2(const ShowDialog: Boolean): Boolean;
begin
  SendDeviceCommand(1,ShowDialog);
end;

function Tdm.SendCOMCommand(const iType: Integer;const ShowDialog:Boolean=False): Boolean;
var
  adoQuery:TADOQuery;
  ApdComPort:TApdComPort;
  sCmd,s:string;
begin
  //编写串行通信程序的过程一般为打开串口、配置串口、发送或接收数据以及关闭串口。
  ApdComPort := TApdComPort.Create(nil);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := conn_DB;
    adoQuery.SQL.Text := 'select * from 投影控制设置表';
    adoQuery.Open;

    try
      ApdComPort.AutoOpen := False;
      //ApdComPort.OnTrigger := ApdComPort1Trigger;

      s := adoQuery.FieldByName('串口号').AsString; //COM1,COM2....
      ApdComPort.ComNumber := StrToIntDef(Copy(s,4,1),1);
      ApdComPort.Baud := adoQuery.FieldByName('波特率').AsInteger;
      s := adoQuery.FieldByName('奇偶校验位').AsString;//pNone, pOdd, pEven, pMark, pSpace
      ApdComPort.Parity := TParity(GetEnumValue(TypeInfo(TParity),s));
      ApdComPort.DataBits := adoQuery.FieldByName('数据位').AsInteger;
      ApdComPort.StopBits := adoQuery.FieldByName('停止位').Value;

      ApdComPort.Open := True;

      if iType=0 then
        sCmd := Trim(adoQuery.FieldByName('关机控制码').Value)
      else
        sCmd := Trim(adoQuery.FieldByName('开机控制码').Value);

      //ApdComPort.BufferFull := Length(sCmd);
      //ApdComPort.OutSize := Length(sCmd);
      ApdComPort.Output := sCmd;//+#10;

      Result := True;
    except
      on e:Exception do
      begin
        Result := False;
        if ShowDialog then
          MessageBox(0, PAnsiChar('投影控制代码执行失败！请检查设备控制代码　' +
            #13#10 + '或与设备厂商联系！失败原因为：'+#13+e.Message), '系统提示', MB_OK +
            MB_ICONSTOP + MB_TOPMOST);
      end;
    end;
  finally
    adoQuery.Free;
    ApdComPort.Open := False;
    ApdComPort.Free;
  end;
end;

function Tdm.SendDeviceCommand(const iType: Integer;const ShowDialog:Boolean=False): Boolean;
var
  fn,title,sError:string;
  wh,gh,bh:LongInt;
begin
  Result := False;
  Screen.Cursor := crHourGlass;
  try
    fn := GetDeviceExeFileName;
    if not ExeIsRunning(fn) then
    begin
      if ExtractFileDir(fn)='' then
        fn := ExtractFilePath(ParamStr(0))+fn;
      if FileExists(fn) then
      begin
        ShellExecute(0,'open',PAnsiChar(fn),nil,PAnsiChar(ExtractFileDir(fn)),SW_HIDE);
        //WinExec(PAnsiChar(fn),SW_SHOWMINIMIZED);
        Sleep(1000);
      end
      else begin
        sError := '投影机控制程序文件不存存在！请检查后重试！　'+#13+fn;
        Exit;
      end;
    end;
    sError := '投影机控制程序接管失败！请检查程序路径和标题是否正确！　';
    wh := FindWindow(nil,PAnsiChar(GetDeviceExeTitle));
    if wh=0 then Exit;
    PostMessage(wh,WM_SYSCOMMAND, SC_MINIMIZE,0);
    //SendMessage(wh,WM_SYSCOMMAND, SC_MINIMIZE,0);
    gh := FindWindowEx(wh,0,'TcxGroupBox','投影机控制');
    if gh=0 then Exit;
    if iType=0 then
      bh := FindWindowEx(gh,0,'TcxButton','关机')
    else
      bh := FindWindowEx(gh,0,'TcxButton','开机');
    if bh=0 then Exit;

    sError := '';
    //PostMessage(bh,WM_SETTEXT,0,Integer(PAnsiChar('XXX')));
    PostMessage(bh,WM_LBUTTONDOWN,0,0);
    PostMessage(bh,WM_LBUTTONUP,0,0);
    //SendMessage(bh,WM_SETTEXT,0,Integer(PAnsiChar('XXX')));
    //SendMessage(bh,WM_LBUTTONDOWN,0,0);
    //SendMessage(bh,WM_LBUTTONUP,0,0);
    Result := True;
  finally
    Screen.Cursor := crDefault;
    if ShowDialog and (not Result) then
    begin
      MessageBox(0, PAnsiChar(sError), '系统提示', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;
  end;
end;

procedure Tdm.SetMasterCode(const Code: string);
var
  fn:string;
begin
  fn := ExtractFilePath(ParamStr(0))+'SysSet.DLL';
  with TIniFile.Create(fn) do
  begin
    try
      WriteString('SrvSet','Code',EnCrypt(Code));
    finally
      Free;
    end;
  end;
end;

function Tdm.SetMasterNewCode(const OldCode, NewCode: string): Boolean;
begin
  if MasterCodeIsOK(OldCode) then
  begin
    SetMasterCode(NewCode);
    Result := True;
  end else
    Result := False;
end;

function Tdm.TimeIsOK: Boolean;
var
  sTime:string;
  adoQuery:TADOQuery;
begin
  sTime := QuotedStr(FormatDateTime('hh:nn',Now));
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := conn_DB;
    adoQuery.SQL.Text := 'SELECT count(*) from 上课时间表 where '+sTime+'>=开始时间 and '+sTime+'<=结束时间 and '+GetWeek+'<>0';
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger>0;
  finally
    adoQuery.Free;
  end;
end;

procedure Tdm.tmr_CheckTimer(Sender: TObject);
begin
  if AllowSj then
  begin
    iTimeCount := 0;
    Application.MainForm.Hide;
    UnLockSystemByXXX;
  end
  else begin
    iTimeCount := iTimeCount+1;
    if not IsSystemLogin then
    begin
      gb_Logined := False;
      LockSystemByXXX;
      Application.MainForm.Show;
    end;
  end;
  if Application.MainForm.Showing and (iTimeCount*(tmr_Check.Interval/1000.0)>=300.0) then //5分钟
  begin
    iTimeCount := 0;
    CloseDevice;
  end;
end;

procedure AddValue(Root: HKEY; StrPath: pchar; StrValue: pchar; Strdata: integer); //Strdata 1:禁用,0:启用
var
  s: Hkey;
  Disposition: Integer;
begin
  RegCreateKeyExA(Root, StrPath, 0, nil, 0, KEY_ALL_ACCESS, nil, s, @Disposition);
  RegSetValueExA(s, StrValue, 0, REG_DWORD, @Strdata, sizeof(Strdata));
  RegCloseKey(s);
end;

procedure DisableTaskMgr;
var
  hwndTaskBar:HWND;
begin
  AddValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\System','DisableTaskMgr',1);
  //打开任务栏
  hwndTaskBar := FindWindow('Shell_TrayWnd',nil);
  ShowWindow(hwndTaskBar,SW_HIDE);
end;

procedure EnableTaskMgr;
var
  hwndTaskBar:HWND;
begin
  AddValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\System','DisableTaskMgr',0);
  //隐藏任务栏
  hwndTaskBar := FindWindow('Shell_TrayWnd',nil);
  ShowWindow(hwndTaskBar,SW_SHOW);
end;

procedure LockSystemByXXX;
begin
  if not TestMode then
  begin
    try
      Screen.Cursor := crHourGlass;
      HookStart;
      //ShowWindow(Application.Handle,SW_HIDE);
      DisableTaskMgr; //禁止任务管理器,任务栏
    finally
      //ShowWindow(Application.Handle,SW_HIDE);
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure UnLockSystemByXXX;
begin
  try
    Screen.Cursor := crHourGlass;
    HookEnd;
    //ShowWindow(Application.Handle,SW_HIDE);
    EnableTaskMgr; //打开任务管理器,任务栏
  finally
    ShowWindow(Application.Handle,SW_HIDE);
    Screen.Cursor := crDefault;
  end;
end;

procedure SaveLog(const s: string);
var
  vdir:String;
  Fstrings:TStrings;
begin
  vdir := ExtractFileDir(ParamStr(0));
  if not DirectoryExists(vdir) then
    if not CreateDir(vdir) then
       Exit;
  try
    vdir := vdir+'\ExitLog.Txt';
    Fstrings := TStringList.Create;
    if FileExists(vdir) then
      Fstrings.LoadFromFile(vdir);
    Fstrings.Add(s+' '+datetimetostr(Now));
    Fstrings.SaveToFile(vdir);
  finally
    FreeAndNil(Fstrings);
  end;
end;

end.
