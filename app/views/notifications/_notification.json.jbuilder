json.extract! notification, :id, :message, :read, :created_at, :updated_at
json.url notification_url(notification, format: :json)
json.notifiable_url notifiable_url(notification)
