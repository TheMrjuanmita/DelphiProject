unit Nueva_Familia;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls;

type
  TFnueva = class(TForm)
    Eexpediente: TEdit;
    Enombre: TEdit;
    Eapellido: TEdit;
    Eedad: TEdit;
    Panel: TPanel;
    Edni: TEdit;
    Spinmiembos: TSpinEdit;
    SpinMenores: TSpinEdit;
    SpinFamilia: TSpinEdit;
    ChDiscapacidad: TCheckBox;
    Chmayor65: TCheckBox;
    L1: TLabel;
    Bnuevoexp: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RGsexo: TRadioGroup;
    l2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bguardar: TButton;
    Bcancelar: TButton;
    CBzona: TComboBox;
    CBequipo: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure EexpedienteExit(Sender: TObject);
    procedure marcarTexto(Sender: TObject);
    procedure BguardarClick(Sender: TObject);
    procedure BcancelarClick(Sender: TObject);
    procedure desmarcarText(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fnueva: TFnueva;

implementation
uses datos,Lista_familias;

{$R *.dfm}

procedure TFnueva.BcancelarClick(Sender: TObject);
begin
  Fdatos.Tfamilia.Cancel;
  ModalResult:=mrOk;
end;

procedure TFnueva.BguardarClick(Sender: TObject);

var
  flag:boolean;
  edadRelleno:boolean;

begin
  //Aqui hago todas las comprobaciones, y si alguna falla pues no te deja avanzar
flag :=true;
edadRelleno := true;

  if Eexpediente.Text = '' then
  begin
    flag := false;
  end;
  if Enombre.Text = '' then
  begin
    flag := false;
  end;
  if Eapellido.Text = '' then
  begin
    flag := false;
  end;
  if Eedad.Text = '' then
  begin
    edadRelleno := false;    //TODO
  end;
  if Edni.Text = '' then
  begin
    flag := false;
  end;
  if RGsexo.ItemIndex = -1 then
  begin
    flag := false;
  end;


//Validar y enviar
  if flag = true then
  begin
    //Si todo ha ido bien, se introducen los datos de la familia corrrespondiente en la BD

    Fdatos.Tfamilia.Append;



    if edadRelleno = false  then
    begin

    end
    else
    begin
      Fdatos.Tfamiliaedad.Value := StrToInt(Eedad.Text);
    end;

    Fdatos.Tfamiliaexpediente.Value := Eexpediente.Text;
    Fdatos.Tfamilianombre.Value := Enombre.Text;
    Fdatos.Tfamiliaapellido.Value := Eapellido.Text;

    Fdatos.Tfamiliasexo.Value := RGsexo.ItemIndex;
    Fdatos.Tfamiliadni.Value := Edni.Text;
    Fdatos.Tfamiliamiembroconvivencia.Value := StrToInt(Spinmiembos.Text);
    Fdatos.Tfamilianumeromenores.Value := StrToInt(SpinMenores.Text);
    Fdatos.Tfamiliaunidadfamiliar.Value := StrToInt(SpinFamilia.Text);
    Fdatos.Tfamiliazona.Value := CBzona.Text;
    Fdatos.Tfamiliaequipo.Value := CBequipo.Text;

    if ChDiscapacidad.Checked = True then
    begin
        Fdatos.Tfamiliadiscapacidad.Value := 1;
    end
    else
    begin
     Fdatos.Tfamiliadiscapacidad.Value := 0;
    end;

    if Chmayor65.Checked = True then
    begin
       Fdatos.Tfamiliamayor65.Value := 1;
    end
    else
    begin
        Fdatos.Tfamiliamayor65.Value := 0;
    end;

    Fdatos.Tfamiliatotalprestaciones.Value := 0;
    //ShowMessage('Anstes de Post');
    Fdatos.Tfamilia.Post;

    //ShowMessage('Despues del post');
    ShowMessage('Datos Guardados Correctamente');

    Fdatos.Tfamilia.Close;
    






    ModalResult:=mrOk;
  end
  else
  begin
      ShowMessage('Error en la inserción de datos');
  end;




end;



procedure TFnueva.EexpedienteExit(Sender: TObject);
begin
//Averiguar si existe un expediente igual
  while not Fdatos.Tfamilia.Eof do
  begin
    if Fdatos.Tfamiliaexpediente.value = Eexpediente.Text then
    begin
      ShowMessage('ERROR Número de expediente ya existente');
      Eexpediente.Text:='';
      Fdatos.Tfamilia.Close;
      ModalResult := mrOk;
      Break

    end
    else
    begin
      Fdatos.Tfamilia.Next;
    end;
    

  end;
  Panel.Visible:=True;
  Bnuevoexp.Enabled:=false;
  Eexpediente.Enabled:=false;

  //Aqui relleno los ComboBox de equipo y zona
  Fdatos.Tequipo.Open();
  Fdatos.Tequipo.First;
  Fdatos.Tzona.Open();
  Fdatos.Tzona.First;
  CBzona.Items.Clear;
  CBequipo.Items.Clear;

  while not Fdatos.Tequipo.Eof do
  begin
    CBequipo.Items.Add(Fdatos.Tequipoequipo.Value);
    Fdatos.Tequipo.Next;
  end;

  while not Fdatos.Tzona.Eof do
  begin
    CBzona.Items.Add(Fdatos.Tzonazonanombre.Value);
    Fdatos.Tzona.Next;
  end;

  Fdatos.Tequipo.Close;
  Fdatos.Tzona.Close;

  //----------------------------------------



end;



procedure TFnueva.marcarTexto(Sender: TObject);
begin
//Poner los textos en amarillo
  (Sender as Tedit).Color:=clYellow;
  (Sender as Tedit).Text := '';
end;

procedure TFnueva.desmarcarText(Sender: TObject);
begin
  //Quitar Color
  (Sender as Tedit).Color:=clWhite;
end;

procedure TFnueva.FormActivate(Sender: TObject);
begin
   Fdatos.Tfamilia.Open();
   Panel.Visible:=false;
   Eexpediente.Enabled:= true;
   Bnuevoexp.Enabled:=true;


   Eexpediente.Text := '';
   Enombre.Text := '';
   Eapellido.Text := '';
   Eedad.Text := '';
   Edni.Text := '';
   Spinmiembos.Value := 0;
   SpinMenores.Value := 0;
   SpinFamilia.Value := 0;
   ChDiscapacidad.Checked := false;
   Chmayor65.Checked := false;
   CBzona.ItemIndex := -1;
   CBequipo.ItemIndex := -1;

   RGsexo.ItemIndex := -1;

end;

end.
