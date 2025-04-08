unit uFirebird;

interface

uses
  System.Classes,
  IBX.IBDatabase, IBX.IBTable, IBX.IBQuery, Data.DB;

type
  TFirebird = class(TObject)
    protected
      FDatabaseName: string;
    public
      procedure databaseName(value: string);
      procedure connection;
      procedure query(value: string);
      function getDatabaseName: string;
  end;

var
  db: TIBDatabase;
  ts: TIBTransaction;
  qry:TIBQuery;

implementation

{ TFirebird }

procedure TFirebird.connection;
begin
  // database
  db:= TIBDatabase.Create(nil);
  db.DatabaseName:= FDatabaseName; // e.g 'D:\tmp\db4_v4.fdb'
  db.Params.Values['user_name']:= 'SYSDBA';
  db.Params.Values['password']:= 'masterkey';

  db.LoginPrompt:= false;
  db.Connected  := true;

  // transaction
  ts:= TIBTransaction.Create(nil);
  ts.DefaultDatabase:= db;
  ts.Active:= true;
end;

procedure TFirebird.databaseName(value: string);
begin
  FDatabaseName:= value;
end;

function TFirebird.getDatabaseName: string;
begin
  result:= FDatabaseName;
end;

procedure TFirebird.query(value: string);
begin
  connection;

  qry:= TIBQuery.Create(nil);
  try
    qry.Database := db;
    qry.Transaction := ts;
    qry.SQL.Text := 'INSERT INTO CLIENTES (nombre) VALUES (:nombre)';
    qry.ParamByName('nombre').AsString := value;
    qry.ExecSQL;
    //ShowMessage(qry.Fields[0].AsString);

    ts.Commit;
    ts.StartTransaction;
  finally
    qry.Free;
  end;
end;

end.
