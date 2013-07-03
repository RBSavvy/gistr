require 'spec_helper'


describe Gist do

  describe '::latest_timestamp' do
    before do
      REDIS.stub(:get) { |key|
        Time.now.to_s
      }
    end

    it 'returns a time object' do
      expect(Gist.latest_timestamp).to be_kind_of(Time)
    end

    it 'is in UTC' do
      expect(Gist.latest_timestamp.zone).to eq('UTC')
    end
  end

  describe '::latest_timestamp=' do
    before do
      REDIS.stub(:set) { |key, value|
        @value = value
      }
      REDIS.stub(:get) { |key|
        @value
      }
    end

    context 'passing a time' do

      it 'saves a time object' do
        expect{Gist.latest_timestamp = Time.now}.to_not raise_error
      end

      it 'is recallable via ::latest_timestamp' do
        time = Time.now
        Gist.latest_timestamp = time
        expect(Gist.latest_timestamp.to_s).to eq time.to_s # TODO: WHY TO_S???
      end

    end

    context 'not passing a time' do
      it 'should raise an error' do
        expect{Gist.latest_timestamp = 'blah'}.to raise_error(ArgumentError)
      end
    end

  end


  describe '#create_from_github' do
    let(:gist_data) do
      {
        id:         '5819127',
        updated_at: Time.now.iso8601,
        html_url:   'https://gist.github.com/5819127',
        owner: {
          login:      'phil-monroe',
          avatar_url: 'http://www.gravatar.com/avatar/de52b3ee38783215913cd0a412436823.png'
        },
        files: {
          'run-pocc.bat' => {
            filename: "run-pocc.bat",
            language: "Batchfile"
          }
        }
      }
    end
    let(:gist){ Gist.create_from_github gist_data }
    let(:language) { double(:language) }

    before do
      Language.stub(:find) { language }
      Language.stub(:all)  { [language, language] }
    end


    it "should add the gist's IDs to languages" do
      language.should_receive(:add).with(gist_data[:id])
      language.should_receive(:remove).any_number_of_times

      gist
    end

    it 'should remap gists languages when they change' do
      language.should_receive(:remove).with(gist_data[:id]).exactly(2).times
      language.should_receive(:add).any_number_of_times

      gist
    end

    it 'should update the latest gist timestamp' do
      language.should_receive(:remove).any_number_of_times
      language.should_receive(:add).any_number_of_times
      Gist.should_receive(:latest_timestamp=).with(Time.parse(gist_data[:updated_at]))

      gist
    end


  end


end