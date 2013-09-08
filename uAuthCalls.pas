unit uAuthCalls;

interface

uses
  SysUtils,
  Classes,

  IdHttp;

function DoKeepAlive(aSessionToken: string): boolean;
function DoLogout(aSessionToken: string): boolean;


implementation

function DoKeepAlive(aSessionToken: string): boolean;
var
  httpClient: TIdHttp;
begin
  result := false;
  httpClient := TIdHttp.Create(nil);
  try
    try
      httpClient.Request.CustomHeaders.Text:= 'Cookie: ssoid=' + aSessionToken + ';';
      httpClient.Get('https://identitysso.betfair.com/api/keepAlive');
      if httpClient.ResponseCode = 200 then result := true;
    except
      result := false;
    end;
  finally
    httpClient.Free;
  end;
end;

function DoLogout(aSessionToken: string): boolean;
var
  httpClient: TIdHttp;
begin
  result := false;
  httpClient := TIdHttp.Create(nil);
  try
    try
      httpClient.Request.CustomHeaders.Text:= 'Cookie: ssoid=' + aSessionToken + '; mSsoToken=' + aSessionToken + '; loggedIn=true;' ;
      httpClient.Get('https://identitysso.betfair.com/api/logout');
      if httpClient.ResponseCode = 200 then result := true;
    except
      result := false;
    end;
  finally
    httpClient.Free;
  end;
end;

end.
