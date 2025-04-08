program kardex_generator;

uses
  Vcl.Forms,
  kardex in 'kardex.pas' {frm_kardex},
  datamodule in 'datamodule.pas' {dm: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  main in 'main.pas' {frm_main},
  operations in 'operations.pas' {frm_operations},
  uFBProduct in 'lib\classes\firebird\uFBProduct.pas',
  uFirebird in 'lib\classes\firebird\uFirebird.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(Tfrm_main, frm_main);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
