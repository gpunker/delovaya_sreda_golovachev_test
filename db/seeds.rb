# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

operation_names = [
    'Снятие средств',
    'Получение средств',
    'Перевод',
    'Покупка',
    'Заправка',
]

user = User.create(
    name: 'Зубенко Михаил Петрович',
    balance: 10000
)

operation = Operation.create(
    name: 'Покупка бензина АИ-92',
    op_type: Operation::EXPENDITURE,
    total: 400,
    operation_date: DateTime.now,
    user: user
)