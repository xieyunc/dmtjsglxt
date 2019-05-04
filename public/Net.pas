unit Net;
{=========================================================================
�� ��: ���纯����
ʱ ��: 2002/10/02
�� ��: 1.0
�� ע: û������ɣ�����дд������һЩ���纯�������ʹ�á�
ϣ������ܼ�������
  ���纯���󹫿�
zsy_good (ֻҪ�ᶨ���Ƶ�����ȥ����һ����ɹ�)
=========================================================================}
interface
uses
  SysUtils
  , Windows
  , dialogs
  , winsock
  , Classes
  , ComObj
  , WinInet
  , Variants
  , Forms
  ;
//������Ϣ����
const
  C_Err_GetLocalIp = '��ȡ����ipʧ��';
  C_Err_GetNameByIpAddr = '��ȡ������ʧ��';
  C_Err_GetSQLServerList = '��ȡSQLServer������ʧ��';
  C_Err_GetUserResource = '��ȡ������ʧ��';
  C_Err_GetGroupList = '��ȡ���й�����ʧ��';
  C_Err_GetGroupUsers = '��ȡ�����������м����ʧ��';
  C_Err_GetNetList = '��ȡ������������ʧ��';
  C_Err_CheckNet = '���粻ͨ';
  C_Err_CheckAttachNet = 'δ��������';
  C_Err_InternetConnected = 'û������';
  C_Txt_CheckNetSuccess = '���糩ͨ';
  C_Txt_CheckAttachNetSuccess = '�ѵ�������';
  C_Txt_InternetConnected = '������';
  
//�õ�����MAC��ַ
function GetMacAddress: string;
//�õ����ػ�����
function GetLocalHostName(): string;
//�õ������ľ�����Ip��ַ
function GetLocalIp(var LocalIp: string): Boolean;
//�õ������ľ�����Ip��ַ
function GetLocalIpStr(): string;
//ͨ��Ip���ػ�����
function GetNameByIPAddr(IPAddr: string; var MacName: string): Boolean;
//��ȡ������SQLServer�б�
function GetSQLServerList(var List: Tstringlist): Boolean;
//��ȡ�����е�������������
function GetNetList(var List: Tstringlist): Boolean;
//��ȡ�����еĹ�����
function GetGroupList(var List: TStringList): Boolean;
//��ȡ�����������м����
function GetUsers(GroupName: string; var List: TStringList): Boolean;
//��ȡ�����е���Դ
function GetUserResource(IpAddr: string; var List: TStringList): Boolean;
//ӳ������������
function NetAddConnection(NetPath: Pchar; PassWord: Pchar; LocalPath: Pchar): Boolean;
//�������״̬
function CheckNet(IpAddr: string): Boolean;
//�������Ƿ��������
function CheckMacAttachNet: Boolean;
//�ж�IpЭ����û�а�װ �������������
function IsIPInstalled: boolean;
//�������Ƿ�����
function InternetConnected: Boolean;
//TStringsת����String
function StringsToStr(const vList:TStrings):string;
//Stringת����TStrings
function StrToStrings(const Str:string;var vList:TStrings):Integer;
function Get_Version: String;
//��ʽ��IP�ַ���
function FormatIP(const sIp:string;const ToLong:Boolean=True):string;

function SelectFolder(const Caption: string; const Root: WideString;
    var Directory: string): boolean;//ѡ���ļ��У��ɱ�����һ��״̬

function RunAndWait(FileName: string; Visibility: Integer): THandle; //ִ���ⲿ���򲢵ȴ�����
function PosRight(const sSubStr,sSourStr:string):Integer;

function GetSpecialFolderDir(const folderid:integer):string;
function GetWindowsVersion:string; //�õ�windows�汾

implementation
uses ShlObj,ActiveX,Registry;

function GetSpecialFolderDir(const folderid:integer):string;
var
  pidl:pItemIDList;
  buffer:array [ 0..255 ] of char ;
begin
  //ȡָ�����ļ�����Ŀ��
  SHGetSpecialFolderLocation( application.Handle , folderid, pidl);
  SHGetPathFromIDList(pidl, buffer);    //ת�����ļ�ϵͳ��·��
  Result:=strpas(buffer);
{
    ���У�folderid����ȡ�����ֵ��������ע�⣬��Щ������ļ��У������ļ�ϵͳ
    ��һ���֣�������SHGetPathFromIDList��ȡ����·���ģ������ڴ�Ҳ�г��ˡ���'*'
    ��Ϊ�����������ļ�ϵͳ��Ӧ���������á�
    CSIDL_BITBUCKET         *   ����վ
    CSIDL_CONTROLS          *   �������
    CSIDL_DESKTOP           *   ����
    CSIDL_DESKTOPDIRECTORY      ����Ŀ¼       //��C:\WINDOWS\Desktop
    CSIDL_DRIVES            *   �ҵĵ���
    CSIDL_FONTS                 ����           //��C:\WINDOWS\FONTS
    CSIDL_NETHOOD               �����ھ�Ŀ¼   //��C:\WINDOWS\NetHood
    CSIDL_NETWORK           *   �����ھ�
    CSIDL_PERSONAL              �ҵ��ĵ�       //��C:\My Documents
    CSIDL_PRINTERS          *   ��ӡ��
    CSIDL_PROGRAMS              ������         //��C:\WINDOWS\Start Menu\Programs
    CSIDL_RECENT                ����ĵ�       //��C:\WINDOWS\Recent
    CSIDL_SENDTO                ���͵�         //��C:\WINDOWS\SentTo
    CSIDL_STARTMENU             ��ʼ�˵�       //��C:\WINDOWS\Start Menu
    CSIDL_STARTUP               ����           //��C:\WINDOWS\����
    CSIDL_TEMPLATES             ģ��           //��C:\WINDOWS\ShellNe
}
end;

function GetWindowsVersion:string;
begin
  //>=4.0 ��Windows 98/Me,5.0��WINDOWS 2000��5.1��WINDOWS XP 5.2��Windows 2003
  if (SysUtils.Win32MajorVersion>=4) and
     (SysUtils.Win32Platform=VER_PLATFORM_WIN32_WINDOWS) then
    Result := 'Windows 9x/Me'
  else if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) and
          (SysUtils.Win32MajorVersion=5) and
          (SysUtils.Win32MinorVersion=0) then
    Result := 'Windows 2000'
  else if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) and
          (SysUtils.Win32MajorVersion=5) and
          (SysUtils.Win32MinorVersion=1) then
    Result := 'Windows XP'
  else if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) and
          (SysUtils.Win32MajorVersion=5) and
          (SysUtils.Win32MinorVersion=2) then
    Result := 'Windows 2003'
  else if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) and
          (SysUtils.Win32MajorVersion>5) and
          (SysUtils.Win32MinorVersion>=0) then
    Result := 'Windows 2003 Later'
  else
    Result := 'Unknow Windows';
end;

function PosRight(const sSubStr,sSourStr:string):integer;
var
  i,iLen: Integer;
begin
  Result := 0;
  iLen := Length(sSubStr);
  i := Length(sSourStr);
  while i > 0 do
  begin
    if Copy(sSourStr,i,iLen)=sSubStr then
    begin
      Result := i;
      Break;
    end else
      i := i-1;
  end;
end;

function Get_Version: String;
var
  VerInfoSize,VerValueSize,Dummy:Dword;
  VerInfo:Pointer;
  VerValue:PVSFixedFileInfo;
  sVer:String;V1,V2,V3,V4:word;
begin
  VerInfo := nil;
  VerInfoSize := 0;
  try
    sVer := ParamStr(0);
    VerInfoSize:=GetFileVersionInfoSize(Pchar(sVer),Dummy);
    sVer := '';
    GetMem(VerInfo,VerInfoSize);
    GetFileVersionInfo(PChar(ParamStr(0)),0,VerInfoSize,VerInfo);
    VerQueryValue(VerInfo,'\',Pointer(VerValue),VerValueSize);
    With   VerValue^   do
    begin
        V1:=dwFileVersionMS   shr   16;
        V2:=dwFileVersionMS   and   $FFFF;
        V3:=dwFileVersionLS   shr   16;
        V4:=dwFileVersionLS   and   $FFFF;
    end;
    FreeMem(VerInfo,VerInfoSize);
    sVer:=IntToStr(V1) + '.' + IntToStr(V2)+ '.' + IntToStr(V3) + '.'+IntToStr(V4);
    Result := sVer;
  except
    FreeMem(VerInfo,VerInfoSize);
  end;
end;

function FormatIP(const sIp:string;const ToLong:Boolean=True):string;
var
  i: Integer;
  //ACount :Integer;
  AStrings: TStringList;
  s: string;
begin
  AStrings := TStringList.Create;
  try
    s := '';
    //ACount := ExtractStrings(['.'], [], PChar(sIp), AStrings);
    ExtractStrings(['.'], [], PChar(sIp), AStrings);
    for i := 0 to AStrings.Count - 1 do
    begin
      if ToLong then
        s := s+Format('%.3d',[StrToIntDef(AStrings[i],0)])+'.'
      else
        s := s+Format('%d',[StrToIntDef(AStrings[i],0)])+'.';
    end;
    Result := Copy(s,1,Length(s)-1);
  finally
    AStrings.Free;
  end;
end;

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
    if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
    result := 0;
end;

function SelectFolder(const Caption: string; const Root: WideString;
    var Directory: string): boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
        POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        hwndOwner := Application.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS+BIF_NEWDIALOGSTYLE;;
        if Directory <> '' then
        begin
          lpfn := SelectDirCB;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        SetErrorMode(OldErrorMode);
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
        ShellMalloc.Free(Buffer);
    end;
  end;
end;

function GetMacAddress: string;
var
  Lib: Cardinal; 
  Func: function(GUID: PGUID): Longint; stdcall; 
  GUID1, GUID2: TGUID; 
begin
  Result := '';
  Lib := LoadLibrary('rpcrt4.dll');
  if Lib <> 0 then
  begin 
    if Win32Platform <>VER_PLATFORM_WIN32_NT then 
      @Func := GetProcAddress(Lib, 'UuidCreate') 
      else @Func := GetProcAddress(Lib, 'UuidCreateSequential'); 
    if Assigned(Func) then 
    begin 
      if (Func(@GUID1) = 0) and 
        (Func(@GUID2) = 0) and 
        (GUID1.D4[2] = GUID2.D4[2]) and 
        (GUID1.D4[3] = GUID2.D4[3]) and 
        (GUID1.D4[4] = GUID2.D4[4]) and 
        (GUID1.D4[5] = GUID2.D4[5]) and 
        (GUID1.D4[6] = GUID2.D4[6]) and 
        (GUID1.D4[7] = GUID2.D4[7]) then 
      begin 
        Result := 
         IntToHex(GUID1.D4[2], 2) + '-' + 
         IntToHex(GUID1.D4[3], 2) + '-' + 
         IntToHex(GUID1.D4[4], 2) + '-' + 
         IntToHex(GUID1.D4[5], 2) + '-' + 
         IntToHex(GUID1.D4[6], 2) + '-' + 
         IntToHex(GUID1.D4[7], 2); 
      end; 
    end; 
    FreeLibrary(Lib); 
  end; 
end;

function RunAndWait(FileName: string; Visibility: Integer): THandle;
var
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  sCmdLine,WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  try
    sCmdLine := FileName+' '+Get_Version;
    StrPCopy(zAppName, sCmdLine);
    GetDir(0, WorkDir);
    StrPCopy(zCurDir, WorkDir);
    FillChar(StartupInfo, SizeOf(StartupInfo), #0);
    StartupInfo.cb := SizeOf(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := Visibility;

    //if not CreateProcess(nil,pchar(sCmdLine), nil, nil, false, Create_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
    if not CreateProcess(nil,zAppName, nil, nil, false, Create_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
    begin
      Result := 0;
      Exit;
    end
    else
    begin
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      GetExitCodeProcess(ProcessInfo.hProcess, Result);
      Application.ProcessMessages;
    end;
  finally
  end;
end;
{=================================================================
�� ��: �������Ƿ��������
�� ��: ��
����ֵ: �ɹ�: True ʧ��: False
�� ע:
�� ��:
1.0 2002/10/03 09:55:00
=================================================================}
function CheckMacAttachNet: Boolean;
begin
  Result := False;
  if GetSystemMetrics(SM_NETWORK) <> 0 then
    Result := True;
end;

{=================================================================
�� ��: ���ر����ľ�����Ip��ַ
�� ��: ��
����ֵ: �ɹ�: True, �����LocalIp ʧ��: False
�� ע:
�� ��:
1.0 2002/10/02 21:05:00
=================================================================}
function GetLocalHostName(): string;
var
  s: array[1..127] of Char;
  i: DWORD;
begin
  i := 127;
  GetComputerName(@s, i);
  Result := StrPas(@s);
end;

//�õ������ľ�����Ip��ַ
function GetLocalIpStr(): String;
var
  s:string;
begin
  if GetLocalIp(s) then
    Result := s
  else
    Result := '';
end;

function GetLocalIP(var LocalIp: string): Boolean;
var
  HostEnt: PHostEnt;
  Ip: string;
  addr: pchar;
  Buffer: array[0..63] of char;
  GInitData: TWSADATA;
begin
  Result := False;
  try
    WSAStartup(2, GInitData);
    GetHostName(Buffer, SizeOf(Buffer));
    HostEnt := GetHostByName(buffer);
    if HostEnt = nil then Exit;
    addr := HostEnt^.h_addr_list^;
    ip := Format('%d.%d.%d.%d', [byte(addr[0]),
      byte(addr[1]), byte(addr[2]), byte(addr[3])]);
    LocalIp := Ip;
    Result := True;
  finally
    WSACleanup;
  end;
end;

{=================================================================
�� ��: ͨ��Ip���ػ�����
�� ��:
IpAddr: ��Ҫ�õ����ֵ�Ip
����ֵ: �ɹ�: ������ ʧ��: ''
�� ע:
inet_addr function converts a string containing an Internet
Protocol dotted address into an in_addr.
�� ��:
1.0 2002/10/02 22:09:00
=================================================================}
function GetNameByIPAddr(IPAddr: string; var MacName: string): Boolean;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  Result := False;
  if IpAddr = '' then exit;
  try
    WSAStartup(2, WSAData);
    SockAddrIn.sin_addr.s_addr := inet_addr(PChar(IPAddr));
    HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
    if HostEnt <> nil then
      MacName := StrPas(Hostent^.h_name);
    Result := True;
  finally
    WSACleanup;
  end;
end;

{=================================================================
�� ��: ����������SQLServer�б�
�� ��:
List: ��Ҫ����List
����ֵ: �ɹ�: True,�����List ʧ�� False
�� ע:
�� ��:
1.0 2002/10/02 22:44:00
=================================================================}
function GetSQLServerList(var List: Tstringlist): boolean;
var
  i: integer;
  //sRetValue: string;
  SQLServer: Variant;
  ServerList: Variant;
begin
  //Result := False;
  List.Clear;
  try
    SQLServer := CreateOleObject('SQLDMO.Application');
    ServerList := SQLServer.ListAvailableSQLServers;
    for i := 1 to Serverlist.Count do
      list.Add(Serverlist.item(i));
    Result := True;
  finally
    SQLServer := NULL;
    ServerList := NULL;
  end;
end;

{=================================================================
�� ��: �ж�IpЭ����û�а�װ
�� ��: ��
����ֵ: �ɹ�: True ʧ��: False;
�� ע: �ú�����������
�� ��:
1.0 2002/10/02 21:05:00
=================================================================}
function IsIPInstalled: boolean;
var
  WSData: TWSAData;
  ProtoEnt: PProtoEnt;
begin
  Result := True;
  try
    if WSAStartup(2, WSData) = 0 then
    begin
      ProtoEnt := GetProtoByName('IP');
      if ProtoEnt = nil then
        Result := False
    end;
  finally
    WSACleanup;
  end;
end;

{=================================================================
�� ��: ���������еĹ�����Դ
�� ��:
IpAddr: ����Ip
List: ��Ҫ����List
����ֵ: �ɹ�: True,�����List ʧ��: False;
�� ע:
WNetOpenEnum function starts an enumeration of network
resources or existing connections.
WNetEnumResource function continues a network-resource
enumeration started by the WNetOpenEnum function.
�� ��:
1.0 2002/10/03 07:30:00
=================================================================}

function GetUserResource(IpAddr: string; var List: TStringList): Boolean;
type
  TNetResourceArray = ^TNetResource; //�������͵�����
var
  i: Integer;
  Buf: Pointer;
  Temp: TNetResourceArray;
  lphEnum: THandle;
  NetResource: TNetResource;
  Count, BufSize, Res: DWord;
begin
  Buf := nil;
  Result := False;
  List.Clear;
  if copy(Ipaddr, 0, 2) <> '\' then
    IpAddr := '\' + IpAddr; //���Ip��ַ��Ϣ
  FillChar(NetResource, SizeOf(NetResource), 0); //��ʼ����������Ϣ
  NetResource.lpRemoteName := @IpAddr[1]; //ָ�����������
  //��ȡָ���������������Դ���
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY,
    RESOURCEUSAGE_CONNECTABLE, @NetResource, lphEnum);
  if Res <> NO_ERROR then exit; //ִ��ʧ��
  while True do //�о�ָ���������������Դ
  begin
    Count := $FFFFFFFF; //������Դ��Ŀ
    BufSize := 8192; //��������С����Ϊ8K
    GetMem(Buf, BufSize); //�����ڴ棬���ڻ�ȡ��������Ϣ
    //��ȡָ���������������Դ����
    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
    if Res = ERROR_NO_MORE_ITEMS then break; //��Դ�о����
    if (Res <> NO_ERROR) then Exit; //ִ��ʧ��
    Temp := TNetResourceArray(Buf);
    for i := 0 to Count - 1 do
    begin
      //��ȡָ��������еĹ�����Դ���ƣ�+2��ʾɾ��"\"��
      //��\192.168.0.1 => 192.168.0.1
      List.Add(Temp^.lpRemoteName + 2);
      Inc(Temp);
    end;
  end;
  Res := WNetCloseEnum(lphEnum); //�ر�һ���о�
  if Res <> NO_ERROR then exit; //ִ��ʧ��
  Result := True;
  FreeMem(Buf);
end;

{=================================================================
�� ��: ���������еĹ�����
�� ��:
List: ��Ҫ����List
����ֵ: �ɹ�: True,�����List ʧ��: False;
�� ע:
�� ��:
1.0 2002/10/03 08:00:00
=================================================================}
function GetGroupList(var List: TStringList): Boolean;
type
  TNetResourceArray = ^TNetResource; //�������͵�����
var
  NetResource: TNetResource;
  Buf: Pointer;
  Count, BufSize, Res: DWORD;
  lphEnum: THandle;
  p: TNetResourceArray;
  i, j: SmallInt;
  NetworkTypeList: TList;
begin
  Result := False;
  NetworkTypeList := TList.Create;
  List.Clear;
  //��ȡ���������е��ļ���Դ�ľ����lphEnumΪ��������
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
    RESOURCEUSAGE_CONTAINER, nil, lphEnum);
  if Res <> NO_ERROR then exit; //Raise Exception(Res);//ִ��ʧ��
  //��ȡ���������е�����������Ϣ
  Count := $FFFFFFFF; //������Դ��Ŀ
  BufSize := 8192; //��������С����Ϊ8K
  GetMem(Buf, BufSize); //�����ڴ棬���ڻ�ȡ��������Ϣ
  Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
  //��Դ�о���� //ִ��ʧ��
  if (Res = ERROR_NO_MORE_ITEMS) or (Res <> NO_ERROR) then Exit;
  P := TNetResourceArray(Buf);
  for i := 0 to Count - 1 do //��¼�����������͵���Ϣ
  begin
    NetworkTypeList.Add(p);
    Inc(P);
  end;
  Res := WNetCloseEnum(lphEnum); //�ر�һ���о�
  if Res <> NO_ERROR then exit;
  for j := 0 to NetworkTypeList.Count - 1 do //�г��������������е����й���������
  begin //�г�һ�����������е����й���������
    NetResource := TNetResource(NetworkTypeList.Items[J]^); //����������Ϣ
    //��ȡĳ���������͵��ļ���Դ�ľ����NetResourceΪ����������Ϣ��lphEnumΪ��������
    Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
      RESOURCEUSAGE_CONTAINER, @NetResource, lphEnum);
    if Res <> NO_ERROR then break; //ִ��ʧ��
    while true do //�о�һ���������͵����й��������Ϣ
    begin
      Count := $FFFFFFFF; //������Դ��Ŀ
      BufSize := 8192; //��������С����Ϊ8K
      GetMem(Buf, BufSize); //�����ڴ棬���ڻ�ȡ��������Ϣ
      //��ȡһ���������͵��ļ���Դ��Ϣ��
      Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
      //��Դ�о���� //ִ��ʧ��
      if (Res = ERROR_NO_MORE_ITEMS) or (Res <> NO_ERROR) then break;
      P := TNetResourceArray(Buf);
      for i := 0 to Count - 1 do //�оٸ������������Ϣ
      begin
        List.Add(StrPAS(P^.lpRemoteName)); //ȡ��һ�������������
        Inc(P);
      end;
    end;
    Res := WNetCloseEnum(lphEnum); //�ر�һ���о�
    if Res <> NO_ERROR then break; //ִ��ʧ��
  end;
  Result := True;
  FreeMem(Buf);
  NetworkTypeList.Destroy;
end;

{=================================================================
�� ��: �оٹ����������еļ����
�� ��:
List: ��Ҫ����List
����ֵ: �ɹ�: True,�����List ʧ��: False;
�� ע:
�� ��:
1.0 2002/10/03 08:00:00
=================================================================}
function GetUsers(GroupName: string; var List: TStringList): Boolean;
type
  TNetResourceArray = ^TNetResource; //�������͵�����
var
  i: Integer;
  Buf: Pointer;
  Temp: TNetResourceArray;
  lphEnum: THandle;
  NetResource: TNetResource;
  Count, BufSize, Res: DWord;
begin
  Buf := nil;
  Result := False;
  List.Clear;
  FillChar(NetResource, SizeOf(NetResource), 0); //��ʼ����������Ϣ
  NetResource.lpRemoteName := @GroupName[1]; //ָ������������
  NetResource.dwDisplayType := RESOURCEDISPLAYTYPE_SERVER; //����Ϊ�������������飩
  NetResource.dwUsage := RESOURCEUSAGE_CONTAINER;
  NetResource.dwScope := RESOURCETYPE_DISK; //�о��ļ���Դ��Ϣ
  //��ȡָ���������������Դ���
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
    RESOURCEUSAGE_CONTAINER, @NetResource, lphEnum);
  if Res <> NO_ERROR then Exit; //ִ��ʧ��
  while True do //�о�ָ���������������Դ
  begin
    Count := $FFFFFFFF; //������Դ��Ŀ
    BufSize := 8192; //��������С����Ϊ8K
    GetMem(Buf, BufSize); //�����ڴ棬���ڻ�ȡ��������Ϣ
    //��ȡ���������
    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
    if Res = ERROR_NO_MORE_ITEMS then break; //��Դ�о����
    if (Res <> NO_ERROR) then Exit; //ִ��ʧ��
    Temp := TNetResourceArray(Buf);
    for i := 0 to Count - 1 do //�оٹ�����ļ��������
    begin
      //��ȡ������ļ�������ƣ�+2��ʾɾ��"\"����\wangfajun=>wangfajun
      List.Add(Temp^.lpRemoteName + 2);
      inc(Temp);
    end;
  end;
  Res := WNetCloseEnum(lphEnum); //�ر�һ���о�
  if Res <> NO_ERROR then exit; //ִ��ʧ��
  Result := True;
  FreeMem(Buf);
end;

{=================================================================
�� ��: �о�������������
�� ��:
List: ��Ҫ����List
����ֵ: �ɹ�: True,�����List ʧ��: False;
�� ע:
�� ��:
1.0 2002/10/03 08:54:00
=================================================================}
function GetNetList(var List: Tstringlist): Boolean;
type
  TNetResourceArray = ^TNetResource; //�������͵�����
var
  p: TNetResourceArray;
  Buf: Pointer;
  i: SmallInt;
  lphEnum: THandle;
  //NetResource: TNetResource;
  Count, BufSize, Res: DWORD;
begin
  Result := False;
  List.Clear;
  Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
    RESOURCEUSAGE_CONTAINER, nil, lphEnum);
  if Res <> NO_ERROR then exit; //ִ��ʧ��
  Count := $FFFFFFFF; //������Դ��Ŀ
  BufSize := 8192; //��������С����Ϊ8K
  GetMem(Buf, BufSize); //�����ڴ棬���ڻ�ȡ��������Ϣ
  Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize); //��ȡ����������Ϣ
  //��Դ�о���� //ִ��ʧ��
  if (Res = ERROR_NO_MORE_ITEMS) or (Res <> NO_ERROR) then Exit;
  P := TNetResourceArray(Buf);
  for i := 0 to Count - 1 do //��¼�����������͵���Ϣ
  begin
    List.Add(p^.lpRemoteName);
    Inc(P);
  end;
  Res := WNetCloseEnum(lphEnum); //�ر�һ���о�
  if Res <> NO_ERROR then exit; //ִ��ʧ��
  Result := True;
  FreeMem(Buf); //�ͷ��ڴ�
end;

{=================================================================
�� ��: ӳ������������
�� ��:
NetPath: ��Ҫӳ�������·��
Password: ��������
Localpath ����·��
����ֵ: �ɹ�: True ʧ��: False;
�� ע:
�� ��:
1.0 2002/10/03 09:24:00
=================================================================}
function NetAddConnection(NetPath: Pchar; PassWord: Pchar
  ; LocalPath: Pchar): Boolean;
var
  Res: Dword;
begin
  Result := False;
  Res := WNetAddConnection(NetPath, Password, LocalPath);
  if Res <> No_Error then exit;
  Result := True;
end;

{=================================================================
�� ��: �������״̬
�� ��:
IpAddr: ������������������IP��ַ�����ƣ�����ʹ��Ip
����ֵ: �ɹ�: True ʧ��: False;
�� ע:
�� ��:
1.0 2002/10/03 09:40:00
=================================================================}
function CheckNet(IpAddr: string): Boolean;
type
  PIPOptionInformation = ^TIPOptionInformation;
  TIPOptionInformation = packed record
    TTL: Byte; // Time To Live (used for traceroute)
    TOS: Byte; // Type Of Service (usually 0)
    Flags: Byte; // IP header flags (usually 0)
    OptionsSize: Byte; // Size of options data (usually 0, max 40)
    OptionsData: PChar; // Options data buffer
  end;
  PIcmpEchoReply = ^TIcmpEchoReply;
  TIcmpEchoReply = packed record
    Address: DWord; // replying address
    Status: DWord; // IP status value (see below)
    RTT: DWord; // Round Trip Time in milliseconds
    DataSize: Word; // reply data size
    Reserved: Word;
    Data: Pointer; // pointer to reply data buffer
    Options: TIPOptionInformation; // reply options
  end;
  TIcmpCreateFile = function: THandle; stdcall;
  TIcmpCloseHandle = function(IcmpHandle: THandle): Boolean; stdcall;
  TIcmpSendEcho = function(
    IcmpHandle: THandle;
    DestinationAddress: DWord;
    RequestData: Pointer;
    RequestSize: Word;
    RequestOptions: PIPOptionInformation;
    ReplyBuffer: Pointer;
    ReplySize: DWord;
    Timeout: DWord
    ): DWord; stdcall;
const
  Size = 32;
  TimeOut = 1000;
var
  wsadata: TWSAData;
  Address: DWord; // Address of host to contact
  HostName, HostIP: string; // Name and dotted IP of host to contact
  Phe: PHostEnt; // HostEntry buffer for name lookup
  BufferSize, nPkts: Integer;
  pReqData, pData: Pointer;
  pIPE: PIcmpEchoReply; // ICMP Echo reply buffer
  IPOpt: TIPOptionInformation; // IP Options for packet to send
const
  IcmpDLL = 'icmp.dll';
var
  hICMPlib: HModule;
  IcmpCreateFile: TIcmpCreateFile;
  IcmpCloseHandle: TIcmpCloseHandle;
  IcmpSendEcho: TIcmpSendEcho;
  hICMP: THandle; // Handle for the ICMP Calls
begin
  // initialise winsock
  Result := True;
  if WSAStartup(2, wsadata) <> 0 then begin
    Result := False;
    halt;
  end;
  // register the icmp.dll stuff
  hICMPlib := loadlibrary(icmpDLL);
  if hICMPlib <> null then begin
    @ICMPCreateFile := GetProcAddress(hICMPlib, 'IcmpCreateFile');
    @IcmpCloseHandle := GetProcAddress(hICMPlib, 'IcmpCloseHandle');
    @IcmpSendEcho := GetProcAddress(hICMPlib, 'IcmpSendEcho');
    if (@ICMPCreateFile = nil) or (@IcmpCloseHandle = nil) or (@IcmpSendEcho = nil) then begin
      Result := False;
      halt;
    end;
    hICMP := IcmpCreateFile;
    if hICMP = INVALID_HANDLE_VALUE then begin
      Result := False;
      halt;
    end;
  end else begin
    Result := False;
    halt;
  end;
  // ------------------------------------------------------------
  Address := inet_addr(PChar(IpAddr));
  if (Address = INADDR_NONE) then begin
    Phe := GetHostByName(PChar(IpAddr));
    if Phe = nil then Result := False
    else begin
      Address := longint(plongint(Phe^.h_addr_list^)^);
      HostName := Phe^.h_name;
      HostIP := StrPas(inet_ntoa(TInAddr(Address)));
    end;
  end
  else begin
    Phe := GetHostByAddr(@Address, 4, PF_INET);
    if Phe = nil then Result := False;
  end;
  if Address = INADDR_NONE then
  begin
    Result := False;
  end;
  // Get some data buffer space and put something in the packet to send
  BufferSize := SizeOf(TICMPEchoReply) + Size;
  GetMem(pReqData, Size);
  GetMem(pData, Size);
  GetMem(pIPE, BufferSize);
  FillChar(pReqData^, Size, $AA);
  pIPE^.Data := pData;
  // Finally Send the packet
  FillChar(IPOpt, SizeOf(IPOpt), 0);
  IPOpt.TTL := 64;
  NPkts := IcmpSendEcho(hICMP, Address, pReqData, Size,
    @IPOpt, pIPE, BufferSize, TimeOut);
  if NPkts = 0 then Result := False;
  // Free those buffers
  FreeMem(pIPE); FreeMem(pData); FreeMem(pReqData);
  // --------------------------------------------------------------
  IcmpCloseHandle(hICMP);
  FreeLibrary(hICMPlib);
  // free winsock
  if WSACleanup <> 0 then Result := False;
end;

{=================================================================
�� ��: ��������Ƿ�����
�� ��: ��
����ֵ: �ɹ�: True ʧ��: False;
�� ע: uses Wininet
�� ��:
1.0 2002/10/07 13:33:00
=================================================================}
function InternetConnected: Boolean;
const
  // local system uses a modem to connect to the Internet.
  INTERNET_CONNECTION_MODEM = 1;
  // local system uses a local area network to connect to the Internet.
  INTERNET_CONNECTION_LAN = 2;
  // local system uses a proxy server to connect to the Internet.
  INTERNET_CONNECTION_PROXY = 4;
  // local system's modem is busy with a non-Internet connection.
  INTERNET_CONNECTION_MODEM_BUSY = 8;
var
  dwConnectionTypes: DWORD;
begin
  dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN
  + INTERNET_CONNECTION_PROXY;
  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
end;

//�ر���������
function NetCloseAll: boolean;
const
  NETBUFF_SIZE = $208;
type
  NET_API_STATUS = DWORD;
  LPByte = PByte;
var
  dwNetRet: DWORD;
  i: integer;
  dwEntries: DWORD;
  dwTotalEntries: DWORD;
  szClient: LPWSTR;
  dwUserName: DWORD;
  Buff: array[0..NETBUFF_SIZE - 1] of byte;
  Adword: array[0..NETBUFF_SIZE div 4 - 1] of dword;
  NetSessionEnum: function(ServerName: LPSTR;
    Reserved: DWORD;
    Buf: LPByte;
    BufLen: DWORD;
    ConnectionCount: LPDWORD;
    ConnectionToltalCount: LPDWORD): NET_API_STATUS;
  stdcall;
  NetSessionDel: function(ServerName: LPWSTR;
    UncClientName: LPWSTR;
    UserName: dword): NET_API_STATUS;
  stdcall;
  LibHandle: THandle;
begin
  Result := false;
  try
    { ���� DLL }
    LibHandle := LoadLibrary('svrapi.dll');
    try
      { �������ʧ�ܣ�LibHandle = 0.}
      if LibHandle = 0 then
        raise Exception.Create('���ܼ���SVRAPI.DLL');
      { DLL ���سɹ���ȡ�õ� DLL �������������Ȼ����� }
      @NetSessionEnum := GetProcAddress(LibHandle, 'NetSessionEnum');
      @NetSessionDel := GetProcAddress(LibHandle, 'NetSessionDel');
      if (@NetSessionEnum = nil) or (@NetSessionDel = nil) then
        RaiseLastWin32Error { ���Ӻ���ʧ�� }
      else
      begin
        dwNetRet := NetSessionEnum(nil, $32, @Buff,
          NETBUFF_SIZE, @dwEntries,
          @dwTotalEntries);
        if dwNetRet = 0 then
        begin
          Result := true;
          for i := 0 to dwTotalEntries - 1 do
          begin
            Move(Buff, Adword, NETBUFF_SIZE);
            szClient := LPWSTR(Adword[0]);
            dwUserName := Adword[2];
            dwNetRet := NetSessionDel(nil, szClient, dwUserName);
            if (dwNetRet <> 0) then
            begin
              Result := false;
              break;
            end;
            Move(Buff[26], Buff[0], NETBUFF_SIZE - (i + 1) * 26);
          end
        end
        else
          Result := false;
      end;
    finally
      FreeLibrary(LibHandle); // Unload the DLL.
    end;
  except
  end;
end;

function StringsToStr(const vList:TStrings):string;
var
  i:Integer;
begin
  Result := '';
  for i:=0 to vList.Count-1 do
  begin
    if Result <> '' then
      Result := Result+'#'+vList.Strings[i]
    else
      Result := vList.Strings[i];
  end;
end;

//Stringת����TStrings
function StrToStrings(const Str:string;var vList:TStrings):Integer;
begin
  Result := ExtractStrings(['#'],[' '],PChar(str),vList);
end;

end.

