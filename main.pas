unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Menus;

type
  Tfrm_main = class(TForm)
    pnl_header: TPanel;
    pc_menu: TPageControl;
    tab_all: TTabSheet;
    pnl_transactions: TPanel;
    pnl_operation: TPanel;
    btn_operation_new: TSpeedButton;
    pnl_kardex: TPanel;
    btn_kardex: TSpeedButton;
    pnl_operations: TPanel;
    mm_menu: TMainMenu;
    frm_file: TMenuItem;
    mnu_exit: TMenuItem;
    procedure btn_kardexClick(Sender: TObject);
    procedure btn_operation_newClick(Sender: TObject);
    procedure mnu_exitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.dfm}

uses
  kardex, operations;

procedure Tfrm_main.btn_kardexClick(Sender: TObject);
var
  Child: Tfrm_kardex;
begin
  Child := Tfrm_kardex.Create(Application);
  Child.Caption := 'Kardex ' + IntToStr(MDIChildCount);
end;

procedure Tfrm_main.btn_operation_newClick(Sender: TObject);
var
  Child: TFrm_operations;
begin
  Child:= Tfrm_operations.Create(Application);
  Child.Caption:= 'Operaciones';
end;

procedure Tfrm_main.mnu_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
