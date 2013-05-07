Sidbase::Application.routes.draw do
  match '/api/v1/:model'     => 'api#options', :via => 'options'
  match '/api/v1/:model'     => 'api#index',   :via => 'get'
  match '/api/v1/:model/:id' => 'api#show',    :via => 'get'
end
