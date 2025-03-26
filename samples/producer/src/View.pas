unit View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btnStop1: TButton;
    btnStart1: TButton;
    Memo1: TMemo;
    edtQueue: TEdit;
    Memo2: TMemo;
    btnStop2: TButton;
    btnStart2: TButton;
    edtRoutingKey: TEdit;
    btnSend1: TButton;
    edtExchange: TEdit;
    btnSend2: TButton;
    procedure btnStart1Click(Sender: TObject);
    procedure btnStop1Click(Sender: TObject);
    procedure btnSend1Click(Sender: TObject);
    procedure btnStart2Click(Sender: TObject);
    procedure btnStop2Click(Sender: TObject);
    procedure btnSend2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  BrokerX.RabbitMQ.Classes, System.Generics.Collections;

{$R *.dfm}

procedure TForm1.btnSend1Click(Sender: TObject);
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter the queue name!');
    Exit;
  end;

  if Memo1.Text = '' then
  begin
    ShowMessage('Enter a message');
    Exit;
  end;

  TRabbitMQ.New
    .Queue(edtQueue.Text)
      .Producer
        .SendMesssage(Memo1.Text);

  Memo1.Lines.Clear;
end;

procedure TForm1.btnStart1Click(Sender: TObject);
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter the queue name!');
    Exit;
  end;

  TRabbitMQ.New
    .Queue(edtQueue.Text)
      .Producer
        .Start;
end;

procedure TForm1.btnStart2Click(Sender: TObject);
begin
  if edtExchange.Text = '' then
  begin
    ShowMessage('Enter the exchange name!');
    Exit;
  end;

  if edtRoutingKey.Text = '' then
  begin
    ShowMessage('Enter the routingkey!');
    Exit;
  end;

  TRabbitMQ.New
    .Exchange(edtExchange.Text)
      .Producer(edtRoutingKey.Text)
        .Start;
end;

procedure TForm1.btnStop1Click(Sender: TObject);
begin
  if edtQueue.Text = '' then
  begin
    ShowMessage('Enter the queue name!');
    Exit;
  end;

  TRabbitMQ.New
    .Queue(edtQueue.Text)
      .Producer
        .Stop;
end;


procedure TForm1.btnStop2Click(Sender: TObject);
begin
  if edtExchange.Text = '' then
  begin
    ShowMessage('Enter the exchange name!');
    Exit;
  end;

  if edtRoutingKey.Text = '' then
  begin
    ShowMessage('Enter the routingkey!');
    Exit;
  end;

  TRabbitMQ.New
    .Exchange(edtExchange.Text)
      .Producer(edtRoutingKey.Text)
        .Stop;
end;

procedure TForm1.btnSend2Click(Sender: TObject);
begin
    if edtExchange.Text = '' then
  begin
    ShowMessage('Enter the exchange name!');
    Exit;
  end;

  if edtRoutingKey.Text = '' then
  begin
    ShowMessage('Enter the routingkey!');
    Exit;
  end;

  if Memo2.Text = '' then
  begin
    ShowMessage('Enter a message to send!');
    Exit;
  end;

  TRabbitMQ.New
    .Exchange(edtExchange.Text)
      .Producer(edtRoutingKey.Text)
        .SendMesssage(Memo2.Text);

  Memo2.Lines.Clear;
end;

end.
