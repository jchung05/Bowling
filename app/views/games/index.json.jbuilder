json.array!(@games) do |game|
  json.extract! game, :id, :name, :frame, :attempt, :score
  json.url game_url(game, format: :json)
end
