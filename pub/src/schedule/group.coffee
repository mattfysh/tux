angular.module('tux.services').factory 'allSchedules', (Schedule) ->
  # query for all items and store array
  items = Schedule.query()

  # list all transactions
  listTransactions: (end) ->
    list = []
    total = 0

    # collect transactions for all schedules
    for item in items
      txs = item.listTransactions end
      list = list.concat txs
    
    # sort transactions by date
    list = _.sortBy list, 'date'

    # add running total
    list.forEach (tx) ->
      total += tx.amount
      tx.total = parseFloat(total.toFixed 2, 10)

    return list

  filter: (cb) ->
    # TODO: return similar object, filtered items, can still list transactions