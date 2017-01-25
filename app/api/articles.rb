class Articles < Grape::API
  resource :articles do

    helpers do
      def create_params
        article = declared(params, include_missing: false)
      end

      def update_params
        article = declared(params, include_missing: false)
      end
    end

    desc "Retrieve articles."
    get do
      Article.all
    end

    desc "Create an article."
    params do
      requires :title, type: String
      requires :body,  type: String
    end
    post do
      Article.create!(create_params)
    end

    helpers do
      def find_article!
        article = Article.find_by_id(params[:id])
        error!("not found.", 404) unless article
        article
      end
    end

    route_param :id do
      get do
        find_article!
      end

      params do
        optional :title, type: String
        optional :body,  type: String
      end
      put do
        article = find_article!
        article.update!(update_params)
        article
      end

      delete do
        article = find_article!
        article.destroy!
        status 204
      end
    end

  end
end
