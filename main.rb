require 'rubygems'
#require 'sinatra'
require 'sinatra/base'
require 'haml'
require 'cramp'
require 'thin'
require 'yajl'
require 'redis'

class ChatWebsocket < Cramp::Websocket
  #@@users = Set.new
  
  on_start :connected
  on_finish :disconnected
  on_data :handle_data
  
  def connected
    #@@users << self
    @publisher = Redis.new
    @subscriber = Redis.new
    Thread.new {
      @subscriber.subscribe("chatapplication") do |on|
        on.subscribe do |channel, subscriptions|
          puts "Subscribed"
        end
        on.message do |channel, message|
          render message
        end
        on.unsubscribe do |channel, subscriptions|
          puts "Unsubscribed"
        end
      end
    }
  end
  
  def disconnected
    #@@users.delete self
    @publisher.quit
    @subscriber.quit
  end
  def handle_data(data)
    msg = parse_json(data)
    @publisher.publish("chatapplication",msg[:name] + ":" + msg[:message])
    #@@users.each {|u| u.render msg[:name] + ":" + msg[:message]}  
  end
  
  def parse_json(str)
    Yajl::Parser.parse(str, :symbolize_keys => true)
  end
  
end

class ChatApp < Sinatra::Base
  set :public, "public"
  set :haml, :format => :html5
  
  get "/chat" do
    haml :chat
  end
  
end


