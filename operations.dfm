object frm_operations: Tfrm_operations
  Left = 0
  Top = 0
  Caption = 'Nueva Operaci'#243'n'
  ClientHeight = 753
  ClientWidth = 1086
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
  OnShow = FormShow
  TextHeight = 15
  object pnl_grid: TPanel
    Left = 0
    Top = 0
    Width = 486
    Height = 753
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 484
    ExplicitHeight = 750
    object sg_data: TStringGrid
      Left = 1
      Top = 42
      Width = 484
      Height = 670
      Align = alClient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
      TabOrder = 0
      ExplicitWidth = 482
      ExplicitHeight = 667
    end
    object pnl_buttons: TPanel
      Left = 1
      Top = 712
      Width = 484
      Height = 40
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 709
      ExplicitWidth = 482
      object btn_delete: TButton
        AlignWithMargins = True
        Left = 360
        Top = 4
        Width = 120
        Height = 32
        Align = alRight
        Caption = '[X] Eliminar'
        TabOrder = 0
        OnClick = btn_deleteClick
        ExplicitLeft = 358
      end
    end
    object pnl_count: TPanel
      Left = 1
      Top = 1
      Width = 484
      Height = 41
      Align = alTop
      TabOrder = 2
      ExplicitWidth = 482
      object lbl_count: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 11
        Width = 3
        Height = 26
        Margins.Left = 10
        Margins.Top = 10
        Align = alLeft
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitHeight = 15
      end
    end
  end
  object pnl_invoice: TPanel
    Left = 486
    Top = 0
    Width = 600
    Height = 753
    Align = alRight
    TabOrder = 1
    ExplicitLeft = 484
    ExplicitHeight = 750
    object btn_save: TButton
      AlignWithMargins = True
      Left = 11
      Top = 665
      Width = 578
      Height = 77
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alBottom
      Caption = '&Guardar Factura'
      TabOrder = 0
      OnClick = btn_saveClick
      ExplicitTop = 662
    end
    object pnl_search_product: TPanel
      Left = 1
      Top = 217
      Width = 598
      Height = 438
      Align = alClient
      Caption = '___'
      TabOrder = 1
      ExplicitHeight = 435
      object sg_search: TStringGrid
        Left = 1
        Top = 1
        Width = 596
        Height = 436
        Align = alClient
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        ScrollBars = ssVertical
        TabOrder = 0
        OnKeyPress = sg_searchKeyPress
        ExplicitHeight = 433
      end
    end
    object pnl_form: TPanel
      Left = 1
      Top = 1
      Width = 598
      Height = 216
      Align = alTop
      TabOrder = 2
      object Label1: TLabel
        Left = 16
        Top = 56
        Width = 25
        Height = 15
        Caption = 'Serie'
        OnClick = Label1Click
      end
      object Label2: TLabel
        Left = 87
        Top = 56
        Width = 44
        Height = 15
        Caption = 'N'#250'mero'
      end
      object Label3: TLabel
        Left = 447
        Top = 56
        Width = 31
        Height = 15
        Caption = 'Fecha'
      end
      object lbl_product: TLabel
        Left = 16
        Top = 104
        Width = 49
        Height = 15
        Caption = 'Producto'
      end
      object lbl_invoice: TLabel
        Left = 16
        Top = 16
        Width = 83
        Height = 28
        Caption = 'FACTURA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 16
        Top = 152
        Width = 48
        Height = 15
        Caption = 'Cantidad'
      end
      object btn_search: TButton
        Left = 448
        Top = 126
        Width = 136
        Height = 21
        Caption = '&Buscar'
        TabOrder = 4
        OnClick = btn_searchClick
      end
      object dtp_date: TDateTimePicker
        Left = 448
        Top = 77
        Width = 136
        Height = 23
        Date = 45663.000000000000000000
        Time = 0.947268530093424500
        TabOrder = 2
      end
      object edt_number: TEdit
        Left = 87
        Top = 77
        Width = 114
        Height = 23
        TabOrder = 1
        OnExit = edt_numberExit
      end
      object edt_product: TEdit
        Left = 15
        Top = 125
        Width = 418
        Height = 23
        CharCase = ecUpperCase
        TabOrder = 3
        OnKeyDown = edt_productKeyDown
        OnKeyPress = edt_productKeyPress
      end
      object edt_serie: TEdit
        Left = 16
        Top = 77
        Width = 65
        Height = 23
        TabOrder = 0
      end
      object btn_add_grid: TButton
        Left = 448
        Top = 172
        Width = 137
        Height = 25
        Caption = '<< Agregar'
        TabOrder = 5
        OnClick = btn_add_gridClick
      end
      object ck_buy: TCheckBox
        Left = 225
        Top = 176
        Width = 137
        Height = 17
        Caption = '02 Compra (Tabla 12)'
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 6
      end
      object ck_invoice: TCheckBox
        Left = 87
        Top = 176
        Width = 137
        Height = 17
        Caption = '01 Factura (Tabla 10)'
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 7
      end
      object edt_quantity: TEdit
        Left = 16
        Top = 173
        Width = 65
        Height = 23
        TabOrder = 8
        OnKeyPress = edt_quantityKeyPress
      end
      object btn_tmp: TButton
        Left = 280
        Top = 46
        Width = 75
        Height = 25
        Caption = 'tmp'
        TabOrder = 9
        Visible = False
        OnClick = btn_tmpClick
      end
      object dtp_now: TDateTimePicker
        Left = 392
        Top = 16
        Width = 186
        Height = 23
        Date = 45666.000000000000000000
        Time = 0.453952268515422500
        TabOrder = 10
        Visible = False
      end
    end
  end
  object Timer1: TTimer
    Interval = 250
    OnTimer = Timer1Timer
    Left = 536
    Top = 384
  end
end
