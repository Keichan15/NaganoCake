class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    case resource
    when Customer
      flash[:notice] = "ようこそ、#{resource.last_name}さん！"
      customers_my_page_path
    when Admin
      admin_path
    end
  end

  def after_sign_out_path_for(resource)
    case resource
    when :customer
      root_path
    when :admin
      new_admin_session_path
    end
  end

end
