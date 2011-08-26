class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def consumer
    @consumer ||= OAuth::Consumer.new(PICYOU_CONFIG['consumer_key'], PICYOU_CONFIG['consumer_secret'],
      :site => 'http://picyou.dev:3000')
  end
end
