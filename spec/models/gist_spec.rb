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


end