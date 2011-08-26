PicyouApiExample::Application.routes.draw do
  get 'request_token' => 'oauth#request_token', :as => :request_token
  get 'callback' => 'oauth#callback', :as => :callback
  post 'upload' => 'home#upload', :as => :upload
  root :to => 'home#index'
end
