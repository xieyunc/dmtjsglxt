program dmtglxt;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  uChgMasterCode in 'uChgMasterCode.pas' {ChgMasterCode},
  udm in 'udm.pas' {dm: TDataModule},
  Net in '..\public\Net.pas',
  PwdFunUnit in '..\public\PwdFunUnit.pas',
  LoginUnit in 'LoginUnit.pas' {LoginForm},
  uShutdown in '..\public\uShutdown.pas',
  uKillProcess in '..\public\uKillProcess.pas',
  uABOUT in 'uABOUT.pas' {AboutBox},
  uHook in 'uHook.pas',
  uSystemSet in 'uSystemSet.pas' {SystemSet};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  dm := Tdm.Create(Application);
  Application.Title := '多媒体教室管理系统';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
