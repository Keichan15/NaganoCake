# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :customer_state, only: [:create]

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  protected

  #退会判断用メソッド
  def customer_state
    # 1.入力したemailの値によって該当アカウントを取得(find_by)
    @customer = Customer.find_by(email: params[:customer][:email])
    # 取得不可の場合、このメソッドを終了
    return if !@customer
    # 2.取得アカウントのパスワードと実際に入力したパスワードが一致しており、かつ、退会ステータスがtrueの場合
    if @customer.valid_password?(params[:customer][:password]) && @customer.is_deleted ## == true
      # サインアップ画面へ遷移
      redirect_to new_customer_registration_path
    end
  end
end
