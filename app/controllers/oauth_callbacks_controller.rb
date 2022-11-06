# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authenticate('Github')
  end

  def vkontakte
    authenticate('VK')
  end

  def yandex
    authenticate('Yandex')
  end

  def authenticate(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Smthng went wrong'
    end
  end
end
