class CreateTodos < ActiveRecord::Migration[7.1]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :content
      t.datetime :datetime
      t.boolean :complete_flag

      t.timestamps
    end
  end
end
