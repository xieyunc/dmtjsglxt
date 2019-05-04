unit DMUnit;

interface

uses
  SysUtils, Classes,Forms,Windows,Messages, DB, DBClient, EhLibCDS, 
  Controls, Net, TypeInst,ProcessUnit,jfglClientIntf,
  IdTCPConnection, IdTCPClient,IniFiles,Dialogs,Graphics,ShellAPI,
  AppEvnts,Sockets, ExtCtrls,Variants, Rio,
  SOAPHTTPClient, WinSock,WSocket, SOAPConn, ADODB, InvokeRegistry;

type
  TDMForm = class(TDataModule)
    ApplicationEvents1: TApplicationEvents;
    HTTPRIO1: THTTPRIO;
    wsckt_Listen: TWSocket;
    SoapConnection1: TSoapConnection;
    tmr_OnlineCheck: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure tmr_SoldierTimer(Sender: TObject);
    procedure wsckt_ListenDataAvailable(Sender: TObject; ErrCode: Word);
    procedure tmr_OnlineCheckTimer(Sender: TObject);
  private
    { Private declarations }
    MonitorFile:string;
    piProcInfoGPS:PROCESS_INFORMATION;

    Tested_Count:Integer; //已测试连接的次数

    //function  CheckHost:Boolean;
    procedure Init_Variant; //初始化环境变量
    procedure FreeIdTcpClient;
    procedure ResetAndInit;
    procedure FreeClentThread;
    function  EstablishProcess(const MonitorFile :string):Boolean; //要监的文件（包含绝对路径）
    function  GetConnInfo:string;//得到连接信息
    function  GetMasterCode:string;
    procedure SetMasterCode(const Code:string);
    function  MasterCodeIsOK(const Code:string):Boolean;
  public
    { Public declarations }
    procedure  Logout;
    procedure  RunClientScreenList;
    procedure  SetLocalHostTeacher(const Msg:string='');//设置本机为教师机
    procedure  SetLocalHostFree(const Msg:string='');   //设置本机为免费开放
    procedure  ShutDownProcess(const ShutDownMode:TCmdType;const IsShowMsgBox:Boolean=True); //下机处理 0:关机 1:重启 2:LogOff
    procedure  UpdateTrayIconStatus(const LoginMode:TLoginMode);overload;
    procedure  UpdateTrayIconStatus(const sStatus:string);overload;
    procedure  UpdateLoginMode(const SjType:string=''); //更新上机类型
    procedure  OnlineCheck;
    procedure  OnlineUserCheck;
    function   SetMasterNewCode(const OldCode,NewCode:string):Boolean;
    function   MasterPwdIsOK(const Pwd:string):Boolean;
  end;

const
  TestMode = False;//True;//
  AppName = '机房管理系统';

var
  DMForm: TDMForm;
  OnlineUserList: TStrings;
  CUR_USER_ID,CUR_USER_PWD: string; //当前上机用户
  CUR_HOST: string;  //当前机器名
  CUR_IP: string;  //当前机器IP
  ErrorHintIsDisplay:Boolean; //错误信息已经显示了吗？
  MessageHintDisplayCount :Integer;
  //Srv_IP,Manager_IP: String;
  LoginMode : TLoginMode;   //上机模式
  Is_OK : Boolean;
  procedure DisableTaskMgr; //1:禁止任务管理器 0:打开任务管理器
  procedure EnableTaskMgr; //1:禁止任务管理器 0:打开任务管理器
  function  Connect_Srv(IsDisplayError:Boolean=True):Boolean; //连接应用服务器
  function  Host_Is_Linked(const vhost:string):Boolean; //某计算机是否连接上了
  procedure Listen_Process(const CB:TCommBlock);
  procedure ShowHintMsg(const msg:string;bShowBalloonHint:Boolean=False);
  procedure SendMsg(const idTcpClient:TIdTCPClient;const cb:TCommBlock);//
  procedure SendMsgToSrvTcp(const cb:TCommBlock); //送给服务器
  procedure SendMsgToMngTcp(const cb:TCommBlock);  //送给管理机
  procedure Send_ShutDown_To_Client(const vhost:string);  //发送关机消息
  procedure LockSystemByXXX;
  procedure UnLockSystemByXXX;
  procedure SaveLog(const s:string);
  procedure CloseErrorMsgBox;
  procedure GetUserList;
  function  Srv_Is_OK:Boolean;
  procedure SendSoldierMsg; //发送要监控的消息
  procedure SendNoSoldierMsg; //发送不要监控的消息

  function  vobj:IjfglClient;//IjfglWebSrv;//再次封装GetIjfglWebSrv接口函数
  function  Is_Allow_Xs_Update_Info:Boolean;

implementation
uses MainUnit,ShutDownComputerUnit,HintUnit,ActiveX,CoolTrayIcon,uHook,PwdFunUnit;//,ErrorUnit;
{$R *.dfm}
var
  MngIP,LogDir : String;
  AppSrvPort,ListenPort,ManagerPort,SendImagePort:string;

function vobj:IjfglClient;//IjfglWebSrv;//再次封装GetIjfglWebSrv接口函数
var
  SoapURL:string;
begin
  SoapURL := DMForm.GetConnInfo;//+SOAP_NAME;
  //Result := GetIjfglWebSrv(False,SoapURL);//,DMForm.HTTPRIO1);
  Result := (dmform.HTTPRIO1 as IjfglClient); //IjfglWebSrv);
end;

function  Srv_Is_OK:Boolean;
begin
  try
    Result := vobj.Srv_Is_OK;
  except
    Result := False;
  end;
end;

procedure SendSoldierMsg; //发送监控的消息
var
  sPath: array [0..255] of Char;
  fn:string;
begin
  GetWindowsDirectory(@sPath,40);
  fn := sPath+'\NoSoldier.Txt';
  if FileExists(fn) then
  begin
    DeleteFile(PChar(fn));
  end;
end;

procedure SendNoSoldierMsg; //发送不要监控的消息
var
  f:TextFile;
  sPath: array [0..255] of Char;
  fn:string;
begin
  GetWindowsDirectory(@sPath,40);
  fn := sPath+'\NoSoldier.Txt';
  if not FileExists(fn) then
  begin
    AssignFile(f,fn);
    Rewrite(f);
    Writeln(f,'LoginMode=lmSystem');
    closefile(f);
  end;
end;

procedure TDMForm.RunClientScreenList;
var
  jfh:String;
  i,ii:integer;
  cb:TCommBlock;
  vIp :String;
begin
  ii := 0;
  GetUserList;
  vIp := GetLocalIpStr;
  cb.cmdType := ctCmd;
  cb.IsBoard := False;
  cb.Msg := '"'+ExtractFilePath(ParamStr(0))+'ScreenClient.exe'+'"'+
            ' '+vIP+' '+InttoStr(Screen.Width)+'*'+IntToStr(Screen.Width);
            //' '+'3'+    //颜色深度
            //' '+'1317';   //端口号
  //ShowMessage(cb.Msg);
  jfh := Copy(GetLocalHostName,1,4); //得到机房号
  for i:=0 to OnlineUserList.Count-1 do
  begin
    //ShowMessage(OnlineUserList.Strings[i]);
    cb.ReceiverIP := Trim(Copy(OnlineUserList.Strings[i],1,ii-1));
    ii := Pos('=',OnlineUserList.Strings[i]);
    //if (Trim(Copy(OnlineUserList.Strings[i],ii+1,4))=jfh) and
    if (cb.ReceiverIP<>vIp) then
    begin
      SendMsgToSrvTcp(cb);
      //ShowMessage(cb.ReceiverIP);
    end;
  end;
end;

procedure TDMForm.SetLocalHostFree(const Msg:string='');
begin
  if Is_OK then
    Exit;

  if not Srv_Is_OK then Exit;

  CUR_USER_ID := CUR_HOST;

  if vobj.Xs_Sj_Process2(CUR_USER_ID,CUR_HOST,CUR_IP,'开放') then
  begin
    Is_OK := True;
    UpdateLoginMode('开放');
    UpdateTrayIconStatus(lmFree);
    UnLockSystemByXXX; //解除系统的锁定模式

    MainForm.CoolTrayIcon1.HideMainForm;

    if Msg = '' then
       ShowHintMsg('本机房已被设为免费开放模式！　　')
    else
       ShowHintMsg(Msg);
  end;
end;

procedure TDMForm.SetLocalHostTeacher(const Msg: string);
begin
  if Is_OK then
    Exit;

  if not Srv_Is_OK then Exit;

  CUR_USER_ID := CUR_HOST;

  if vobj.Xs_Sj_Process2(CUR_USER_ID,CUR_HOST,CUR_IP,'教师') then
  begin
    Is_OK := True;
    UpdateLoginMode('教师');
    UpdateTrayIconStatus(LoginMode);
    UnLockSystemByXXX; //解除系统的锁定模式

    MainForm.CoolTrayIcon1.HideMainForm;

    if Msg = '' then
       ShowHintMsg('本机已被设为教师机模式！　　')
    else
       ShowHintMsg(Msg);
  end;
end;

function TDMForm.SetMasterNewCode(const OldCode, NewCode: string): Boolean;
begin
  if MasterCodeIsOK(OldCode) then
  begin
    SetMasterCode(NewCode);
    Result := True;
  end else
    Result := False;
end;

procedure TDMForm.SetMasterCode(const Code: string);
var
  fn:string;
begin
  fn := ExtractFilePath(ParamStr(0))+'ConnSet.DLL';
  with TIniFile.Create(fn) do
  begin
    try
      WriteString('SrvSet','Code',EnCrypt(Code));
    finally
      Free;
    end;
  end;
end;

procedure TDMForm.ShutDownProcess(const ShutDownMode:TCmdType;const IsShowMsgBox:Boolean=True); //下机处理 0:关机 1:重启 2:LogOff
var
  s:string;
begin
  if IsShowMsgBox then
  begin
    case ShutDownMode of
      ctShutDown:
         s := '你确定要下机注销并关机吗？　　';
      ctReboot:
         s := '你确定要下机注销并重启计算机吗？　　';
      ctLogoff,
      ctOffLine:
         s := '你确定要下机注销(不关机)吗？　　';
    end;

    if IsShowMsgBox then
      if MessageBox(Application.Handle, PChar(s),PChar(Application.Title), MB_YESNO + MB_ICONQUESTION) <> IDYES then
         Exit;
  end;

  try
    SendSoldierMsg;
    Screen.Cursor := crHourGlass;

    if not Connect_Srv then
    begin
       ShowHintMsg('下机处理失败！请重新注销！');
       Exit;
    end;

    //if vobj.Xs_Xj_Process(CUR_USER_ID)=False then
    if vobj.Xs_LogOut(CUR_USER_ID)=False then
    begin
      ShowHintMsg('下机处理失败！请重新注销！');
      Exit;
    end;

    CUR_USER_ID := CUR_HOST;
    //CUR_USER_ID := '';
    Is_OK := False;
    LoginMode := lmNone;

    case ShutDownMode of
      ctShutDown:  ShutDownComputer;
      ctReboot  :  RebootComputer;
      ctLogoff  :  //LogoffComputer;
//{
      begin
        MainForm.tmr_time.Enabled := True;
        MainForm.CoolTrayIcon1.ShowMainForm;
        if not TestMode then
        begin
          if not Is_OK then KillTaskByXXX;
          LockSystemByXXX;
          SetWindowPos(Application.Handle,HWND_TOPMOST,MainForm.Left,MainForm.Top,MainForm.Width,MainForm.Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
          //ShowWindow(Application.Handle,SW_HIDE);
        end;
      end;
//}
    end; //end case ... of
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure GetUserList;
begin
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

procedure ShowHintMsg(const msg:string;bShowBalloonHint:Boolean=False);
begin
  if Is_OK or bShowBalloonHint then
    MainForm.CoolTrayIcon1.ShowBalloonHint(AppName+' Ver '+Get_Version,msg,bitInfo,10)
  else if (MessageHintDisplayCount<=3) then
  with THintForm.Create(Application) do
  begin
    lbl_Hint.Caption := msg;
    Show;
  end;
end;

procedure SendMsg(const idTcpClient:TIdTCPClient;const cb:TCommBlock);//
begin
  idTcpClient.WriteBuffer(cb,SizeOf(cb));
end;

procedure SendMsgToSrvTcp(const cb:TCommBlock); //送给服务器
begin
  CoInitialize(nil);
  try
    vobj.SendMessage(cb.cmdType,cb.Msg,cb.ReceiverIP);
  finally
    CoUninitialize;
  end;
end;

procedure SendMsgToMngTcp(const cb:TCommBlock);  //送给管理机
begin
end;

function Host_Is_Linked(const vhost:string):Boolean; //某计算机是否连接上了
begin
  Result := True;
end;

procedure Send_ShutDown_To_Client(const vhost:string);  //发送关机消息
var
  cb:TCommBlock;
begin
  if Host_Is_Linked(vhost) then
  begin
    cb.cmdType := ctShutDown;
    cb.Msg := '正在关机...';
    cb.ReceiverIP := vhost;
    SendMsgToSrvTcp(cb);
  end;
end;

function Connect_Srv(IsDisplayError:Boolean=True):Boolean; //连接应用服务器
begin
  if IsDisplayError then
    Result := vobj.Srv_Is_OK
  else
    Result := Srv_Is_OK;
end;

{ TDMForm }

procedure TDMForm.Init_Variant;
var
  fn:string;
  sPath: array [0..255] of Char;
  iRound : Integer;
begin
  Tested_Count := 0; //测试MngSrv是否可用的次数
  MessageHintDisplayCount := 1;
  ErrorHintIsDisplay := False;
  fn := ExtractFilePath(ParamStr(0))+'ConnSet.DLL';

  OnlineUserList := TStringList.Create;

  with TINIFile.Create(fn) do
  begin
    try
      MngIP := ReadString('SrvSet','MngIP','172.18.4.33');
      LogDir :=  ReadString('SrvSet','LogDir','E:\SysLog');

      ListenPort := '1314';//ReadString('SrvSet','ListenPort','1314');

      try
        wsckt_Listen.Close;
        wsckt_Listen.Port := ListenPort;
        wsckt_Listen.Addr := '0.0.0.0';
        wsckt_Listen.Listen;
      except
        SaveLog('WinSocket启动失败！');
      end;
    finally
      Free;
    end;
  end;
  
  Randomize;
  iRound := 60000+Random(60000);
  tmr_OnlineCheck.Interval := iRound;
  SaveLog('Timer: '+IntToStr(tmr_OnlineCheck.Interval)+'秒！');

  //可以用这一函数得到系统的安装目录：GetJfglxtPath;
  GetWindowsDirectory(sPath,40);
  fn := sPath+'\JfglxtSet.INI';
  with TINIFile.Create(fn) do
  begin
    try
      WriteString('SYSSET','JfglxtPath',ExtractFilePath(ParamStr(0)));
    finally
      Free;
    end;
  end;
end;

procedure TDMForm.Logout;
begin
  if Srv_Is_OK then
  begin
    if Is_OK then //已登录
      vobj.Xs_LogOut(CUR_USER_ID) //vobj.Xs_Xj_Process(CUR_USER_ID)
    else //未登录
      vobj.Host_UnRegister(CUR_HOST,CUR_IP);
  end;
end;

function TDMForm.MasterCodeIsOK(const Code: string): Boolean;
begin
  Result := Code=GetMasterCode;
end;

function TDMForm.MasterPwdIsOK(const Pwd: string): Boolean;
begin
  Result := Pwd=GetMasterCode+FormatDateTime('hhnn',Now);
end;

procedure TDMForm.OnlineCheck;
begin
  if vobj.Is_Teacher_Host(CUR_HOST) and vobj.Host_Is_Jxjf(CUR_HOST) then
  begin
    SetLocalHostTeacher('本机为教师机！已开启教学模式！'); //设置本机为开放模式
    LoginMode := lmTeacher;
  end
  else if vobj.Is_FreeOpen_Host(CUR_HOST) then
  begin
    SetLocalHostFree('本机已被设为免费开放模式！'); //设置本机为开放模式
    LoginMode := lmFree;
  end
  else if not vobj.Host_Is_Registered(CUR_HOST) then  //入网登记
  begin
    vobj.Host_Register(CUR_HOST,CUR_IP);
    LoginMode := lmNone;
  end;
end;

procedure TDMForm.OnlineUserCheck;
var
  Res_SjType,Res_Msg:WideString;
  sMsg :string;
begin
  try
    if (not Is_OK) then
    begin
      CUR_USER_ID := CUR_HOST;
      if vobj.Register_Host(CUR_USER_ID,CUR_HOST,CUR_IP,Res_SjType,Res_Msg) then
      begin
        if Res_SjType='' then
          Exit;

        UpdateLoginMode(Res_SjType);
        UpdateTrayIconStatus(LoginMode);
        Is_OK := True;
        UnLockSystemByXXX; //解除系统的锁定模式

        MainForm.CoolTrayIcon1.HideMainForm;

        if (Res_SjType<>'') and (Res_Msg<>'') then
           ShowHintMsg(Res_Msg);
      end;
    end
    else 
    begin
       if (not vobj.Check_Host(CUR_USER_ID,CUR_HOST,CUR_IP,Res_SjType,Res_Msg)) then   //是本机在上机吗？非开放上机
       begin
          UpdateLoginMode(Res_SjType);
          UpdateTrayIconStatus(LoginMode);

         if (Res_SjType='自费') or (Res_SjType='') then//(Res_SjType='教学') or (Res_SjType='开放') or (Res_SjType='教师') or (Res_SjType='免费') then
         begin
           ShutDownProcess(ctLogoff,False);
           sMsg := Res_Msg;
           if sMsg<>'' then
              MessageBox(0, PChar(sMsg),'系统提示', MB_OK + MB_ICONWARNING + MB_TOPMOST);
         end
         else if (Res_Msg<>'') then
           ShowHintMsg(Res_Msg);
       end
       else
       begin
         if MainForm.CoolTrayIcon1.IconIndex=4 then
         begin
            UpdateTrayIconStatus(LoginMode);
            ShowHintMsg('  服务器重新连接......OK！  ');
         end;
         if (Res_Msg<>'') then
         begin
           ShowHintMsg(Res_Msg);
           //tmr_OnlineCheckTimer(Self);
           //OnlineCheck;  //好怕怕
         end;
         if (Res_SjType='') then  //不允许上机，会返回一个空串
         begin
           ShutDownProcess(ctLogoff,False);
         end;
         UpdateLoginMode(Res_SjType);
         UpdateTrayIconStatus(LoginMode);
       end;
    end;
  except
    //不要抛出异常
    if Is_OK then
    begin
       ShowHintMsg('服务器或网络连接失败！请与机房管理员联系！  ');
       UpdateTrayIconStatus('断开');
    end;
  end;
end;

procedure TDMForm.DataModuleCreate(Sender: TObject);
begin
  SendSoldierMsg;
  SoapConnection1.Connected := False;
  LoginMode := lmNone;
  Is_OK := False;
  GetConnInfo;
  Init_Variant;
  if TestMode then
     SendNoSoldierMsg;
end;

procedure Listen_Process(const CB:TCommBlock); //处理监听到的消息
var
  cmdstr,parastr:string;
  i:Integer;
begin
  case CB.cmdType of
    ctShutDown,
    ctReboot,
    ctLogoff,
    ctOffLine:
      begin
        DMForm.ShutDownProcess(CB.cmdType,False); //无须提示直接执行指令
      end;
    ctFreeOpen: //免费开放
      begin
        DMForm.SetLocalHostFree(cb.Msg);//设置本机为免费开放模式
      end;
    ctMessage:
      begin
        ShowHintMsg(CB.Msg);
      end;
    ctMngReady: //管理员上线了
      begin
        //ShowHintMsg('系统提示：上机状态验证中......');
        //DMForm.tmr_OnlineCheckTimer(DMForm);// .OnlineCheck;
        DMForm.OnlineUserCheck;
      end;
    ctImage: //屏幕图像
      begin
        //SendScreen;
      end;
    ctCmd: //执行命令
      begin
        cmdstr := Trim(CB.Msg);
        i := Pos(' ',cmdstr);
        if i>0 then
        begin
           parastr := Trim(Copy(cmdstr,i+1,Length(cmdstr)));
           cmdstr := Copy(cmdstr,1,i-1);
        end
        else
           parastr := '';

        //ShowMessage(cmdstr+','+parastr);

        if parastr = '' then
           ShellExecute(Application.Handle,pchar('open'),pchar(cmdstr),nil,nil,SW_SHOWNORMAL)
        else
           ShellExecute(Application.Handle,pchar('open'),pchar(cmdstr),PChar(parastr),nil,SW_SHOWNORMAL);

      end;
  end;
  //SaveLog(IntToStr(cb.cmdType)+':'+CB.Msg);  //收到消息就保存日志
end;

procedure TDMForm.FreeIdTcpClient;
begin
end;

function TDMForm.GetConnInfo: string;
var
  fn:string;
begin
  fn := ExtractFilePath(ParamStr(0))+'ConnSet.DLL';
  with TIniFile.Create(fn) do
  begin
    try
      Result := ReadString('SrvSet','SrvIP','');
      if Result='' then
      begin
        Result := 'http://localhost/jfgl/jfglWebSrv.dll/soap/IjfglClient';
        WriteString('SrvSet','SrvIP',Result);
      end;
      HTTPRIO1.URL := Result;
      SoapConnection1.URL := Result;
    finally
      Free;
    end;
  end;
end;

function TDMForm.GetMasterCode: string;
var
  fn:string;
begin
  fn := ExtractFilePath(ParamStr(0))+'ConnSet.DLL';
  with TIniFile.Create(fn) do
  begin
    try
      Result := ReadString('SrvSet','Code','');
      if Result='' then
      begin
        Result := EnCrypt('jxstnu_admin&');
        WriteString('SrvSet','Code',Result);
      end;

      Result := DeCrypt(Result);
    finally
      Free;
    end;
  end;
end;

procedure TDMForm.ResetAndInit;
begin
  //===============为了初始化================//
  FreeIdTcpClient;
  //==========================================//
  Init_Variant;
  MainForm.tmr_time.Enabled := True;
end;

procedure TDMForm.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  //try
    SaveLog('00:'+e.Message);

    //======希望它不慢了========//
    FreeClentThread;
    ResetAndInit;
    //======希望它不慢了========//

    if ErrorHintIsDisplay then
       Exit;

    if MainForm.Showing then
    begin
       MainForm.Refresh;
       Application.ProcessMessages;
    end;

    if not ErrorHintIsDisplay then //如果错误信息还没显示
    begin
      //with TErrorForm.Create(Application) do
      //begin
      //  lbl_Hint.Caption := '服务器或网络连接失败！请换机或与机房管理员联系！  ';
      //  ShowModal;
      //end;
      //ErrorHintIsDisplay := True;
      if not Is_OK then
         Application.MessageBox(PChar('服务器或网络连接失败！请与机房管理员联系！  '),PChar(Application.Title), MB_OK + MB_ICONERROR)
      else
         ShowHintMsg('服务器或网络连接失败！请与机房管理员联系！  ');
      //ErrorHintIsDisplay := False;
    end;
    UpdateTrayIconStatus(LoginMode); //更改右下角图标状态

    SaveLog('05:ApplicationEvents1Exception:关闭应用服务器将触发这个的异常');
  //except
  //end;
  //Exit;
end;

procedure TDMForm.wsckt_ListenDataAvailable(Sender: TObject; ErrCode: Word);
var
    //Buffer : array [0..1023] of char;
    Buffer : TCommBlock;
    Len    : Integer;
    Src    : TSockAddrIn;
    SrcLen : Integer;
begin
    wsckt_Listen.Addr := '0.0.0.0'; //'0.0.0.0';     { 接收任意来源IP的消息 }
    SrcLen := SizeOf(Src);
    Len    := wsckt_Listen.ReceiveFrom(@Buffer, SizeOf(Buffer), Src, SrcLen);
    if Len >= 0 then begin
      Listen_Process(Buffer);
    end;
end;

procedure SaveLog(const s: string);
var
  vdir:String;
  Fstrings:TStrings;
begin
  vdir := LogDir;
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

procedure TDMForm.FreeClentThread;
begin
end;

procedure TDMForm.DataModuleDestroy(Sender: TObject);
begin
  wsckt_Listen.Close;
  FreeAndNil(OnlineUserList);
end;

function TDMForm.EstablishProcess(const MonitorFile: string): Boolean;
var
  fSucessed:Boolean;
  //piProcInfoGPS:PROCESS_INFORMATION;
  siStartupInfo: STARTUPINFO;
  saProcess, saThread: SECURITY_ATTRIBUTES;
begin
  ZeroMemory(@siStartupInfo, sizeof(siStartupInfo));
  siStartupInfo.cb := sizeof(siStartupInfo);
  saProcess.nLength := sizeof(saProcess);
  saProcess.lpSecurityDescriptor := PChar(nil);
  saProcess.bInheritHandle := true;
  saThread.nLength := sizeof(saThread);
  saThread.lpSecurityDescriptor := PChar(nil);
  saThread.bInheritHandle := true;
  fSucessed := CreateProcess(PChar(nil), PChar(MonitorFile), @saProcess,
                            @saThread, False, CREATE_DEFAULT_ERROR_MODE,
                            Pchar(nil), Pchar(nil), siStartupInfo,
                            piProcInfoGPS);
  Result := fSucessed;
  if not fSucessed then
    SaveLog('Create Process '+MonitorFile+' 失败.')  //实际应用中应改为写Log文件更好
  else
    SaveLog('Create Process '+MonitorFile+' 成功.'); //实际应用中应改为写Log文件更好
end;

procedure TDMForm.ApplicationEvents1Minimize(Sender: TObject);
begin
  if not Is_OK then
    MainForm.Show;
end;

procedure CloseErrorMsgBox;
var
  vhwnd :HWND;
begin
  if ErrorHintIsDisplay then
  begin
    vhwnd := FindWindow(nil,PChar(Application.Title));
    if vhwnd<>0 then
      PostMessage(vhWnd,WM_CLOSE,0,0);
    ErrorHintIsDisplay := False;
  end;
end;

procedure TDMForm.tmr_SoldierTimer(Sender: TObject);
begin
end;
//============================================================}

procedure TDMForm.UpdateLoginMode(const SjType:string='');
var
  s:string;
begin
  if LoginMode in [lmSystem] then
    Exit;

  if SjType='' then
  begin
    if Srv_Is_OK then
      s := vobj.Get_Xs_Sj_Type(CUR_USER_ID)
    else
      Exit;
  end else
    s := SjType;

  if s='教学' then
    LoginMode := lmTeach
  else if s='自费' then
    LoginMode := lmMonery
  else if s='教师' then
    LoginMode := lmTeacher
  else if s='开放' then
    LoginMode := lmFree
  else if s='管理' then
    LoginMode := lmSystem
  else
    LoginMode := lmNone;
end;

procedure TDMForm.UpdateTrayIconStatus(const LoginMode: TLoginMode);
begin
  if LoginMode=lmNone then
    MainForm.CoolTrayIcon1.IconIndex := 0
  else if LoginMode in [lmTeach,lmTeacher] then
    MainForm.CoolTrayIcon1.IconIndex := 1
  else if LoginMode=lmMonery then
    MainForm.CoolTrayIcon1.IconIndex := 2
  else if LoginMode in [lmFree,lmSystem] then
    MainForm.CoolTrayIcon1.IconIndex := 3
  else
    MainForm.CoolTrayIcon1.IconIndex := 4;
end;

procedure TDMForm.UpdateTrayIconStatus(const sStatus:String);
begin
  if sStatus = '' then
    MainForm.CoolTrayIcon1.IconIndex := 0
  else if (sStatus='教学') or (sStatus='教师') then
    MainForm.CoolTrayIcon1.IconIndex := 1
  else if sStatus='自费' then
    MainForm.CoolTrayIcon1.IconIndex := 2
  else if (sStatus='开放') or (LoginMode=lmSystem) then
    MainForm.CoolTrayIcon1.IconIndex := 3
  else
    MainForm.CoolTrayIcon1.IconIndex := 4;
end;

procedure TDMForm.tmr_OnlineCheckTimer(Sender: TObject);
var
  Res_SjType:WideString;
begin
  if LoginMode in [lmFree,lmSystem] then Exit;

  if (not Is_OK) and MainForm.Showing and (not Application.Active) then
  begin
    Application.BringToFront;
    //Exit;
  end;
  if not Is_OK then KillTaskByXXX;

  if Is_OK and (not ExeIsRunning('Explorer.exe')) then
  begin
    WinExec('explorer.exe',SW_SHOWNORMAL);
    InjoinDLL;
  end;

  if Is_OK then
  begin
    if not Srv_Is_OK then
    begin
      if (Tested_Count<10) then
      begin
        ShowHintMsg('服务器连接中断！正在重新连接......');
        Inc(Tested_Count);
        UpdateTrayIconStatus('断开');
      end else  //; else if Is_OK then LogOut;
      begin
        Tested_Count := 0;
        Is_OK := False;
        MainForm.CoolTrayIcon1.ShowMainForm;  //应该弹出主窗口了
      end;
      Exit;
    end
    else if (Tested_Count>0) then //已登录了并且网络曾经中断过，因为Tested_Count是尝试连接的次数
    begin
      Tested_Count := 0; //尝试连接复位
      ShowHintMsg('  服务器重新连接......OK！  ');
      UpdateTrayIconStatus(LoginMode); //更改右下角图标状态
    end;
  end;

  OnlineUserCheck;
end;

function Is_Allow_Xs_Update_Info:Boolean;
begin
  try
    Result := vobj.Is_Allow_Xs_Update_Info;
  except
    Result := False;
  end;
end;

initialization
  CUR_HOST := GetLocalHostName;
  CUR_IP := GetLocalIPStr;

end.


