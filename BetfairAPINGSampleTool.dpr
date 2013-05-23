program BetfairAPINGSampleTool;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uConfig in 'uConfig.pas',
  JsonRpc in 'JsonRpc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
