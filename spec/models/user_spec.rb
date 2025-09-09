require 'rails_helper'

RSpec.describe User, type: :model do
  it 'creates a record' do
    create(:user)
  end
end
