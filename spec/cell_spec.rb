require 'rspec'

require 'pry'

$: << File.absolute_path('.')
require_relative '../cell'

describe Cell do

  let(:location) { :test_location }
  let(:state) { Cell::ALIVE }
  subject { described_class.new location, state }

  it 'exists' do
    expect(Cell).not_to eq nil
  end

  describe '#dup' do
    it 'duplicates with its state' do
      expect(subject.dup.alive?).to eq subject.alive?
    end

    let(:collection) { double('collection') }
    xit 'is not affected by parent being updated' do
      expect(subject.alive?).to eq true
      dup = subject.dup
      subject.update 
      dup
    end
  end

  describe '#update' do

  end

end
