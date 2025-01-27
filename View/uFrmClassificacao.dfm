object frmClassificacao: TfrmClassificacao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Classifica'#231#227'o das Provas'
  ClientHeight = 361
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object plTop: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 41
    Align = alTop
    Color = clBtnShadow
    ParentBackground = False
    TabOrder = 0
    object LB_TIT_CLA: TLabel
      Left = 5
      Top = 13
      Width = 124
      Height = 15
      Caption = 'Provas de classifica'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnFechar: TButton
      Left = 462
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnFecharClick
    end
  end
  object plCenter: TPanel
    Left = 0
    Top = 41
    Width = 542
    Height = 320
    Align = alClient
    TabOrder = 1
    object btnGerar: TBitBtn
      Left = 176
      Top = 140
      Width = 177
      Height = 41
      Caption = 'Gerar classifica'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnGerarClick
    end
  end
  object qryProvas: TFDQuery
    Connection = Form1.FDConnection
    SQL.Strings = (
      'select cod_prova, nom_prova, tip_prova'
      'from provas')
    Left = 152
    Top = 49
  end
  object qryClassAtleta: TFDQuery
    Connection = Form1.FDConnection
    SQL.Strings = (
      'select nom_prova, posicao, nom_atleta, marca, nom_cidade'
      'from class_prova cl'
      'inner join provas on provas.cod_prova = cl.cod_prova'
      'inner join cidades on cidades.cod_cidade = cl.cod_cidade'
      'order by nom_prova, posicao')
    Left = 152
    Top = 101
  end
  object qryClassCidade: TFDQuery
    Connection = Form1.FDConnection
    SQL.Strings = (
      
        'select cidades.cod_cidade, nom_cidade, ouro, prata, bronze from ' +
        '('
      
        'select cod_cidade, count(1) ouro, 0 prata, 0 bronze from class_p' +
        'rova'
      'where posicao = 1'
      'group by cod_cidade'
      'union'
      
        'select cod_cidade, 0 ouro, count(1) prata, 0 bronze from class_p' +
        'rova'
      'where posicao = 2'
      'group by cod_cidade'
      'union'
      
        'select cod_cidade, 0 ouro, 0 prata, count(1) bronze from class_p' +
        'rova'
      'where posicao = 3'
      'group by cod_cidade'
      ') cl'
      'inner join CIDADES on cidades.cod_cidade = cl.cod_cidade'
      'order by 3 desc,4 desc,5 desc')
    Left = 226
    Top = 101
  end
  object qryincClassif: TFDQuery
    Connection = Form1.FDConnection
    Left = 296
    Top = 101
  end
  object qryExcluir: TFDQuery
    Connection = Form1.FDConnection
    SQL.Strings = (
      'delete  from class_prova'
      '')
    Left = 264
    Top = 50
  end
  object qryMarcas: TFDQuery
    Connection = Form1.FDConnection
    Left = 207
    Top = 50
  end
end
