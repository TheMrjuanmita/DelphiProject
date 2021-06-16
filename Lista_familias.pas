unit Lista_familias;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls;

type
  TFlista_familias = class(TForm)
    DBGrid1: TDBGrid;
    Basignar: TButton;
    Button1: TButton;
    Ebuscar: TEdit;
    CBbusqueda: TComboBox;
    Label1: TLabel;
    Button2: TButton;
    Bclear: TButton;
    Button3: TButton;
    Label2: TLabel;
    SaveD: TSaveDialog;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BasignarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BclearClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Flista_familias: TFlista_familias;

implementation

uses datos,Expediente_detalle,Nueva_ayuda;

{$R *.dfm}

procedure TFlista_familias.BasignarClick(Sender: TObject);
begin
  Fnueva_ayuda.ShowModal;
end;

procedure TFlista_familias.BclearClick(Sender: TObject);
begin

Fdatos.Tfamilia.Filtered:= False;
Bclear.Visible:=false;
end;

procedure TFlista_familias.Button1Click(Sender: TObject);
begin
//Abrir expediente_detalle
FdetalleExpediente.ShowModal;
end;



procedure TFlista_familias.Button2Click(Sender: TObject);
begin

  //Fdatos.Tfamilia.Filter:=QuotedStr(CBbusqueda.Text)+'='+QuotedStr(Ebuscar.Text);
  Fdatos.Tfamilia.Filter:=CBbusqueda.Text+ ' = '+QuotedStr(Ebuscar.Text);
  Fdatos.Tfamilia.Filtered:=true;

  //ShowMessage('edad <= '+QuotedStr(Ebuscar.Text));
  //ShowMessage(QuotedStr(CBbusqueda.Text)+'='+Ebuscar.Text);
  Bclear.Visible:=true;
end;

procedure TFlista_familias.Button3Click(Sender: TObject);
var
  I, J: Integer;
  SL,SL2: TStringList;


begin



   SaveD.Execute();



  SL := TStringList.Create;

  Fdatos.Tfamilia.First;
  for I := 1 to  Fdatos.Tfamilia.RecordCount do
  begin
    SL.Add('');
    Fdatos.Tfamilia.RecNo := I;
    for J := 0 to Fdatos.Tfamilia.Fields.Count - 1 do
      SL[SL.Count - 1] := SL[SL.Count - 1] + Fdatos.Tfamilia.Fields[J].AsString + ';';
  end;

  SL.Add('');
  SL.Add('');
  SL[SL.Count-1] := 'TABLA DE PRESTACIONES'+';';

  Fdatos.Tprestacion.Open();
  Fdatos.Tprestacion.First;
   for I := 1 to  Fdatos.Tprestacion.RecordCount do
  begin
    SL.Add('');
    Fdatos.Tprestacion.RecNo := I;
    for J := 0 to Fdatos.Tprestacion.Fields.Count - 1 do
      SL[SL.Count - 1] := SL[SL.Count - 1] + Fdatos.Tprestacion.Fields[J].AsString + ';';
  end;



  SL.SaveToFile(SaveD.FileName);
  SL.Free;

  Fdatos.Tfamilia.Close;
  Fdatos.Tfamilia.Open();
  Fdatos.Tprestacion.Close;

end;




procedure TFlista_familias.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  Fdatos.Tfamilia.Filtered:=false;
 Fdatos.Tfamilia.Open();
 CBbusqueda.Items.Clear;
 with DBGrid1 do
 begin
   for i := 0 to Columns.Count-1 do
      CBbusqueda.Items.Add(Columns[i].FieldName);
 end;
 CBbusqueda.ItemIndex:=0;
 Bclear.Visible:=false;


 SaveD.DefaultExt := 'csv';
 SaveD.Filter := 'Archivo csv|*.csv';
end;



procedure TFlista_familias.FormDestroy(Sender: TObject);
begin
 Fdatos.Tfamilia.Close;
end;

end.
