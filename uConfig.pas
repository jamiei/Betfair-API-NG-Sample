unit uConfig;

interface

uses
  SysUtils, Classes, IniFiles, System.IOUtils;

type
  TAPINGMethodConfig = class
    private
      class function readStringFromIni(aFileName, aSection, aKeyname, aDefault: string): string;
      class procedure writeStringToIni(aFileName, aSection, aKeyname, aValue: string);
    public
      class function LoadEndpoint(aFileName: string): string;
      class function LoadMethodNames(aFileName: string): TStrings;
      class function LoadSavedAppKey(aFileName: string): string;
      class function SaveAppKey(aFileName, aAppkey: string): boolean;
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

class function TAPINGMethodConfig.LoadSavedAppKey(aFileName: string): string;
begin
  Result := TAPINGMethodConfig.readStringFromIni(aFileName, 'APING', 'appkey', '');
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

class function TAPINGMethodConfig.SaveAppKey(aFileName,
  aAppkey: string): boolean;
begin
  Result := true;
  try
    TAPINGMethodConfig.writeStringToIni(aFilename, 'APING', 'appkey', aAppKey);
  except
    Result := false;
  end;
end;

class procedure TAPINGMethodConfig.writeStringToIni(aFileName, aSection,
  aKeyname, aValue: string);
var
  iniFile : TIniFile;
begin
  iniFile := TIniFile.Create(aFileName);
  try
    iniFile.WriteString(aSection, aKeyname, aValue);
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
