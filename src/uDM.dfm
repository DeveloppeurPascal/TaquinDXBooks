object dm: Tdm
  OldCreateOrder = False
  Height = 433
  Width = 622
  object RESTDelphiBooksAPI: TRESTClient
    BaseURL = 'https://delphi-books.com/api'
    Params = <>
    Left = 400
    Top = 56
  end
  object RESTListeDesLivres: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTDelphiBooksAPI
    Params = <>
    Resource = 'b/lastyear.json'
    Response = RESTResponse1
    Left = 408
    Top = 64
  end
  object RESTResponse1: TRESTResponse
    Left = 416
    Top = 72
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = tabListeDesLivres
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = JSONOnly
    Left = 424
    Top = 80
  end
  object tabListeDesLivres: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 432
    Top = 88
  end
end
