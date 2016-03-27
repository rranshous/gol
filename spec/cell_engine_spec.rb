require 'rspec'
require_relative '../cell_engine'

describe CellEngine do

  it 'exists' do
    expect(CellEngine).not_to eq nil
  end

  describe '#alive' do
    it 'returns bool' do
      expect(subject.alive?).to be false
    end

    context 'has been set alive' do
      before { subject.set_alive }

      it 'is alive' do
        expect(subject.alive?).to eq true
      end

      context 'has 4 neighbors' do
        before { subject.alive_neighbor_count = 4 }
        it 'is not alive' do
          expect(subject.alive?).to eq false
        end

        context 'has 3 neighbors' do
          before { subject.alive_neighbor_count = 3 }
          it 'is alive' do
            expect(subject.alive?).to eq true
          end
        end
      end

      context 'has 3 neighbors' do
        before { subject.alive_neighbor_count = 3 }
        it 'is alive' do
          expect(subject.alive?).to eq true
        end

        context 'has 2 neighbors' do
          before { subject.alive_neighbor_count = 2 }
          it 'is alive' do
            expect(subject.alive?).to eq true
          end
        end
      end
    end

    context 'has 3 neighbors' do
      before { subject.alive_neighbor_count = 3 }
      it 'should be alive' do
        expect(subject.alive?).to eq true
      end
    end
  end
end
