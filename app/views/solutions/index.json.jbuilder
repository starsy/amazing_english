json.array!(@solutions) do |solution|
  if !solution
    next
  end

  if ! @event.is_solution_published
    json.set! :id, nil
    json.set! :text, 'Not published'
    next
  end

  if solution && @event.is_solution_published
    json.extract! solution, :id, :text, :provider
    json.url event_solutions_path(@event, format: :json)
  end
end
