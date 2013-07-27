class GistsController < ApplicationController

  def show
  end

  private

  def language
    if params[:language].present?
      Language.find params[:language].titleize
    else
      Language.all.sample
    end
  end


  def gist_id
    @gist_id ||= if params[:id] = 'random'
      language.random_gist_id
    else
      params[:id]
    end
  end
  helper_method :gist_id

  def gist
    @gist ||= GITHUB.gists.get(gist_id)
  rescue
    Language.remove_gist_id(gist_id)
    @gist_id = nil
    retry
  end
  helper_method :gist
end
