require 'sinatra'
require 'sequel'
require 'sqlite3'
require 'json'
require 'time'
require 'httpx'

USER_URL = ENV['USER_URL'] || "http://127.0.0.1:4567"

module OrderService
  class API < Sinatra::Base
    get '/order/user/:user_id' do
      "List of orders for user #{user_id}"
      
      response = HTTPX.get("#{USER_URL}/users/#{user_id}")
      unless response.error
        order_data = ''
        File.open('order.json', 'r') do |file|
          order_data = JSON.parse(file.read)
        end
        user_data = JSON.parse(response.body.to_s)
        content_type :json
        { order: {user: user_data, order_details: order_data}}.to_json
      else
        status 500
        { error: response.error }.to_json
      end
    end

  end
end
