json.array!(@members) do |member|
  json.extract! member, :id, :name, :role, :birth_date, :group_id
  json.url member_url(member, format: :json)
end
