unit Nueva_ayuda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.DBCtrls, Data.Win.ADODB,
  Data.FMTBcd, Data.SqlExpr;

type
  TFnueva_ayuda = class(TForm)
    Lexpediente: TLabel;
    Panel: TPanel;
    L1: TLabel;
    Limporte: TLabel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Mdescripcion: TMemo;
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
    Button1: TButton;
    EimporteIngresar: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    DateSolicitud: TDateTimePicker;
    ChAdo: TCheckBox;
    ChNumeroAdo: TCheckBox;
    DateAdo: TDateTimePicker;
    ENumeroAdo: TEdit;
    ENumeroRegistro: TEdit;
    Lmaximolabel: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Bcancelar: TButton;
    Label17: TLabel;
    DatePrestacion: TDateTimePicker;
    ChPrestacion: TCheckBox;
    DBMemo1: TDBMemo;
    procedure FormActivate(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure ChAdoClick(Sender: TObject);
    procedure ChNumeroAdoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BcancelarClick(Sender: TObject);
    procedure ChPrestacionClick(Sender: TObject);
    
  private
    { Private declarations }
    miembrosunidad:Integer;
  public
    { Public declarations }
  end;

var
  Fnueva_ayuda: TFnueva_ayuda;

implementation
uses datos;

{$R *.dfm}

procedure TFnueva_ayuda.BcancelarClick(Sender: TObject);
begin
  Fdatos.Tprestacion.Cancel;
  Fdatos.Tprestacion.Close;
  Fdatos.Tfamilia.Close;
  Fdatos.Tfamilia.Open();
 ModalResult := mrCancel;
end;

procedure TFnueva_ayuda.Button1Click(Sender: TObject);
  var
  flag,sobresuma : boolean;
  importe,suma,maximo : double;
begin
  sobresuma := true;
  flag :=true;
  suma := 0;
  maximo := StrToFloat(Lmaximolabel.Caption) ;
 //Hacer el post de todo

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

  //suma :=Query.SQL:= 'select sum(dineroprestacion) AS total from prestacion where tipoprestacion ='+IntToStr(Fdatos.Tgastonumero.value);

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
    Fdatos.Tprestacion.Append;

    //Aqui viene lo fuerte
    Fdatos.Tprestacionexpedientefamilia.Value := Lexpediente.Caption;
    //Fdatos.Tprestacionexpedientefamilia.Value := Lexpediente.Caption;   //Expediente
    Fdatos.Tprestaciontipoprestacion.Value := IntToStr(Fdatos.Tgastonumero.Value);  //tipo de prestacion
    Fdatos.Tprestaciondineroprestacion.Value := importe;  //importe

    Fdatos.Tprestacionfechasolicitud.Value := DateToStr(DateSolicitud.Date);  //Fecha de solicitud


    if ChPrestacion.Checked = true then
    begin
      Fdatos.Tprestacionfechaprestacion.Value := DateToStr(DatePrestacion.Date);
    end;

    if ENumeroRegistro.Text = '' then
    begin

    end
    else
    begin
       Fdatos.Tprestacionnumeroregistro.Value := ENumeroRegistro.Text;  //Numero de registro
    end;

    if ChAdo.Checked = true then
    begin
      Fdatos.Tprestacionfechaado.Value := DateToStr(DateAdo.Date);   //Fecha ADO
    end;

    if ChNumeroAdo.Checked = true then
    begin
      Fdatos.Tprestacionnumeroado.Value := StrToInt(ENumeroAdo.Text);   //Numero ADO
    end;
    
    
    
    Fdatos.Tprestacion.Post;
    Fdatos.Tprestacion.Close;
    Fdatos.Tfamilia.Close;
    Fdatos.Tfamilia.Open();
    ModalResult := mrOk;

  end;




  //Se usa StrToDate y datetostr
  //Fdatos.Tprestacion.Close;
end;

procedure TFnueva_ayuda.ChAdoClick(Sender: TObject);
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

procedure TFnueva_ayuda.ChNumeroAdoClick(Sender: TObject);
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

procedure TFnueva_ayuda.ChPrestacionClick(Sender: TObject);
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

procedure TFnueva_ayuda.DBGrid1CellClick(Column: TColumn);
begin
  Mdescripcion.Lines.Clear;
       //Buscar la imformacion
       Mdescripcion.Lines.Add(Fdatos.Tgastodescripcion.Value);

       if Fdatos.Tgastomaximo.Value = 0 then
       begin
        //  AQui buscar en la tabla detalle de los gastos
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
            if Fdatos.Tgasto_detallepersona.Value >= 6 then
            begin
                Lpersona6.Caption := (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
          end;

          if miembrosunidad = Fdatos.Tgasto_detallepersona.Value then
            begin
               Lmaximolabel.Caption:= (Fdatos.Tgasto_detallemaximo.Value).ToString;
            end;
          if miembrosunidad >= 6 then
          begin
            Lmaximolabel.Caption := Lpersona6.Caption;
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

procedure TFnueva_ayuda.FormActivate(Sender: TObject);
var
  aux1,aux2 : boolean;

begin

  Fdatos.Tfamilia.Open();
  EimporteIngresar.Text:='';
  ENumeroAdo.Text :='';
  ENumeroRegistro.Text := '';
  



  aux1 := false;
  aux2 := false;


  miembrosunidad := 0;

  Fdatos.Tgasto.Open();
  Mdescripcion.Lines.Clear;
  Ppersona.Visible:=false;


  DBMemo1.ReadOnly:= true;


  //Poner numero de expediente
  Lexpediente.Caption := Fdatos.Tfamiliaexpediente.Value;
  DateSolicitud.Date := Now;

  //Filtrar
  Fdatos.Tfamilia.Filter := 'expediente='+QuotedStr(Lexpediente.Caption);
  Fdatos.Tfamilia.Filtered := true;

  miembrosunidad := Fdatos.Tfamiliamiembroconvivencia.Value;

  //Poner los chec a false
  ChAdo.Checked := False;
  ChNumeroAdo.Checked := False;
  ChPrestacion.Checked := False;


  DateAdo.Enabled:=false;
  ENumeroAdo.Enabled:=False;
  DatePrestacion.Enabled := False;

  //Abrir la tabla para insertar
  Fdatos.Tprestacion.Open();
  Fdatos.Tprestacion.Append;

  //EimporteIngresar.Text := IntToStr(miembrosunidad);
  //


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
  //ENumeroRegistro.Text := IntToStr(miembrosunidad);




end;

procedure TFnueva_ayuda.FormDestroy(Sender: TObject);
begin
  Fdatos.Tfamilia.Filtered := false;
end;

end.
