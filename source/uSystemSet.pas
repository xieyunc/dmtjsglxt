unit uSystemSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,TypInfo,
  Dialogs, DB, ADODB, DBGridEhGrouping, GridsEh, DBGridEh, ExtCtrls, StdCtrls,StrUtils,
  Mask, DBCtrls, CheckLst, DBCtrlsEh, Buttons, ComCtrls, OoMisc, AdPort,Registry;

type
  TSystemSet = class(TForm)
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    pgc1: TPageControl;
    ts1: TTabSheet;
    lbl_11: TLabel;
    lbl_12: TLabel;
    lbl_2: TLabel;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    edt_1: TDBNumberEditEh;
    DBGridEh1: TDBGridEh;
    ts2: TTabSheet;
    lbl1: TLabel;
    lbl2: TLabel;
    AdoQuery3: TADOQuery;
    DataSource3: TDataSource;
    lbl3: TLabel;
    dbedt1: TDBEdit;
    dbedt2: TDBEdit;
    dbedt3: TDBEdit;
    lbl4: TLabel;
    cbb_Port: TDBComboBoxEh;
    lbl5: TLabel;
    dbedt5: TDBComboBoxEh;
    lbl6: TLabel;
    dbedt6: TDBComboBoxEh;
    lbl7: TLabel;
    dbedt7: TDBComboBoxEh;
    lbl8: TLabel;
    dbedt8: TDBComboBoxEh;
    pnl1: TPanel;
    btn_Save: TBitBtn;
    btn_Exit: TBitBtn;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    lbl_Dir: TLabel;
    lbl_13: TLabel;
    dbedt4: TDBEdit;
    dbedt_Exe: TDBEdit;
    btn3: TSpeedButton;
    btn_Open2: TSpeedButton;
    btn_Close2: TSpeedButton;
    dlgOpen1: TOpenDialog;
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_ExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure cbb_PortDropDown(Sender: TObject);
    procedure cbb_PortClick(Sender: TObject);
    procedure btn_Open2Click(Sender: TObject);
    procedure btn_Close2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitCOMPortList;
  public
    { Public declarations }
  end;

var
  SystemSet: TSystemSet;

implementation
uses udm,frxpngimage;
{$R *.dfm}

procedure TSystemSet.btn1Click(Sender: TObject);
begin
  btn_Save.Click;
  dm.OpenDevice1(True);
end;

procedure TSystemSet.btn2Click(Sender: TObject);
begin
  btn_Save.Click;
  dm.CloseDevice1(True);
end;

procedure TSystemSet.btn3Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    AdoQuery3.Edit;
    AdoQuery3.FieldByName('控制程序').AsString := dlgOpen1.FileName;
    //dbedt_Exe.Text := dlgOpen1.FileName;
  end;
end;

procedure TSystemSet.btn_Close2Click(Sender: TObject);
begin
  btn_Save.Click;
  dm.CloseDevice2(True);
end;

procedure TSystemSet.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TSystemSet.btn_Open2Click(Sender: TObject);
begin
  btn_Save.Click;
  dm.OpenDevice2(True);
end;

procedure TSystemSet.btn_SaveClick(Sender: TObject);
begin
  if ADOQuery1.State in [dsEdit,dsInsert] then
    ADOQuery1.Post;
  if ADOQuery2.State in [dsEdit,dsInsert] then
    ADOQuery2.Post;
  if ADOQuery3.State in [dsEdit,dsInsert] then
    AdoQuery3.Post;
end;

procedure TSystemSet.cbb_PortClick(Sender: TObject);
begin
  if not (AdoQuery3.State in [dsEdit,dsInsert]) then
    AdoQuery3.Edit;
end;

procedure TSystemSet.cbb_PortDropDown(Sender: TObject);
begin
  InitCOMPortList;
end;

procedure TSystemSet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btn_Save.OnClick(Self);
  Action := caFree;
end;

procedure TSystemSet.FormCreate(Sender: TObject);
begin
  pgc1.ActivePageIndex := 0;
  with ADOQuery1 do
  begin
    Connection := dm.conn_DB;
    Close;
    SQL.Text := 'select * from 上课日期表';
    Open;
  end;
  with ADOQuery2 do
  begin
    Connection := dm.conn_DB;
    Close;
    SQL.Text := 'select * from 上课时间表';
    Open;
  end;
  with ADOQuery3 do
  begin
    Connection := dm.conn_DB;
    Close;
    SQL.Text := 'select * from 投影控制设置表';
    Open;
  end;
end;

procedure TSystemSet.InitCOMPortList;
var
  reg : TRegistry;
  sl: TStrings;
  s:string;
  i: integer;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('hardware\devicemap\serialcomm', false);
    sl := TStringList.Create;
    cbb_Port.Items.Clear;
    cbb_Port.KeyItems.Clear;
    try
      reg.GetValueNames(sl);
      for i := 0 to sl.Count -1 do
        s := reg.ReadString(sl.Strings[i]);
        cbb_Port.Items.Add(s);
        //cbb_Port.KeyItems.Add(RightStr(s,1));
    finally
      sl.Free;
    end;
  finally
    reg.CloseKey;
    reg.free;
  end;
end;

end.
