object SystemSet: TSystemSet
  Left = 0
  Top = 0
  ActiveControl = btn_Exit
  BorderStyle = bsDialog
  Caption = #31995#32479#35774#32622
  ClientHeight = 390
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 586
    Height = 345
    ActivePage = ts2
    Align = alClient
    HotTrack = True
    TabOrder = 0
    ExplicitWidth = 455
    ExplicitHeight = 267
    object ts1: TTabSheet
      Caption = #19978#35838#26102#38388#35774#32622
      ExplicitWidth = 447
      ExplicitHeight = 238
      object lbl_11: TLabel
        Left = 8
        Top = 10
        Width = 60
        Height = 14
        Caption = #24320#22987#26085#26399#65306
      end
      object lbl_12: TLabel
        Left = 168
        Top = 10
        Width = 60
        Height = 14
        Caption = #24490#29615#27425#25968#65306
      end
      object lbl_2: TLabel
        Left = 294
        Top = 10
        Width = 90
        Height = 13
        Caption = '(-1'#34920#31034#19981#38480#27425#25968')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object DBDateTimeEditEh1: TDBDateTimeEditEh
        Left = 66
        Top = 7
        Width = 87
        Height = 22
        DataField = #24320#22987#26085#26399
        DataSource = DataSource1
        EditButtons = <>
        Kind = dtkDateEh
        TabOrder = 0
        Visible = True
      end
      object edt_1: TDBNumberEditEh
        Left = 226
        Top = 7
        Width = 61
        Height = 22
        DataField = #27425#25968
        DataSource = DataSource1
        EditButtons = <>
        MaxValue = 99999.000000000000000000
        MinValue = -1.000000000000000000
        TabOrder = 1
        Visible = True
      end
      object DBGridEh1: TDBGridEh
        Left = 8
        Top = 41
        Width = 558
        Height = 164
        Align = alCustom
        AllowedOperations = [alopInsertEh, alopUpdateEh]
        DataGrouping.GroupLevels = <>
        DataSource = DataSource2
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -12
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        ImeMode = imDisable
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghColumnResize, dghColumnMove, dghHotTrack]
        ParentFont = False
        RowDetailPanel.Color = clBtnFace
        RowHeight = 45
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        UseMultiTitle = True
        VertScrollBar.VisibleMode = sbNeverShowEh
        Columns = <
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Layout = tlCenter
            Visible = False
            Width = 29
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #25945#23460
            Footers = <>
            Layout = tlCenter
            Visible = False
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #35828#26126
            Footers = <>
            Layout = tlCenter
            Width = 45
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #24320#22987#26102#38388
            Footers = <>
            Layout = tlCenter
            Width = 58
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #32467#26463#26102#38388
            Footers = <>
            Layout = tlCenter
            Width = 58
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#26085
            Footers = <>
            Layout = tlCenter
            Width = 55
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#19968
            Footers = <>
            Layout = tlCenter
            Width = 55
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#20108
            Footers = <>
            Layout = tlCenter
            Width = 55
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#19977
            Footers = <>
            Layout = tlCenter
            Width = 55
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#22235
            Footers = <>
            Layout = tlCenter
            Width = 55
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#20116
            Footers = <>
            Layout = tlCenter
            Width = 55
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = #21608#20845
            Footers = <>
            Layout = tlCenter
            Width = 55
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object ts2: TTabSheet
      Caption = #25237#24433#25511#21046#35774#32622
      ImageIndex = 1
      ExplicitWidth = 447
      ExplicitHeight = 238
      object lbl1: TLabel
        Left = 30
        Top = 36
        Width = 72
        Height = 14
        Caption = #24320#26426#25511#21046#30721#65306
      end
      object lbl2: TLabel
        Left = 30
        Top = 63
        Width = 72
        Height = 14
        Caption = #20851#26426#25511#21046#30721#65306
      end
      object lbl3: TLabel
        Left = 30
        Top = 10
        Width = 72
        Height = 14
        Caption = #25237#24433#26426#22411#21495#65306
        FocusControl = dbedt1
      end
      object lbl4: TLabel
        Left = 54
        Top = 89
        Width = 48
        Height = 14
        Caption = #20018#21475#21495#65306
        FocusControl = cbb_Port
      end
      object lbl5: TLabel
        Left = 54
        Top = 115
        Width = 48
        Height = 14
        Caption = #27874#29305#29575#65306
        FocusControl = dbedt5
      end
      object lbl6: TLabel
        Left = 30
        Top = 141
        Width = 72
        Height = 14
        Caption = #22855#20598#26657#39564#20301#65306
        FocusControl = dbedt6
      end
      object lbl7: TLabel
        Left = 54
        Top = 168
        Width = 48
        Height = 14
        Caption = #25968#25454#20301#65306
        FocusControl = dbedt7
      end
      object lbl8: TLabel
        Left = 54
        Top = 194
        Width = 48
        Height = 14
        Caption = #20572#27490#20301#65306
        FocusControl = dbedt8
      end
      object btn1: TSpeedButton
        Left = 532
        Top = 35
        Width = 23
        Height = 22
        Hint = #27979#35797
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000520B0000520B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
          82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
          F100C56A31000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000EEEEEEEEEEAA
          EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE81EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEAA
          A2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAA2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAD5A2EEEEEEEEEEEEEEEEEEEEEEEEEE81E381EEEEEEEEEEEEEEEEEEEEEEAAA2
          A2A2D4A2EEEEEEEEEEEEEEEEEEEE81818181AC81EEEEEEEEEEEEEEEEEEEEAAD5
          D4D4D4D4A2EEEEEEEEEEEEEEEEEE81E3ACACACAC81EEEEEEEEEEEEEEEEEEEEAA
          D5D4A2AAAAAAEEEEEEEEEEEEEEEEEE81E3AC81818181EEEEEEEEEEEEEEEEEEAA
          D5D4D4A2EEEEEEEEEEEEEEEEEEEEEE81E3ACAC81EEEEEEEEEEEEEEEEAAA2A2A2
          A2D5D4D4A2EEEEEEEEEEEEEE8181818181E3ACAC81EEEEEEEEEEEEEEAAD5D5D4
          D4D4D4D4D4A2EEEEEEEEEEEE81E3E3ACACACACACAC81EEEEEEEEEEEEEEAAD5D5
          D4D4A2AAAAAAEEEEEEEEEEEEEE81E3E3ACAC81818181EEEEEEEEEEEEEEAAD5D5
          D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEEEAA
          D5D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEAA
          AAAAAAAAAAAAAAAAEEEEEEEEEEEEEE818181818181818181EEEE}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btn1Click
      end
      object btn2: TSpeedButton
        Left = 532
        Top = 60
        Width = 23
        Height = 22
        Hint = #27979#35797
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000520B0000520B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
          82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
          F100C56A31000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000EEEEEEEEEEAA
          EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE81EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEAA
          A2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAA2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAD5A2EEEEEEEEEEEEEEEEEEEEEEEEEE81E381EEEEEEEEEEEEEEEEEEEEEEAAA2
          A2A2D4A2EEEEEEEEEEEEEEEEEEEE81818181AC81EEEEEEEEEEEEEEEEEEEEAAD5
          D4D4D4D4A2EEEEEEEEEEEEEEEEEE81E3ACACACAC81EEEEEEEEEEEEEEEEEEEEAA
          D5D4A2AAAAAAEEEEEEEEEEEEEEEEEE81E3AC81818181EEEEEEEEEEEEEEEEEEAA
          D5D4D4A2EEEEEEEEEEEEEEEEEEEEEE81E3ACAC81EEEEEEEEEEEEEEEEAAA2A2A2
          A2D5D4D4A2EEEEEEEEEEEEEE8181818181E3ACAC81EEEEEEEEEEEEEEAAD5D5D4
          D4D4D4D4D4A2EEEEEEEEEEEE81E3E3ACACACACACAC81EEEEEEEEEEEEEEAAD5D5
          D4D4A2AAAAAAEEEEEEEEEEEEEE81E3E3ACAC81818181EEEEEEEEEEEEEEAAD5D5
          D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEEEAA
          D5D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEAA
          AAAAAAAAAAAAAAAAEEEEEEEEEEEEEE818181818181818181EEEE}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btn2Click
      end
      object lbl_Dir: TLabel
        Left = 18
        Top = 220
        Width = 84
        Height = 14
        Caption = #25511#21046#31243#24207#25991#20214#65306
      end
      object lbl_13: TLabel
        Left = 18
        Top = 249
        Width = 84
        Height = 14
        Caption = #31243#24207#26631#39064#25991#26412#65306
        FocusControl = dbedt4
      end
      object btn3: TSpeedButton
        Left = 532
        Top = 218
        Width = 23
        Height = 22
        Hint = #27979#35797
        Caption = '...'
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btn3Click
      end
      object btn_Open2: TSpeedButton
        Left = 507
        Top = 246
        Width = 23
        Height = 22
        Hint = #27979#35797#25171#24320#25237#24433#26426
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000520B0000520B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
          82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
          F100C56A31000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000EEEEEEEEEEAA
          EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE81EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEAA
          A2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAA2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAD5A2EEEEEEEEEEEEEEEEEEEEEEEEEE81E381EEEEEEEEEEEEEEEEEEEEEEAAA2
          A2A2D4A2EEEEEEEEEEEEEEEEEEEE81818181AC81EEEEEEEEEEEEEEEEEEEEAAD5
          D4D4D4D4A2EEEEEEEEEEEEEEEEEE81E3ACACACAC81EEEEEEEEEEEEEEEEEEEEAA
          D5D4A2AAAAAAEEEEEEEEEEEEEEEEEE81E3AC81818181EEEEEEEEEEEEEEEEEEAA
          D5D4D4A2EEEEEEEEEEEEEEEEEEEEEE81E3ACAC81EEEEEEEEEEEEEEEEAAA2A2A2
          A2D5D4D4A2EEEEEEEEEEEEEE8181818181E3ACAC81EEEEEEEEEEEEEEAAD5D5D4
          D4D4D4D4D4A2EEEEEEEEEEEE81E3E3ACACACACACAC81EEEEEEEEEEEEEEAAD5D5
          D4D4A2AAAAAAEEEEEEEEEEEEEE81E3E3ACAC81818181EEEEEEEEEEEEEEAAD5D5
          D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEEEAA
          D5D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEAA
          AAAAAAAAAAAAAAAAEEEEEEEEEEEEEE818181818181818181EEEE}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btn_Open2Click
      end
      object btn_Close2: TSpeedButton
        Left = 532
        Top = 246
        Width = 23
        Height = 22
        Hint = #27979#35797#20851#38381#25237#24433#26426
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000520B0000520B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
          82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
          F100C56A31000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000EEEEEEEEEEAA
          EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE81EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEAA
          A2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAA2EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEEEE
          AAD5A2EEEEEEEEEEEEEEEEEEEEEEEEEE81E381EEEEEEEEEEEEEEEEEEEEEEAAA2
          A2A2D4A2EEEEEEEEEEEEEEEEEEEE81818181AC81EEEEEEEEEEEEEEEEEEEEAAD5
          D4D4D4D4A2EEEEEEEEEEEEEEEEEE81E3ACACACAC81EEEEEEEEEEEEEEEEEEEEAA
          D5D4A2AAAAAAEEEEEEEEEEEEEEEEEE81E3AC81818181EEEEEEEEEEEEEEEEEEAA
          D5D4D4A2EEEEEEEEEEEEEEEEEEEEEE81E3ACAC81EEEEEEEEEEEEEEEEAAA2A2A2
          A2D5D4D4A2EEEEEEEEEEEEEE8181818181E3ACAC81EEEEEEEEEEEEEEAAD5D5D4
          D4D4D4D4D4A2EEEEEEEEEEEE81E3E3ACACACACACAC81EEEEEEEEEEEEEEAAD5D5
          D4D4A2AAAAAAEEEEEEEEEEEEEE81E3E3ACAC81818181EEEEEEEEEEEEEEAAD5D5
          D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4A2EEEEEEEEEEEEEEEEEE81E3E3E3ACAC81EEEEEEEEEEEEEEEEEEAAD5
          D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEEEAA
          D5D5D5D4D4D4A2EEEEEEEEEEEEEEEE81E3E3E3ACACAC81EEEEEEEEEEEEEEEEAA
          AAAAAAAAAAAAAAAAEEEEEEEEEEEEEE818181818181818181EEEE}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btn_Close2Click
      end
      object dbedt1: TDBEdit
        Left = 104
        Top = 7
        Width = 451
        Height = 22
        DataField = #25237#24433#26426#21517#31216
        DataSource = DataSource3
        TabOrder = 0
      end
      object dbedt2: TDBEdit
        Left = 104
        Top = 34
        Width = 426
        Height = 22
        DataField = #24320#26426#25511#21046#30721
        DataSource = DataSource3
        TabOrder = 1
      end
      object dbedt3: TDBEdit
        Left = 104
        Top = 60
        Width = 426
        Height = 22
        DataField = #20851#26426#25511#21046#30721
        DataSource = DataSource3
        TabOrder = 2
      end
      object cbb_Port: TDBComboBoxEh
        Left = 104
        Top = 87
        Width = 144
        Height = 22
        Alignment = taLeftJustify
        DataField = #20018#21475#21495
        DataSource = DataSource3
        EditButtons = <>
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9')
        TabOrder = 3
        Visible = True
        OnClick = cbb_PortClick
        OnDropDown = cbb_PortDropDown
      end
      object dbedt5: TDBComboBoxEh
        Left = 104
        Top = 114
        Width = 144
        Height = 22
        Alignment = taLeftJustify
        DataField = #27874#29305#29575
        DataSource = DataSource3
        EditButtons = <>
        Items.Strings = (
          '1200'
          '2400'
          '4800'
          '9600'
          '19200'
          '38400'
          '57600'
          '115200'
          '230400'
          '460800'
          '921600')
        TabOrder = 4
        Visible = True
        OnClick = cbb_PortClick
      end
      object dbedt6: TDBComboBoxEh
        Left = 104
        Top = 141
        Width = 144
        Height = 22
        Alignment = taLeftJustify
        DataField = #22855#20598#26657#39564#20301
        DataSource = DataSource3
        EditButtons = <>
        Items.Strings = (
          #26080
          #22855#26657#39564
          #20598#26657#39564
          #26631#24535
          #31354#26684)
        KeyItems.Strings = (
          'pNone'
          'pOdd'
          'pEven'
          'pMark'
          'pSpace')
        TabOrder = 5
        Visible = True
        OnClick = cbb_PortClick
      end
      object dbedt7: TDBComboBoxEh
        Left = 104
        Top = 167
        Width = 144
        Height = 22
        Alignment = taLeftJustify
        DataField = #25968#25454#20301
        DataSource = DataSource3
        EditButtons = <>
        Items.Strings = (
          '5'
          '6'
          '7'
          '8')
        TabOrder = 6
        Visible = True
        OnClick = cbb_PortClick
      end
      object dbedt8: TDBComboBoxEh
        Left = 104
        Top = 194
        Width = 144
        Height = 22
        Alignment = taLeftJustify
        DataField = #20572#27490#20301
        DataSource = DataSource3
        EditButtons = <>
        Items.Strings = (
          '1'
          '1.5'
          '2')
        TabOrder = 7
        Visible = True
        OnClick = cbb_PortClick
      end
      object dbedt4: TDBEdit
        Left = 104
        Top = 246
        Width = 400
        Height = 22
        Hint = #24517#39035#20934#30830#30340#22635#20889#25237#24433#26426#25511#21046#31243#24207#30340#26631#39064#20869#23481
        DataField = #31243#24207#26631#39064
        DataSource = DataSource3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object dbedt_Exe: TDBEdit
        Left = 104
        Top = 218
        Width = 426
        Height = 22
        Hint = #24102#36335#36335#24452#30340#25237#24433#26426#25511#21046#31243#24207#25991#20214#20840#21517'(exe'#25991#20214')'
        DataField = #25511#21046#31243#24207
        DataSource = DataSource3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 345
    Width = 586
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 267
    ExplicitWidth = 455
    DesignSize = (
      586
      45)
    object btn_Save: TBitBtn
      Left = 395
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #20445#23384
      TabOrder = 0
      OnClick = btn_SaveClick
      Glyph.Data = {
        36060000424D3606000000000000360400002800000020000000100000000100
        08000000000000020000320B0000320B00000001000000000000000000003300
        00006600000099000000CC000000FF0000000033000033330000663300009933
        0000CC330000FF33000000660000336600006666000099660000CC660000FF66
        000000990000339900006699000099990000CC990000FF99000000CC000033CC
        000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
        0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
        330000333300333333006633330099333300CC333300FF333300006633003366
        33006666330099663300CC663300FF6633000099330033993300669933009999
        3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
        330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
        66006600660099006600CC006600FF0066000033660033336600663366009933
        6600CC336600FF33660000666600336666006666660099666600CC666600FF66
        660000996600339966006699660099996600CC996600FF99660000CC660033CC
        660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
        6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
        990000339900333399006633990099339900CC339900FF339900006699003366
        99006666990099669900CC669900FF6699000099990033999900669999009999
        9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
        990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
        CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
        CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
        CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
        CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
        CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
        FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
        FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
        FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
        FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
        000000808000800000008000800080800000C0C0C00080808000191919004C4C
        4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
        82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
        F100C56A31000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000EEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE0909
        EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEEEEEEEEEEEE091010
        09EEEEEEEEEEEEEEEEEEEEEEEE81ACAC81EEEEEEEEEEEEEEEEEEEEEE09101010
        1009EEEEEEEEEEEEEEEEEEEE81ACACACAC81EEEEEEEEEEEEEEEEEE0910101010
        101009EEEEEEEEEEEEEEEE81ACACACACACAC81EEEEEEEEEEEEEEEE0910100909
        10101009EEEEEEEEEEEEEE81ACAC8181ACACAC81EEEEEEEEEEEEEE091009EEEE
        0910101009EEEEEEEEEEEE81AC81EEEE81ACACAC81EEEEEEEEEEEE0909EEEEEE
        EE0910101009EEEEEEEEEE8181EEEEEEEE81ACACAC81EEEEEEEEEEEEEEEEEEEE
        EEEE0910101009EEEEEEEEEEEEEEEEEEEEEE81ACACAC81EEEEEEEEEEEEEEEEEE
        EEEEEE0910101009EEEEEEEEEEEEEEEEEEEEEE81ACACAC81EEEEEEEEEEEEEEEE
        EEEEEEEE09101009EEEEEEEEEEEEEEEEEEEEEEEE81ACAC81EEEEEEEEEEEEEEEE
        EEEEEEEEEE091009EEEEEEEEEEEEEEEEEEEEEEEEEE81AC81EEEEEEEEEEEEEEEE
        EEEEEEEEEEEE0909EEEEEEEEEEEEEEEEEEEEEEEEEEEE8181EEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE}
      NumGlyphs = 2
    end
    object btn_Exit: TBitBtn
      Left = 486
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #20851#38381
      TabOrder = 1
      OnClick = btn_ExitClick
      Glyph.Data = {
        36060000424D3606000000000000360400002800000020000000100000000100
        08000000000000020000B40B0000B40B00000001000000000000000000003300
        00006600000099000000CC000000FF0000000033000033330000663300009933
        0000CC330000FF33000000660000336600006666000099660000CC660000FF66
        000000990000339900006699000099990000CC990000FF99000000CC000033CC
        000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
        0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
        330000333300333333006633330099333300CC333300FF333300006633003366
        33006666330099663300CC663300FF6633000099330033993300669933009999
        3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
        330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
        66006600660099006600CC006600FF0066000033660033336600663366009933
        6600CC336600FF33660000666600336666006666660099666600CC666600FF66
        660000996600339966006699660099996600CC996600FF99660000CC660033CC
        660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
        6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
        990000339900333399006633990099339900CC339900FF339900006699003366
        99006666990099669900CC669900FF6699000099990033999900669999009999
        9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
        990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
        CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
        CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
        CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
        CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
        CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
        FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
        FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
        FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
        FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
        000000808000800000008000800080800000C0C0C00080808000191919004C4C
        4C00B2B2B200E5E5E5005A1E1E00783C3C0096646400C8969600FFC8C800465F
        82005591B9006EB9D7008CD2E600B4E6F000D8E9EC0099A8AC00646F7100E2EF
        F100C56A31000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000EEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE09EEEE
        EEEEEEEEEEEEEEEE10EEEEEEEE81EEEEEEEEEEEEEEEEEEEEACEEEEEE091009EE
        EEEEEEEEEEEEEEEEEEEEEEEE81AC81EEEEEEEEEEEEEEEEEEEEEEEEEE09101009
        EEEEEEEEEEEEEE10EEEEEEEE81E3AC81EEEEEEEEEEEEEEACEEEEEEEEEE091009
        EEEEEEEEEEEE10EEEEEEEEEEEE81E381EEEEEEEEEEEEACEEEEEEEEEEEEEE0910
        09EEEEEEEE1009EEEEEEEEEEEEEE81AC81EEEEEEEEAC81EEEEEEEEEEEEEEEE09
        1009EEEE1009EEEEEEEEEEEEEEEEEE81AC81EEEEAC81EEEEEEEEEEEEEEEEEEEE
        0910091009EEEEEEEEEEEEEEEEEEEEEE81AC81AC81EEEEEEEEEEEEEEEEEEEEEE
        EE091009EEEEEEEEEEEEEEEEEEEEEEEEEE81AC81EEEEEEEEEEEEEEEEEEEEEEEE
        0910091009EEEEEEEEEEEEEEEEEEEEEE81AC818181EEEEEEEEEEEEEEEEEEEE09
        1009EEEE1009EEEEEEEEEEEEEEEEEE81AC81EEEE8181EEEEEEEEEEEEEE091010
        09EEEEEEEE1009EEEEEEEEEEEE81ACAC81EEEEEEEE8181EEEEEEEEEE09101009
        EEEEEEEEEEEE1009EEEEEEEE81E3AC81EEEEEEEEEEEE8181EEEEEEEE090909EE
        EEEEEEEEEEEEEEEE10EEEEEEAC81ACEEEEEEEEEEEEEEEEEE81EEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE}
      NumGlyphs = 2
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 280
    Top = 176
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 368
    Top = 176
  end
  object ADOQuery1: TADOQuery
    Connection = dm.conn_DB
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#19978#35838#26085#26399#34920)
    Left = 240
    Top = 176
  end
  object ADOQuery2: TADOQuery
    Connection = dm.conn_DB
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#19978#35838#26102#38388#34920)
    Left = 328
    Top = 176
  end
  object AdoQuery3: TADOQuery
    Connection = dm.conn_DB
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from '#25237#24433#25511#21046#35774#32622#34920)
    Left = 328
    Top = 64
  end
  object DataSource3: TDataSource
    DataSet = AdoQuery3
    Left = 368
    Top = 64
  end
  object dlgOpen1: TOpenDialog
    DefaultExt = '*.exe'
    Filter = #31243#24207#25991#20214'(*.exe)|*.exe|'#25152#26377#25991#20214'(*.*)|*.*'
    Title = #25237#24433#26426#25511#21046#31243#24207
    Left = 400
    Top = 176
  end
end