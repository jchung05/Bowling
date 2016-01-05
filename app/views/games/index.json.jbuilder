json.array!(@games) do |game|
  json.extract! game, :id, :name, :index, :attempt, :score
  json.url game_url(game, format: :json)
end
