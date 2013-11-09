class Users::AccountResource < Cyrax::Resource
  resource :user
  accessible_attributes :name, :email, :password, 
    :password_confirmation, :remember_me
end