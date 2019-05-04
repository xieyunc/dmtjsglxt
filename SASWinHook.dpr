library SASWinHook;

uses Windows, Messages;

{$R *.res}

var
  FHandle: THandle;
  OldAppProc: Pointer;

function HookProc(hHandle: THandle; uMsg: Cardinal;
  wParam, lParam: Integer): LRESULT; stdcall;
var K, C: Word;  // wndproc
begin
  if uMsg = WM_HOTKEY then
     begin
        K := HIWORD(lParam);
        C := LOWORD(lParam);
        // press Ctrl + Alt + Del
        if (C and VK_CONTROL<>0) and (C and VK_MENU <>0) and ( K = VK_Delete)
           then Exit;   // disable Ctrl + Alt + Del
     end;
  Result := CallWindowProc(OldAppProc, hHandle,
    uMsg, wParam, lParam);
end;

procedure EntryPointProc(Reason: Integer);
begin
  case reason of
    DLL_PROCESS_ATTACH:
      begin  // hook SAS window wndproc
        FHandle := FindWindow('SAS window class', 'SAS window');
        if not IsWindow(FHandle) then Exit;  // is window found?
        // save old wndproc
        OldAppProc := Pointer(GetWindowLong(FHandle, GWL_WNDPROC));
        // set new wndproc
        SetWindowLong(FHandle, GWL_WNDPROC, Cardinal(@HookProc));
      end;
    DLL_PROCESS_DETACH:
      begin
        if FHandle > 0 then
           begin  // unhook
             if Assigned(OldAppProc) then
                SetWindowLong(FHandle, GWL_WNDPROC, LongInt(OldAppProc));
             OldAppProc := nil;
           end;
      end;
    end;
end;

exports
  HookProc;

begin
  OldAppProc := nil;
  FHandle := 0;
  DllProc := @EntryPointProc;
  EntryPointProc(DLL_PROCESS_ATTACH);
end. 
