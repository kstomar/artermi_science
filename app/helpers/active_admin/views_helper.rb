module ActiveAdmin::ViewsHelper #camelized file name
  def zip_created(batch_bid)
   	status_container = SidekiqStatus::Container.load(batch_bid)
    status_container.status == 'complete'
  end
end
