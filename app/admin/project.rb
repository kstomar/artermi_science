ActiveAdmin.register Project do
  permit_params :name, :organization_id, :user_d

  index do
    selectable_column
    id_column
    column :name
    column :organization
    column :user
    column :created_at
    actions
  end

  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :organization
      f.input :user
    end
    f.actions
  end
end
