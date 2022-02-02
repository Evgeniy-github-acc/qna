module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote]
    before_action :authenticate_user!, only: :vote
  end

  def vote
    @votable.voting(value: params[:value], user: current_user)

    respond_to do |format|
      if current_user.author_of?(@votable)
        format.json { render json: "You can't vote for your posts", status: :unprocessable_entity }
      else
        format.json { render json: {   id: @votable.id,
                                      klass: @votable.class.to_s.underscore,
                                      rating: @votable.rating,
                                      status: 0} }                            
      end
    end  
  end

  private

  def set_votable
    @votable = resource_name.classify.constantize.find(params[:id])
  end

  def resource_name
    params[:votable]
  end
  
  def vote_params
    params.require(:vote).permit(:value)
  end
end