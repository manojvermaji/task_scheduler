class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks, id: :string do |t|
      t.string :title
      t.text :description
      t.string :priority, default: "Low", null: false
      t.date :due_date
      t.string :status, default: "Pending", null: false

      t.timestamps
    end
  end
end
