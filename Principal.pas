unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, Vcl.StdCtrls,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Familias1: TMenuItem;
    NuevaFamilia1: TMenuItem;
    ListadodeFamilias1: TMenuItem;
    FDConnection1: TFDConnection;
    Bnueva_familia: TButton;
    Blistado: TButton;
    Bsalir: TButton;
    procedure FormActivate(Sender: TObject);
    procedure NuevaFamilia1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListadodeFamilias1Click(Sender: TObject);
    procedure BsalirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Nueva_Familia,datos,Lista_familias;

procedure TForm1.BsalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
 FDConnection1.Connected:=True;
 if FDConnection1.Connected = true then
 begin
   //ShowMessage('Base de datos Conectada');
   //Proyecto
 end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//Cerrar todas las conexiones

 FDConnection1.Close;
  
end;

procedure TForm1.ListadodeFamilias1Click(Sender: TObject);
begin
 Flista_familias.ShowModal;
end;

procedure TForm1.NuevaFamilia1Click(Sender: TObject);
begin
 Fnueva.ShowModal;
end;

end.
