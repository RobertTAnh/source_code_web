class NewsController < ApplicationController
  def feed
    @posts = Post.lastest.limit(10).to_a
    @products = Product.order(created_at: :desc).limit(10)
    respond_to do |format|
      format.atom
      format.xml { render :xml => @posts }
    end
  end
end
