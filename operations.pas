unit operations;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Grids, uFBProduct;

type
  Tfrm_operations = class(TForm)
    pnl_grid: TPanel;
    pnl_invoice: TPanel;
    sg_data: TStringGrid;
    lbl_invoice: TLabel;
    Label1: TLabel;
    edt_serie: TEdit;
    Label2: TLabel;
    edt_number: TEdit;
    Label3: TLabel;
    dtp_date: TDateTimePicker;
    lbl_product: TLabel;
    edt_product: TEdit;
    Label5: TLabel;
    edt_quantity: TEdit;
    ck_invoice: TCheckBox;
    ck_buy: TCheckBox;
    btn_add_grid: TButton;
    btn_save: TButton;
    pnl_search_product: TPanel;
    sg_search: TStringGrid;
    btn_search: TButton;
    pnl_form: TPanel;
    btn_tmp: TButton;
    dtp_now: TDateTimePicker;
    btn_delete: TButton;
    pnl_buttons: TPanel;
    pnl_count: TPanel;
    lbl_count: TLabel;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_searchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edt_productKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_add_gridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_productKeyPress(Sender: TObject; var Key: Char);
    procedure sg_searchKeyPress(Sender: TObject; var Key: Char);
    procedure edt_quantityKeyPress(Sender: TObject; var Key: Char);
    procedure Label1Click(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_tmpClick(Sender: TObject);
    procedure edt_numberExit(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    _row: integer;
    procedure SearchProduct;
    procedure ClearControls;
    procedure ProductSelected;
    procedure AddProductoToGrid;
    procedure DocumentPost;
    procedure ProductDelete;
    procedure CountRecords;
    procedure ExistInvoice;
    procedure ProductsFree;
    function IsDateValid: boolean;
  end;

var
  frm_operations: Tfrm_operations;
  FBProduct: TFBProduct;
  _description: string;


implementation

{$R *.dfm}

procedure Tfrm_operations.AddProductoToGrid;
begin
  sg_data.Cells[0,_row] := FBProduct.id(sg_search.Row);;
  sg_data.Cells[1,_row] := FBProduct.sku(sg_search.Row);
  sg_data.Cells[2,_row] := FBProduct.description(sg_search.Row);
  sg_data.Cells[3,_row] := edt_quantity.text;

  inc(_row);
  sg_data.rowCount:= _row;
end;

procedure Tfrm_operations.btn_add_gridClick(Sender: TObject);
begin
  if edt_quantity.text = '' then
  begin
    ShowMessage('Ingresa Cantidad');
    exit;
  end
  else
  begin
    edt_product.SetFocus;
    edt_product.SelectAll;
    sg_search.Visible:= false;
    lbl_product.Caption:= 'Producto';
    AddProductoToGrid;
  end;
  edt_quantity.Text:= '';
  CountRecords;
  ProductsFree;
end;

procedure Tfrm_operations.btn_deleteClick(Sender: TObject);
begin
  if sg_data.Cells[1,sg_data.Row] <> '' then
  begin
    if(sg_data.RowCount <> 1) then begin
      ProductDelete;
      dec(_row);
    end
    else begin
      showMessage('Necesitas seleccionar el producto a eliminar.');
    end;
  end
  else
  begin
    showMessage('Necesita seleccionar un producto a eliminar');
  end;

  CountRecords;
end;

procedure Tfrm_operations.btn_saveClick(Sender: TObject);
begin
  if Length(trim(edt_serie.Text)) = 0 then
  begin
    showMessage('Ingresa serie');
    abort;
  end;

  if Length(trim(edt_number.Text)) = 0 then
  begin
    showMessage('Ingresa número');
    abort;
  end;

  if not IsDateValid then
  begin
    ShowMessage('Selecciona una fecha válida');
    abort;
  end;

  if _row = 1 then
  begin
    showMessage('Ingresa al menos un producto');
    abort;
  end;

  DocumentPost;
  ClearControls;
  edt_serie.SetFocus;
  dtp_date.Date:= now;
  showMessage('Factura Guardada');
end;

procedure Tfrm_operations.btn_searchClick(Sender: TObject);
begin
  if sg_search.Visible then
  begin
    sg_search.Visible:= true;
    SearchProduct;
    sg_search.SetFocus;
  end
  else
  begin
    //ShowMessage(edt_product.Text + ': ¡no existe!');
  end;
end;

procedure Tfrm_operations.btn_tmpClick(Sender: TObject);
begin
  ExistInvoice;
end;

procedure Tfrm_operations.ClearControls;
begin
  self._row:= 1;

  // Setting GridData
  sg_data.ColCount:= 4;
  sg_data.RowCount := 2;

  sg_data.ColWidths[0] := 0;
  sg_data.ColWidths[1] := 100;
  sg_data.ColWidths[2] := 400;
  sg_data.ColWidths[3] := 50;

  sg_data.Cells[0, 0] := '';
  sg_data.Cells[1, 0] := 'SKU';
  sg_data.Cells[2, 0] := 'Descripción';
  sg_data.Cells[3, 0] := 'Cant.';

  sg_data.Cells[0, 1] := '';
  sg_data.Cells[1, 1] := '';
  sg_data.Cells[2, 1] := '';
  sg_data.Cells[3, 1] := '';


  // Setting GridSearchProduct
  sg_search.ColCount:= 4;
  sg_search.ColWidths[0] := 0;
  sg_search.ColWidths[1] := 100;
  sg_search.ColWidths[2] := 400;
  sg_search.ColWidths[3] := 50;
  sg_search.RowCount:= 0;

  sg_search.Visible:= false;

  edt_serie.Text := '';
  edt_number.Text := '';
  edt_product.Text := '';
  edt_quantity.Text := '';
  lbl_count.Caption:= '';
end;

procedure Tfrm_operations.CountRecords;
begin
  lbl_count.Caption:= 'N° Productos: ' + inttostr(sg_data.RowCount - 1);
end;

procedure Tfrm_operations.DocumentPost;
var
  i: integer;
  ProductItems: TArray<TProductItem>;
  FBProduct: TFBProduct;
begin
  SetLength(ProductItems, sg_data.RowCount-1);

  for i := 0 to sg_data.RowCount-2 do
  begin
    ProductItems[i].id := sg_data.Cells[0, i+1];
    ProductItems[i].sku := sg_data.Cells[1, i+1];
    ProductItems[i].quantity := sg_data.Cells[3, i+1];
  end;

  FBProduct:= TFBProduct.Create;
  FBProduct.databaseName('D:\bventa kargen\data\DB.FDB');
  FBProduct.connection;

  FBProduct.post(
    edt_serie.Text,
    edt_number.Text,
    dtp_date.Date,
    '01',
    '02',
    ProductItems // record[id, quantity]
  );
end;

procedure Tfrm_operations.edt_numberExit(Sender: TObject);
begin
  ExistInvoice;
end;

procedure Tfrm_operations.edt_productKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
end;

procedure Tfrm_operations.edt_productKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btn_search.click;
end;

procedure Tfrm_operations.edt_quantityKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btn_add_grid.Click;
end;

procedure Tfrm_operations.ExistInvoice;
begin
  FBProduct:= TFBProduct.Create;
  FBProduct.databaseName('D:\bventa kargen\data\DB.FDB');
  FBProduct.ExistInvoice(edt_serie.Text	, edt_number.Text);
end;

procedure Tfrm_operations.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Self.Release;
  Self := nil;
end;

procedure Tfrm_operations.FormCreate(Sender: TObject);
begin
  ClearControls;

  dtp_date.Date := now;
  dtp_now.Date := now;
end;

procedure Tfrm_operations.FormShow(Sender: TObject);
begin
  edt_product.SetFocus;
end;

function Tfrm_operations.IsDateValid: boolean;
begin
  Result := dtp_date.Date < dtp_now.Date;
end;

procedure Tfrm_operations.Label1Click(Sender: TObject);
begin
  edt_serie.Text:= 'F001';
end;

procedure Tfrm_operations.ProductDelete;
var
  i: integer;
begin
try
  if(sg_data.RowCount <> 0) then begin
    if (Application.MessageBox( '¿Desea eliminar el producto seleccionado?', '', MB_OKCANCEL ) = ID_OK ) then
    begin
      for i := sg_data.Row to sg_data.RowCount - 1  do
      begin
        sg_data.Rows[i] := sg_data.Rows[i+1];
      end;

      if(sg_data.RowCount > 1) then begin
        sg_data.RowCount := sg_data.RowCount - 1;
      end
      else begin
        sg_data.Cells[0,1] := '';
        sg_data.Cells[1,1] := '';
        sg_data.Cells[2,1] := '';
        sg_data.Cells[3,1] := '';
      end;
    end;
  end;
  except
    abort;
  end;
end;

procedure Tfrm_operations.ProductSelected;
begin
  lbl_product.Caption:= FBProduct.description(sg_search.Row);
  lbl_product.Font.Style := lbl_product.Font.Style + [fsBold];
  sg_search.Visible:= false;
end;

procedure Tfrm_operations.ProductsFree;
begin
  // To free object FBProduct
  if Assigned(FBProduct) then
  begin
    FBProduct.Free;
    FBProduct := nil;
  end
  else
  begin
    //showMessage('FBProduct ya ha sido liberado o no ha sido creado.');
  end;
end;

procedure Tfrm_operations.SearchProduct;
var
  i: integer;
begin
  if Length(Trim(edt_product.Text)) >= 3 then
  begin
    sg_search.Visible:= true;

    try
      FBProduct:= TFBProduct.Create;
      FBProduct.databaseName('D:\bventa kargen\data\DB.FDB');
      FBProduct.searchByName(trim(edt_product.Text));

      if FBProduct.count > 0 then
      begin
        sg_search.RowCount:= FBProduct.count;

        for i := 0 to FBProduct.count-1 do
        begin
          sg_search.Cells[0, i] := FBProduct.id(i);
          sg_search.Cells[1, i] := FBProduct.sku(i);
          sg_search.Cells[2, i] := FBProduct.description(i);
          sg_search.Cells[3, i] := FBProduct.status(i);
        end;
      end
      else begin
        sg_search.RowCount := 0;
        sg_search.Visible := false;
      end;
    finally

    end;
  end
  else
  begin
    pnl_search_product.Caption:= 'Sin resultados.';
    sg_search.Visible:= false;
  end;
end;

procedure Tfrm_operations.sg_searchKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    ProductSelected;
    edt_quantity.Clear;
    edt_quantity.SetFocus;
end;

procedure Tfrm_operations.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  SearchProduct;
end;

end.
