class PagesController < ApplicationController
  before_action :find_story, only: [:show]

  def index
    @stories = Story.published_stories_with_image
  end

  def show

  end

  def user

  end

  def demo

  end

  private

  def find_story
    @story = Story.friendly.find(params[:story_id])
  end
end
