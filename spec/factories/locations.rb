FactoryBot.define do
  factory :location do
    factory :location_with_url do
      identifier { 'www.google.com' }
    end

    factory :location_with_ip do
      identifier { '162.158.146.166' }
    end
  end
end
