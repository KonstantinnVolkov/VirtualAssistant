object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 328
  ClientWidth = 896
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 49
    Width = 43
    Height = 13
    Caption = #1047#1072#1087#1088#1086#1089#1099
  end
  object Label2: TLabel
    Left = 480
    Top = 49
    Width = 145
    Height = 13
    Caption = #1054#1090#1074#1077#1090#1099' '#1080#1083#1080' '#1085#1086#1084#1077#1088' '#1076#1077#1081#1089#1090#1074#1080#1103
  end
  object Label3: TLabel
    Left = 480
    Top = 262
    Width = 123
    Height = 13
    Caption = #1057#1089#1099#1083#1082#1072' '#1080#1083#1080' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1103
  end
  object AddCB: TComboBox
    Left = 8
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 0
    Text = #1063#1090#1086' '#1076#1086#1073#1072#1074#1080#1090#1100'?'
    Items.Strings = (
      'Greetings'
      'UsefulInfo'
      'Joke')
  end
  object AddButton: TButton
    Left = 8
    Top = 267
    Width = 97
    Height = 42
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = AddButtonClick
  end
  object AddMemo: TMemo
    Left = 8
    Top = 68
    Width = 409
    Height = 185
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object ActionNumber: TMemo
    Left = 480
    Top = 68
    Width = 409
    Height = 185
    Lines.Strings = (
      '')
    TabOrder = 3
  end
  object ActionCB: TComboBox
    Left = 480
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 4
    Text = #1058#1080#1087' '#1086#1090#1074#1077#1090#1072
    Items.Strings = (
      'Answer'
      'Action')
  end
  object LinkEdit: TEdit
    Left = 480
    Top = 277
    Width = 409
    Height = 21
    TabOrder = 5
  end
  object MainMenu1: TMainMenu
    Left = 928
    Top = 25
    object N1: TMenuItem
      Caption = #1050#1072#1082' '#1101#1090#1080#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100#1089#1103
      OnClick = N1Click
    end
  end
end
