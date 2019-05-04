unit uKillProcess;

interface
uses SysUtils,Classes,Windows,TlHelp32,ShellAPI,PsAPI, IniFiles;

const
  SysSetFileName:string = 'dmtSysSet.ini';

  procedure SendSoldierMsg; //发送要监控的消息
  procedure SendNoSoldierMsg; //发送不要监控的消息
  procedure SaveSoldierLog(const sMessage:string);
  function  IsSystemLogin: Boolean;

  function  GetExePath:string;  //得到系统的安装路径
  function  GetExeFileSize:Integer;
  function  ExeIsRunning(const sExeFileName:string):Boolean;
  function  program_is_running: Boolean;
  procedure KillTaskByXXX;
  procedure InjoinDLL; //远程注入
  //function KillTask(const sExeFileName:string):Boolean;

implementation

function  GetExePath:string;
var
  sPath: array [0..255] of Char;
  fn:string;
begin
  GetWindowsDirectory(@sPath,40);
  fn := string(sPath)+'\'+SysSetFileName;
  with TIniFile.Create(fn) do
  begin
    try
      if not FileExists(fn) then
        WriteString('SYSSET','SysPath','d:\dmtglxt\');
      Result := ReadString('SYSSET','SysPath','d:\dmtglxt\');
      if Result[Length(Result)]<>'\' then
        Result := Result + '\';
    finally
      Free;
    end;
  end;
end;

function  GetExeFileSize:Integer;
var
  sPath: array [0..255] of Char;
  fn:string;
begin
  GetWindowsDirectory(@sPath,40);
  fn := string(sPath)+'\'+SysSetFileName;
  with TIniFile.Create(fn) do
  begin
    try
      if not FileExists(fn) then
        WriteString('SYSSET','dmtglxtFileSize','0');
      Result := ReadInteger('SYSSET','dmtglxtFileSize',0);
    finally
      Free;
    end;
  end;
end;

procedure SendSoldierMsg; //发送监控的消息
var
  sPath: array [0..255] of Char;
  fn:string;
begin
  GetWindowsDirectory(@sPath,40);
  fn := sPath+'\dmt_NoSoldier.Txt';
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
  fn := sPath+'\dmt_NoSoldier.Txt';
  if not FileExists(fn) then
  begin
    AssignFile(f,fn);
    Rewrite(f);
    Writeln(f,'LoginMode=lmSystem');
    closefile(f);
  end;
end;

function IsSystemLogin: Boolean;
var
  sPath: array [0..255] of Char;
  fn:string;
begin
  GetWindowsDirectory(@sPath,40);
  fn := sPath+'\dmt_NoSoldier.Txt';
  Result := FileExists(fn);
end;

procedure SaveSoldierLog(const sMessage:string);
var
  fn:string;
  sList:TStrings;
begin
  fn := GetExePath+'dmt_Soldier.Log';
  sList := TStringList.Create;
  try
    if FileExists(fn) then
      sList.LoadFromFile(fn);
    if sList.Count>1000 then
      sList.Clear;
    sList.Add(FormatDateTime('yyy-mm-dd hh:nn:ss',Now)+':'+sMessage);
    sList.SaveToFile(fn);
  finally
    sList.Free;
  end;
end;

function GetFullFileName(const pID:DWORD):string; //uses PSAPI;
var
  h:THandle;
  fileName:string;
  iLen:integer;
  hMod:HMODULE;
  cbNeeded:DWORD;
begin
  Result := '';
  h := OpenProcess(PROCESS_ALL_ACCESS, false, pID);     //pID 为 进程ID
  if h > 0 then
  begin
    if EnumProcessModules( h, @hMod, sizeof(hMod), cbNeeded) then
    begin
      SetLength(fileName, MAX_PATH);
      iLen := GetModuleFileNameEx(h, hMod, PCHAR(fileName), MAX_PATH);
      if iLen <> 0 then
      begin
        SetLength(fileName, StrLen(PCHAR(fileName)));
        Result := FileName; //包含路径和文件名
      end;
    end;
    CloseHandle(h);
  end;
end;

function ExeIsRunning(const sExeFileName:string):Boolean;
var
  lppe  : TProcessEntry32;
  found : boolean;
  Hand  : THandle;
  pID   : DWORD;
  sSysFileName,
  sFullFileName,
  sFileName : String;
begin
  Hand := CreateToolhelp32Snapshot(TH32CS_SNAPALL,0);
  lppe.dwSize := SizeOf(lppe);  //这一语句必不可少，否则将出现无法预知的结果
  found := Process32First(Hand,lppe);
  sFullFileName := LowerCase(sExeFileName); //含路径的文件名
  sFileName := ExtractFileName(sFullFileName); //准文件名
  while found do
  begin
    sSysFileName := LowerCase(StrPas(lppe.szExeFile));
    if (sSysFileName=sFileName) then
    begin
      if sFullFileName<>sFileName then  //如果传过来的是含路径的全文件名，还要比较路径是不是相同
      begin
        pID:=lppe.th32ProcessID;
        Result := sFullFileName=LowerCase(GetFullFileName(pID));
        Exit;
      end else
      begin
        Result := True;
        Exit;
      end;
    end;
    found := Process32Next(Hand,lppe);
  end;
  Result := False;
end;

function program_is_running: Boolean;
begin
  //Result := ExeIsRunning(GetExePath+'dmtglxt.exe');
  Result := ExeIsRunning('dmtglxt.exe');
end;

function KillTask(const sExeFileName:string):Boolean;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOLean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(sExeFileName)) or
       (UpperCase(FProcessEntry32.szExeFile) = UpperCase(sExeFileName))) then
          Result := TerminateProcess(
          OpenProcess(PROCESS_TERMINATE,
          BooL(0),
          FProcessEntry32.th32ProcessID),
          0);
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure KillTaskByXXX;
begin
  //if ExeIsRunning('taskmgr.exe') then
    KillTask('taskmgr.exe');
  //if ExeIsRunning('qq.exe') then
    KillTask('qq.exe');
  //if ExeIsRunning('IEXPLORE.EXE') then
    KillTask('IEXPLORE.EXE');
  //if ExeIsRunning('firefox.exe') then
    KillTask('firefox.exe');
end;

procedure InjoinDLL;
var
  fn:string;
begin
{
  if not ExeIsRunning('explorer.exe') then
  begin
    WinExec('Explorer.exe',SW_NORMAL);
    Sleep(1000);
    fn := ExtractFilePath(ParamStr(0))+'InToExitDLL.EXE';
    ShellExecute(0,'open',PChar(fn),nil,PChar(ExtractFileDir(fn)),SW_HIDE);
  end;
}
  if ExeIsRunning('explorer.exe') then
  begin
    fn := ExtractFilePath(ParamStr(0))+'InToExitDLL.EXE';
    if FileExists(fn) then
      ShellExecute(0,'open',PChar(fn),nil,PChar(ExtractFileDir(fn)),SW_HIDE);
  end;
end;

end.
