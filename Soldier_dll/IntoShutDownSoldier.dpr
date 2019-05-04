program IntoShutDownSoldier;

uses
  Forms,
  uShutDownDLL in 'uShutDownDLL.pas' {ToDll};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TToDll, ToDll);
  Application.Run;
end.
