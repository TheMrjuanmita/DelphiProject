unit Expediente_detalle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls;

type
  TFdetalleExpediente = class(TForm)
    Lnombre: TLabel;
    Lapellido: TLabel;
    Ledad: TLabel;
    Ldni: TLabel;
    Lsexo: TLabel;
    Lexpediente: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Lmiembroconvivencia: TLabel;
    Lmenores: TLabel;
    Lunidadfamiliar: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Ldiscapacidad: TLabel;
    Lmayores: TLabel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label7: TLabel;
    MemoObservaciones: TDBMemo;
    Button1: TButton;
    BmodificarAyuda: TButton;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BmodificarAyudaClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FdetalleExpediente: TFdetalleExpediente;

implementation
uses datos, ModificEeXP,ModifiAyuda, Nueva_ayuda;
{$R *.dfm}

procedure TFdetalleExpediente.BmodificarAyudaClick(Sender: TObject);
begin
 ModificarAyuda.ShowModal;
end;

procedure TFdetalleExpediente.Button1Click(Sender: TObject);
begin
 Modificar.ShowModal;
end;

procedure TFdetalleExpediente.Button2Click(Sender: TObject);
begin
Fnueva_ayuda.ShowModal;
end;

procedure TFdetalleExpediente.FormActivate(Sender: TObject);
begin
  //Aqui pillo los datos de la tabla y los pongo para una mejor visualizacion
  Lexpediente.Caption:=  Fdatos.Tfamiliaexpediente.Value;
  Lnombre.Caption:= Fdatos.Tfamilianombre.Value;
  Lapellido.Caption:= Fdatos.Tfamiliaapellido.Value;
  Ldni.Caption:= Fdatos.Tfamiliadni.Value;
  Ledad.Caption:= IntToStr(Fdatos.Tfamiliaedad.Value);

  if Fdatos.Tfamiliasexo.Value = 0 then
  begin
    Lsexo.Caption:='Hombre';

  end
  else
  begin
    Lsexo.Caption:='Mujer';
  end;

  Lmiembroconvivencia.Caption := IntToStr(Fdatos.Tfamiliamiembroconvivencia.Value);
  Lmenores.Caption :=IntToStr(Fdatos.Tfamilianumeromenores.Value);
  Lunidadfamiliar.Caption := IntToStr(Fdatos.Tfamiliaunidadfamiliar.Value);

  if Fdatos.Tfamiliadiscapacidad.Value = 0 then
  begin
     Ldiscapacidad.Caption := 'No';
  end
  else
  begin
     Ldiscapacidad.Caption := 'Si';
  end;

  if Fdatos.Tfamiliamayor65.Value = 0 then
  begin
     Lmayores.Caption := 'No';
  end
  else
  begin
      Lmayores.Caption := 'Si';
  end;

  Fdatos.Tprestacion.Open();
  Fdatos.Tprestacion.Filter := ('expedientefamilia='+QuotedStr(Lexpediente.Caption));
  Fdatos.Tprestacion.Filtered := true;


end;

procedure TFdetalleExpediente.FormDestroy(Sender: TObject);
begin
 Fdatos.Tprestacion.Filtered:=false;
 Fdatos.Tprestacion.Close;
end;

end.
