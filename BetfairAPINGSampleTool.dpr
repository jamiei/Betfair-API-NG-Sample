program BetfairAPINGSampleTool;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uConfig in 'uConfig.pas',
  JsonRpc in 'JsonRpc.pas',
  uAuthForm in 'uAuthForm.pas' {fAuthForm},
  AppNsHandler in 'lib\AppNsHandler.pas',
  uAuthCalls in 'uAuthCalls.pas',
  uCertLogin in 'uCertLogin.pas' {fCertLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
