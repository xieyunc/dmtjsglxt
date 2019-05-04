unit uHook;
  
interface
  
uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs; 

type
  tagKBDLLHOOKSTRUCT = packed record 
  vkCode: DWORD;
  scanCode: DWORD;
  flags: DWORD;
  time: DWORD;
  dwExtraInfo: DWORD;
  end;
  KBDLLHOOKSTRUCT= tagKBDLLHOOKSTRUCT;
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;
  const WH_KEYBOARD_LL = 13;
  const LLKHF_ALTDOWN = $20;
  function LowLevelKeyboardProc(nCode:Integer;
  WParam: WPARAM;LParam:LPARAM):LRESULT;stdcall;
  procedure HookStart;
  procedure HookEnd;
var
  hhkLowLevelKybd:HHOOK;

implementation

function LowLevelKeyboardProc(nCode: Integer;WParam: WPARAM;LParam: LPARAM):LRESULT; stdcall;
var
  fEatKeystroke: BOOL; 
  p: PKBDLLHOOKSTRUCT; 
begin
  Result:=0;
  fEatKeystroke:=FALSE;
  p:=PKBDLLHOOKSTRUCT(lParam);
  if (nCode=HC_ACTION) then
  begin
    case wParam of
    WM_KEYDOWN,
    WM_SYSKEYDOWN,
    WM_KEYUP,
    WM_SYSKEYUP:
      fEatKeystroke:=  
      ((p.vkCode=VK_TAB) and ((p.flags and LLKHF_ALTDOWN) <> 0)) or
      ((p.vkCode=VK_ESCAPE) and ((p.flags and LLKHF_ALTDOWN) <> 0))or
      (p.vkCode=VK_Lwin) or
      (p.vkCode=VK_Rwin) or
      (p.vkCode=VK_apps) or
      ((p.vkCode=VK_ESCAPE) and ((GetKeyState(VK_CONTROL) and $8000) <> 0)) or
      ((p.vkCode=VK_F4) and ((p.flags and LLKHF_ALTDOWN) <> 0)) or
      ((p.vkCode=VK_SPACE) and ((p.flags and LLKHF_ALTDOWN) <> 0)) or
      (((p.vkCode=VK_CONTROL) and (P.vkCode = LLKHF_ALTDOWN and p.flags) and (P.vkCode=VK_Delete)))
    end;
  end;
  if fEatKeystroke=True then
    Result:=1;
  if nCode <> 0 then
    Result := CallNextHookEx(0,nCode,wParam,lParam);
end;

procedure HookStart;
begin
  if hhkLowLevelKybd=0 then
    hhkLowLevelKybd:=SetWindowsHookExW(WH_KEYBOARD_LL,LowLevelKeyboardProc, Hinstance,0);
end;

procedure HookEnd;
begin
  if (hhkLowLevelKybd<>0) and UnhookWindowsHookEx(hhkLowLevelKybd) then
    hhkLowLevelKybd:=0;
end;

initialization
  //HookStart;

finalization
  //HookEnd;

end.
