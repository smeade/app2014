json.array!(@entries) do |entry|
  json.extract! entry, :id, :date, :minutes, :project_id, :description, :journal, :billable
  json.url entry_url(entry, format: :json)
end
