class SlackNotification

    def self.notify(action, message)
        app_name = ENV['APP_NAME'] || 'dev'
        str = "#{action} -- (#{app_name}) #{message}"
        self.transmit(str) if Rails.env.production?
    end

    def self.transmit(str)
        notifier = Slack::Notifier.new(
            ENV['SLACK_URL'],
            channel: ENV['SLACK_CHANNEL'],
            username: ENV['SLACK_USERNAME']
        )

        notifier.ping(str)
    end
end
