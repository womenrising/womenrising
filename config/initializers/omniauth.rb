module OmniAuth
  module Strategies
    class Developer
      # emulate fields used from LinkedIn
      option :fields, [:first_name, :last_name, :email]

      extra do
        {
          'raw_info' => {
            'pictureUrls' => { '0' => nil, '1' => [random_pic] },
            'publicProfileUrl' => 'http://example.com/123'
          }
        }
      end

      def random_pic
        n = request.params['email'].length % 10 + 1 rescue 0
        "http://lorempixel.com/400/400/cats/#{n}"
      end
    end
  end
end
