object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Betfair API-NG Sample Tool'
  ClientHeight = 519
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblMethodName: TLabel
    Left = 8
    Top = 160
    Width = 69
    Height = 13
    Caption = 'Method name:'
  end
  object gbAuthentication: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 85
    Caption = 'Authentication'
    TabOrder = 0
    object lblSessionToken: TLabel
      Left = 16
      Top = 27
      Width = 72
      Height = 13
      Caption = 'Session Token:'
    end
    object lblAppKey: TLabel
      Left = 16
      Top = 54
      Width = 44
      Height = 13
      Caption = 'App Key:'
    end
    object eSessionToken: TEdit
      Left = 96
      Top = 24
      Width = 225
      Height = 21
      TabOrder = 0
    end
    object eAppKey: TEdit
      Left = 96
      Top = 51
      Width = 225
      Height = 21
      TabOrder = 1
    end
  end
  object mParams: TMemo
    Left = 8
    Top = 184
    Width = 503
    Height = 103
    Lines.Strings = (
      'Params..')
    TabOrder = 4
  end
  object btnSend: TButton
    Left = 384
    Top = 68
    Width = 97
    Height = 25
    Caption = 'Send'
    TabOrder = 2
    OnClick = btnSendClick
  end
  object cbOperation: TComboBox
    Left = 96
    Top = 157
    Width = 415
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
  object mOutput: TMemo
    Left = 8
    Top = 293
    Width = 503
    Height = 218
    ReadOnly = True
    TabOrder = 5
  end
  object gbPrepopulateInstructions: TGroupBox
    Left = 8
    Top = 99
    Width = 503
    Height = 44
    Caption = 'Pre-populate scenario'
    TabOrder = 1
    object cbScenario: TComboBox
      Left = 16
      Top = 18
      Width = 473
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbScenarioChange
    end
  end
  object btnLogin: TButton
    Left = 384
    Top = 9
    Width = 97
    Height = 25
    Caption = 'Login'
    TabOrder = 6
    OnClick = btnLoginClick
  end
  object btnLogout: TButton
    Left = 384
    Top = 37
    Width = 97
    Height = 25
    Caption = 'Logout'
    Enabled = False
    TabOrder = 7
    OnClick = btnLogoutClick
  end
  object TKeepAliveTimer: TTimer
    Enabled = False
    Interval = 420000
    OnTimer = TKeepAliveTimerTimer
    Left = 488
    Top = 72
  end
end
