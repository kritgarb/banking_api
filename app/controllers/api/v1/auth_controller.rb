module Api
  module V1
    class AuthController < ApplicationController
      include Auditable
      skip_before_action :authenticate_request, only: [:login]
      
      def login
        user = User.find_by(email: params[:email])
        
        if user&.authenticate(params[:password])
          @current_user = user  
          registrar_auditoria(:login)
          
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: {
              id: user.id,
              nome: user.nome,
              email: user.email
            }
          }, status: :ok
        else
          render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
        end
      end
    end
  end
end