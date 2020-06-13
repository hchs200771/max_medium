class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_story, only: %i[destroy edit update]

  def index
    @stories = current_user.stories.order(created_at: :desc)
  end

  def new
    @story = current_user.stories.new
  end

  def create
    @story = current_user.stories.new(stroy_params)
    @story.publish if params[:publish]
    if @story.save
      if params[:publish]
        redirect_to stories_path, notice: '已成功發布故事'
      else
        redirect_to edit_story_path(@story), notice: '故事已儲存'
      end
    else
      render :new
    end
  end

  def edit; end

  def update
    if @story.update(stroy_params)
      if params[:publish]
        @story.publish!
        redirect_to stories_path, notice: '故事已上架'
      elsif params[:unpublish]
        @story.unpublish!
        redirect_to stories_path, notice: '故事已下架'
      else
        redirect_to stories_path, notice: '故事更新成功'
      end
    else
      render :edit
    end
  end

  def destroy
    if @story.destroy
      redirect_to stories_path, notice: '故事刪除成功'
    else
      render :index
    end
  end

  private

  def find_story
    @story = current_user.stories.friendly.find(params[:id])
  end

  def stroy_params
    params.require(:story).permit(:title, :content, :cover_image)
  end
end
