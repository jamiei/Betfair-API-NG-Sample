unit uAuthCalls;

interface

uses
  SysUtils,
  Classes,

  superobject,
  IdHttp;

function DoKeepAlive(aAppKey, aSessionToken: string): boolean;
function DoLogout(aAppKey, aSessionToken: string): boolean;


implementation

function DoKeepAlive(aAppKey, aSessionToken: string): boolean;
var
  httpClient: TIdHttp;
  jsonResp: ISuperObject;
begin
  result := false;
  httpClient := TIdHttp.Create(nil);
  try
    try
      httpClient.Request.CustomHeaders.AddValue('X-Application', aAppKey);
      httpClient.Request.CustomHeaders.AddValue('X-Authentication', aSessionToken);
      httpClient.Request.Accept := 'application/json';
      httpClient.Get('https://identitysso.betfair.com/api/keepAlive');
      if httpClient.ResponseCode = 200 then
      begin
        jsonResp := SO(httpClient.ResponseText);
        if jsonResp.S['status'] = 'SUCESS' then result := true else result := false;
      end;
    except
      result := false;
    end;
  finally
    httpClient.Free;
  end;
end;

function DoLogout(aAppKey, aSessionToken: string): boolean;
var
  httpClient: TIdHttp;
  jsonResp: ISuperObject;
begin
  result := false;
  httpClient := TIdHttp.Create(nil);
  try
    try
      httpClient.Request.CustomHeaders.AddValue('X-Application', aAppKey);
      httpClient.Request.CustomHeaders.AddValue('X-Authentication', aSessionToken);
      httpClient.Request.Accept := 'application/json';
      httpClient.Get('https://identitysso.betfair.com/api/logout');
      if httpClient.ResponseCode = 200 then
      begin
        jsonResp := SO(httpClient.ResponseText);
        if jsonResp.S['status'] = 'SUCESS' then result := true else result := false;
      end;
    except
      result := false;
    end;
  finally
    httpClient.Free;
  end;
end;

end.
