Url.create!(original_url: 'https://www.google.com', short_url: Faker::Internet.uuid)
15.times.each do
  Url.create!(original_url: Faker::Internet.url, short_url: Faker::Internet.uuid)
end