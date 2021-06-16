unit datos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFdatos = class(TForm)
    Tfamilia: TFDTable;
    Dfamilia: TDataSource;
    Tgasto: TFDTable;
    Dgasto: TDataSource;
    Tgastonumero: TIntegerField;
    Tgastodescripcion: TStringField;
    Tgastomaximo: TFloatField;
    Tgasto_detalle: TFDTable;
    Dgasto_detalle: TDataSource;
    Tprestacion: TFDTable;
    Tgasto_detallenumerogasto: TIntegerField;
    Tgasto_detallepersona: TIntegerField;
    Tgasto_detallemaximo: TFloatField;
    Tequipo: TFDTable;
    Tzona: TFDTable;
    Dequipo: TDataSource;
    Dzona: TDataSource;
    Tequipoequipo: TStringField;
    Tzonazonanombre: TStringField;
    Tfamiliaexpediente: TStringField;
    Tfamilianombre: TStringField;
    Tfamiliaapellido: TStringField;
    Tfamiliaedad: TIntegerField;
    Tfamiliasexo: TIntegerField;
    Tfamiliadni: TStringField;
    Tfamiliamiembroconvivencia: TIntegerField;
    Tfamilianumeromenores: TIntegerField;
    Tfamiliaunidadfamiliar: TIntegerField;
    Tfamiliadiscapacidad: TIntegerField;
    Tfamiliamayor65: TIntegerField;
    Tfamiliatotalprestaciones: TFloatField;
    Tfamiliazona: TStringField;
    Tfamiliaequipo: TStringField;
    Tprestacionexpedientefamilia: TStringField;
    Tprestaciontipoprestacion: TStringField;
    Tprestaciondineroprestacion: TFloatField;
    Tprestacionfechaprestacion: TStringField;
    Tprestacionfechasolicitud: TStringField;
    Tprestacionfechaado: TStringField;
    Tprestacionnumeroregistro: TStringField;
    Tprestacionobservacion: TWideMemoField;
    Tprestacionnumeroado: TIntegerField;
    D_prestacion: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fdatos: TFdatos;

implementation

uses Principal;

{$R *.dfm}

end.
