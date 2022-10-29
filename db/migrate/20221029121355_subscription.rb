class Subscription < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :state, null: false, default: 'created'
      t.belongs_to :question, foreign_key: true
    end

    add_reference :users, :subscription, index: true
    add_reference :subscriptions, :user, index: true
  end
end
