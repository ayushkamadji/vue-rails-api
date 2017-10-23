module Api
  module V1
    class AuthsController < ApplicationController
      skip_before_action :authenticate_user

      def create
        token_request_command = AuthenticateUserCommand.call(params[:email], params[:password])

        if token_request_command.success?
          render json: {token: token_request_command.result}
        else
          render json: {error: token_request_command.errors}, status: :unauthorized
        end
      end

    end
  end
end