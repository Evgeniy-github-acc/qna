class SearchController < ApplicationController

  def index
    @results = search_type(params[:model_name])
  end  

  private

  def search_type(model_name)
    model_name == 'Anywhere' ? ThinkingSphinx.search(params[:query]) : model_name.constantize.search(params[:query])
  end  
end
