class Comments < Grape::API
  helpers do
    def set_article!
      @article = Article.find_by_id(params[:article_id])
      error!('Article Not found.', 404) unless @article
    end
  end

  resource :articles do
    route_param :article_id do
      resource :comments do
        get do
          set_article!
          @comments = @article.comments
        end

        params do
          requires :comment, type: String
        end
        post do
          set_article!
          @comment = @article.comments.create(declared(params, include_missing: false))
        end
      end
    end
  end
end
