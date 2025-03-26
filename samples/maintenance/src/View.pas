unit View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmMaintenance = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    edtQueue: TEdit;
    btnDeclareQueue: TButton;
    btnDeleteQueue: TButton;
    btnBindQueue: TButton;
    edtExchange: TEdit;
    btnDeclareExchange: TButton;
    btnDeleteExchange: TButton;
    btnBindExchange: TButton;
    procedure btnDeclareQueueClick(Sender: TObject);
    procedure btnDeleteQueueClick(Sender: TObject);
    procedure btnBindQueueClick(Sender: TObject);
    procedure btnDeclareExchangeClick(Sender: TObject);
    procedure btnDeleteExchangeClick(Sender: TObject);
    procedure btnBindExchangeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMaintenance: TfrmMaintenance;

implementation

uses
  BrokerX.RabbitMQ.Classes;

{$R *.dfm}

procedure TfrmMaintenance.btnBindExchangeClick(Sender: TObject);
var
  LRoutingKey: String;
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter queue name!');
    Exit;
  end;

  if edtExchange.Text = '' then
  begin
    ShowMessage('Enter exchange name!');
    Exit;
  end;

  LRoutingKey := InputBox('Routing Key Input', 'Please enter the routing key:', '');

  if LRoutingKey.IsEmpty then
  begin
    ShowMessage('RoutingKey not specified. Operation Canceled');
    Exit;
  end;

  TRabbitMQ.New.Exchange(edtExchange.Text).Bind(edtQueue.Text, LRoutingKey);
end;

procedure TfrmMaintenance.btnBindQueueClick(Sender: TObject);
var
  LRoutingKey: String;
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter queue name!');
    Exit;
  end;

  if edtExchange.Text = '' then
  begin
    ShowMessage('Enter exchange name!');
    Exit;
  end;

  LRoutingKey := InputBox('Routing Key Input', 'Please enter the routing key:', '');

  if LRoutingKey.IsEmpty then
  begin
    ShowMessage('RoutingKey not specified. Operation Canceled');
    Exit;
  end;

  TRabbitMQ.New.Queue(edtQueue.Text).Bind(edtExchange.Text, LRoutingKey);
end;

procedure TfrmMaintenance.btnDeclareExchangeClick(Sender: TObject);
begin
  if edtExchange.Text = '' then
  begin
    ShowMessage('Enter exchange name!');
    Exit;
  end;

  TRabbitMQ.New.Exchange(edtExchange.Text).Declare;
end;

procedure TfrmMaintenance.btnDeclareQueueClick(Sender: TObject);
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter queue name!');
    Exit;
  end;

  TRabbitMQ.New.Queue(edtQueue.Text).Declare;
end;

procedure TfrmMaintenance.btnDeleteExchangeClick(Sender: TObject);
begin
  if edtExchange.Text = '' then
  begin
    ShowMessage('Enter exchange name!');
    Exit;
  end;

  TRabbitMQ.New.Exchange(edtExchange.Text).Delete(False, False);
end;

procedure TfrmMaintenance.btnDeleteQueueClick(Sender: TObject);
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter queue name!');
    Exit;
  end;

  TRabbitMQ.New.Queue(edtQueue.Text).Delete(False, False);
end;

end.
