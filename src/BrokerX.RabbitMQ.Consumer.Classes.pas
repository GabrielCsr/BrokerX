unit BrokerX.RabbitMQ.Consumer.Classes;

interface

uses
  BrokerX.RabbitMQ.Interfaces, System.Threading, StompClient, Classes,
  BrokerX.RabbitMQ.Connection.Stomp.Classes, System.SyncObjs
  {$IFDEF FMX}
  , FMX.Forms
  {$ELSE}
    {$IFDEF VCL}
    , Vcl.Forms
    {$ENDIF}
  {$ENDIF};

type
  TReceiveNotify = procedure(const AFrame: IStompFrame) of object;

  TConsume = class;

  TThreadReceiver = class(TThread)
  private
    FStompClient: IStompClient;
    FOnReceive: TReceiveNotify;
    FStopEvent: TEvent;
    FLock: TObject;
  protected
    procedure Execute; override;
  public
    constructor Create(const AStompClient: IStompClient);
    destructor Destroy; override;
    procedure OnReceive(ANotifyReceive: TReceiveNotify);
    procedure StopThread;
  end;

  TConsume = class(TInterfacedObject, IConsumer)
  private
    FOnReceive: TReceiveMessage;
    FReceiver: TThreadReceiver;
    FConnection: IStompConnection;
    procedure ThreadTerminate(Sender: TObject);
    procedure Receive(const AStompFrame: IStompFrame);
  public
    constructor Create(AConnection: IStompConnection);
    destructor Destroy; override;
    class function New(AConnection: IStompConnection): IConsumer;
    function Start: IConsumer;
    function Stop: IConsumer;
    function OnReceiveMessage(AProcReceiveMessage: TReceiveMessage): IConsumer;
  end;

implementation

uses
  BrokerX.RabbitMQ.Connection.Classes, SysUtils, System.Generics.Collections;

{ TConsume }

constructor TConsume.Create(AConnection: IStompConnection);
begin
  FConnection := AConnection;
  FReceiver := nil;
end;

destructor TConsume.Destroy;
begin
  if Assigned(FReceiver) then
  begin
    FReceiver.StopThread;
    FReceiver.WaitFor;
    FreeAndNil(FReceiver);
  end;
  inherited;
end;

class function TConsume.New(AConnection: IStompConnection): IConsumer;
begin
  Result := Self.Create(AConnection);
end;

function TConsume.OnReceiveMessage(AProcReceiveMessage: TReceiveMessage): IConsumer;
begin
  Result := Self;
  FOnReceive := AProcReceiveMessage;
end;

procedure TConsume.Receive(const AStompFrame: IStompFrame);
var
  LHeader: TDictionary<String, String>;
  I: Integer;
begin
  LHeader := nil;

  if AStompFrame.Headers.Count > 0 then
  begin
    LHeader := TDictionary<String, String>.Create;
    for I := 0 to Pred(AStompFrame.Headers.Count) do
      LHeader.Add(AStompFrame.Headers.GetAt(I).Key,
                  AStompFrame.Headers.GetAt(I).Value);
  end;

  FOnReceive(AStompFrame.Body, LHeader);
end;

function TConsume.Start: IConsumer;
begin
  Result := Self;

  if Assigned(FReceiver) then
    Exit;

  FReceiver := TThreadReceiver.Create(FConnection.Connection);
  FReceiver.OnReceive(Receive);
  FReceiver.OnTerminate := ThreadTerminate;
  FReceiver.Start;
end;

function TConsume.Stop: IConsumer;
begin
  Result := Self;

  if Assigned(FReceiver) then
  begin
    FReceiver.StopThread;
    FReceiver.WaitFor;
    FreeAndNil(FReceiver);
  end;
end;

procedure TConsume.ThreadTerminate(Sender: TObject);
var
  LException: TObject;
begin
  if not (Sender is TThread) then
    Exit;

  LException := TThread(Sender).FatalException;
  if Assigned(LException) then
  begin
    if LException is Exception then
      {$IF DEFINED(FMX) OR DEFINED(VCL)}
      Application.ShowException(Exception(LException));
      {$ELSE}
      raise Exception(LException);
      {$ENDIF}
  end;
end;

{ TThreadReceiver }

constructor TThreadReceiver.Create(const AStompClient: IStompClient);
begin
  inherited Create(True);
  FStompClient := AStompClient;
  FStopEvent := TEvent.Create;
  FLock := TObject.Create;
end;

destructor TThreadReceiver.Destroy;
begin
  FStopEvent.Free;
  FreeAndNil(FLock);
  inherited;
end;

procedure TThreadReceiver.Execute;
var
  LFrame: IStompFrame;
  LOnReceive: TReceiveNotify;
begin
  while not Terminated do
  begin
    if (FStopEvent.WaitFor(1000) = wrSignaled) then
      Break;

    if Assigned(FStompClient) and FStompClient.Receive(LFrame, 1000) then
    begin
      TMonitor.Enter(FLock);
      try
        LOnReceive := FOnReceive;
      finally
        TMonitor.Exit(FLock);
      end;

      if Assigned(LOnReceive) then
        TThread.Queue(nil,
          procedure
          begin
            LOnReceive(LFrame);
          end);
    end;
  end;
end;

procedure TThreadReceiver.OnReceive(ANotifyReceive: TReceiveNotify);
begin
  TMonitor.Enter(FLock);
  try
    FOnReceive := ANotifyReceive;
  finally
    TMonitor.Exit(FLock);
  end;
end;

procedure TThreadReceiver.StopThread;
begin
  Terminate;
  FStopEvent.SetEvent;
end;

end.
