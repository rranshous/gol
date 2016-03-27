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
      before { puts 'setting alive'; subject.set_alive; puts 'set alive' }

      it 'is alive' do
        expect(subject.alive?).to eq true
      end

      context 'has 4 neighbors' do
        before { subject.alive_neighbor_count = 4 }
        it 'is not alive' do
          expect(subject.alive?).to eq false
        end
      end

      context 'has 3 neighbors' do
        before { puts 'setting 3'; subject.alive_neighbor_count = 3; puts 'set 3' }
        it 'is alive' do
          expect(subject.alive?).to eq true
        end

        context 'has 2 neighbors' do
          before { puts 'setting 2'; subject.alive_neighbor_count = 2; puts 'set 2' }
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
