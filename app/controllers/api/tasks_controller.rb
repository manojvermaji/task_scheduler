class Api::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

    def index
      tasks = Task.all
			tasks = tasks.order(due_date: :asc)
			tasks = tasks.where(priority: params[:priority]) if params[:priority].present?
			tasks = tasks.where(status: params[:status]) if params[:status].present?
      render json: tasks
    end

    def show
      render json: @task
    end

    def create
      task = Task.new(task_params)

      if task.save
        render json: task, status: :created
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        render json: @task
      else
        render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
			if @task.present?
				@task.destroy
        render json: { message: "Task deleted successfully" }, status: :ok
			else
				render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
			end
    end

    private

    def set_task
      @task = Task.find_by(id: params[:id])
      render json: { error: "Task not found" }, status: :not_found if @task.nil?
    end

    def task_params
      params.require(:task).permit(:title, :description, :priority, :due_date, :status)
    end
end
