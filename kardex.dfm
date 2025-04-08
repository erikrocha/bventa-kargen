object frm_kardex: Tfrm_kardex
  Left = 0
  Top = 0
  Caption = 'Kardex General'
  ClientHeight = 657
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 758
    Height = 592
    Align = alClient
    ColCount = 11
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
    TabOrder = 0
    ExplicitWidth = 756
    ExplicitHeight = 589
  end
  object Panel1: TPanel
    Left = 0
    Top = 624
    Width = 984
    Height = 33
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 621
    ExplicitWidth = 982
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 982
      Height = 31
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 980
    end
  end
  object pnl_right: TPanel
    Left = 758
    Top = 0
    Width = 226
    Height = 592
    Align = alRight
    TabOrder = 2
    ExplicitLeft = 756
    ExplicitHeight = 589
    object GroupBox1: TGroupBox
      Left = 1
      Top = 244
      Width = 224
      Height = 105
      Align = alTop
      Caption = 'Negritas'
      TabOrder = 0
      object ck_sku_product: TCheckBox
        Left = 16
        Top = 32
        Width = 153
        Height = 17
        Caption = 'SKU y Producto'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object ck_months: TCheckBox
        Left = 16
        Top = 55
        Width = 153
        Height = 17
        Caption = 'Meses'
        Enabled = False
        TabOrder = 1
      end
      object ck_totals: TCheckBox
        Left = 16
        Top = 78
        Width = 97
        Height = 17
        Caption = 'Totales'
        Enabled = False
        TabOrder = 2
      end
    end
    object pnl_records: TPanel
      Left = 1
      Top = 1
      Width = 224
      Height = 123
      Align = alTop
      BevelOuter = bvLowered
      TabOrder = 1
      object RadioGroup1: TRadioGroup
        Left = 1
        Top = 1
        Width = 222
        Height = 118
        Align = alTop
        Caption = 'Mostrar Datos'
        TabOrder = 3
      end
      object rb_100: TRadioButton
        Left = 16
        Top = 32
        Width = 113
        Height = 17
        Caption = '100 registros'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rb_100Click
      end
      object rb_1000: TRadioButton
        Left = 16
        Top = 55
        Width = 113
        Height = 17
        Caption = '1000 registros'
        TabOrder = 1
        OnClick = rb_1000Click
      end
      object rb_all: TRadioButton
        Left = 16
        Top = 78
        Width = 137
        Height = 17
        Caption = 'Todos los registros'
        TabOrder = 2
        OnClick = rb_allClick
      end
    end
    object pnl_colors: TPanel
      Left = 1
      Top = 124
      Width = 224
      Height = 120
      Align = alTop
      TabOrder = 2
      object RadioGroup2: TRadioGroup
        Left = 1
        Top = 1
        Width = 222
        Height = 118
        Align = alClient
        Caption = 'Color de fondo SKU y Producto'
        TabOrder = 0
      end
      object rb_yellow: TRadioButton
        Left = 16
        Top = 32
        Width = 113
        Height = 17
        Caption = 'Amarillo'
        TabOrder = 1
      end
      object rb_green: TRadioButton
        Left = 16
        Top = 55
        Width = 113
        Height = 17
        Caption = 'Verde'
        Checked = True
        TabOrder = 2
        TabStop = True
      end
      object rb_blue: TRadioButton
        Left = 16
        Top = 78
        Width = 113
        Height = 17
        Caption = 'Azul'
        TabOrder = 3
      end
    end
    object btn_export_excel: TButton
      AlignWithMargins = True
      Left = 4
      Top = 525
      Width = 218
      Height = 63
      Align = alBottom
      Caption = 'Exportar a Excel'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btn_export_excelClick
      ExplicitTop = 522
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 4
      Top = 487
      Width = 218
      Height = 32
      Align = alBottom
      Caption = 'Cargar Datos'
      TabOrder = 4
      OnClick = Button1Click
      ExplicitTop = 484
    end
    object btn_import: TButton
      AlignWithMargins = True
      Left = 4
      Top = 352
      Width = 218
      Height = 44
      Align = alTop
      Caption = 'Importar datos'
      TabOrder = 5
      OnClick = btn_importClick
    end
    object btn_tmp: TButton
      Left = 136
      Top = 202
      Width = 75
      Height = 25
      Caption = 'tmp'
      TabOrder = 6
      OnClick = btn_tmpClick
    end
    object pnl_validate_dates: TPanel
      Left = 1
      Top = 399
      Width = 224
      Height = 34
      Align = alTop
      TabOrder = 7
      object btn_validate_dates: TButton
        AlignWithMargins = True
        Left = 71
        Top = 4
        Width = 149
        Height = 26
        Align = alClient
        Caption = 'Validar Fechas'
        TabOrder = 0
        OnClick = btn_validate_datesClick
      end
      object edt_validate_year: TEdit
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 61
        Height = 26
        Align = alLeft
        TabOrder = 1
        ExplicitHeight = 23
      end
    end
  end
  object pnl_database: TPanel
    Left = 0
    Top = 592
    Width = 984
    Height = 32
    Align = alBottom
    TabOrder = 3
    Visible = False
    ExplicitTop = 589
    ExplicitWidth = 982
    object lbl_db: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 78
      Height = 24
      Align = alLeft
      Alignment = taCenter
      Caption = 'Base de datos: '
      ExplicitHeight = 15
    end
    object edt_db: TEdit
      AlignWithMargins = True
      Left = 88
      Top = 4
      Width = 664
      Height = 24
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 23
    end
    object btn_selected_db: TButton
      AlignWithMargins = True
      Left = 758
      Top = 4
      Width = 222
      Height = 24
      Align = alLeft
      Caption = 'Seleccionar base de datos ...'
      TabOrder = 1
      OnClick = btn_selected_dbClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 704
    Top = 24
  end
end
