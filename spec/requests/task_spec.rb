require 'rails_helper'

RSpec.describe Api::TasksController, type: :controller do
	describe "GET #index" do
		before do
			Task.create!(title: "Task 1", due_date: Date.today + 1.day, priority: "low", status: "pending")
			Task.create!(title: "Task 2", due_date: Date.today + 2.days, priority: "medium", status: "completed")
		end

		it "returns a list of tasks sorted by due_date" do
			get :index

			expect(response).to have_http_status(:success)
			json_response = JSON.parse(response.body)
			expect(json_response.length).to eq(2)
			expect(json_response.first["title"]).to eq("Task 1")
		end

		it "filters tasks by priority" do
			get :index, params: { priority: "low" }

			expect(response).to have_http_status(:success)
			json_response = JSON.parse(response.body)
			expect(json_response.length).to eq(1)
			expect(json_response.first["priority"]).to eq("low")
		end

		it "filters tasks by status" do
			get :index, params: { status: "completed" }

			expect(response).to have_http_status(:success)
			json_response = JSON.parse(response.body)
			expect(json_response.length).to eq(1)
			expect(json_response.first["status"]).to eq("completed")
		end
	end
  describe "GET #show" do
    it "returns the task details" do
      get :show, params: { id: task2.id }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(task1.id)
    end

    it "returns an error if task not found" do
      get :show, params: { id: "non-existent-id" }
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Task not found")
    end
  end

  describe "POST #create" do
    let(:valid_params) { { task: { title: "New Task", description: "Description", due_date: Date.today + 3.days, priority: "medium", status: "pending" } } }
    let(:invalid_params) { { task: { title: "", due_date: "" } } }

    it "creates a new task with valid parameters" do
      expect {
        post :create, params: valid_params
      }.to change(Task, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors with invalid parameters" do
      post :create, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Title can't be blank", "Due date can't be blank")
    end
  end
end
