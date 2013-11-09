unit uAuthCalls;

interface

uses
  SysUtils,
  Classes,

  superobject,
  IdHttp,
  IdSSL,
  IdSSLOpenSSL;

  type
    TCertLoginResponse = record
      IsLoggedIn: boolean;
      SessionToken: string;
      ReturnCode: string;
    end;

function DoKeepAlive(aAppKey, aSessionToken: string): boolean;
function DoLogout(aAppKey, aSessionToken: string): boolean;
function DoCertLogin(aAppKey, aUsername, aPassword: string; aCertFile, aKeyFile: string): TCertLoginResponse;


implementation

function DoKeepAlive(aAppKey, aSessionToken: string): boolean;
var
  httpClient: TIdHttp;
  sslHandler: TIdSSLIOHandlerSocketOpenSSL;
  jsonResp: ISuperObject;
begin
  result := false;
  httpClient := TIdHttp.Create(nil);
  try
    sslHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
    try
      httpClient.Request.CustomHeaders.AddValue('X-Application', aAppKey);
      httpClient.Request.CustomHeaders.AddValue('X-Authentication', aSessionToken);
      httpClient.Request.Accept := 'application/json';
      httpClient.Get('https://identitysso.betfair.com/api/keepAlive');
      if httpClient.ResponseCode = 200 then
      begin
        jsonResp := SO(httpClient.ResponseText);
        if jsonResp.S['status'] = 'SUCCESS' then result := true else result := false;
      end;
    except
      result := false;
    end;
  finally
    if Assigned(sslHandler) then sslHandler.Free;
    httpClient.Free;
  end;
end;

function DoLogout(aAppKey, aSessionToken: string): boolean;
var
  httpClient: TIdHttp;
  sslHandler: TIdSSLIOHandlerSocketOpenSSL;
  jsonResp: ISuperObject;
begin
  result := false;
  httpClient := TIdHttp.Create(nil);
  try
    sslHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
    try
      httpClient.Request.CustomHeaders.AddValue('X-Application', aAppKey);
      httpClient.Request.CustomHeaders.AddValue('X-Authentication', aSessionToken);
      httpClient.Request.Accept := 'application/json';
      httpClient.Get('https://identitysso.betfair.com/api/logout');
      if httpClient.ResponseCode = 200 then
      begin
        jsonResp := SO(httpClient.ResponseText);
        if jsonResp.S['status'] = 'SUCCESS' then result := true else result := false;
      end;
    except
      result := false;
    end;
  finally
    if Assigned(sslHandler) then sslHandler.Free;
    httpClient.Free;
  end;
end;


function DoCertLogin(aAppKey, aUsername, aPassword: string; aCertFile, aKeyFile: string): TCertLoginResponse;
var
  httpClient: TIdHttp;
  sslHandler: TIdSSLIOHandlerSocketOpenSSL;
  strResp: string;
  jsonResp: ISuperObject;
  params: TStringList;
begin
  result.IsLoggedIn := false;
  httpClient := TIdHttp.Create(nil);
  params := TStringList.Create;
  try
    sslHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
    sslHandler.SSLOptions.CertFile := aCertFile;
    sslHandler.SSLOptions.KeyFile := aKeyFile;
    sslHandler.SSLOptions.Method := sslvSSLv23 ;
    sslHandler.SSLOptions.mode := sslmClient;
    httpClient.IOHandler := sslHandler;
    try
      httpClient.Request.CustomHeaders.AddValue('X-Application', aAppKey);
      httpClient.Request.Accept := 'application/json';
      params.Add('username=' + aUsername);
      params.Add('password=' + aPassword);
      strResp := httpClient.Post('https://identitysso-api.betfair.com/api/certlogin', params);


      if httpClient.ResponseCode = 200 then
      begin
        jsonResp := SO(strResp);
        if jsonResp.S['loginStatus'] = 'SUCCESS' then
        begin
          result.IsLoggedIn := true;
          result.SessionToken := jsonResp.S['sessionToken'];
        end
         else result.IsLoggedIn := false;
        result.ReturnCode := jsonResp.S['loginStatus'];
      end;
    except
      result.IsLoggedIn := false;
      result.ReturnCode := httpClient.ResponseText;
    end;
  finally
    if Assigned(sslHandler) then sslHandler.Free;
    params.Free;
    httpClient.Free;
  end;
end;

end.
