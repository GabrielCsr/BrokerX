program Maintenance;

uses
  Vcl.Forms,
  View in 'src\View.pas' {frmMaintenance},
  BrokerX.RabbitMQ.Classes in '..\..\src\BrokerX.RabbitMQ.Classes.pas',
  BrokerX.RabbitMQ.Configuration.Classes in '..\..\src\BrokerX.RabbitMQ.Configuration.Classes.pas',
  BrokerX.RabbitMQ.Configuration.Interfaces in '..\..\src\BrokerX.RabbitMQ.Configuration.Interfaces.pas',
  BrokerX.RabbitMQ.Connection.AMQP.Classes in '..\..\src\BrokerX.RabbitMQ.Connection.AMQP.Classes.pas',
  BrokerX.RabbitMQ.Connection.Classes in '..\..\src\BrokerX.RabbitMQ.Connection.Classes.pas',
  BrokerX.RabbitMQ.Connection.Interfaces in '..\..\src\BrokerX.RabbitMQ.Connection.Interfaces.pas',
  BrokerX.RabbitMQ.Connection.Stomp.Classes in '..\..\src\BrokerX.RabbitMQ.Connection.Stomp.Classes.pas',
  BrokerX.RabbitMQ.Consumer.Classes in '..\..\src\BrokerX.RabbitMQ.Consumer.Classes.pas',
  BrokerX.RabbitMQ.Consumer.Factory.Classes in '..\..\src\BrokerX.RabbitMQ.Consumer.Factory.Classes.pas',
  BrokerX.RabbitMQ.Exchange.Classes in '..\..\src\BrokerX.RabbitMQ.Exchange.Classes.pas',
  BrokerX.RabbitMQ.Exchange.Factory.Classes in '..\..\src\BrokerX.RabbitMQ.Exchange.Factory.Classes.pas',
  BrokerX.RabbitMQ.Interfaces in '..\..\src\BrokerX.RabbitMQ.Interfaces.pas',
  BrokerX.RabbitMQ.Producer.Classes in '..\..\src\BrokerX.RabbitMQ.Producer.Classes.pas',
  BrokerX.RabbitMQ.Producer.Factory.Classes in '..\..\src\BrokerX.RabbitMQ.Producer.Factory.Classes.pas',
  BrokerX.RabbitMQ.Queue.Classes in '..\..\src\BrokerX.RabbitMQ.Queue.Classes.pas',
  BrokerX.RabbitMQ.Queue.Factory.Classes in '..\..\src\BrokerX.RabbitMQ.Queue.Factory.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMaintenance, frmMaintenance);
  Application.Run;
end.
