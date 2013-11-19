unit uAuthForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ComCtrls, MSHTML, UrlMon,
  ComServ, ActiveX, ComObj, Vcl.StdCtrls, IdURI;

type
  TfAuthForm = class(TForm)
    wbAuth: TWebBrowser;
    pbBrowse: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure wbAuthProgressChange(ASender: TObject; Progress,
      ProgressMax: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wbAuthBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
  private
    { Private declarations }
    FSessionToken: string;
    FAppKey: string;
    procedure RegisterBfAppProtocol;
    procedure UnregisterBfAppProtocol;
  public
    { Public declarations }
    property SessionToken: string read FSessionToken write FSessionToken;
    property AppKey: string read FAppKey write FAppKey;
  end;

var
  fAuthForm: TfAuthForm;
  Factory: IClassFactory;
  InternetSession: IInternetSession;

const
  ISSO_URL = 'https://identitysso.betfair.com/view/login?url=https://www.betfair.com&product=';

implementation

{$R *.dfm}

uses
  AppNsHandler;

procedure TfAuthForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnregisterBfAppProtocol;
end;

procedure TfAuthForm.FormShow(Sender: TObject);
begin
  wbAuth.Navigate(ISSO_URL + FAppKey);
  // Registering this protocol curently does nothing. This is an example.
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

procedure TfAuthForm.wbAuthBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
  function OleVariantToMemoryStream(OV: OleVariant): TMemoryStream;
   var
     Data: PByteArray;
     Size: integer;
   begin
     Result := TMemoryStream.Create;
     try
        Size := VarArrayHighBound (OV, 1) - VarArrayLowBound(OV, 1) + 1;
        Data := VarArrayLock(OV) ;
        try
          Result.Position := 0;
          Result.WriteBuffer(Data^, Size) ;
        finally
          VarArrayUnlock(OV) ;
        end;
     except
        Result.Free;
        Result := nil;
     end;
   end;
var
   ms: TMemoryStream;
   ss: TStringStream;
   params: TStringList;
begin
  ss := TStringStream.Create('');
  params := TStringList.Create;
  try
    if (URL = 'https://www.betfair.com/') and (Length(PostData) > 0) then
    begin
      ms := OleVariantToMemoryStream(PostData);
      ms.Position := 0;
      ss.CopyFrom(ms, ms.size);
      ss.Position := 0;

      params.Delimiter := '&';
      params.DelimitedText := ss.DataString;
      if params.Values['loginStatus'] = TIdURI.URLDecode('SUCCESS') then
      begin
        FSessionToken := TIdURI.URLDecode(params.Values['productToken']);
        Self.ModalResult := mrOK;
      end;
    end;
  finally
    params.Free;
    ss.Free;
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
