object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FDConnection: TFDConnection
    Params.Strings = (
      'Server=INFOBAC01'
      'Database=ClassificacaoProvas'
      'User_Name=sa'
      'Password=root'
      'OSAuthent=No'
      'DriverID=MSSQL')
    Left = 96
    Top = 144
  end
end
