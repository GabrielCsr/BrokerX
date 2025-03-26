unit BrokerX.RabbitMQ.Producer.Classes;

interface

uses
  BrokerX.RabbitMQ.Interfaces, System.Classes, StompClient,
  System.Generics.Collections, BrokerX.RabbitMQ.Connection.Stomp.Classes,
  System.SyncObjs;

type
  TThreadSender = class(TThread)
  private
    FStompClient: IStompClient;
    FQueue: TThreadedQueue<TPair<String, IStompHeaders>>;
    FMessagePath: String;
  protected
    procedure Execute; override;
  public
    constructor Create(const AStompClient: IStompClient; AMessagePath: String);
    destructor Destroy; override;
    procedure Add(AMessage: String; AHeader: TDictionary<String, String> = nil);
  end;

  TProducer = class(TInterfacedObject, IProducer)
  private
    FSender: TThreadSender;
    FMessagePath: String;
    FConnection: IStompConnection;
    procedure TerminateSender(ASender: TObject);
  public
    constructor Create(AMessagePath: String; AConnection: IStompConnection);
    destructor Destroy; override;
    class function New(AMessagePath: String; AConnection: IStompConnection): IProducer;
    function Start: IProducer;
    function Stop: IProducer;
    function SendMesssage(APayload: String; AHeader: TDictionary<String, String> = nil): IProducer;
  end;

implementation

uses
  SysUtils, BrokerX.RabbitMQ.Connection.Classes;

{ TProducer }

constructor TProducer.Create(AMessagePath: String; AConnection: IStompConnection);
begin
  FConnection := AConnection;
  FMessagePath := AMessagePath;
  FSender := nil;
end;

destructor TProducer.Destroy;
begin
  Stop;
  inherited;
end;

class function TProducer.New(AMessagePath: String; AConnection: IStompConnection): IProducer;
begin
  Result := Self.Create(AMessagePath, AConnection);
end;

function TProducer.SendMesssage(APayload: String;
  AHeader: TDictionary<String, String>): IProducer;
begin
  Result := Self;
  if Assigned(FSender) then
    FSender.Add(APayload, AHeader);
end;

function TProducer.Start: IProducer;
begin
  Result := Self;

  if Assigned(FSender) then
    Exit;

  FSender := TThreadSender.Create(FConnection.Connection, FMessagePath);
  FSender.OnTerminate := TerminateSender;
  FSender.Start;
end;

function TProducer.Stop: IProducer;
begin
  Result := Self;

  if Assigned(FSender) then
  begin
    FreeAndNil(FSender);
  end;
end;

procedure TProducer.TerminateSender(ASender: TObject);
var
  LException: TObject;
begin
  if not (ASender is TThread) then
    Exit;

  LException := TThread(ASender).FatalException;
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

{ TThreadSender }

function HeadersFromDict(ADict: TDictionary<String, String>): IStompHeaders;
var
  LKey: String;
begin
  Result := nil;

  if not Assigned(ADict) or (ADict.Count = 0) then
    Exit;

  Result := StompUtils.Headers;
  for LKey in ADict.Keys do
    Result.Add(LKey, ADict.Items[LKey]);
end;

procedure TThreadSender.Add(AMessage: String; AHeader: TDictionary<String, String> = nil);
var
  LDict: TPair<String, IStompHeaders>;
begin
  LDict := TPair<String, IStompHeaders>.Create(AMessage, HeadersFromDict(AHeader));
  FQueue.PushItem(LDict);
end;

constructor TThreadSender.Create(const AStompClient: IStompClient; AMessagePath: String);
begin
  inherited Create(True);
  FStompClient := AStompClient;
  FQueue := TThreadedQueue<TPair<String, IStompHeaders>>.Create(10, 2000, 1000);
  FreeOnTerminate := False;
  FMessagePath := AMessagePath;
end;

destructor TThreadSender.Destroy;
begin
  Terminate;
  if not Suspended then
    WaitFor;

  FreeAndNil(FQueue);
  inherited;
end;

procedure TThreadSender.Execute;
var
  LPair: TPair<String, IStompHeaders>;
  LQueueStatus: TWaitResult;
begin
  while not Terminated do
  begin
    LQueueStatus := FQueue.PopItem(LPair);

    if LQueueStatus = wrSignaled then
    begin
      try
        FStompClient.Send(FMessagePath, LPair.Key, LPair.Value);
      except
        on E: Exception do
          raise Exception.Create('Error sending message: ' + E.Message);
      end;
    end
    else
    begin
      Sleep(50);
    end;
  end;
end;

end.

