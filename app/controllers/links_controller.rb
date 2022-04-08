class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_link

  def destroy
    if current_user&.author_of?(@link.linkable)
      @link.destroy
    end
  end

  private

  def load_link
    @link = Link.find(params[:id])
  end

  helper_method :link
end
