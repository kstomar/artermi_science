module ActiveAdmin::ViewsHelper #camelized file name
  def zip_created 
 	event = current_admin_user.data_base_event
 	if event
      status_container = SidekiqStatus::Container.load(event.batch_bid)
      status_container.status == 'complete'
 	else
 	  false
 	end
  end 
end 