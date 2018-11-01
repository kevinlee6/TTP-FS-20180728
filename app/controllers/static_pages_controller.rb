class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    # Homepage/Landing
  end
end
