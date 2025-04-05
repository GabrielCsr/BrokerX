unit BrokerX.RabbitMQ.Connection.Stomp.Classes;

interface

uses
  StompClient;

type
  IStompConnection = interface
    function Host(AValue: String):     IStompConnection;
    function Port(AValue: Integer):    IStompConnection;
    function User(AValue: String):     IStompConnection;
    function Password(AValue: String): IStompConnection;
    function Connect: IStompConnection;
    function Disconnect: IStompConnection;
    function Connection: IStompClient;
    function Prototype: IStompConnection;
  end;

  TStompConnection = class(TInterfacedObject, IStompConnection)
  private
    FStompClient: IStompClient;
    FHost,
    FUser,
    FPassword: String;
    FPort: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IStompConnection;
    function Host(AValue: String):     IStompConnection;
    function Port(AValue: Integer):    IStompConnection;
    function User(AValue: String):     IStompConnection;
    function Password(AValue: String): IStompConnection;
    function Connect: IStompConnection;
    function Disconnect: IStompConnection;
    function Connection: IStompClient;
    function Prototype: IStompConnection;
  end;

implementation

{ TStompConnection }

function TStompConnection.Connect: IStompConnection;
begin
  Result := Self;

  if FStompClient.Connected then
    Exit;
  FStompClient.Connect;
end;

function TStompConnection.Connection: IStompClient;
begin
  if not FStompClient.Connected then
    FStompClient.Connect;

  Result := FStompClient;
end;

constructor TStompConnection.Create;
begin
  FStompClient := StompUtils.StompClient;
end;

destructor TStompConnection.Destroy;
begin

  inherited;
end;

function TStompConnection.Disconnect: IStompConnection;
begin
  Result := Self;

  if not FStompClient.Connected then
    Exit;

  FStompClient.Disconnect;
end;

function TStompConnection.Host(AValue: String): IStompConnection;
begin
  Result := Self;
  FHost := AValue;
  FStompClient.SetHost(FHost);
end;

class function TStompConnection.New: IStompConnection;
begin
  Result := Self.Create;
end;

function TStompConnection.Password(AValue: String): IStompConnection;
begin
  Result := Self;
  FPassword := AValue;
  FStompClient.SetPassword(FPassword);
end;

function TStompConnection.Port(AValue: Integer): IStompConnection;
begin
  Result := Self;
  FPort := AValue;
  FStompClient.SetPort(FPort);
end;

function TStompConnection.Prototype: IStompConnection;
begin
  Result := TStompConnection.New
              .Host(FHost)
              .Port(FPort)
              .User(FUser)
              .Password(FPassword)
              .Connect;
end;

function TStompConnection.User(AValue: String): IStompConnection;
begin
  Result := Self;
  FUser := AValue;
  FStompClient.SetUserName(FUser);
end;

end.
