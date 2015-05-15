json.array!(@answers) do |answer|
  if answer
    json.extract! answer, :id, :text, :trainee, :score
    json.url "/events/#{@event.id}/answers/#{answer.id}.json"
  end
end
