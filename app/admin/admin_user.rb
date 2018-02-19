ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  collection_action :add_to_sidekiq, method: :get do
    dbe = DataBaseEvent.create(admin_user_id: current_admin_user.id, filename:  Time.now.to_i, event_type: "Dump")
    dbe.update(batch_bid: DataBaseEventJob.perform_async(dbe.id))
    redirect_to :back, notice: "Sit back and relax while you backup gets prepared "
  end

  collection_action :progress, method: :get do
  end

  collection_action :download, method: :get do
    dbe = DataBaseEvent.find(params[:data_base_event_id])
    send_file( "#{Rails.root}/public/#{dbe.filename}_zip", filename: "#{dbe.filename}_zip.zip")
  end

  member_action :upload_zip, method: :post do
    filename = params[:file].original_filename + Time.now.to_i.to_s
    Zipper.unzip_file(params[:file].open.path, "#{Rails.root}/public/upload/#{filename}")
    dbe = DataBaseEvent.create(admin_user_id: current_admin_user.id, filename:  filename, event_type: "Restore")
    dbe.update(batch_bid: DataBaseEventJob.perform_async(dbe.id))
    redirect_to :back, notice: "Sit back and relax while you backup gets prepared "
  end
end
