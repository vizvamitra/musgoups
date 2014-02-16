json.array!(@groups) do |group|
  json.extract! group, :id, :title, :formation_year, :country, :top_position
  json.url group_url(group, format: :json)
end
