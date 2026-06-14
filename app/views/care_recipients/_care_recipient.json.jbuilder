json.extract! care_recipient, :id, :name, :birthday, :address, :care_level, :memo, :created_at, :updated_at
json.url care_recipient_url(care_recipient, format: :json)
