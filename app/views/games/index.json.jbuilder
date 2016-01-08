json.array!(@games) do |game|
  json.extract! game, :id, :name, :index, :score
  json.url game_url(game, format: :json)
end
