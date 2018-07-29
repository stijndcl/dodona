require 'swagger_helper'

describe 'Homepage API' do
  path '/' do

    get 'Retrieves information about the current session' do
      let :user do
        create :user
      end

      let :api_key do
        key = create :api_token, user: user
        byebug
        key.token
      end

      security [api_key: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'info found ' do
        schema type: :object,
          properties: {
            user: {
              '$ref' => '#/definitions/user'
            },
            deadline_series: {
              type: :object,
              properties: {
                id: { type: :integer },
                url: { type: :string },
                course_id: { type: :integer },
                name: { type: :string },
                description: { type: :string },
                visibility: { type: :string },
                order: { type: :string },
                deadline: { type: :date, 'x-nullable': true }
              }
            },
            version: { type: :string },
            min_supported_client: { type: :string }
          },
          required: %w[user version min_supported_client]

        run_test!
      end
    end
  end
end
