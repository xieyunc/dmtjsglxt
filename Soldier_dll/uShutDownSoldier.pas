unit uShutDownSoldier;

interface
uses
  SysUtils, Classes, Windows, ExtCtrls, Forms, IniFiles, ShellAPI, MMSystem,
  TlHelp32, PsAPI;

//var
//  MonitorFile :string;// = 'notepad.exe';

  procedure StartTimer;stdcall; //如果要Export此方法，请加上stdcall申明
  procedure StopTimer;stdcall;

implementation
uses uShutDown,uKillProcess;

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
  //SaveLog(iCount);  //自已定义的一个日志存储过程
  //Inc(iCount);
  if not IsSystemLogin then //无须监控
  begin
    //Sleep(100);
    if not program_is_running then
    begin
      if iCount>1 then
         ShutDownComputer; //关机
         //RebootComputer; //重启计算机

      SaveSoldierLog('检测到客户端被退出！');
      Inc(iCount);
    end else
      iCount := 0;
  end;
end;

procedure StartTimer;stdcall; //按开始按钮，开始计数
begin
  timeid := timeSetEvent(5000,1,@MyCallBack,0,TIME_PERIODIC); //延时1000ms，循环模式，返回计数器的句柄
  SaveSoldierLog('开始注入！');
end;

procedure StopTimer;stdcall;
begin
  timeKillEvent(timeid); //销毁计时器线程，停止计数
  SaveSoldierLog('结束注入！');
  //iCount := 0;
end;

end.
