require 'rails_helper'

RSpec.configure do |config|
  # Include factory_bot factories
  config.include FactoryBot::Syntax::Methods

  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      basePath: '/',
      securityDefinitions: {
        apiKey: {
          type: :apiKey,
          name: 'api_key',
          in: :header
        }
      },
      definitions: {
        user: {
          type: :object,
          properties: {
            id: { type: :integer },
            url: { type: :string },
            username: { type: :string },
            ugent_id: { type: :string },
            first_name: { type: :string },
            last_name: { type: :string },
            email: { type: :string },
            permission: { type: :string },
            time_zone: { type: :string },
            lang: { type: :string },
            submission_count: { type: :integer },
            correct_exercises: { type: :integer },
            subscribed_courses: {
              type: :array,
              item: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  url: { type: :string },
                  year: { type: :string },
                  teacher: { type: :string },
                  color: { type: :string }
                }
              }
            }
          }
        }
      }
    }
  }
end
