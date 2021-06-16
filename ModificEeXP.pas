unit ModificEeXP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin;

type
  TModificar = class(TForm)
    Panel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    l2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Enombre: TEdit;
    Eapellido: TEdit;
    Eedad: TEdit;
    Edni: TEdit;
    Spinmiembos: TSpinEdit;
    SpinMenores: TSpinEdit;
    SpinFamilia: TSpinEdit;
    ChDiscapacidad: TCheckBox;
    Chmayor65: TCheckBox;
    RGsexo: TRadioGroup;
    CBzona: TComboBox;
    CBequipo: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Lexpediente: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Modificar: TModificar;

implementation
uses datos;

{$R *.dfm}

procedure TModificar.Button1Click(Sender: TObject);
begin
  //Mandar los datos modificados a la BD
  Fdatos.Tfamiliadni.Value :=  Edni.Text;
  Fdatos.Tfamilianombre.Value :=  Enombre.Text;
  Fdatos.Tfamiliaapellido.Value := Eapellido.Text;
  Fdatos.Tfamiliaedad.Value := StrToInt(Eedad.Text);
  Fdatos.Tfamiliamiembroconvivencia.Value := Spinmiembos.Value;
  Fdatos.Tfamilianumeromenores.Value := SpinMenores.Value;
  Fdatos.Tfamiliaunidadfamiliar.Value := SpinFamilia.Value;

  Fdatos.Tfamiliasexo.Value := RGsexo.ItemIndex;

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

    Fdatos.Tfamilia.Post;
    Fdatos.Tfamilia.Close;
    Fdatos.Tfamilia.Open();
    Fdatos.Tfamilia.Locate('expediente',Lexpediente.Caption);
    ModalResult := mrOk;


end;

procedure TModificar.Button2Click(Sender: TObject);
begin
  Fdatos.Tfamilia.Cancel;
  ModalResult :=mrCancel;
end;

procedure TModificar.FormActivate(Sender: TObject);
begin
//Poner los valores de todos los Campos
  Lexpediente.Caption := Fdatos.Tfamiliaexpediente.Value;

   Edni.Text := Fdatos.Tfamiliadni.Value;
   Enombre.Text := Fdatos.Tfamilianombre.Value;
   Eapellido.Text := Fdatos.Tfamiliaapellido.Value;
   Eedad.Text := IntToStr(Fdatos.Tfamiliaedad.Value);
   Spinmiembos.Value := Fdatos.Tfamiliamiembroconvivencia.Value;
   SpinMenores.Value := Fdatos.Tfamilianumeromenores.Value;
   SpinFamilia.Value := Fdatos.Tfamiliaunidadfamiliar.Value;


   if Fdatos.Tfamiliamayor65.Value = 1 then
   begin
     Chmayor65.Checked := true;
   end;

   if Fdatos.Tfamiliadiscapacidad.Value = 1 then
   begin
     ChDiscapacidad.Checked := true;
   end;

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
  //------------------------------------------------
  CBzona.Text := Fdatos.Tfamiliazona.Value;
  CBequipo.Text := Fdatos.Tfamiliaequipo.Value;
  RGsexo.ItemIndex := Fdatos.Tfamiliasexo.Value;

  Fdatos.Tfamilia.Edit;

end;

end.
