15.times.each do
  Url.create!(original_url: Faker::Internet.url)
end
Url.create!(original_url: 'https://www.google.com')