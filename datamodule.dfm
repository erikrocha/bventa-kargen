object dm: Tdm
  Height = 480
  Width = 640
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 'D:\bventa kargen\data\DB.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 48
    Top = 40
  end
  object IBTransaction1: TIBTransaction
    Active = True
    DefaultDatabase = IBDatabase1
    Left = 144
    Top = 40
  end
  object Datasource1: TDataSource
    DataSet = IBQuery1
    Left = 336
    Top = 40
  end
  object IBQuery1: TIBQuery
    Database = IBDatabase1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'SELECT'
      '    k.product_sku AS sku,'
      '    p.description,'
      '    MAX(k.fecha)",  -- Obtiene la fecha m'#225's reciente'
      '    k.type,'
      '    k.serie,'
      '    k.number,'
      '    k.type_operation,'
      '    k.output'
      'FROM'
      '    kardex k'
      'JOIN'
      '    products p ON p.sku = k.product_sku'
      'GROUP BY'
      
        '    k.product_sku, p.description, k.type, k.serie, k.number, k.t' +
        'ype_operation, k.output'
      'ORDER BY'
      '    p.description, k.number, MAX(k.fecha);')
    PrecommittedReads = False
    Left = 240
    Top = 40
  end
end
