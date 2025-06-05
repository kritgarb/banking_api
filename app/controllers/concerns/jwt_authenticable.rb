module JwtAuthenticable
  extend ActiveSupport::Concern
  
  included do
    before_action :authenticate_request
  end
  
  private
  
  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: 'Usuário não encontrado' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: 'Token inválido' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
  
  def current_conta
    @current_conta ||= current_user.conta_bancaria
  end
end