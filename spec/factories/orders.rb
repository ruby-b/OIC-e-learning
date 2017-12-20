FactoryGirl.define do
  factory :order, class: Order do
    association :book, factory: :book
    address "東京都"
    updated_at Time.zone.now.to_s
  end

  factory :registered_order, class: Order do
    association :book, factory: :book, title: "我輩はイヌである　第3巻"
    address Gimei.address.kanji
    status 0
  end

  factory :payed_order, class: Order do
    association :book, factory: :book, title: "我輩はイヌである　第2巻"
    address Gimei.address.kanji
    status 1
  end

  factory :delivered_order, class: Order do
    association :book, factory: :book, title: "我輩はイヌである　第1巻"
    address Gimei.address.kanji
    status 2
  end
end
