unit BrokerX.RabbitMQ.Connection.Classes;

interface

uses
  BrokerX.RabbitMQ.Connection.Interfaces,
  BrokerX.RabbitMQ.Connection.AMQP.Classes,
  BrokerX.RabbitMQ.Connection.Stomp.Classes;

type
  TConnection = class
  private
    class var FInstanceAMQP: IAMQPConnection;
    class var FInstanceSTOMP: IStompConnection;
  public
    class function InstanceAMQP: IAMQPConnection;
    class function InstanceSTOMP: IStompConnection;
    class function NewStompConnected: IStompConnection;
  end;

implementation

uses
  SysUtils, BrokerX.RabbitMQ.Configuration.Classes,
  BrokerX.RabbitMQ.Configuration.Interfaces;

{ TConnection }

class function TConnection.InstanceAMQP: IAMQPConnection;
begin
  try
    if not Assigned(FInstanceAMQP) then
      FInstanceAMQP := TAMQPConnection.New;

    Result := FInstanceAMQP;
  except
    On E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

class function TConnection.InstanceSTOMP: IStompConnection;
begin
  try
    if not Assigned(FInstanceSTOMP) then
      FInstanceSTOMP := TStompConnection.New;

    Result := FInstanceSTOMP;
  except
    On E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

class function TConnection.NewStompConnected: IStompConnection;
var
  LConfig: IConfiguration;
begin
  try
    LConfig := TConfiguration.New(ctSTOMP);

    Result := TStompConnection
              .New
              .Host(LConfig.Host)
              .Port(LConfig.Port)
              .User(LConfig.User)
              .Password(LConfig.Password)
              .Connect;
  except
    On E: Exception do
      raise Exception.Create('problems connecting to STOMP. ' +
                             'Check the parameters in the configMQ.properties file. ' + E.Message);
  end;
end;

end.
