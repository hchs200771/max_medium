class Api::StoriesController < Api::BaseController
  def clap
    story = Story.friendly.find(params[:id])
    story.increment!(:clap)
    render json: { clap_number: story.clap }
  end
end
