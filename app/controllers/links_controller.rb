class LinksController < ApplicationController
  before_action :authenticate_user!
 
  def destroy
    @link = Link.find(params[:id])

    if @link.linkable.instance_of?(Question)
      @question = @link.linkable
    elsif @link.linkable.instance_of?(Answer)
      @question = @link.linkable.question
    end
    
    authorize! :destroy, @link
    @link.destroy
  end
end
