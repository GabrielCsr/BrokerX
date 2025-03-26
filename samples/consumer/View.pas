unit View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Generics.Collections;

type
  TProcReceive = procedure(APayload: String; AHeader: TDictionary<String, String>) of object;

  TForm1 = class(TForm)
    Memo1: TMemo;
    btnStart1: TButton;
    btnStop1: TButton;
    GroupBox1: TGroupBox;
    edtQueue: TEdit;
    Memo2: TMemo;
    btnStop2: TButton;
    btnStart2: TButton;
    edtQueue2: TEdit;
    Memo3: TMemo;
    btnStop3: TButton;
    btnStart3: TButton;
    edtQueue3: TEdit;
    Memo4: TMemo;
    btnStop4: TButton;
    btnStart4: TButton;
    edtQueue4: TEdit;
    Label1: TLabel;
    procedure btnStart1Click(Sender: TObject);
    procedure btnStop1Click(Sender: TObject);
  private
    { Private declarations }
    procedure OnReceiveMaster(AMemo: TMemo; APayload: String; AHeader: TDictionary<String, String>);
    procedure OnReceive(APayload: String; AHeader: TDictionary<String, String>);
    procedure OnReceive2(APayload: String; AHeader: TDictionary<String, String>);
    procedure OnReceive3(APayload: String; AHeader: TDictionary<String, String>);
    procedure OnReceive4(APayload: String; AHeader: TDictionary<String, String>);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  BrokerX.RabbitMQ.Classes;

{$R *.dfm}

procedure TForm1.btnStart1Click(Sender: TObject);
var
  LQueueName,
  LButtonName: String;
  LProc: TProcReceive;
begin
  LProc := nil;
  LButtonName := TEdit(Sender).Name;

  if LButtonName.Equals('btnStart1') then
  begin
    LQueueName := edtQueue.Text;
    LProc := Self.OnReceive;
  end
  else if LButtonName.Equals('btnStart2') then
  begin
    LQueueName := edtQueue2.Text;
    LProc := Self.OnReceive2;
  end
  else if LButtonName.Equals('btnStart3') then
  begin
    LQueueName := edtQueue3.Text;
    LProc := Self.OnReceive3;
  end
  else if LButtonName.Equals('btnStart4') then
  begin
    LQueueName := edtQueue4.Text;
    LProc := Self.OnReceive4;
  end;


  if LQueueName.Equals(EmptyStr) then
  begin
    ShowMessage('Queue dont informed!');
    exit;
  end;

  TRabbitMQ.New
    .Queue(LQueueName)
      .Subscribe(True)
      .Consumer
        .OnReceiveMessage(LProc)
        .Start;
end;

procedure TForm1.btnStop1Click(Sender: TObject);
var
  LQueueName,
  LButtonName: String;
begin
  LButtonName := TEdit(Sender).Name;

  if LButtonName.Equals('btnStop1') then
    LQueueName := edtQueue.Text
  else if LButtonName.Equals('btnStop2') then
    LQueueName := edtQueue2.Text
  else if LButtonName.Equals('btnStop3') then
    LQueueName := edtQueue3.Text
  else if LButtonName.Equals('btnStop4') then
    LQueueName := edtQueue4.Text;


  if LQueueName.Equals(EmptyStr) then
  begin
    ShowMessage('Queue dont informed!');
    exit;
  end;

  TRabbitMQ.New
    .Queue(LQueueName)
      .UnSubscribe;
end;

//procedure TForm1.Button4Click(Sender: TObject);
//begin
//  TRabbitMQ.New
//    .Exchange(edtExchange.Text)
//      .Producer(edtRoutingKey.Text)
//        .Start;
//end;
//
//procedure TForm1.Button5Click(Sender: TObject);
//begin
//  if Memo2.Text = '' then
//  begin
//    ShowMessage('Enter the message to send it');
//    Exit;
//  end;
//
//  TRabbitMQ.New
//    .Exchange(edtExchange.Text)
//      .Producer(edtRoutingKey.Text)
//        .SendMesssage(Memo2.Text);
//
//  Memo2.Lines.Clear;
//end;

procedure TForm1.OnReceive(APayload: String; AHeader: TDictionary<String, String>);
begin
  OnReceiveMaster(Memo1, APayload, AHeader);
end;

procedure TForm1.OnReceive2(APayload: String; AHeader: TDictionary<String, String>);
begin
  OnReceiveMaster(Memo2, APayload, AHeader);
end;

procedure TForm1.OnReceive3(APayload: String; AHeader: TDictionary<String, String>);
begin
  OnReceiveMaster(Memo3, APayload, AHeader);
end;

procedure TForm1.OnReceive4(APayload: String; AHeader: TDictionary<String, String>);
begin
  OnReceiveMaster(Memo4, APayload, AHeader);
end;

procedure TForm1.OnReceiveMaster(AMemo: TMemo; APayload: String; AHeader: TDictionary<String, String>);
var
  LKey: String;
  LShowHeaders: Boolean;
begin
  LShowHeaders := False;

  try
    AMemo.Lines.Add('--------------');
    AMemo.Lines.Add('');

    if Assigned(AHeader) and LShowHeaders then
    begin
      for LKey in AHeader.Keys do
      begin
        AMemo.Lines.Add(LKey + ' = ' + AHeader.Items[LKey]);
        AMemo.Lines.Add('***************');
      end;
    end;
    AMemo.Lines.Add(APayload);

    AMemo.Lines.Add('');
    AMemo.Lines.Add('---------------');
  finally
    FreeAndNil(AHeader);
  end;
end;

end.
