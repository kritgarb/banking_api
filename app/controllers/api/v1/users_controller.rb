module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]
      
      def create
        user = User.new(user_params)
        
        if user.save
          user.create_conta_bancaria!(
            agencia: '0001',
            saldo: 0.0
          )
          
          render json: { 
            message: 'Usuário criado com sucesso',
            user: user_response(user)
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      private
      
      def user_params
        params.require(:user).permit(:nome, :email, :password, :password_confirmation, :cpf)
      end
      
      def user_response(user)
        {
          id: user.id,
          nome: user.nome,
          email: user.email,
          cpf: user.cpf,
          conta: {
            numero_conta: user.conta_bancaria.numero_conta,
            agencia: user.conta_bancaria.agencia
          }
        }
      end
    end
  end
end
