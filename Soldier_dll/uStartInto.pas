unit uStartInto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, tlhelp32;

type
  TStartInto = class(TForm)
    btn_into: TButton;
    btn_Exit: TButton;
    Memo1: TMemo;
    procedure btn_intoClick(Sender: TObject);
    procedure btn_ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartInto: TStartInto;

implementation
uses ShellAPI;

{$R *.DFM}

procedure FindAProcess(const AFilename: string; const PathMatch: Boolean; var ProcessID: DWORD);
var
  lppe: TProcessEntry32;
  SsHandle: Thandle;
  FoundAProc, FoundOK: boolean;
begin
  ProcessID :=0;
  SsHandle := CreateToolHelp32SnapShot(TH32CS_SnapProcess, 0);
  FoundAProc := Process32First(Sshandle, lppe);
  while FoundAProc do
  begin
    if PathMatch then
      FoundOK := AnsiStricomp(lppe.szExefile, PChar(AFilename)) = 0
    else
      FoundOK := AnsiStricomp(PChar(ExtractFilename(lppe.szExefile)), PChar(ExtractFilename(AFilename))) = 0;
    if FoundOK then
    begin
      ProcessID := lppe.th32ProcessID;
      break;
    end;
    FoundAProc := Process32Next(SsHandle, lppe);
  end;
  CloseHandle(SsHandle);
end;

function EnabledDebugPrivilege(const bEnabled: Boolean): Boolean;
var
  hToken: THandle;
  tp: TOKEN_PRIVILEGES;
  a: DWORD;
const
  SE_DEBUG_NAME = 'SeDebugPrivilege';
begin
  Result := False;
  if (OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, hToken)) then
  begin
    tp.PrivilegeCount := 1;
    LookupPrivilegeValue(nil, SE_DEBUG_NAME, tp.Privileges[0].Luid);
    if bEnabled then
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      tp.Privileges[0].Attributes := 0;
    a := 0;
    AdjustTokenPrivileges(hToken, False, tp, SizeOf(tp), nil, a);
    Result := GetLastError = ERROR_SUCCESS;
    CloseHandle(hToken);
  end;
end;

function AttachToProcess(const HostFile, GuestFile: string; const PID: DWORD = 0): DWORD;
var
  hRemoteProcess: THandle;
  dwRemoteProcessId: DWORD;
  cb: DWORD;
  pszLibFileRemote: Pointer;
  iReturnCode: Boolean;
  TempVar: DWORD;
  pfnStartAddr: TFNThreadStartRoutine;
  pszLibAFilename: PwideChar;
begin
  Result := 0;
  EnabledDebugPrivilege(True);
  Getmem(pszLibAFilename, Length(GuestFile) * 2 + 1);
  StringToWideChar(GuestFile, pszLibAFilename, Length(GuestFile) * 2 + 1);
  if PID > 0 then
     dwRemoteProcessID := PID
  else
     FindAProcess(HostFile, False, dwRemoteProcessID);

  hRemoteProcess := OpenProcess(PROCESS_CREATE_THREAD + {允许远程创建线程}
                                PROCESS_VM_OPERATION + {允许远程VM操作}
                                PROCESS_VM_WRITE, {允许远程VM写}
                                FALSE, dwRemoteProcessId);
  cb := (1 + lstrlenW(pszLibAFilename)) * sizeof(WCHAR);
  pszLibFileRemote := PWIDESTRING(VirtualAllocEx(hRemoteProcess, nil, cb, MEM_COMMIT, PAGE_READWRITE));
  TempVar := 0;
  iReturnCode := WriteProcessMemory(hRemoteProcess, pszLibFileRemote, pszLibAFilename, cb, TempVar);
  if iReturnCode then
  begin
    pfnStartAddr := GetProcAddress(GetModuleHandle('Kernel32'), 'LoadLibraryW');
    TempVar := 0;
    Result := CreateRemoteThread(hRemoteProcess, nil, 0, pfnStartAddr, pszLibFileRemote, 0, TempVar);
    //成功：返回非0，失败：返回0
  end;
  Freemem(pszLibAFilename);
end;

procedure TStartInto.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TStartInto.btn_intoClick(Sender: TObject);
//var
//  sDllName,sExeName,sMsg:string;
begin
{
  if ParamCount<2 then
  begin
    sMsg := '命令格式错误！正确格式为：IntoDLL  XXX.DLL  XXX.EXE'+#13+
            '其中XXX.DLL为欲注入的DLL文件，XXX.EXE为注入目标程序'+#13+
            '如：IntoDLL MySoldier.dll Explorer.exe';
    MessageDlg(PChar(sMsg),  mtError, [mbOK], 0);
    Close;
  end else
  begin
    sDllName := ParamStr(1);
    sExeName := ParamStr(2);
    if sDllName=ExtractFileName(sDllName) then
       sDllName := ExtractFilePath(ParamStr(0))+sDllName;
    sExeName := ExtractFileName(sExeName);
    //ShowMessage(sDllName+','+sExename);
    AttachToProcess(sExeName, sDllName);
    Close; //执行完成后退出
  end;
}
  //成功：返回非0，失败：返回0
  if AttachToProcess('Services.exe', ExtractFilePath(paramstr(0))+'ShutDownSoldier.dll')=0 then
     AttachToProcess('Explorer.exe', ExtractFilePath(paramstr(0))+'ShutDownSoldier.dll');
  //其中Mysoldier.dll是想要注入到Explorer.EXE的进程,Explorer.exe也可以是别的进程.
  //dll中只能执行API函数，自定义函数也不能执行，故要实现某些功能的话，请直接写在dll的begin....end.之间
end;

procedure TStartInto.FormCreate(Sender: TObject);
begin
  Application.ShowMainForm := False;//True;//
  if not Application.ShowMainForm then
  begin
     btn_intoClick(Self);
     Application.Terminate;
  end;
end;

end.


