# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(
    name: 'Зубенко Михаил Петрович',
    balance: 10000
)
now = DateTime.now

operation = Operation.create([
    {
        name: 'Покупка бензина АИ-92',
        op_type: Operation::EXPENDITURE,
        total: 2400,
        operation_date: now - 15.days,
        user: user
    },
    {
        name: 'Покупка продуктов',
        op_type: Operation::EXPENDITURE,
        total: 756,
        operation_date: now - 10.days,
        user: user
    },
    {
        name: 'Снятие наличных',
        op_type: Operation::EXPENDITURE,
        total: 300,
        operation_date: now - 8.days,
        user: user
    },
    {
        name: 'Перевод от другого клиента',
        op_type: Operation::INCOME,
        total: 1000,
        operation_date: now - 5.days,
        user: user
    },
    {
        name: 'Покупка продуктов',
        op_type: Operation::EXPENDITURE,
        total: 340,
        operation_date: now + 2.days,
        user: user
    },
    {
        name: 'Снятие наличных',
        op_type: Operation::EXPENDITURE,
        total: 2000,
        operation_date: now + 3.days,
        user: user
    },
    {
        name: 'Зачисление зарплаты',
        op_type: Operation::INCOME,
        total: 20000,
        operation_date: now + 4.days,
        user: user
    },
    {
        name: 'Перевод на карту',
        op_type: Operation::EXPENDITURE,
        total: 10000,
        operation_date: now + 5.days,
        user: user
    },

])