require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:votable) }

  it { should validate_inclusion_of(:value).in_array([-1, 0, 1]) }
end
