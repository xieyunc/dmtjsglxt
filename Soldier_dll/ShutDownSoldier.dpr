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

//======================第三种方法=======================//}
procedure MyCallBack(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall; //要回调的过程，由于是引用MMsystem中声明timeSetEvent函数，过程按这样定义
begin
  //数字每秒加一，与可视控件（如窗体的Caption，因为它还要通知Windows任务栏之类的）
  //之间会有同步的问题，最好用日志存放中变化
  //TestFrm.Caption:= IntToStr(iCount);
  //TestFrm.lbl_Count.Caption := IntToStr(iCount);
  //SaveSoldierLog(iCount);  //自已定义的一个日志存储过程
  //Inc(iCount);
  if not IsSystemLogin then //无须监控
  begin
    //Sleep(100);
    if not program_is_running then
    begin
      if iCount>0 then
      begin
        SaveSoldierLog('妈的，客户端又不见了！我重启！！');
        RebootComputer; //重启计算机
        Exit;
      end else
        SaveSoldierLog('妈的，客户端又不见了！再等5秒还没有我就重启！！');

      Inc(iCount);
    {
    end else if not ExeIsRunning('Explorer.exe') then
    begin
      SaveSoldierLog('妈的，怎么把Explorer.exe退掉了！我重启你个王八羔子！！');
      if iCount>2 then
        //RebootComputer; //重启计算机
        WinExec('explorer.exe',SW_SHOWNORMAL);
      Inc(iCount);
    }
    end else
    begin
      iCount := 0;
    end;
  end;
end;

procedure StartTimer;stdcall; //按开始按钮，开始计数
begin
  timeid := timeSetEvent(5000,1,@MyCallBack,0,TIME_PERIODIC); //延时1000ms，循环模式，返回计数器的句柄
  SaveSoldierLog('开始注入！To '+ParamStr(0));
end;

procedure StopTimer;stdcall;
begin
  timeKillEvent(timeid); //销毁计时器线程，停止计数
  SaveSoldierLog('结束注入！By '+ParamStr(0));
  //iCount := 0;
end;

procedure DllEnterPoint(dwReason: DWORD);//far;stdcall;//要实行远程注入时DLL的入口函数不能加stdcall声明
{
  dwReason参数有四种类型：
  DLL_PROCESS_ATTACH : 进程进入时   1
  DLL_PROCESS_DETACH : 进程退出时   0
  DLL_THREAD_ATTACH  : 线程进入时   2
  DLL_THREAD_DETACH  : 线程退出时   3
  在初始化部分写:
}
begin
  if dwReason=DLL_PROCESS_ATTACH then
     StartTimer
  else
  if dwReason=DLL_PROCESS_DETACH then
     StopTimer;
end;

begin
  //当我们进行远程注入时，ExtractFilePath(ParamStr(0))得到的是注入目标程序的路径，
  //即Explorer.exe程序所在的路径 C:\Windows
  SaveSoldierLog('准备注入'+GetExePath+'dmtglxt.exe程序！To '+ParamStr(0));
{
  Timer1:=TTimer.Create(nil);
  timer1.Interval := 3000;
  Method.Data   :=   nil;
  Method.Code   :=   @Timer1Timer;
  Timer1.OnTimer:=   TNotifyEvent(Method);
  //while True do Application.ProcessMessages;
}
  DLLProc := @DLLEnterPoint;
  DllEnterPoint(DLL_PROCESS_ATTACH); //也可以直接调用 StartTimer;
  //StartTimer;
end.


