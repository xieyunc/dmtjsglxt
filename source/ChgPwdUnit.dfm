object ChgPwdForm: TChgPwdForm
  Left = 384
  Top = 191
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #20462#25913#23494#30721
  ClientHeight = 222
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object rzgrpbx1: TRzGroupBox
    Left = 18
    Top = 9
    Width = 313
    Height = 168
    Caption = #35831#36755#20837#20197#19979#20449#24687#65306
    TabOrder = 0
    object lbl_1: TRzLabel
      Left = 61
      Top = 32
      Width = 60
      Height = 14
      Caption = #19978#26426#35777#21495#65306
      LightTextStyle = True
    end
    object RzLabel1: TRzLabel
      Left = 61
      Top = 65
      Width = 56
      Height = 14
      Caption = #21407' '#23494' '#30721#65306
      LightTextStyle = True
    end
    object img1: TImage
      Left = 16
      Top = 31
      Width = 32
      Height = 32
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000000000000000000000000000000000000077000000000
        00000000000000000000F7870000000000000000000000077008078700000000
        0000000000000887770087870000000000000000000008F7878F778700000000
        00008000000008F78708F787000000000008B330000000078700078700000000
        0800BB80000000878700878700000000833BB80000008F77878F778700000000
        8BBB8030000008F7878F7787000000800BB80300000000078708F78700000833
        BB803000000000878708F78800008BBBB803000000008F77878F77F800008BBB
        8030000000008F7788F77F778000BBB803000000000008F78F77F000000BBB80
        30000000000008F8F7700888888BB8030000000000008F8F77088BBBBBBB8030
        000000000008F78F708BBBBBBBB7B30000000000008F778F70BBBB7B7B7B7300
        0000000008F77F8F0BBBB0B0B7B7B300000000008F77F78F8BBBBB0B0B7B7300
        000000008F777F788BBBBBB0B0B7B300000000008F77F7008BBB880B0B0B7300
        000000008F77708F8BB00770B0B73000000000008F77F0878BB00070BBB73000
        0000000008F7708808B00800BB73000000000000008F77000788000BB3300000
        000000000008FFF0878077773000000000000000000088808880888800000000
        0000000000000000800080000000000000000000000000000000000000000000
        00000000FFF9FFFFFFF0FFFFFE607FFFFC007FFFF8007FFFF8007FF1F8007FE0
        FC107F80F8007F00F0007F00F8007C01FC007803F8007007F000700FF000201F
        F800003FF800007FF00000FFE00001FFC00001FF800001FF000001FF000001FF
        000001FF000803FF000403FF800207FFC0000FFFE0001FFFF0107FFFFE73FFFF
        FF07FFFF}
      Stretch = True
    end
    object RzLabel2: TRzLabel
      Left = 61
      Top = 97
      Width = 56
      Height = 14
      Caption = #26032' '#23494' '#30721#65306
      LightTextStyle = True
    end
    object RzLabel3: TRzLabel
      Left = 61
      Top = 130
      Width = 60
      Height = 14
      Caption = #30830#35748#23494#30721#65306
      LightTextStyle = True
    end
    object edt_User: TRzEdit
      Left = 134
      Top = 32
      Width = 155
      Height = 22
      TabOrder = 0
      OnChange = edt_UserChange
    end
    object edt_Pwd: TRzEdit
      Left = 134
      Top = 63
      Width = 155
      Height = 22
      TabOrder = 1
      OnChange = edt_UserChange
    end
    object edt_newPwd: TRzEdit
      Left = 134
      Top = 93
      Width = 155
      Height = 22
      TabOrder = 2
      OnChange = edt_UserChange
    end
    object edt_newSePwd: TRzEdit
      Left = 134
      Top = 124
      Width = 155
      Height = 22
      TabOrder = 3
      OnChange = edt_UserChange
    end
  end
  object btn_OK: TRzBitBtn
    Left = 144
    Top = 186
    Default = True
    Caption = #30830#23450'[&O]'
    Enabled = False
    LightTextStyle = True
    TabOrder = 1
    OnClick = btn_OKClick
  end
  object btn_Exit: TRzBitBtn
    Left = 256
    Top = 186
    Cancel = True
    Caption = #36864#20986'[&X]'
    LightTextStyle = True
    TabOrder = 2
    OnClick = btn_ExitClick
  end
end
