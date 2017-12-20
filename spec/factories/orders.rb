FactoryGirl.define do
  factory :order, class: Order do
    association :book, factory: :book
    address "東京都"
    updated_at Time.zone.now.to_s
  end
end
