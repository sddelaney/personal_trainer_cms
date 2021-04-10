json.extract! workout, :id, :user_id, :date, :content, :created_at, :updated_at
json.url workout_url(workout, format: :json)
