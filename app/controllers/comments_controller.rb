class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_owner, only: [:create, :index]

  def index
    per_page = 10
    comments_qry = Comment.where(owner_id: @owner.id, owner_type: @owner.class.to_s, depth: 0)
                          .where('status = ? OR user_uuid = ?', 'published', customer_uuid)
                          .includes(:replies)
    @comments = comments_qry.page(params[:page]).per(per_page)
    load_more = comments_qry.count > params[:page].to_i * per_page

    html = render_view(
      'components/comments/comments_list',
      locals: {
        comments: @comments,
      }
    )

    render json: { status: 'success', html: html, load_more: load_more, page: params[:page].to_i + 1 }
  end

  def create
    begin
      @comment = Comment.new(comment_params)
      @comment.user_uuid = customer_uuid
      @comment.save!

      comment_html = render_view('components/comments/comment_item', locals: { comment: @comment, children: [] })
      result = { success: true, comment_html: comment_html, errors: '' }
    rescue StandardError => e
      result = { success: false, errors: e.inspect }
    end

    render json: result
  end

  private

  def find_owner
    @owner = comment_params[:owner_type].constantize.find(comment_params[:owner_id])
  end

  def comment_params
    params.permit(:name, :content, :rate, :owner_id, :owner_type, :address, :email, :phone, :page)
  end
end
