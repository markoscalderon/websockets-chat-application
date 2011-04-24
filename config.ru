require 'main'
EventMachine.run{
  Cramp::Websocket.backend = :thin
  Rack::Handler::Thin.run ChatApp, :Port => 3000
  Rack::Handler::Thin.run ChatWebsocket, :Port => 3001
}