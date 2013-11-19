unit AppNsHandler;

interface

uses
  Comserv, Registry, SysUtils, ComObj, Classes, AxCtrls, Windows, ActiveX, Urlmon, WinInet,
  Dialogs;

const
  Class_SIELProtocol: TGUID = '{3A0DC1B1-5105-4AA6-B34D-F65E6DD99E94}';
  ProtoName = 'BfApp';

type
  TAppNsHandler = class(TComObject, IInternetProtocol)
  private

  protected
    function Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
      OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;
    function Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
    function Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;

    function Continue(const ProtocolData: TProtocolData): HResult; stdcall;
    function Terminate(dwOptions: DWORD): HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
    function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
    function LockRequest(dwOptions: DWORD): HResult; stdcall;
    function UnlockRequest: HResult; stdcall;
  end;

implementation

{ TAppNsHandler }

function TAppNsHandler.Abort(hrReason: HResult; dwOptions: DWORD): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Continue(const ProtocolData: TProtocolData): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.LockRequest(dwOptions: DWORD): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Resume: HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD;
  out libNewPosition: ULARGE_INTEGER): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
  OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Suspend: HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.Terminate(dwOptions: DWORD): HResult;
begin
  Result := S_OK;
end;

function TAppNsHandler.UnlockRequest: HResult;
begin
  Result := S_OK;
end;

end.
