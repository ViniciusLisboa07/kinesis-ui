class HomeController < ApplicationController
  def index
    @users = [
      { id: 1, name: "João Silva", email: "joao@example.com" },
      { id: 2, name: "Maria Santos", email: "maria@example.com" },
      { id: 3, name: "Pedro Oliveira", email: "pedro@example.com" }
    ]
  end

  def show
    @user = { id: 1, name: "João Silva", email: "joao@example.com" }
  end

  def create_user
    redirect_to root_path, notice: "Usuário criado com sucesso!"
  end

  def delete_user
    redirect_to root_path, notice: "Usuário deletado com sucesso!"
  end
end