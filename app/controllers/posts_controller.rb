class PostsController < ApplicationController
  def index
    @user = User.includes(posts: :comments).find(params[:id])
    @posts = @user.posts.includes(:comments)

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def show
    @current_user = current_user
    @post = Post.find(params[:post_id])
  end

  def new
    @current_user = current_user
    @post = @current_user.posts.new
  end

  def create
    @current_user = current_user
    @post = @current_user.posts.new(post_params)

    if @post.save
      redirect_to user_posts_path(@current_user), notice: 'Post created successfully.'
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    authorize! :destroy, @post

    @post.destroy
    redirect_to user_posts_path(@current_user), notice: 'Post deleted successfully.'
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
