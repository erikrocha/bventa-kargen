unit uFBProduct;

interface

uses
  System.Classes, Vcl.Dialogs, System.SysUtils,
  IBX.IBDatabase, IBX.IBTable, IBX.IBQuery, Data.DB,
  uFirebird;

type
  TProductItem = record
    id: string;
    sku: string;
    quantity: string;
  end;

  TFBProduct = class(TFirebird)
    protected
      FID         : TStringList;
      FSKU        : TStringList;
      FDescription: TStringList;
      FBarcode    : TStringList;
      FStatus     : TStringList;

    public
      // crud
      procedure get;
      procedure post(serie: string; number: string; fecha:TDate; tipo: string; type_operation: string; items: TArray<TProductItem>);
      //procedure post(serie, number, fecha, tipo, type_operation: string);
      procedure ExistInvoice(serie, number: string);

      // fields
      function id(id: integer): string;
      function sku(id: integer): string;
      function description(id: integer): string;
      function barcode(id: integer): string;
      function status(id: integer): string;

      // search
      procedure searchByName(q: string);

      function count: integer;
      destructor Destroy; override;

  end;

implementation

{ TFBClient }

function TFBProduct.description(id: integer): string;
begin
  Result:= FDescription[id];
end;

destructor TFBProduct.Destroy;
begin
  FID.Free;
  FSKU.Free;
  FDescription.Free;
  FBarcode.Free;
  FStatus.Free;
  inherited;
end;

procedure TFBProduct.ExistInvoice(serie, number: string);
var
  ProductInfo: string;
  fechaConsulta: TDate;
begin
  connection;

  qry := TIBQuery.Create(nil);
  try
    qry.Database := db;
    qry.Transaction := ts;

    // Insert to master (document)
    qry.SQL.Text :=
      'SELECT * ' +
      'FROM KARDEX k ' +
      'INNER JOIN PRODUCTS p ON k.product_sku = p.sku ' +
      'WHERE k.serie = :serie AND k.number = :number AND k.type_operation = :type_operation';
    qry.ParamByName('serie').AsString := serie;
    qry.ParamByName('number').AsString := number;
    qry.ParamByName('type_operation').AsString := '2';
    qry.Open;

    if not qry.IsEmpty then
    begin
      productInfo := '¡Esta factura ya fue registrada!: ' + sLineBreak +
                  'Serie: ' + serie + sLineBreak +
                  'Nro: ' + number + sLineBreak +
                  sLineBreak + 'Productos encontrados:';
      while not qry.Eof do
      begin
         ProductInfo := productInfo + sLineBreak +
                       'fecha: ' + qry.FieldByName('fecha').AsString +
                       ', sku: ' + qry.FieldByName('sku').AsString +
                       ', des: ' + qry.FieldByName('description').AsString +
                       ', can: ' + qry.FieldByName('input').AsString;
        qry.Next;
      end;
      showMessage(ProductInfo)
    end
    else
    begin
      //ShowMessage('No existe ese documento');
    end;

  finally
    qry.Free;
  end;
end;

function TFBProduct.count: integer;
begin
  Result:= FID.Count;
end;

procedure TFBProduct.get;
begin
  connection;
  qry         := TIBQuery.Create(nil);

  FID         := TStringList.Create;
  FSKU        := TStringList.Create;
  FDescription:= TStringList.Create;
  FBarcode    := TStringList.Create;
  FStatus     := TStringList.Create;

  qry.Database := db;
  qry.Transaction := ts;

  qry.SQL.Text := 'SELECT FIRST 10 * FROM products order by id desc';
  qry.Open;

  while not qry.Eof do
  begin
    FID.Add(qry.FieldByName('id').AsString);
    FSKU.Add(qry.FieldByName('sku').AsString);
    FDescription.Add(qry.FieldByName('description').AsString);
    FBarcode.Add(qry.FieldByName('barcode').AsString);
    FStatus.Add(qry.FieldByName('status').AsString);
    qry.Next;
  end;

  FID.Free;
  FSKU.Free;
  FDescription.Free;
  FBarcode.Free;
  FStatus.Free;
  qry.Free;
end;

function TFBProduct.id(id: integer): string;
begin
  Result:= FID[id];
end;

procedure TFBProduct.post(serie: string; number: string; fecha: TDate; tipo: string; type_operation: string; items: TArray<TProductItem>);
begin
  connection;

  qry := TIBQuery.Create(nil);
  try
    qry.Database := db;
    qry.Transaction := ts;

    // Insert to master (document)
    qry.SQL.Text :=
      'INSERT INTO KARDEX (product_sku, fecha, tipo, serie, number, type_operation, input) ' +
      'VALUES (:product_sku, :fecha, :tipo, :serie, :number, :type_operation, :input) ';

    for var item in items do
    begin
      qry.ParamByName('product_sku').AsString := item.sku;
      qry.ParamByName('fecha').AsDate := fecha;
      qry.ParamByName('tipo').AsString := tipo;
      qry.ParamByName('serie').AsString := serie;
      qry.ParamByName('number').AsString := number;
      qry.ParamByName('type_operation').AsString := type_operation;
      qry.ParamByName('input').AsString := item.quantity;
      qry.ExecSQL;
    end;

    // transaction
    ts.Commit;
    ts.StartTransaction;


  finally
    qry.Free;
  end;
end;

function TFBProduct.sku(id: integer): string;
begin
  Result:= FSKU[id];
end;

function TFBProduct.status(id: integer): string;
begin
  Result:= FStatus[id];
end;

function TFBProduct.barcode(id: integer): string;
begin
  Result:= FBarcode[id];
end;

procedure TFBProduct.searchByName(q: string);
begin
  connection;
  qry         := TIBQuery.Create(nil);
  FID         := TStringList.Create;
  FSKU        := TStringList.Create;
  FDescription:= TStringList.Create;
  FBarcode    := TStringList.Create;
  FStatus     := TStringList.Create;

  qry.Database := db;
  qry.Transaction := ts;

  qry.SQL.Text := 'SELECT * FROM products WHERE (description LIKE :description OR sku LIKE :sku) ORDER BY id DESC';
  qry.ParamByName('description').AsString:= '%'+ q + '%';
  qry.ParamByName('sku').AsString := '%' + q + '%';
  qry.Open;

  try
    while not qry.Eof do
    begin
      FID.Add(qry.FieldByName('id').AsString);
      FSKU.Add(qry.FieldByName('sku').AsString);
      FDescription.Add(qry.FieldByName('description').AsString);
      FBarcode.Add(qry.FieldByName('barcode').AsString);
      FStatus.Add(qry.FieldByName('status').AsString);
      qry.Next;
    end;
  finally
  end;

  qry.Free;
end;

end.
