class SlackNotification

    def self.notify(action, message)
        str = "#{action} -- #{message}"
        self.transmit(str)
    end

    def self.transmit(str)
        notifier = Slack::Notifier.new(
            ENV["SLACK_URL"],
            channel: ENV['SLACK_CHANNEL'],
            username: ENV['SLACK_USERNAME']
        )

        notifier.ping(str)
    end
end
