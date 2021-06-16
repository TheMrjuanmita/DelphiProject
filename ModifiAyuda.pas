unit ModifiAyuda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TModificarAyuda = class(TForm)
    Lexpediente: TLabel;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Lmaximolabel: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Panel: TPanel;
    L1: TLabel;
    Limporte: TLabel;
    Label8: TLabel;
    Mdescripcion: TMemo;
    DBGrid1: TDBGrid;
    Ppersona: TPanel;
    Lpersona1: TLabel;
    Lpersona2: TLabel;
    Lpersona3: TLabel;
    Lpersona4: TLabel;
    Lpersona5: TLabel;
    Lpersona6: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    BmodificarAyuda: TButton;
    EimporteIngresar: TEdit;
    MemoObservacion: TDBMemo;
    DateSolicitud: TDateTimePicker;
    ChAdo: TCheckBox;
    ChNumeroAdo: TCheckBox;
    DateAdo: TDateTimePicker;
    ENumeroAdo: TEdit;
    ENumeroRegistro: TEdit;
    Button1: TButton;
    Label17: TLabel;
    DatePrestacion: TDateTimePicker;
    ChPrestacion: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure BmodificarAyudaClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button1Click(Sender: TObject);
    procedure ChAdoClick(Sender: TObject);
    procedure ChNumeroAdoClick(Sender: TObject);
    procedure ChPrestacionClick(Sender: TObject);
  private

    { Private declarations }
    miembrosunidad:Integer;
  public
    { Public declarations }
  end;

var
  ModificarAyuda: TModificarAyuda;

implementation

{$R *.dfm}

uses datos;

procedure TModificarAyuda.BmodificarAyudaClick(Sender: TObject);
var
  flag,sobresuma : boolean;
  importe,maximo,suma : double;
begin
 //Asegurarme de todo y modificar

  flag :=true;
  sobresuma := true;
  suma := 0;
  maximo := StrToFloat(Lmaximolabel.Caption);



 //Primero las combrovaciones

  //Excepcion de float

  try
      importe := strtofloat(EimporteIngresar.Text);
  except
    on Exception : EConvertError do
    begin
      ShowMessage('Error en el importe');
      EimporteIngresar.Text := '';
    end;

  end;



  //Filtrar prestaciones de numero similar y sumarlas

  Fdatos.Tprestacion.Filter := 'expedientefamilia='+QuotedStr(Lexpediente.Caption) +'AND'
  +' tipoprestacion='+QuotedStr(IntToStr(Fdatos.Tgastonumero.Value));

  Fdatos.Tprestacion.Filtered:=true;
  while not Fdatos.Tprestacion.Eof do
  begin
    suma := suma+ Fdatos.Tprestaciondineroprestacion.Value;
    Fdatos.Tprestacion.Next;
  end;

  //ShowMessage(FloatToStr(suma));

  if (suma + importe) > maximo then
  begin
    sobresuma := false;
    flag := false
  end;


  Fdatos.Tprestacion.Filtered:=false;
  Fdatos.Tprestacion.Close;
  Fdatos.Tprestacion.Open();




  //Importe--------------------------------------------------------
  if EimporteIngresar.Text = '' then
  begin
    flag := false;
  end;
  if strtofloat(EimporteIngresar.Text) > strtofloat(Lmaximolabel.Caption) then
  begin
    flag := false;
  end;

  if ENumeroRegistro.Text = '' then
  begin
    flag := false;
  end;

  if ChNumeroAdo.Checked = true then
  begin
    if ENumeroAdo.Text = '' then
    begin
      flag := false;
    end;
  end;

   //-------------------------------------------------------------------

  if flag = false then
  begin
      if sobresuma = false then
    begin

      ShowMessage('Sobrepasa el importe maximo permitido por año('+FloatToStr(maximo-suma)+'€ restantes)');
    end
    else
    begin
      ShowMessage('Faltan campos esenciales por rellenar');

    end;
  end
  else
  begin
    //Aqui viene lo fuerte
    Fdatos.Tprestacion.Edit;

    Fdatos.Tprestacionexpedientefamilia.Value := Lexpediente.Caption;   //Expediente
    Fdatos.Tprestaciontipoprestacion.Value := IntToStr(Fdatos.Tgastonumero.Value);  //tipo de prestacion
    Fdatos.Tprestaciondineroprestacion.Value := importe;  //importe
    Fdatos.Tprestacionfechaprestacion.Value := DateToStr(Date);    //Fecha de prestacion(Propio mio)
    Fdatos.Tprestacionfechasolicitud.Value := DateToStr(DateSolicitud.Date);  //Fecha de solicitud
    Fdatos.Tprestacionnumeroregistro.Value := ENumeroRegistro.Text;  //Numero de registro

    if ChAdo.Checked = true then
    begin
      Fdatos.Tprestacionfechaado.Value := DateToStr(DateAdo.Date);   //Fecah ADO
    end;

    if ChNumeroAdo.Checked = true then
    begin
      Fdatos.Tprestacionnumeroado.Value := StrToInt(ENumeroAdo.Text);   //Numero ADO
    end;

    if ChPrestacion.Checked = true then
    begin
      Fdatos.Tprestacionfechaprestacion.Value := DateToStr(DatePrestacion.Date); //Fecha de Asignacion Prestacion
    end;




    Fdatos.Tprestacion.Post;

    Fdatos.Tprestacion.Close;
    Fdatos.Tprestacion.Open();
    Fdatos.Tprestacion.Filter := ('expedientefamilia='+QuotedStr(Lexpediente.Caption));
    Fdatos.Tprestacion.Filtered := true;

    Fdatos.Tgasto.Close;
    Fdatos.Tgasto.Open();
    ModalResult := mrOk;
  end;




  //Se usa StrToDate y datetostr
  //Fdatos.Tprestacion.Close;
end;











procedure TModificarAyuda.Button1Click(Sender: TObject);
begin
 Fdatos.Tprestacion.Cancel;
 ModalResult := mrCancel;
end;

procedure TModificarAyuda.ChAdoClick(Sender: TObject);
begin
//Poner dateAdo enable
  if ChAdo.Checked = True then
  begin
    DateAdo.Enabled:=True;
  end
  else
  begin
    DateAdo.Enabled:=False;
  end;
end;

procedure TModificarAyuda.ChNumeroAdoClick(Sender: TObject);
begin
//Poner el edit enable
  if ChNumeroAdo.Checked = True then
  begin
    ENumeroAdo.Enabled := True;
  end
  else
  begin
    ENumeroAdo.Enabled := False;
  end;
end;

procedure TModificarAyuda.ChPrestacionClick(Sender: TObject);
begin
  //Poner DatePrestacion a enable
  if ChPrestacion.Checked = true then
  begin
    DatePrestacion.Enabled := true;
  end
  else
  begin
    DatePrestacion.Enabled := False;
  end;
end;

procedure TModificarAyuda.DBGrid1CellClick(Column: TColumn);
begin
Mdescripcion.Lines.Clear;
       //Buscar la imformacion
       Mdescripcion.Lines.Add(Fdatos.Tgastodescripcion.Value);

       if Fdatos.Tgastomaximo.Value = 0 then
       begin
        //  AQui buscar en la tabla detalle
        Ppersona.Visible:=true;
        Fdatos.Tgasto_detalle.Open();
        Fdatos.Tgasto_detalle.Filter:=('numerogasto ='+QuotedStr(IntToStr(Fdatos.Tgastonumero.Value)));
        Fdatos.Tgasto_detalle.Filtered:=true;
        Fdatos.Tgasto_detalle.First;

        while not Fdatos.Tgasto_detalle.Eof do
        begin


          if Fdatos.Tgastonumero.Value = Fdatos.Tgasto_detallenumerogasto.Value then

          begin
            if Fdatos.Tgasto_detallepersona.Value = 1 then
            begin
                Lpersona1.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
            if Fdatos.Tgasto_detallepersona.Value = 2 then
            begin
                Lpersona2.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
            if Fdatos.Tgasto_detallepersona.Value = 3 then
            begin
               Lpersona3.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
            if Fdatos.Tgasto_detallepersona.Value = 4 then
            begin
               Lpersona4.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
            if Fdatos.Tgasto_detallepersona.Value = 5 then
            begin
               Lpersona5.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
            if Fdatos.Tgasto_detallepersona.Value = 6 then
            begin
                Lpersona6.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
          end;

          if miembrosunidad = Fdatos.Tgasto_detallepersona.Value then
            begin
               Lmaximolabel.Caption:= (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;

          Fdatos.Tgasto_detalle.Next;

        end;
        Fdatos.Tgasto_detalle.Filtered := False;



       end
       else
       begin
        Ppersona.Visible:=false;
        Limporte.Caption := (Fdatos.Tgastomaximo.Value).ToString;
        Lmaximolabel.Caption := Limporte.Caption;
       end;
end;

procedure TModificarAyuda.FormActivate(Sender: TObject);
var
  aux1,aux2 : boolean;


begin

  aux1 := false;
  aux2 := false;



  miembrosunidad := 0;

  Fdatos.Tgasto.Open();
  Mdescripcion.Lines.Clear;
  Ppersona.Visible:=false;

  MemoObservacion.ReadOnly:= true;


  //Poner en edir mode
  Fdatos.Tprestacion.Edit;





  //Poner numero de expediente fecha y numero de registro
  Lexpediente.Caption := Fdatos.Tfamiliaexpediente.Value;
   DateSolicitud.Date := strtodate(Fdatos.Tprestacionfechasolicitud.Value);
   ENumeroRegistro.Text := Fdatos.Tprestacionnumeroregistro.Value;
   ENumeroRegistro.ReadOnly := true;
  //Filtrar


  miembrosunidad := Fdatos.Tfamiliamiembroconvivencia.Value;

  // Verificar los checks
  if Fdatos.Tprestacionnumeroado.Value = 0 then
  begin
    ChNumeroAdo.Checked := False;
    ENumeroAdo.Enabled:=False;
  end
  else
  begin
    ChNumeroAdo.Checked := True;
    ENumeroAdo.Text := IntToStr(Fdatos.Tprestacionnumeroado.Value);
    ENumeroAdo.Enabled:= True;
  end;

  if Fdatos.Tprestacionfechaado.Value = '' then
  begin
    ChAdo.Checked := False;
    DateAdo.Enabled:=false;
  end
  else
  begin
     ChAdo.Checked := True;
     DateAdo.Date := strtodate(Fdatos.Tprestacionfechaado.Value);
     DateAdo.Enabled:=True;
  end;

  if Fdatos.Tprestacionfechaprestacion.Value = '' then
  begin
    ChPrestacion.Checked := False;
    DatePrestacion.Enabled := false;
  end
  else
  begin
    ChPrestacion.Checked := True;
    DatePrestacion.Date := StrToDate(Fdatos.Tprestacionfechaprestacion.Value);
    DatePrestacion.Enabled := true;
  end;


  if Fdatos.Tfamiliadiscapacidad.Value = 1 then
  begin
   aux1 := true;
  end;
  if Fdatos.Tfamiliamayor65.Value = 1 then
  begin
    aux2 := true;
  end;




  if (aux1 = true) OR (aux2 = true) then
  begin
    miembrosunidad := miembrosunidad+1;

  end;
  Fdatos.Tfamilia.Filtered := false;


  //Ahora el importe y las observaciones

  EimporteIngresar.Text := FloatToStr(Fdatos.Tprestaciondineroprestacion.Value);




  //El tipo de prestacion
  while not Fdatos.Tgasto.Eof do
  begin
    if Fdatos.Tprestaciontipoprestacion.Value = IntToStr(Fdatos.Tgastonumero.Value) then
    begin
      //ShowMessage(Fdatos.Tprestaciontipoprestacion.Value);
      DBGrid1.SetFocus;

      DBGrid1CellClick(DBGrid1.Columns[0]);
      break;
    end
    else
    begin

      //ShowMessage(IntToStr(i));
      Fdatos.Tgasto.Next;
    end;

  end;






end;

end.
