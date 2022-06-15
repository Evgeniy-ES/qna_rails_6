# frozen_string_literal: true

# Add a task in queue in DailyDigestJob class

class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigestService.new.send_digest
  end
end
