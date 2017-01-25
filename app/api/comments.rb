class Comments < Grape::API
  helpers do
    def set_article!
      @article = Article.find_by_id(params[:article_id])
      error!('Article Not found.', 404) unless @article
    end

    def set_comment!
      @comment = @article.comments.find_by_id(params[:id])
      error!('Comment Not found.', 404) unless @comment
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

        route_param :id do
          get do
            set_article!
            set_comment!
            @comment
          end

          params do
            requires :comment, type: String
          end
          put do
            set_article!
            set_comment!
            if @comment.update(declared(params, include_missing: false))
              @comment
            else
              error!(@comment.errors, 422)
            end
          end

          delete do
            set_article!
            set_comment!
            @comment.destroy
            status 204
          end
        end
      end
    end
  end
end
