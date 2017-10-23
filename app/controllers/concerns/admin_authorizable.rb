class NotPermittedException < StandardError; end

module AdminAuthorizable
  extend ActiveSupport::Concern

  included do
    rescue_from NotPermittedException, with: -> { render json: {error: 'Not permitted'}, status: :forbidden }
  end

  def authorize!(action)
    raise NotPermittedException if action != :read && !current_user.admin?
    true
  end
end