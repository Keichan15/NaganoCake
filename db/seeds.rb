# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email: "a@a",
  password: "aaaaaa"
)

Genre.create!(
  [
    {
      name: "ケーキ"
    },
    {
      name: "焼き菓子"
    },
    {
      name: "プリン"
    },
    {
      name: "キャンディ"
    }
  ]
)

20.times do |n|
  item = Item.create(genre_id: 1, name: "ケーキ{n}", introduction: "甘くて美味しいケーキ{n}", price: n * 500, is_active: 'true'),
  item.image.attach(io: File.open(Rails.root.join('app/assets/images/no_image.jpg')),filename: 'no_image.jpg')
end

# Item.create!(
#   [
#     {
#       genre_id: Genre.find(1).id,
#       name: "チーズケーキ",
#       introduction: "甘くておいしい",
#       price: 500,
#       is_active: 'true'
#     },
#     {
#       genre_id: Genre.find(2).id,
#       name: "クッキー",
#       introduction: "サクサクできたて",
#       price: 300,
#       is_active: 'true'
#     },
#     {
#       genre_id: Genre.find(3).id,
#       name: "ぷっちんプリン",
#       introduction: "簡単プリン",
#       price: 450,
#       is_active: 'true'
#     },
#     {
#       genre_id: Genre.find(2).id,
#       name: "スコーン",
#       introduction: "食べごたえ抜群",
#       price: 600,
#       is_active: 'false'
#     }
#   ]
# )