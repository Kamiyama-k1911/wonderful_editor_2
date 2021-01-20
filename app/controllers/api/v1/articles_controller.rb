class Api::V1::ArticlesController < Api::V1::BaseApiController
  def index
    @articles = Article.all.order(updated_at: "DESC")
    render json: @articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    @article = Article.find(params[:id])
    render json: @article
  end
end
