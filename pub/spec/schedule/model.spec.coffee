describe 'schedule model', ->

  schedule = null
  scheduleData =
    date: '20130123'
    amount: 12.34
    desc: 'chocolate'
    freq: 'w'
    modifiers:
      20130213:
        date: '20130212'
        desc: 'carob'
        amount: 43.21
      20130220:
        amount: 3
        sticky: true

  beforeEach module 'tux.services'

  beforeEach inject ($injector, Schedule) ->
    $httpBackend = $injector.get('$httpBackend');
    $httpBackend.when('GET', '/models/calendar/1').respond scheduleData
    schedule = Schedule.get scheduleId: 1
    $httpBackend.flush()

  describe 'transaction list for a weekly amount', ->

    list = null

    beforeEach ->
      list = schedule.getTransactionList '20130206'

    it 'is an array', ->
      list.should.be.a 'array'

    it 'has first occurance as first item in array', ->
      {date, amount, desc} = list[0]
      date.should.equal '20130123'
      amount.should.equal 12.34
      desc.should.equal 'chocolate'

    it 'has second occurance as second item in array', ->
      {date, amount, desc} = list[1]
      date.should.equal '20130130'
      amount.should.equal 12.34
      desc.should.equal 'chocolate'

    it 'has third occurance as third item in array', ->
      list[2].date.should.equal '20130206'

    it 'should not go past given end date', ->
      list.should.have.length 3

  describe 'frequencies', ->

    withFreq = (freq, secondDate) ->
      schedule.freq = freq
      list = schedule.getTransactionList secondDate
      list[1].date.should.equal secondDate

    it 'can be daily', ->
      withFreq 'd', '20130124'

    it 'can be fortnightly', ->
      withFreq 'f', '20130206'

    it 'can be monthly', ->
      withFreq 'm', '20130223'

    it 'can be quarterly', ->
      withFreq 'q', '20130423'

    it 'can be yearly', ->
      withFreq 'y', '20140123'

    it 'can be once only', ->
      delete schedule.freq
      list = schedule.getTransactionList '20130206'
      list.should.have.length 1

  describe 'modifier', ->

    it 'changes details of an occurance', ->
      list = schedule.getTransactionList '20130213'
      {date, amount, desc} = list[3]
      date.should.equal '20130212'
      amount.should.equal 43.21
      desc.should.equal 'carob'

    it 'can affect all following occurances', ->
      list = schedule.getTransactionList '20130227'
      {date, amount, desc} = list[5]
      date.should.equal '20130227'
      amount.should.equal 3
      desc.should.equal 'chocolate'

    # date modifiers - tx's that go beyond start or end, ensure correct order

  describe 'startup process', ->
    # creates pending transactions, updates data

  # TODO
  # caching
  # changing date or frequency: erases all modifiers, invalidates cache
  # changing amount or desc: smart cache refresh
  # end date
  # input checking & errors
