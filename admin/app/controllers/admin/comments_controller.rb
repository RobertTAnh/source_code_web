module Admin
  class CommentsController < ApplicationController
    before_action :get_comment, only: [:show, :edit, :update, :create]

    def index
      raise Unauthorized unless can?(:read, :comment)

      @comments = CommentCmds::List.call(context: context, params: params).result
    end

    def show
      raise Unauthorized unless can?(:read, @comment)

      modal = render_to_string(partial: 'admin/comments/comment_modal', locals: { comment: @comment })

      render json: { modal_data: modal }
    end

    def create
      raise Unauthorized unless can?(:create, :comment)

      cmd = CommentCmds::Create.call(context: context, params: create_comment_params, parent: @comment)

      if cmd.success?
        comment_html = render_to_string(partial: 'admin/comments/reply_item', locals: { reply: cmd.result })
        render json: { comment: cmd.result, comment_html: comment_html }
      else
        render json: { errors: cmd.errors }
      end
    end

    def update
      raise Unauthorized unless can?(:update, @comment)

      cmd = CommentCmds::Update.call(context: context, params: update_comment_params, comment: @comment)

      if cmd.success?
        comment = cmd.result

        if comment.is_admin?
          comment_html = render_to_string(partial: 'admin/comments/reply_item', locals: { reply: cmd.result })
        else
          comment_html = render_to_string(partial: 'admin/comments/comment_item', locals: { comment: cmd.result })
        end

        render json: { comment: cmd.result, comment_html: comment_html }
      else
        render json: { errors: cmd.errors }
      end
    end

    private

    def get_comment
      @comment = Comment.find(params[:id])
    end

    def create_comment_params
      params.require(:comment).permit(:name, :content, :owner_id, :owner_type)
    end
    
    def update_comment_params
      params.permit(:id, :status, :content)
    end

    def get_owner
      @owner = params[:owner_type].constantize.where(id: params[:owner_id]).first
    end
  end
end
