class MainController < ApplicationController

  def index
    @languages = Language.all.sort_by(&:gist_count).reverse!
  end

end