class PagesController < ApplicationController

  def index
    @stories = Story.published_stories_with_image
  end

  def show

  end

  def user

  end

  def demo

  end
end
