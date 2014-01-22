json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :hourly_rate, :billable, :common
  json.url task_url(task, format: :json)
end
