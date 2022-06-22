class SearchController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def search
     if params[:body] != nil && params[:type] != nil
       @search = params[:type]
     end
  end

  def result
  end

  private

  def search_params
    params.permit(:body, :type)
  end

end
