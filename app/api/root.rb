class Root < Grape::API
  version 'v1', using: :path
  format :json

  mount Articles
  mount Comments
end
