class EndOfCycleJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      EndOfCycleService.new(user: user).perform
    end
  end
end
