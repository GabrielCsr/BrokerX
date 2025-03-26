unit BrokerX.RabbitMQ.Connection.Interfaces;

interface

uses
  BrokerX.RabbitMQ.Connection.Stomp.Classes,
  BrokerX.RabbitMQ.Connection.AMQP.Classes;

type
  IConnection = interface
    function STOMP: IStompConnection;
    function AMQP:  IAMQPConnection;
  end;

implementation

end.
