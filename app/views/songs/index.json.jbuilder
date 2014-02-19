json.array!(@songs) do |song|
  json.extract! song, :id, :title, :music_by, :lyrics_by, :group_id
  json.url song_url(song, format: :json)
end
