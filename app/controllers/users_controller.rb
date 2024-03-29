class UsersController < ApplicationController
  before_filter :set_user, only: [:show, :edit, :update]
  # before_filter :validate_authorization_for_user, only: [:edit, :update]

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  def index
    @users = User.all
  end

  # PATCH/PUT /users/1
  def update
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render action: 'edit'
    end
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def validate_authorization_for_user
       redirect_to root_path unless @user == current_user
    end

    def user_params
      params.require(:user).permit(:user_name, :user, :about)
    end
  end
