class SphinxIndexJob < ApplicationJob
  queue_as :default

  def perform
    rake ts:index
  end
end
