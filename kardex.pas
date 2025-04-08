unit kardex;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,   System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls,

  ComObj, DateUtils, Vcl.Buttons, Vcl.ComCtrls, IniFiles, ShellAPI;

type
  Tfrm_kardex = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    pnl_right: TPanel;
    pnl_database: TPanel;
    lbl_db: TLabel;
    edt_db: TEdit;
    btn_selected_db: TButton;
    OpenDialog1: TOpenDialog;
    RadioGroup1: TRadioGroup;
    rb_100: TRadioButton;
    rb_1000: TRadioButton;
    rb_all: TRadioButton;
    GroupBox1: TGroupBox;
    ck_sku_product: TCheckBox;
    ck_months: TCheckBox;
    ck_totals: TCheckBox;
    pnl_records: TPanel;
    pnl_colors: TPanel;
    RadioGroup2: TRadioGroup;
    rb_yellow: TRadioButton;
    rb_green: TRadioButton;
    rb_blue: TRadioButton;
    btn_export_excel: TButton;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    btn_import: TButton;
    btn_validate_dates: TButton;
    btn_tmp: TButton;
    pnl_validate_dates: TPanel;
    edt_validate_year: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_export_excelClick(Sender: TObject);
    procedure btn_selected_dbClick(Sender: TObject);
    procedure rb_100Click(Sender: TObject);
    procedure rb_1000Click(Sender: TObject);
    procedure rb_allClick(Sender: TObject);
    procedure btn_importClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_validate_datesClick(Sender: TObject);
    procedure btn_tmpClick(Sender: TObject);
  private
    procedure saveToIni;
    procedure readFromIni;
    function Min(A, B: Integer): Integer;
  public
    { Public declarations }
  end;

var
  frm_kardex: Tfrm_kardex;
  totalRecords: integer;

implementation

uses
  datamodule;

{$R *.dfm}

function Tfrm_kardex.Min(A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

procedure Tfrm_kardex.btn_selected_dbClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Archivos Firebird (*.fdb)|*.fdb|Todos los archivos (*.*)|*.*';
  OpenDialog1.Title := 'Selecciona una base de datos Firebird';

  if OpenDialog1.Execute then
  begin
    edt_db.Text := OpenDialog1.FileName;
    saveToIni;
  end;
end;

procedure Tfrm_kardex.btn_tmpClick(Sender: TObject);
begin
  showMessage(inttostr(StringGrid1.RowCount));
end;

procedure Tfrm_kardex.btn_importClick(Sender: TObject);
var
  path: string;
begin
  path := 'C:\Program Files\Firebird\Firebird_4_0\isql.exe';

  if not FileExists(path) then
  begin
    ShowMessage('No se encuentra el archivo en la ruta: ' + path);
    exit;
  end;

  ShellExecute(0, 'open', PChar(path), nil, nil, SW_SHOWNORMAL);
end;

procedure Tfrm_kardex.btn_validate_datesClick(Sender: TObject);
var
  i: Integer;
  dateStr: string;
  date: TDateTime;
  msj: string;
  record_id: string;
  invalid_count: Integer;
begin
  msj := '';
  invalid_count := 0;

  if StringGrid1.RowCount < 2 then
  begin
    showMessage('Necesitas cargar datos para validar fechas.');
    exit;
  end;

  if edt_validate_year.Text = '' then
  begin
    ShowMessage('VALIDAR FECHAS' + sLineBreak + 'Ingresa el año que quieres validar.' + sLineBreak + 'Ejm: 2024');
    exit;
  end;

  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    dateStr := StringGrid1.Cells[2, i];

    // Try convert str to date
    if not TryStrToDate(dateStr, date) then
    begin
      Inc(invalid_count);
    end
    else if (date < EncodeDate(StrToInt(edt_validate_year.Text), 1, 1)) or (date > EncodeDate(StrToInt(edt_validate_year.Text), 12, 31)) then
    begin
      Inc(invalid_count);
    end;
  end;

  if invalid_count > 100 then
  begin
    ShowMessage('Se han encontrado más de 100 fechas inválidas. ¿Está seguro de que ha ingresado el año correctamente?');
    exit;
  end;

  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    dateStr := StringGrid1.Cells[2, i];
    record_id := StringGrid1.Cells[10, i];

    // Try convert str to date
    if not TryStrToDate(dateStr, date) then
      msj := msj + Format('Fila %d, ID: %s - Formato de fecha inválido: %s' + sLineBreak, [i, record_id, dateStr])
    else if (date < EncodeDate(StrToInt(edt_validate_year.Text), 1, 1)) or (date > EncodeDate(StrToInt(edt_validate_year.Text), 12, 31)) then
      msj := msj + Format('Fila %d, ID: %s - Fecha fuera del rango permitido: %s' + sLineBreak, [i, record_id, dateStr]);
  end;

  if msj <> '' then
    ShowMessage(msj)
  else
    ShowMessage('Todas las fechas son válidas y están dentro del rango.');
end;

//procedure Tfrm_kardex.Button1Click(Sender: TObject);
//var
//  i, j, qty: Integer;
//begin
//
//
//
//  // Setting query
//  dm.IBQuery1.Close;
//  dm.IBQuery1.SQL.Text :=
//    'SELECT ' +
//    '    k.id AS kardex_id, ' +
//    '    k.product_sku AS sku, ' +
//    '    p.description, ' +
//    '    MAX(k.fecha) AS fecha, ' +
//    '    k.tipo, ' +
//    '    k.serie, ' +
//    '    k.number, ' +
//    '    k.type_operation, ' +
//    '    k.output, ' +
//    '    k.input ' +
//    'FROM ' +
//    '    kardex k ' +
//    'JOIN ' +
//    '    products p ON p.sku = k.product_sku ' +
//    'GROUP BY ' +
//    '    k.id, k.product_sku, p.description, k.tipo, k.serie, k.number, k.type_operation, k.output, k.input ' +
//    'ORDER BY ' +
//    '    p.description, MAX(fecha), k.number';
//  dm.IBQuery1.Open;
//
//  // Verificar si hay registros en la consulta
//  if dm.IBQuery1.RecordCount = 0 then
//  begin
//    ShowMessage('No hay registros para cargar.');
//    Exit;
//  end;
//
//  // Setting sg_data
//  StringGrid1.ColCount := 11;
//  StringGrid1.Cells[0, 0] := 'SKU';
//  StringGrid1.Cells[1, 0] := 'Descripción';
//  StringGrid1.Cells[2, 0] := 'Fecha';
//  StringGrid1.Cells[3, 0] := 'Tipo';
//  StringGrid1.Cells[4, 0] := 'Serie';
//  StringGrid1.Cells[5, 0] := 'Número';
//  StringGrid1.Cells[6, 0] := 'T. Ope.';
//  StringGrid1.Cells[7, 0] := 'Salida';
//  StringGrid1.Cells[8, 0] := 'Entrada';
//  StringGrid1.Cells[9, 0] := '#';
//  StringGrid1.Cells[10, 0] := 'ID';
//
//  i := 1;
//
//  // 100, 1000 or all data
//  if rb_100.Checked then
//    qty := 100
//  else if rb_1000.Checked then
//    qty := 1000
//  else if rb_all.Checked then
//    qty := -1
//  else
//    qty := 0;
//
//  // Setting progress_bar
//  ProgressBar1.Min := 0;
//  ProgressBar1.Max := qty;
//  ProgressBar1.Position := 0;
//  ProgressBar1.Step := 1;
//
//  if qty = -1 then
//  begin
//    dm.IBQuery1.Last;
//    ProgressBar1.Min := 0;
//    ProgressBar1.Max := dm.IBQuery1.RecordCount;
//    ProgressBar1.Position := 0;
//    ProgressBar1.Step := 1;
//    ShowMessage('Cargando ' + IntToStr(dm.IBQuery1.RecordCount) + ' registros.');
//    dm.IBQuery1.First;
//
//    // Modificación aquí para cargar solo si hay más de un registro
//    while not dm.IBQuery1.Eof do
//    begin
//      StringGrid1.RowCount := i + 1;
//      StringGrid1.Cells[0, i] := dm.IBQuery1.FieldByName('sku').AsString;
//      StringGrid1.Cells[1, i] := dm.IBQuery1.FieldByName('description').AsString;
//      StringGrid1.Cells[2, i] := dm.IBQuery1.FieldByName('fecha').AsString;
//      StringGrid1.Cells[3, i] := dm.IBQuery1.FieldByName('tipo').AsString;
//      StringGrid1.Cells[4, i] := dm.IBQuery1.FieldByName('serie').AsString;
//      StringGrid1.Cells[5, i] := dm.IBQuery1.FieldByName('number').AsString;
//      StringGrid1.Cells[6, i] := dm.IBQuery1.FieldByName('type_operation').AsString;
//      StringGrid1.Cells[7, i] := dm.IBQuery1.FieldByName('output').AsString;
//      StringGrid1.Cells[8, i] := dm.IBQuery1.FieldByName('input').AsString;
//      StringGrid1.Cells[9, i] := IntToStr(i);
//      StringGrid1.Cells[10, i] := dm.IBQuery1.FieldByName('kardex_id').AsString;
//
//      ProgressBar1.Position := i;
//      Application.ProcessMessages;
//
//      dm.IBQuery1.Next;
//      Inc(i);
//    end;
//  end
//  else
//  begin
//    // Modificación aquí para cargar solo el número de registros deseado
//    for j := 1 to Min(qty, dm.IBQuery1.RecordCount) do
//    begin
//      StringGrid1.RowCount := i + 1;
//      StringGrid1.Cells[0, i] := dm.IBQuery1.FieldByName('sku').AsString;
//      StringGrid1.Cells[1, i] := dm.IBQuery1.FieldByName('description').AsString;
//      StringGrid1.Cells[2, i] := dm.IBQuery1.FieldByName('fecha').AsString;
//      StringGrid1.Cells[3, i] := dm.IBQuery1.FieldByName('tipo').AsString;
//      StringGrid1.Cells[4, i] := dm.IBQuery1.FieldByName('serie').AsString;
//      StringGrid1.Cells[5, i] := dm.IBQuery1.FieldByName('number').AsString;
//      StringGrid1.Cells[6, i] := dm.IBQuery1.FieldByName('type_operation').AsString;
//      StringGrid1.Cells[7, i] := dm.IBQuery1.FieldByName('output').AsString;
//      StringGrid1.Cells[8, i] := dm.IBQuery1.FieldByName('input').AsString;
//      StringGrid1.Cells[9, i] := IntToStr(i);
//      StringGrid1.Cells[10, i] := dm.IBQuery1.FieldByName('kardex_id').AsString;
//
//      ProgressBar1.Position := j;
//      Application.ProcessMessages;
//
//      dm.IBQuery1.Next;
//      Inc(i);
//    end;
//  end;
//
//  ShowMessage('¡Carga de datos completado!');
//  btn_export_excel.Enabled := true;
//end;

procedure Tfrm_kardex.btn_export_excelClick(Sender: TObject);
var
  ExcelApp, ExcelWorkbook, ExcelSheet: OleVariant;
  i, currentRow, monthStartRow: Integer;
  currentMonth, previousMonth: Integer;
  currentSKU, previousSKU: string;
  monthNames: array[1..12] of string;
  qty: integer;
  color: integer;
begin

  ShowMessage('EMPEZANDO LA EXPORTACIÓN A EXCEL' + sLineBreak + 'Espere hasta que le aparezca un cuadro de dialogo donde debe presionar: SI' + sLineBreak + 'Por favor espere, puede tomar varios minutos dependiendo de la cantidad de registros.');

  qty:= StringGrid1.RowCount;
  if qty < 2 then
  begin
    ShowMessage('¡No hay datos a exportar!, antes presione el botón Mostrar Datos');
    Exit;
  end;

  if rb_yellow.Checked then
    color := RGB(255,242,204)
  else if rb_green.Checked then
    color := RGB(198,224,180)
  else if rb_blue.Checked then
    color := RGB(221,235,247)
  else
    color := RGB(255, 255, 255);

  try
    // Setting months
    monthNames[1] := 'ENERO'; monthNames[2] := 'FEBRERO'; monthNames[3] := 'MARZO';
    monthNames[4] := 'ABRIL'; monthNames[5] := 'MAYO'; monthNames[6] := 'JUNIO';
    monthNames[7] := 'JULIO'; monthNames[8] := 'AGOSTO'; monthNames[9] := 'SEPTIEMBRE';
    monthNames[10] := 'OCTUBRE'; monthNames[11] := 'NOVIEMBRE'; monthNames[12] := 'DICIEMBRE';

    // Create excel instance
    ExcelApp := CreateOleObject('Excel.Application');

    ExcelApp.ScreenUpdating := True;
    ExcelApp.DisplayAlerts := True;
    //ExcelApp.Visible := False;

    ExcelWorkbook := ExcelApp.Workbooks.Add;
    ExcelSheet := ExcelWorkbook.Worksheets[1];
    ExcelApp.Calculation := -4105;

    // Setting header excel
    ExcelSheet.Cells[1, 1] := 'SKU';
    ExcelSheet.Cells[1, 2] := 'PRODUCTO';
    ExcelSheet.Cells[1, 3] := 'FECHA';
    ExcelSheet.Cells[1, 4] := 'TIPO';
    ExcelSheet.Cells[1, 5] := 'SERIE';
    ExcelSheet.Cells[1, 6] := 'NÚMERO';
    ExcelSheet.Cells[1, 7] := 'T. OPE';
    ExcelSheet.Cells[1, 8] := 'ENTRADAS';
    ExcelSheet.Cells[1, 9] := 'SALIDAS';
    ExcelSheet.Cells[1, 10] := 'SALDO FINAL';

    currentRow := 2;
    previousSKU := '';
    previousMonth := -1;
    monthStartRow := 0;

    for i := 1 to StringGrid1.RowCount - 1 do
    begin
      // Get sku & month
      currentSKU := StringGrid1.Cells[0, i];
      currentMonth := MonthOf(StrToDate(StringGrid1.Cells[2, i]));

      // If sku change, insert new sku & description
      if currentSKU <> previousSKU then
      begin

        // Insert totals for the previous month if there is data.
        if previousMonth <> -1 then
        begin
          ExcelSheet.Cells[currentRow, 7] := 'TOTALES';
          currentRow := currentRow + 1;
        end;
        ExcelSheet.Cells[currentRow, 1] := currentSKU; // SKU
        ExcelSheet.Cells[currentRow, 2] := StringGrid1.Cells[1, i]; // Description
        ExcelSheet.Rows[currentRow].Interior.Color := color;
        ExcelSheet.Rows[currentRow].Font.Bold := True;
        currentRow := currentRow + 1;
        previousSKU := currentSKU; // Update previous sku
        previousMonth := -1; // Restart previous month
      end;

      // If month change, insert name month and totals previous month
      if currentMonth <> previousMonth then
      begin
        if previousMonth <> -1 then
        begin
          ExcelSheet.Cells[currentRow, 7] := 'TOTALES';
          currentRow := currentRow + 1;
        end;
        ExcelSheet.Cells[currentRow, 2] := monthNames[currentMonth];
        ExcelSheet.Rows[currentRow].Interior.Color := RGB(237, 237, 237);
        currentRow := currentRow + 1;
        previousMonth := currentMonth; // Update previous month
      end;

      // Insert data in current row with identation
      ExcelSheet.Cells[currentRow, 3] := StrToDate(StringGrid1.Cells[2, i]); // Fecha
      ExcelSheet.Cells[currentRow, 4] := StringGrid1.Cells[3, i]; // Tipo
      ExcelSheet.Cells[currentRow, 5] := StringGrid1.Cells[4, i]; // Serie
      ExcelSheet.Cells[currentRow, 6] := StringGrid1.Cells[5, i]; // Número
      ExcelSheet.Cells[currentRow, 7] := StringGrid1.Cells[6, i]; // T. Ope.
      ExcelSheet.Cells[currentRow, 8] := StringGrid1.Cells[8, i]; // Entradas
      ExcelSheet.Cells[currentRow, 9] := StringGrid1.Cells[7, i]; // Salida
      ExcelSheet.Cells[currentRow, 10]:= ''; // Saldo Final

      // If there is a value in "Entradas" change background color.
      if Trim(StringGrid1.Cells[8, i]) <> '' then
      begin
        ExcelSheet.Rows[currentRow].Interior.Color := RGB(255,242,204);
      end;

      currentRow := currentRow + 1;
    end;

    // Insert totals for the last month
    if previousMonth <> -1 then
    begin
      ExcelSheet.Cells[currentRow, 7] := 'TOTALES';
      currentRow := currentRow + 1;
    end;

    // Formatting columns
    ExcelSheet.Columns[1].NumberFormat := '0';
    ExcelSheet.Columns[3].NumberFormat := 'dd/mm/yyyy';

    ExcelWorkbook.SaveAs('D:\bventa kargen\excel\report.xlsx');
    ExcelApp.Quit;
  except
    on E: Exception do
      ShowMessage('Ocurrió un error: ' + E.Message);
  end;
end;

procedure Tfrm_kardex.Button1Click(Sender: TObject);
var
  i, j, qty: Integer;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text :=
    'SELECT ' +
    '    k.id AS kardex_id, ' +
    '    k.product_sku AS sku, ' +
    '    p.description, ' +
    '    MAX(k.fecha) AS fecha, ' +
    '    k.tipo, ' +
    '    k.serie, ' +
    '    k.number, ' +
    '    k.type_operation, ' +
    '    k.output, ' +
    '    k.input ' +
    'FROM ' +
    '    kardex k ' +
    'JOIN ' +
    '    products p ON p.sku = k.product_sku ' +
    'GROUP BY ' +
    '    k.id, k.product_sku, p.description, k.tipo, k.serie, k.number, k.type_operation, k.output, k.input ' +
    'ORDER BY ' +
    '    p.description, MAX(fecha), k.number';
  dm.IBQuery1.Open;

  if dm.IBQuery1.IsEmpty then
  begin
    ShowMessage('No existen registros en la tabla kardex.');
    Exit;
  end;

  // Setting StringGrid
  StringGrid1.ColCount := 11;
  StringGrid1.Cells[0, 0] := 'SKU';
  StringGrid1.Cells[1, 0] := 'Descripción';
  StringGrid1.Cells[2, 0] := 'Fecha';
  StringGrid1.Cells[3, 0] := 'Tipo';
  StringGrid1.Cells[4, 0] := 'Serie';
  StringGrid1.Cells[5, 0] := 'Número';
  StringGrid1.Cells[6, 0] := 'T. Ope.';
  StringGrid1.Cells[7, 0] := 'Salida';
  StringGrid1.Cells[8, 0] := 'Entrada';
  StringGrid1.Cells[9, 0] := '#';
  StringGrid1.Cells[10, 0] := 'ID';

  i := 1;

  if rb_100.Checked then
    qty := 100
  else if rb_1000.Checked then
    qty := 1000
  else if rb_all.Checked then
    qty := -1
  else
    qty := 0;

  // Setting progressbar
  if qty = -1 then
  begin
    dm.IBQuery1.Last;
    ProgressBar1.Min := 0;
    ProgressBar1.Max := dm.IBQuery1.RecordCount;
    ProgressBar1.Position := 0;
    ProgressBar1.Step := 1;
    ShowMessage('Cargar ' + IntToStr(dm.IBQuery1.RecordCount) + ' registros');
    dm.IBQuery1.First;
    while not dm.IBQuery1.Eof do
    begin
      // Show data in stringGrid
      StringGrid1.RowCount := i + 1;
      StringGrid1.Cells[0, i] := dm.IBQuery1.FieldByName('sku').AsString;
      StringGrid1.Cells[1, i] := dm.IBQuery1.FieldByName('description').AsString;
      StringGrid1.Cells[2, i] := dm.IBQuery1.FieldByName('fecha').AsString;
      StringGrid1.Cells[3, i] := dm.IBQuery1.FieldByName('tipo').AsString;
      StringGrid1.Cells[4, i] := dm.IBQuery1.FieldByName('serie').AsString;
      StringGrid1.Cells[5, i] := dm.IBQuery1.FieldByName('number').AsString;
      StringGrid1.Cells[6, i] := dm.IBQuery1.FieldByName('type_operation').AsString;
      StringGrid1.Cells[7, i] := dm.IBQuery1.FieldByName('output').AsString;
      StringGrid1.Cells[8, i] := dm.IBQuery1.FieldByName('input').AsString;
      StringGrid1.Cells[9, i] := IntToStr(i);
      StringGrid1.Cells[10, i] := dm.IBQuery1.FieldByName('kardex_id').AsString;

      ProgressBar1.Position := i;
      Application.ProcessMessages;

      dm.IBQuery1.Next;
      Inc(i);
    end;
  end
  else
  begin

    ProgressBar1.Min := 0;
    ProgressBar1.Max := qty;
    ProgressBar1.Position := 0;
    ProgressBar1.Step := 1;

    for j := 1 to qty do
    begin
      // Check if is the last record
      if dm.IBQuery1.Eof then
        Break;

      StringGrid1.RowCount := i + 1;
      StringGrid1.Cells[0, i] := dm.IBQuery1.FieldByName('sku').AsString;
      StringGrid1.Cells[1, i] := dm.IBQuery1.FieldByName('description').AsString;
      StringGrid1.Cells[2, i] := dm.IBQuery1.FieldByName('fecha').AsString;
      StringGrid1.Cells[3, i] := dm.IBQuery1.FieldByName('tipo').AsString;
      StringGrid1.Cells[4, i] := dm.IBQuery1.FieldByName('serie').AsString;
      StringGrid1.Cells[5, i] := dm.IBQuery1.FieldByName('number').AsString;
      StringGrid1.Cells[6, i] := dm.IBQuery1.FieldByName('type_operation').AsString;
      StringGrid1.Cells[7, i] := dm.IBQuery1.FieldByName('output').AsString;
      StringGrid1.Cells[8, i] := dm.IBQuery1.FieldByName('input').AsString;
      StringGrid1.Cells[9, i] := IntToStr(i);
      StringGrid1.Cells[10, i] := dm.IBQuery1.FieldByName('kardex_id').AsString;

      ProgressBar1.Position := j;
      Application.ProcessMessages;

      dm.IBQuery1.Next;
      Inc(i);
    end;
  end;

  ShowMessage('¡Carga de datos completado!');
  btn_export_excel.Enabled := True;
end;


procedure Tfrm_kardex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Self.Release;
  Self := nil;
end;

procedure Tfrm_kardex.FormCreate(Sender: TObject);
begin
  StringGrid1.ColWidths[0] := 150;
  StringGrid1.ColWidths[1] := 400;
  StringGrid1.ColWidths[2] := 100;
  StringGrid1.ColWidths[3] := 50;
  StringGrid1.ColWidths[4] := 50;
  StringGrid1.ColWidths[5] := 100;
  StringGrid1.ColWidths[6] := 100;
  StringGrid1.ColWidths[7] := 50;
  StringGrid1.ColWidths[8] := 50;
  StringGrid1.ColWidths[9] := 50;
  StringGrid1.ColWidths[10] := 50;

  readFromIni;
end;
procedure Tfrm_kardex.rb_1000Click(Sender: TObject);
begin

  ProgressBar1.Min := 0;
  ProgressBar1.Max := totalRecords;
  ProgressBar1.Position := 0;
  ProgressBar1.Step := 1;

  // Clean stringgrid1
  stringgrid1.RowCount:= 0;

  btn_export_excel.Enabled:= false;
end;

procedure Tfrm_kardex.rb_100Click(Sender: TObject);
begin

  ProgressBar1.Min := 0;
  ProgressBar1.Max := 0;
  ProgressBar1.Position := 0;
  ProgressBar1.Step := 1;

  stringgrid1.RowCount:= 0;

  btn_export_excel.Enabled:= false;
end;

procedure Tfrm_kardex.rb_allClick(Sender: TObject);
begin

  ProgressBar1.Min := 0;
  //ProgressBar1.Max := totalRecords;
  ProgressBar1.Position := 0;
  ProgressBar1.Step := 1;

  stringgrid1.RowCount:= 0;

  btn_export_excel.Enabled:= false;
end;

procedure Tfrm_kardex.readFromIni;
var
  ini: TIniFile;
  iniFilePath: string;
begin
  IniFilePath := ExtractFilePath(ParamStr(0)) + 'config.ini';

  Ini := TIniFile.Create(IniFilePath);
  try
    edt_db.Text:= Ini.ReadString('database', 'path', '');
  finally
    Ini.Free;
  end;
end;

procedure Tfrm_kardex.saveToIni;
var
  ini: TIniFile;
  IniFilePath: string;
begin
  IniFilePath:= ExtractFilePath(ParamStr(0)) + 'config.ini';

  ini:= TIniFile.Create(IniFilePath);
  try
    ini.WriteString('database','host', 'localhost');
    ini.WriteString('database','path', edt_db.Text);
    ini.WriteString('database','username', 'SYSDBA');
    ini.WriteString('database','password', 'masterkey');
  finally
    ini.Free;
  end;
end;

end.
