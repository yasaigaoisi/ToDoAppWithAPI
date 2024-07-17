class TodosController < ApplicationController
  include HTTParty
  base_uri 'http://127.0.0.1:3000'
  before_action :set_todo, only: %i[ show edit update destroy ]
  def index
    response = self.class.get('/todos')
    @todos = JSON.parse(response.body)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    # APIに新規リクエストを送信
    response = api_create_todo(todo_params)
    
    if response.success?
      redirect_to todo_path(response.body['id']), notice: 'Todo was successfully created.'
    else
      @errors = response.errors
      render :edit
    end
  end

  def update
    @todo_id = params[:id]
    # APIに更新リクエストを送信
    response = api_update_todo(@todo_id, todo_params)

    if response.success?
      redirect_to todo_path(@todo_id), notice: 'Todo was successfully updated.'
    else
      @errors = response.errors
      @todo = todo_params
      render :edit
    end
  end

  def destroy
  end

  private
    def set_todo
      response = self.class.get("/todos/#{params[:id]}")
      @todo = JSON.parse(response.body)
    end

    def todo_params
      params.permit(:title)
    end

    def api_update_todo(id, todo_data)
      # APIに更新リクエストを送信
      response = self.class.patch(
        "/todos/#{params[:id]}",
        body: todo_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      # レスポンスを適切に処理して返す
      OpenStruct.new(
        success?: response.success?,
        errors: JSON.parse(response.body)['errors'] || []
      )
    end

    def api_create_todo(todo_data)
      # APIに作成リクエストを送信
      response = self.class.post(
        "/todos",
        body: todo_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      # レスポンスを適切に処理して返す
      OpenStruct.new(
        success?: response.success?,
        body: JSON.parse(response.body),
        errors: JSON.parse(response.body)['errors'] || []
      )
    end
end
