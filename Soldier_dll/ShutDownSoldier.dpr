library ShutDownSoldier;
uses
  SysUtils,
  Classes,
  Windows,
  ShellAPI,
  MMSystem,
  uShutdown in '..\public\uShutdown.pas',
  uKillProcess in '..\public\uKillProcess.pas',
  uShutDownSoldier in 'uShutDownSoldier.pas';

{$R *.res}
var
  timeid: Cardinal;
  iCount: Integer = 0;

//======================�����ַ���=======================//}
procedure MyCallBack(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall; //Ҫ�ص��Ĺ��̣�����������MMsystem������timeSetEvent���������̰���������
begin
  //����ÿ���һ������ӿؼ����細���Caption����Ϊ����Ҫ֪ͨWindows������֮��ģ�
  //֮�����ͬ�������⣬�������־����б仯
  //TestFrm.Caption:= IntToStr(iCount);
  //TestFrm.lbl_Count.Caption := IntToStr(iCount);
  //SaveSoldierLog(iCount);  //���Ѷ����һ����־�洢����
  //Inc(iCount);
  if not IsSystemLogin then //������
  begin
    //Sleep(100);
    if not program_is_running then
    begin
      if iCount>0 then
      begin
        SaveSoldierLog('��ģ��ͻ����ֲ����ˣ�����������');
        RebootComputer; //���������
        Exit;
      end else
        SaveSoldierLog('��ģ��ͻ����ֲ����ˣ��ٵ�5�뻹û���Ҿ���������');

      Inc(iCount);
    {
    end else if not ExeIsRunning('Explorer.exe') then
    begin
      SaveSoldierLog('��ģ���ô��Explorer.exe�˵��ˣ�������������˸��ӣ���');
      if iCount>2 then
        //RebootComputer; //���������
        WinExec('explorer.exe',SW_SHOWNORMAL);
      Inc(iCount);
    }
    end else
    begin
      iCount := 0;
    end;
  end;
end;

procedure StartTimer;stdcall; //����ʼ��ť����ʼ����
begin
  timeid := timeSetEvent(5000,1,@MyCallBack,0,TIME_PERIODIC); //��ʱ1000ms��ѭ��ģʽ�����ؼ������ľ��
  SaveSoldierLog('��ʼע�룡To '+ParamStr(0));
end;

procedure StopTimer;stdcall;
begin
  timeKillEvent(timeid); //���ټ�ʱ���̣߳�ֹͣ����
  SaveSoldierLog('����ע�룡By '+ParamStr(0));
  //iCount := 0;
end;

procedure DllEnterPoint(dwReason: DWORD);//far;stdcall;//Ҫʵ��Զ��ע��ʱDLL����ں������ܼ�stdcall����
{
  dwReason�������������ͣ�
  DLL_PROCESS_ATTACH : ���̽���ʱ   1
  DLL_PROCESS_DETACH : �����˳�ʱ   0
  DLL_THREAD_ATTACH  : �߳̽���ʱ   2
  DLL_THREAD_DETACH  : �߳��˳�ʱ   3
  �ڳ�ʼ������д:
}
begin
  if dwReason=DLL_PROCESS_ATTACH then
     StartTimer
  else
  if dwReason=DLL_PROCESS_DETACH then
     StopTimer;
end;

begin
  //�����ǽ���Զ��ע��ʱ��ExtractFilePath(ParamStr(0))�õ�����ע��Ŀ������·����
  //��Explorer.exe�������ڵ�·�� C:\Windows
  SaveSoldierLog('׼��ע��'+GetExePath+'dmtglxt.exe����To '+ParamStr(0));
{
  Timer1:=TTimer.Create(nil);
  timer1.Interval := 3000;
  Method.Data   :=   nil;
  Method.Code   :=   @Timer1Timer;
  Timer1.OnTimer:=   TNotifyEvent(Method);
  //while True do Application.ProcessMessages;
}
  DLLProc := @DLLEnterPoint;
  DllEnterPoint(DLL_PROCESS_ATTACH); //Ҳ����ֱ�ӵ��� StartTimer;
  //StartTimer;
end.


