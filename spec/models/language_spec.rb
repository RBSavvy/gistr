require 'spec_helper'


describe Language do
  let(:language) { Language.find('Ruby') }


  describe '::all' do
    it 'returns an Array' do
      expect(Language.all).to be_kind_of Array
    end

    it 'returns an Array with proper size' do
      expect(Language.all.count).to be(LANGUAGE_FIXTURES.count)
    end

    it 'returns an Array of language objects' do
      Language.all.each do |lang|
        lang.should be_kind_of Language
      end
    end
  end


  describe '#initialize' do
    it 'can create a language' do
      expect(Language.new('languages:language:Ruby').name).to eq('Ruby')
    end

    it 'should throw an error if the key is malformed' do
      expect{Language.new('foo:bar')}.to raise_error ArgumentError
    end
  end


  describe '::find' do
    it 'can find a language' do
      expect(Language.find('Ruby').key).to eq('languages:language:Ruby')
      expect(Language.find('Ruby').name).to eq('Ruby')
    end

    it 'should raise and error if the language is not present' do
      expect{Language.find('NOTHING')}.to raise_error Language::NoLanguage
    end
  end


  describe '#gist_ids' do
    it 'returns an array of gist_ids ' do
      expect(language.gist_ids).to eq(LANGUAGE_FIXTURES['Ruby'])
    end
  end


  describe '#random_gist_id' do
    it 'returns a gist id for a language' do
      LANGUAGE_FIXTURES['Ruby'].count.times do
        expect(language.gist_ids).to include(language.random_gist_id)
      end
    end
  end


  describe '#add_gist_id' do
    let(:gist_id) { rand(language.gist_ids.max+1..100_000)}
    it 'adds a gist id to the language' do
      expect(language.gist_ids).to_not include gist_id

      expect(language.add_gist_id(gist_id)).to be_true
      expect(language.gist_ids).to include gist_id
    end
  end


  describe '#remove_gist_id' do
    let(:gist_id) {LANGUAGE_FIXTURES['Ruby'].first}
    it 'removes the gist id from the language' do
      expect(language.gist_ids).to include(gist_id)
      expect(language.remove_gist_id(gist_id)).to be_true
      expect(language.gist_ids).to_not include(gist_id)
    end
  end


  describe '::remove_gist_id' do
    let(:gist_id) { 3 }
    it 'removes the gist id from all languages' do
      Language.all.each { |l| expect(l.gist_ids).to     include gist_id }
      expect(Language.remove_gist_id(gist_id)).to be_true
      Language.all.each { |l| expect(l.gist_ids).to_not include gist_id }
    end
  end


  describe '#gist_count' do
    it 'can show the count of gist ids for a language' do
      expect(language.gist_count).to eq(LANGUAGE_FIXTURES['Ruby'].count)
    end
  end


end