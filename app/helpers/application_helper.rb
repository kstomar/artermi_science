module ApplicationHelper

  def organizations
  	Organization.all.collect {|p| [ p.name, p.id ] }
  end
end
