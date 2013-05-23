unit JsonRpc;

interface

uses
  SysUtils,
  Classes,

  IdHttp,

  superobject;

type
  TJsonRpc = class
    private
      FId: integer;
      FEndpoints: TStringList;
      function getJsonRpcBody(aMethodName: string; aParams: string; aId: string): TStringStream;
      function endpointFromMethodName(aMethodName: string): string;
    public
      constructor Create(endpoint: string); overload;
      constructor Create(endpoints: TStringList); overload;
      destructor Destroy; override;
      function GetNewIdAsString: string;
      function DoJsonRpcReq(aHttpClient: TIdHttp; aMethodName: string; aParams: TStrings; aId: string): string;
    end;


implementation

{ TJsonRpc }

constructor TJsonRpc.Create(endpoint: string);
var
  defaultEndpoint: TStringList;
begin
  defaultEndpoint := TStringList.Create;
  defaultEndpoint.DelimitedText := 'default=' + endpoint;
  Create(defaultEndpoint);
end;

constructor TJsonRpc.Create(endpoints: TStringList);
begin
  FEndpoints := endpoints;
  FId := 0;
end;

destructor TJsonRpc.Destroy;
begin
  FEndpoints.Free;
  inherited;
end;

function TJsonRpc.DoJsonRpcReq(aHttpClient: TIdHttp; aMethodName: string; aParams: TStrings;
  aId: string): string;
var
  jsonRpcReqStream: TStringStream;
begin
  jsonRpcReqStream := getJsonRpcBody(aMethodName, aParams.Text, aId);
  try
    endpointFromMethodName(aMethodName);
    Result := aHttpClient.Post(endpointFromMethodName(aMethodName), jsonRpcReqStream);
  finally
    jsonRpcReqStream.Free;
  end;
end;

function TJsonRpc.endpointFromMethodName(aMethodName: string): string;
var
  endpointKey: string;
begin
  endpointKey := Copy(aMethodname, 0, (AnsiPos('/', aMethodName) - 1));
  if Length(FEndpoints.Values[endpointKey]) < 0 then Result := FEndpoints.Values['default'] else Result := FEndpoints.Values[endpointKey];
end;

function TJsonRpc.getJsonRpcBody(aMethodName, aParams, aId: string): TStringStream;
var
  request: ISuperObject;
begin
  request := TSuperObject.Create;
  request.S['jsonrpc'] := '2.0';
  request.S['method'] := aMethodName;
  request.O['params'] := SO(aParams);
  request.S['id'] := aId;
  result := TStringStream.Create(request.AsString);
end;

function TJsonRpc.GetNewIdAsString: string;
var
  guidTemp: TGUID;
begin
  Result := '';
  if CreateGUID(guidTemp) <> 0 then
  begin
    // Try a guid at first
    Result := GUIDToString(guidTemp);
  end
  else
  begin
    // Guid creation failed, fallback
    Inc(FId);
    Result := IntToStr(FId);
  end;
end;

end.
