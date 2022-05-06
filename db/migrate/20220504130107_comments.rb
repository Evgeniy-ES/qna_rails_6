class Comments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.belongs_to :user, foreign_key: true
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end
