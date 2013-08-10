require 'spec_helper'

describe GistsController  do
  render_views

  describe '#random' do
    it 'should throw an error if language is not found' do
      get :random, language: 'foo'
      expect(response.body).to include("Not Found")
      expect(response.status).to eq(404)
    end
  end

end