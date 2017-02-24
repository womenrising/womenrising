require 'rails_helper'

describe Location do

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:city) }
    it { expect(subject).to validate_presence_of(:state) }
  end
end
