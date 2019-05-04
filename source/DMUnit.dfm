object DMForm: TDMForm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 291
  Width = 394
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    OnMinimize = ApplicationEvents1Minimize
    Left = 35
    Top = 72
  end
  object HTTPRIO1: THTTPRIO
    URL = 'http://localhost:81/jfglWADWebSrv.jfglWebSrv/soap'
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 32
    Top = 16
  end
  object wsckt_Listen: TWSocket
    LineMode = False
    LineLimit = 65536
    LineEnd = #13#10
    LineEcho = False
    LineEdit = False
    Addr = '0.0.0.0'
    Port = '1314'
    Proto = 'udp'
    LocalAddr = '0.0.0.0'
    LocalPort = '0'
    LastError = 0
    MultiThreaded = False
    MultiCast = False
    MultiCastIpTTL = 1
    ReuseAddr = False
    ComponentOptions = []
    ListenBacklog = 5
    ReqVerLow = 1
    ReqVerHigh = 1
    OnDataAvailable = wsckt_ListenDataAvailable
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    KeepAliveOnOff = wsKeepAliveOnSystem
    KeepAliveTime = 30000
    KeepAliveInterval = 1000
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    Left = 128
    Top = 14
  end
  object SoapConnection1: TSoapConnection
    Agent = 'Borland SOAP 1.2'
    URL = 'http://localhost:1024/jfglWADWebSrv.jfglWebSrv/soap'
    SOAPServerIID = 'IAppServerSOAP - {C99F4735-D6D2-495C-8CA2-E53E5A439E61}'
    UseSOAPAdapter = False
    Left = 32
    Top = 144
  end
  object tmr_OnlineCheck: TTimer
    Interval = 20000
    OnTimer = tmr_OnlineCheckTimer
    Left = 232
    Top = 16
  end
end
