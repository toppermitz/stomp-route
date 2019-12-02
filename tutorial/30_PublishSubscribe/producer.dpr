program producer;

{$APPTYPE CONSOLE}

{$R *.res}

{
  https://www.rabbitmq.com/tutorials/tutorial-three-python.html
}

uses
  System.SysUtils,
  StompClient in '..\..\StompClient.pas';

procedure Main;
var
  lClient: IStompClient;
  lMessage: string;
begin
  lClient := StompUtils.StompClient
               .SetHeartBeat(0, 2000)
               .SetAcceptVersion(TStompAcceptProtocol.Ver_1_1)
               .Connect;
  WriteLn('Sending messages to topic "mytopic"');
  WriteLn('NOTE: Consumers will wait a second for each "." present in the message.');
  WriteLn('      empty message will terminate the program.');
  lMessage := '';
  repeat
    write('Message to send: ');
    Readln(lMessage);
    if not lMessage.IsEmpty then
    begin
      lClient.Send('/topic/mytopic', lMessage);
      // Server can replyes with an ERROR.
      // Server Errors raise exception automatically in the client,
      // so we can just "try" to read something.
      // If you need to understand the type of the error you can
      // read the message normally and check the body.
      lClient.Receive(100);
    end
    else
      WriteLn('Nothing to send... we are not kidding here bro!');
  until lMessage.IsEmpty;
  WriteLn('bye bye');
  lClient.Disconnect;
end;

begin
  try
    Main;
    Readln;
  except
    on E: Exception do
    begin
      WriteLn(E.ClassName, ': ', E.Message);
      Readln;
    end;
  end;

end.
