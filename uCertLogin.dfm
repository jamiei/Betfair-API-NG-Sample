object fCertLogin: TfCertLogin
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Certificate Login'
  ClientHeight = 234
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 517
    Height = 25
    AutoSize = False
    Caption = 
      'This method uses the certificate login method. There are pre-req' +
      'uisistes that you will need to follow:  http://bit.ly/1aexr6P'
    WordWrap = True
  end
  object gbLoginParams: TGroupBox
    Left = 8
    Top = 56
    Width = 517
    Height = 137
    Caption = 'Please enter your Betfair details:'
    TabOrder = 0
    object lblUsername: TLabel
      Left = 42
      Top = 27
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object lblPassword: TLabel
      Left = 42
      Top = 54
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object eUsername: TEdit
      Left = 144
      Top = 24
      Width = 329
      Height = 21
      TabOrder = 0
    end
    object ePassword: TEdit
      Left = 144
      Top = 51
      Width = 329
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object eCertFile: TEdit
      Left = 42
      Top = 78
      Width = 346
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object btnOpenCert: TButton
      Left = 394
      Top = 78
      Width = 79
      Height = 25
      Caption = 'Choose Cert'
      TabOrder = 3
      OnClick = btnOpenCertClick
    end
  end
  object btnLogin: TButton
    Left = 240
    Top = 199
    Width = 122
    Height = 25
    Caption = 'Login'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnLoginClick
  end
  object btnCancel: TButton
    Left = 368
    Top = 199
    Width = 113
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object eKeyFile: TEdit
    Left = 50
    Top = 161
    Width = 346
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object btnChooseKey: TButton
    Left = 402
    Top = 161
    Width = 79
    Height = 25
    Caption = 'Choose Key'
    TabOrder = 4
    OnClick = btnChooseKeyClick
  end
  object foCert: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Title = 'Please select your certificate file.'
    Left = 480
    Top = 40
  end
  object foKey: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Title = 'Please select your key file'
    Left = 440
    Top = 40
  end
end
