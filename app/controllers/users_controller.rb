class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  require 'rest-client'
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def login
  
  end 

  def goToSpotify
    client_id = ENV["CLIENT_ID"]
    redirect_uri = ENV["REDIRECT_URI"]
    redirect_to "https://accounts.spotify.com/en/authorize?response_type=code&client_id=#{client_id}&scope=user-top-read%20user-library-modify%20user-read-private%20user-read-email&redirect_uri=#{redirect_uri}"
  end 

  def callback

    p "test1"

    p params[:code]

  
    body = {
      grant_type: "authorization_code",
      code: params[:code],
      redirect_uri: ENV['REDIRECT_URI'],
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],

    }

    p "test2"

   auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)

  p auth_params = JSON.parse(auth_response.body)
  p "test4"
  header = { 
    Authorization: "Bearer #{auth_params["access_token"]}"
    }
    p "test5"
  user_response = RestClient.get("https://api.spotify.com/v1/me/top/tracks", header)
  p "test6"
  p user_params = JSON.parse(user_response.body)
  p "test7"
  end 

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})
    end
end
