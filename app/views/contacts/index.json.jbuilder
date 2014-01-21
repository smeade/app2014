json.array!(@contacts) do |contact|
  json.extract! contact, :id, :client_id, :first_name, :last_name, :title, :email, :phone, :fax
  json.url contact_url(contact, format: :json)
end
