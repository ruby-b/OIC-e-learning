require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'testing for order status' do
    context 'assign premitive value' do
      it "expects 0 to be mapped to 'registered'" do
        order = Order.create(status: 0)
        expect(order.status).to eq('registered')
      end
      it "expects 1 to be mapped to 'payed'" do
        order = Order.create(status: 1)
        expect(order.status).to eq('payed')
      end
      it "expects 2 to be mapped to 'delivered'" do
        order = Order.create(status: 2)
        expect(order.status).to eq('delivered')
      end
    end

    context 'assign enum value' do
      it "expects 'registered' to be mapped to 0" do
        order = Order.create(status: 'registered')
        expect(Order.statuses[order.status]).to eq(0)
      end
      it "expects 'payed' to be mapped to 1" do
        order = Order.create(status: 'payed')
        expect(Order.statuses[order.status]).to eq(1)
      end
      it "expects 'payed' to be mapped to 2" do
        order = Order.create(status: 'delivered')
        expect(Order.statuses[order.status]).to eq(2)
      end
    end
  end

  describe 'testing for order status' do
    describe 'enum attributes are available for where clause' do
      let(:user) { create(:user) }
      before do
        FactoryGirl.create_list(:registered_order, 7, user: user)
        FactoryGirl.create_list(:payed_order, 11, user: user)
        FactoryGirl.create_list(:delivered_order, 15, user: user)
      end

      it "expects the number of 'registered' orders is 7" do
        expect(Order.registered.count).to eq(7)
      end

      it "expects the number of 'payed' order is 11" do
        expect(Order.payed.count).to eq(11)
      end

      it "expects the number of 'delivered' order is 15" do
        expect(Order.delivered.count).to eq(15)
      end
    end
  end
end
