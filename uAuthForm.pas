unit uAuthForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ComCtrls, MSHTML, UrlMon,
  ComServ, ActiveX, ComObj, Vcl.StdCtrls;

type
  TfAuthForm = class(TForm)
    wbAuth: TWebBrowser;
    pbBrowse: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure wbAuthProgressChange(ASender: TObject; Progress,
      ProgressMax: Integer);
    procedure wbAuthDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FSessionToken: string;
    procedure RegisterBfAppProtocol;
    procedure UnregisterBfAppProtocol;
  public
    { Public declarations }
    property SessionToken: string read FSessionToken write FSessionToken;
  end;

var
  fAuthForm: TfAuthForm;
  Factory: IClassFactory;
  InternetSession: IInternetSession;

const
  ISSO_URL = 'https://identitysso.betfair.com';

implementation

{$R *.dfm}

uses
  AppNsHandler;

procedure TfAuthForm.Button1Click(Sender: TObject);
begin
  wbAuth.Navigate('BfApp://test');
end;

procedure TfAuthForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnregisterBfAppProtocol;
end;

procedure TfAuthForm.FormShow(Sender: TObject);
begin
  wbAuth.Navigate(ISSO_URL);
  RegisterBfAppProtocol;
  Self.ModalResult := mrCancel;
end;

procedure TfAuthForm.RegisterBfAppProtocol;
var
  sessionResult: HRESULT;
begin
  Factory := TComObjectFactory.Create(ComServer, TAppNsHandler, AppNsHandler.Class_SIELProtocol, 'Protocol', '', ciMultiInstance, tmApartment);
  sessionResult := CoInternetGetSession(0, InternetSession, 0);
  if ((sessionResult = S_OK) and (InternetSession <> nil)) then
  begin
    InternetSession.RegisterNameSpace(Factory, AppNsHandler.Class_SIELProtocol, AppNsHandler.ProtoName, 0, nil, 0);
  end;
end;

procedure TfAuthForm.UnregisterBfAppProtocol;
begin
  if (InternetSession <> nil) then InternetSession.UnregisterNameSpace(Factory, AppNsHandler.ProtoName);
  InternetSession := nil;
  if (Factory <> nil) then Factory := nil;
end;

procedure TfAuthForm.wbAuthDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  document: IHTMLDocument2;
  cookies: TStringList;
  urlStr: String;
begin
  document := wbAuth.Document as IHTMLDocument2;
  if Assigned(document) then
  begin
    urlStr := document.url;
    cookies := TStringList.Create;
    cookies.Delimiter := ';';
    try
      cookies.DelimitedText := document.cookie;
      if ((urlStr = 'https://identitysso.betfair.com/api/login') and (Length(cookies.Values['ssoid']) > 5)) then
      begin
        FSessionToken := cookies.Values['ssoid'];
        Self.ModalResult := mrOK;
      end;
    finally
      cookies.Free;
    end;
  end;
end;

procedure TfAuthForm.wbAuthProgressChange(ASender: TObject; Progress,
  ProgressMax: Integer);
begin
  if Progress > 0 then
  begin
    pbBrowse.Max := ProgressMax;
    pbBrowse.Position := Progress
  end { Progress>0 }
  else
    pbBrowse.Position := 0
end;

end.
