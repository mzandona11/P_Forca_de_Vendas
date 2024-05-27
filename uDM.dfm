object DM: TDM
  OnCreate = DataModuleCreate
  Height = 302
  Width = 400
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Matheus\Documents\GitHub\Projeto Forca de vend' +
        'as (delphi)\P_Forca_de_Vendas\Banco\banco-univel'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    Left = 144
    Top = 48
  end
end
