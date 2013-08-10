class GistsController < ApplicationController

  def show
    @gist =  GITHUB.gists.get(params[:id])
  end

  def random
    @gist =  GITHUB.gists.get(language.random_gist_id)
    render :show
  rescue Github::Error::NotFound
    retry
  end

  private

  def language
    if params[:language].present?
      lang = params[:language].gsub('_', ' ')
      Language.find lang
    else
      Language.all.sample
    end
  end

  def gist
    @gist
  end
  helper_method :gist
end
