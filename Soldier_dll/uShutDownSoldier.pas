unit uShutDownSoldier;

interface
uses
  SysUtils, Classes, Windows, ExtCtrls, Forms, IniFiles, ShellAPI, MMSystem,
  TlHelp32, PsAPI;

//var
//  MonitorFile :string;// = 'notepad.exe';

  procedure StartTimer;stdcall; //���ҪExport�˷����������stdcall����
  procedure StopTimer;stdcall;

implementation
uses uShutDown,uKillProcess;

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
  //SaveLog(iCount);  //���Ѷ����һ����־�洢����
  //Inc(iCount);
  if not IsSystemLogin then //������
  begin
    //Sleep(100);
    if not program_is_running then
    begin
      if iCount>1 then
         ShutDownComputer; //�ػ�
         //RebootComputer; //���������

      SaveSoldierLog('��⵽�ͻ��˱��˳���');
      Inc(iCount);
    end else
      iCount := 0;
  end;
end;

procedure StartTimer;stdcall; //����ʼ��ť����ʼ����
begin
  timeid := timeSetEvent(5000,1,@MyCallBack,0,TIME_PERIODIC); //��ʱ1000ms��ѭ��ģʽ�����ؼ������ľ��
  SaveSoldierLog('��ʼע�룡');
end;

procedure StopTimer;stdcall;
begin
  timeKillEvent(timeid); //���ټ�ʱ���̣߳�ֹͣ����
  SaveSoldierLog('����ע�룡');
  //iCount := 0;
end;

end.
