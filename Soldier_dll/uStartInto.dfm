object StartInto: TStartInto
  Left = 0
  Top = 0
  ActiveControl = btn_Exit
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #36828#31243#27880#20837#31243#24207
  ClientHeight = 213
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    352
    213)
  PixelsPerInch = 96
  TextHeight = 14
  object btn_into: TButton
    Left = 171
    Top = 173
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #27880#20837'[&T]'
    TabOrder = 1
    OnClick = btn_intoClick
  end
  object btn_Exit: TButton
    Left = 263
    Top = 173
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #36864#20986'[&X]'
    TabOrder = 2
    OnClick = btn_ExitClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 332
    Height = 150
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = #26032#23435#20307
    Font.Style = []
    Lines.Strings = (
      #20351#29992#35828#26126#65306
      ''
      '1'#12289#27492#24037#20855#21487#25226#19968#20010'DLL'#25991#20214#36828#31243#27880#20837#21040#25805#20316#31995#32479#30340
      'Service.Exe'#25110#32773'Explorer.Exe'#36827#31243#20013#12290
      '2'#12289#32463#27979#35797#65292'Windows 7'#19981#20801#35768#23545'Service.Exe'#36827#31243#36827
      #34892#27880#20837#12290
      '3'#12289#25226#27492#25991#20214#21152#20837#25805#20316#31995#32479#30340#21551#21160#32452#25110#32773'RUN'#27880#20876#34920
      #20013#21363#21487#12290)
    ParentFont = False
    TabOrder = 0
  end
end
