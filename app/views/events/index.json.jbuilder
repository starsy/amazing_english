json.array!(@events) do |event|
  json.extract! event, :id, :title, :trainer, :date
  json.url event_url(event, format: :json)
end
