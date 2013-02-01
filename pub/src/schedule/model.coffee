angular.module('tux.services', ['ngResource'])

.factory 'Schedule', ($resource) ->

  dateFormat = 'YYYYMMDD'
  freqMap =
    d: ['d', 1]
    w: ['w', 1]
    f: ['w', 2]
    m: ['M', 1]
    q: ['M', 3]
    y: ['y', 1]

  Schedule = $resource '/models/calendar/:scheduleId'
    scheduleId: '@_id'

  Schedule::getTransactionList = (end) ->
    {date, amount, desc} = @
    next = moment date, dateFormat
    end = moment end, dateFormat
    interval = freqMap[@freq]

    list = while next && next <= end

      # extract date and lookup modifer
      date = next.format dateFormat
      mod = @modifiers?[date] || {}

      # apply sticky modifiers
      if mod.sticky
        amount = mod.amount if mod.amount
        desc = mod.desc if mod.desc

      # calculate next
      if interval then next.add interval... else next = null

      # add occurance to list
      date: mod.date || date
      amount: mod.amount || amount
      desc: mod.desc || desc

  # return
  Schedule
