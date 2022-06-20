class SearchController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def search

  end

  
end
