program IntoShutDownDLL;

uses
  Forms,
  uStartInto in 'uStartInto.pas' {StartInto};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStartInto, StartInto);
  Application.Run;
end.
