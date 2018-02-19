require 'rake'
class DataBaseEventJob
  include Sidekiq::Worker
  include SidekiqStatus::Worker
 #queue_as :default
 #include Sidekiq::Status::Worker #Important
 def perform(dbe)
    data_base_event = DataBaseEvent.find(dbe)
    Rails.application.load_tasks
    if data_base_event.event_type == "Dump"
      ::Rake::Task["db:dump_with_documents"].invoke(data_base_event.filename)
    elsif data_base_event.event_type == "Restore"
      ::Rake::Task["db:restore"].invoke(data_base_event.filename)
    end
  end
  private

  def load_data_base_event(dbe)
    DataBaseEvent.find(dbe)
  end
end
