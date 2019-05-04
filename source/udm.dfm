object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 459
  Width = 557
  object conn_DB: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\xxx\'#22810#23186#20307#25945#23460#31649#29702#31995#32479'\bi' +
      'n\data.dll;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 32
  end
  object tmr_Check: TTimer
    Interval = 30000
    OnTimer = tmr_CheckTimer
    Left = 112
    Top = 32
  end
end
