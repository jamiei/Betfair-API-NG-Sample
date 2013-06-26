object fAuthForm: TfAuthForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Login to betfair.com'
  ClientHeight = 408
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    737
    408)
  PixelsPerInch = 96
  TextHeight = 13
  object wbAuth: TWebBrowser
    Left = 8
    Top = 8
    Width = 721
    Height = 369
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnProgressChange = wbAuthProgressChange
    OnDocumentComplete = wbAuthDocumentComplete
    ExplicitWidth = 618
    ControlData = {
      4C000000844A0000232600000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126200000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object pbBrowse: TProgressBar
    Left = 8
    Top = 383
    Width = 721
    Height = 17
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
end
