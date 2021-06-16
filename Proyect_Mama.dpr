program Proyect_Mama;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {Form1},
  Nueva_Familia in 'Nueva_Familia.pas' {Fnueva},
  datos in 'datos.pas' {Fdatos},
  Lista_familias in 'Lista_familias.pas' {Flista_familias},
  Expediente_detalle in 'Expediente_detalle.pas' {FdetalleExpediente},
  Nueva_ayuda in 'Nueva_ayuda.pas' {Fnueva_ayuda},
  ModificEeXP in 'ModificEeXP.pas' {Modificar},
  ModifiAyuda in 'ModifiAyuda.pas' {ModificarAyuda};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFnueva, Fnueva);
  Application.CreateForm(TFdatos, Fdatos);
  Application.CreateForm(TFlista_familias, Flista_familias);
  Application.CreateForm(TFdetalleExpediente, FdetalleExpediente);
  Application.CreateForm(TFnueva_ayuda, Fnueva_ayuda);
  Application.CreateForm(TModificar, Modificar);
  Application.CreateForm(TModificarAyuda, ModificarAyuda);
  Application.Run;
end.
