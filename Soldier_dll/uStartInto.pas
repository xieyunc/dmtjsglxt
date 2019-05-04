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

  hRemoteProcess := OpenProcess(PROCESS_CREATE_THREAD + {����Զ�̴����߳�}
                                PROCESS_VM_OPERATION + {����Զ��VM����}
                                PROCESS_VM_WRITE, {����Զ��VMд}
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
    //�ɹ������ط�0��ʧ�ܣ�����0
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
    sMsg := '�����ʽ������ȷ��ʽΪ��IntoDLL  XXX.DLL  XXX.EXE'+#13+
            '����XXX.DLLΪ��ע���DLL�ļ���XXX.EXEΪע��Ŀ�����'+#13+
            '�磺IntoDLL MySoldier.dll Explorer.exe';
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
    Close; //ִ����ɺ��˳�
  end;
}
  //�ɹ������ط�0��ʧ�ܣ�����0
  if AttachToProcess('Services.exe', ExtractFilePath(paramstr(0))+'ShutDownSoldier.dll')=0 then
     AttachToProcess('Explorer.exe', ExtractFilePath(paramstr(0))+'ShutDownSoldier.dll');
  //����Mysoldier.dll����Ҫע�뵽Explorer.EXE�Ľ���,Explorer.exeҲ�����Ǳ�Ľ���.
  //dll��ֻ��ִ��API�������Զ��庯��Ҳ����ִ�У���Ҫʵ��ĳЩ���ܵĻ�����ֱ��д��dll��begin....end.֮��
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


