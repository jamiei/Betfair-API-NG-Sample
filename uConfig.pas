unit uConfig;

interface

uses
  SysUtils, Classes, IniFiles, System.IOUtils;

type
  TAPINGMethodConfig = class
    private
      class function readStringFromIni(aFileName, aSection, aKeyname, aDefault: string): string;
    public
      class function LoadEndpoint(aFileName: string): string;
      class function LoadMethodNames(aFileName: string): TStrings;
  end;

  TScenarioDataConfig = class
    private
    public
      class function LoadScenarioDataAsStr(aFileName: string): string;
  end;

implementation

{ TAPINGMethodConfig }

class function TAPINGMethodConfig.LoadEndpoint(aFileName: string): string;
begin
  Result := TAPINGMethodConfig.readStringFromIni(aFileName, 'APING', 'endpoints', 'SportsAPING=https://beta-api.betfair.com/json-rpc');
end;

class function TAPINGMethodConfig.LoadMethodNames(
  aFileName: string): TStrings;
begin
  Result := TStringList.Create;
  Result.Delimiter := ',';
  Result.DelimitedText := TAPINGMethodConfig.readStringFromIni(aFileName, 'APING', 'methods', 'SportsAPING/v1.0/listCompetitions');
end;

class function TAPINGMethodConfig.readStringFromIni(aFileName, aSection,
  aKeyname, aDefault: string): string;
var
  iniFile : TIniFile;
begin
  iniFile := TIniFile.Create(aFileName);
  try
    Result := iniFile.ReadString(aSection, aKeyname, aDefault);
  finally
    iniFile.Free;
  end;
end;

{ TScenarioDataConfig }

class function TScenarioDataConfig.LoadScenarioDataAsStr(
  aFileName: string): string;
begin
  result := TFile.ReadAllText(aFileName);
end;

end.
