require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nome) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:cpf) }
    it { should validate_uniqueness_of(:cpf) }
    
    it 'validates CPF format' do
      user = build(:user, cpf: '12345678900')
      expect(user).not_to be_valid
      expect(user.errors[:cpf]).to include('inválido')
    end
    
    it 'accepts valid CPF' do
      user = build(:user, cpf: '11144477735')
      expect(user).to be_valid
    end
  end
  
  describe 'associations' do
    it { should have_one(:conta_bancaria).dependent(:destroy) }
  end
end