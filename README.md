# Betfair API-NG Sample Tool for Delphi
This project is a demo tool, intended to provide example usage of requests to [Betfair's API-NG](https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Betting+API+Home). 
Addtionally, this project provides sample code for connecting to Betfair API-NG from Delphi using Indy 10. This project was built for Delphi XE2, but should be backwards compatible with post Delphi 2009 versions. This sample tool logs all requests and responses to a response log in the same folder as the application executable for educational purposes. 

**Please note:** You will need to provide your own Application Key in order to use this sample tool.

## Configuration

There are two files:
* BetfairAPINGSampleTool.ini - Named with the same name as the executable. This file contains a comma seperated list of json-rpc methods and a comma seperated list of endpoints as name=value pairs.
* scenario-data.json - A Json file which contains the scenarios to pre-populate the tool with at application start-up time. You can edit this to provide your own scenarios, the required fields per json object in the array are caption, methodName and params.

## License

Licensed under the BSD3 license. See the [LICENSE.md](LICENSE.md) file.

## Delphi Developers Note

There is also a very basic Json-Rpc 2.0 client included, which I will probably break into a seperate project. A basic request looks like this:

```delphi
var
  FEndPoints: TStringList;
  FJsonRpc: TJsonRpc;

  httpClient: TIdHttp;
  sslIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  // ##### Memory clean-up and Error handling code omitted for clarity. #####
  FEndpoints := TStringList.Create;
  FEndpoints.Add('SportsAPING=https://beta-api.betfair.com/betting/json-rpc');
  FJsonRpc := TJsonRpc.Create(FEndpoints);

  // Setup the Http Client
  httpClient := TIdHttp.Create;
  httpClient.Request.ContentType := 'application/json';
  httpClient.Request.Accept := 'application/json';
  httpClient.Request.CustomHeaders.Add('X-Application:' + 'XXXX-APP_KEY-XXXX');
  httpClient.Request.CustomHeaders.Add('X-Authentication:' + 'XXXXXXXXX-SESSION_TOKEN-XXXXXXXXX');
  sslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  httpClient.IOHandler := sslIOHandler;

  FJsonRpc.DoJsonRpcReq(httpClient, 'SportsAPING/v1.0/listCurrentOrders', '{"orderProjection": "EXECUTABLE"}', FJsonRpc.GetNewIdAsString);

  // ##### Don't forget to clean up and handle errors! #####
end;
```

![Screenshot of the Sample Tool](http://jamiei.com/blog/wp-content/uploads/2013/09/screenshot.png)

## Dependencies
Due to distribution restrictions, there are a couple of dependencies that you must fulfil:

* [superobject](https://code.google.com/p/superobject/) - The excellent superobject library should be somewhere on your project's search path.
* [SSL DLL's](http://www.indyproject.org/sockets/SSL.EN.aspx) - Indy SSL support requires you to have the appropriate SSL DLLs on your deployment target node.
