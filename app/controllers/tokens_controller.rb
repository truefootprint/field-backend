class TokensController < ActionController::API
  def create
    phone_number = params["phone_number"]
    access_denied and return unless phone_number

    user = User.find_by(phone_number: phone_number)
    access_denied and return unless user

    # Admin tokens are created manually.
    access_denied and return if user.roles.any?(&:admin?)

    api_token = ApiToken.generate_for!(user)
    render json: { token: api_token.token }, status: :created
  end

  private

  def access_denied
    render json: {}, status: 401
  end
end
