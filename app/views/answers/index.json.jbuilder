json.array!(@answers) do |answer|
  json.extract! answer, :id, :text, :trainee, :score
  json.url answer_url(answer, format: :json)
end
