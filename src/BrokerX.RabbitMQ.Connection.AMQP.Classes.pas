unit BrokerX.RabbitMQ.Connection.AMQP.Classes;

interface

uses
  AMQP.Connection, AMQP.Interfaces;

type
  IAMQPConnection = interface
    function Host(AValue: String):     IAMQPConnection;
    function Port(AValue: Integer):    IAMQPConnection;
    function User(AValue: String):     IAMQPConnection;
    function Password(AValue: String): IAMQPConnection;
    procedure Connect;
    procedure Disconnect;
    function Channel: IAMQPChannel;
    function Connected: Boolean;
  end;

  TAMQPConnection = class(TInterfacedObject, IAMQPConnection)
  private
    FConnection: AMQP.Connection.TAMQPConnection;
    FChannel:    IAMQPChannel;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IAMQPConnection;
    function Host(AValue: String):     IAMQPConnection;
    function Port(AValue: Integer):    IAMQPConnection;
    function User(AValue: String):     IAMQPConnection;
    function Password(AValue: String): IAMQPConnection;
    procedure Connect;
    procedure Disconnect;
    function Channel: IAMQPChannel;
    function Connected: Boolean;
  end;

implementation

{ TAMQPConnection }

function TAMQPConnection.Channel: IAMQPChannel;
begin
  if not (Assigned(FChannel)) or (FChannel.State = cClosed) then
    FChannel := FConnection.OpenChannel;

  Result := FChannel;
end;

procedure TAMQPConnection.Connect;
begin
  if FConnection.IsOpen then
    Exit;

  FConnection.Connect;
end;

function TAMQPConnection.Connected: Boolean;
begin
  Result := FConnection.IsOpen;
end;

constructor TAMQPConnection.Create;
begin
  FConnection := AMQP.Connection.TAMQPConnection.Create;
  FConnection.HeartbeatSecs := 120;
  FConnection.Timeout := 5000;
end;

destructor TAMQPConnection.Destroy;
begin
  if FConnection.isOpen then
    FConnection.Disconnect;
  FConnection.Free;
  inherited;
end;

procedure TAMQPConnection.Disconnect;
begin
  if not FConnection.IsOpen then
    Exit;

  FConnection.Disconnect;
end;

function TAMQPConnection.Host(AValue: String): IAMQPConnection;
begin
  Result := Self;
  FConnection.Host := AValue;
end;

class function TAMQPConnection.New: IAMQPConnection;
begin
  Result := Self.Create;
end;

function TAMQPConnection.Password(AValue: String): IAMQPConnection;
begin
  Result := Self;
  FConnection.Password := AValue;
end;

function TAMQPConnection.Port(AValue: Integer): IAMQPConnection;
begin
  Result := Self;
  FConnection.Port := AValue;
end;

function TAMQPConnection.User(AValue: String): IAMQPConnection;
begin
  Result := Self;
  FConnection.Username := AValue;
end;

end.
