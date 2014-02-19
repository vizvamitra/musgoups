json.array!(@concerts) do |concert|
  json.extract! concert, :id, :country, :city, :date, :tour_id
  json.url concert_url(concert, format: :json)
end
