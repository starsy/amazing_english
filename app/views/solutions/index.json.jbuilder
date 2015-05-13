json.array!(@solutions) do |solution|
  json.extract! solution, :id, :text, :provider
  json.url solution_url(solution, format: :json)
end
