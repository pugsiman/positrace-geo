module BasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  # NOTE: This is not very secure (raw token in DB) but will make do for an exercise. We can discuss!
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = User.find_by(api_key: token) if token
    render json: { error: 'Unauthorized credentials' }, status: :unauthorized unless @current_user
  end
end
