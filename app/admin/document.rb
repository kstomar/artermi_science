ActiveAdmin.register Document do
  permit_params :image, :user_id

  index do
    selectable_column
    id_column
    column :image
    column :user
    column :created_at
    actions
  end

  filter :created_at

  form do |f|
    f.inputs do
      f.input :user
      f.input :image, :as => :file
    end
    f.actions
  end
end
