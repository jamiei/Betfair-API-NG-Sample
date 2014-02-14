unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Generics.Collections,

  superobject,
  IdMultiPartFormData,
  IdLogFile,
  IdSSLOpenSSL,
  IdHttp,

  uAuthCalls,
  JsonRpc, Vcl.ExtCtrls;

type
  TfMain = class(TForm)
    gbAuthentication: TGroupBox;
    eSessionToken: TEdit;
    eAppKey: TEdit;
    lblSessionToken: TLabel;
    lblAppKey: TLabel;
    mParams: TMemo;
    btnSend: TButton;
    cbOperation: TComboBox;
    mOutput: TMemo;
    lblMethodName: TLabel;
    gbPrepopulateInstructions: TGroupBox;
    cbScenario: TComboBox;
    btnLogin: TButton;
    TKeepAliveTimer: TTimer;
    btnLogout: TButton;
    btnCertLogin: TButton;
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbScenarioChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure TKeepAliveTimerTimer(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnCertLoginClick(Sender: TObject);
  private
    { Private declarations }
    FScenarioData: TStringList;
    FEndpoints: TStringList;
    FJsonRpc: TJsonRpc;
    FKeepAliveFailCount: integer;
    // Form population methods
    procedure loadScenarioData(aFilename: string);
    procedure populateScenarioData(aSelectedIndex: integer);
    function getClientWithSessionAndAuth(aSession, aAppKey: string): TIdHttp;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;


implementation

uses
  uConfig,
  uAuthForm,
  uCertLogin;

{$R *.dfm}

procedure TfMain.btnCertLoginClick(Sender: TObject);
var
  fCertLogin: TfCertLogin;
  mrAuth: TModalResult;
  result: TCertLoginResponse;
begin
  fCertLogin := TfCertLogin.Create(nil);
  try
    mrAuth := fCertLogin.ShowModal;
    if mrAuth = mrOK then
    begin
      result := DoCertLogin(eAppKey.Text, fCertLogin.eUsername.Text, fCertLogin.ePassword.Text, fCertLogin.eCertFile.Text, fCertLogin.eKeyFile.Text);
      if result.IsLoggedIn then
      begin
        eSessionToken.Text := result.SessionToken;
        TKeepAliveTimer.Enabled := true;
        btnLogout.Enabled := true;
        btnLogin.Enabled := false;
        btnCertLogin.Enabled := false;
      end else ShowMessage('ERROR: ' + result.ReturnCode);
    end;
  finally
    fCertLogin.Free;
  end;
end;

procedure TfMain.btnLoginClick(Sender: TObject);
var
  fAuthForm: TfAuthForm;
  mrAuth: TModalResult;
begin
  fAuthForm := TfAuthForm.Create(nil);
  try
    fAuthForm.AppKey := eAppKey.Text;
    mrAuth := fAuthForm.ShowModal;
    if mrAuth = mrOK then
    begin
      eSessionToken.Text := fAuthForm.SessionToken;
      TKeepAliveTimer.Enabled := true;
      btnLogout.Enabled := true;
      btnLogin.Enabled := false;
      btnCertLogin.Enabled := false;
    end;
  finally
    fAuthForm.Free;
  end;
end;

procedure TfMain.btnLogoutClick(Sender: TObject);
begin
  if DoLogOut(eAppKey.Text, eSessionToken.Text) then
  begin
    eSessionToken.Text := '';
    btnLogin.Enabled := true;
    btnCertLogin.Enabled := true;
    btnLogout.Enabled := false;
    TKeepAliveTimer.Enabled := false;
    FKeepAliveFailCount := 0;
  end else ShowMessage('Logout Failed!');
end;

procedure TfMain.btnSendClick(Sender: TObject);
var
  httpClient: TIdHttp;
  logger: TIdLogFile;
  sslIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  id: string;
begin
  if cbOperation.ItemIndex > -1  then
  begin
    if ((Length(eSessionToken.Text) > 0) and (Length(eAppKey.Text) > 0)) then
    begin
      logger := TIdLogFile.Create(nil);
      logger.Filename := 'requestlog.log';
      logger.Active := true;
      try
        httpClient := getClientWithSessionAndAuth(eSessionToken.Text, eAppKey.Text);
        sslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        httpClient.IOHandler := sslIOHandler;
        httpClient.Intercept := logger;
        try
          mOutput.Lines.Text := FJsonRpc.DoJsonRpcReq(httpClient, cbOperation.Text, mParams.Lines, FJsonRpc.GetNewIdAsString);
        finally
          httpClient.Free;
          sslIOHandler.Free;
        end;
      finally
        logger.Free;
      end;
    end;
  end;
end;

procedure TfMain.loadScenarioData(aFilename: string);
var
  jsonAsStr: string;
  jsonScenario: ISuperObject;
  scenarioEntry: ISuperObject;
begin
  jsonAsStr := TScenarioDataConfig.LoadScenarioDataAsStr(aFilename);
  jsonScenario := SO(jsonAsStr);
  for scenarioEntry in jsonScenario do
  begin
    cbScenario.Items.Add(scenarioEntry.S['caption']);
    FScenarioData.Add(scenarioEntry.AsString);
  end;
end;

procedure TfMain.populateScenarioData(aSelectedIndex: integer);
var
  scenarioData: ISuperObject;
  i, indexOfOperation: integer;
begin
  if ((aSelectedIndex >= 0) and (aSelectedIndex <= FScenarioData.Count - 1)) then
  begin
    scenarioData := SO(FScenarioData[aSelectedIndex]);
    mParams.Text := scenarioData['params'].AsString;
    indexOfOperation := 0;
    for i := 0 to cbOperation.Items.Count - 1 do
    begin
      if cbOperation.Items[i] = scenarioData['methodName'].AsString then indexOfOperation := i;
    end;
    cbOperation.ItemIndex := indexOfOperation;
  end;
end;

procedure TfMain.TKeepAliveTimerTimer(Sender: TObject);
begin
  // Keep alive runs every 7 minutes
  if Length(eSessionToken.Text) > 1 then
  begin
    DoKeepAlive(eAppkey.Text, eSessionToken.Text);
  end
  else
  begin
    Inc(FKeepAliveFailCount);
    if FKeepAliveFailCount > 7 then
    begin
      TKeepAliveTimer.Enabled := false;
      ShowMessage('The Keep Alive operation has failed more than 7 times now and has been disabled.');
    end;
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  methodNames: TStrings;
  iniFilename: string;
begin
  FScenarioData := TStringList.Create;
  FKeepAliveFailCount := 0;
  // Load ini config
  iniFilename := ChangeFileExt(Application.ExeName,'.ini');
  FEndpoints := TStringList.Create;
  FEndpoints.CommaText := TAPINGMethodConfig.LoadEndpoint(iniFilename);
  FJsonRpc := TJsonRpc.Create(FEndpoints);
  methodNames := TAPINGMethodConfig.LoadMethodNames(iniFilename);
  eAppKey.Text := TAPINGMethodConfig.LoadSavedAppKey(iniFilename);
  try
    cbOperation.Items.AddStrings(methodNames);
  finally
    methodNames.Free;
  end;
  // Load the json with the scenario data.
  loadScenarioData('scenario-data.json');
end;

procedure TfMain.FormDestroy(Sender: TObject);
var
  iniFilename: string;
begin
  iniFilename := ChangeFileExt(Application.ExeName,'.ini');
  TAPINGMethodConfig.SaveAppKey(iniFilename, eAppKey.Text);
  FScenarioData.Clear;
  FScenarioData.Free;
  FJsonRpc.Free;
end;

procedure TfMain.cbScenarioChange(Sender: TObject);
begin
  if cbScenario.ItemIndex >= 0 then
  begin
    populateScenarioData(cbScenario.ItemIndex);
  end;
end;

function TfMain.getClientWithSessionAndAuth(aSession, aAppKey: string): TIdHttp;
begin
  Result := TIdHttp.Create(nil);
  Result.Request.ContentType := 'application/json';
  Result.Request.Accept := 'application/json';
  // Add our headers.
  Result.Request.CustomHeaders.Add('X-Application:' + aAppKey);
  Result.Request.CustomHeaders.Add('X-Authentication:' + aSession);
  // Try to ensure persistent connections - connections are expensive to setup
  Result.Request.Connection := 'keep-alive';
  Result.HTTPOptions := Result.HTTPOptions + [ hoKeepOrigProtocol ];
end;

end.
