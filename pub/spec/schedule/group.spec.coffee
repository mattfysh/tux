describe 'schedule group', ->

  group = null
  schedule1 = listTransactions: sinon.stub().returns [
      (date: '20130123', amount: 1.01, desc: 'venice')
      (date: '20130124', amount: 1.01, desc: 'venice')
      (date: '20130125', amount: 1.01, desc: 'venice')
    ]
  schedule2 = listTransactions: sinon.stub().returns [
      (date: '20130123', amount: 2.02, desc: 'colonia')
      (date: '20130124', amount: 2.02, desc: 'colonia')
    ]
  Schedule =
    query: sinon.stub().returns [schedule1, schedule2]

  beforeEach module 'tux.services'

  beforeEach ->
    angular.module('tux.services').value('Schedule', Schedule);

  beforeEach inject (allSchedules) ->
      group = allSchedules

  it 'queries for all schedules', ->
    Schedule.query.should.have.been.called

  describe 'transaction report', ->

    list = null

    beforeEach ->
      list = group.listTransactions '20130201'

    it 'is an array', ->
      list.should.be.a 'array'

    it 'uses schedule transactions', ->
      schedule1.listTransactions.should.have.been.calledWith '20130201'
      schedule1.listTransactions.should.have.been.calledWith '20130201'
      list.should.have.length 5

    it 'sorts by date', ->
      list[4].date.should.equal '20130125'

    it 'adds running total', ->
      list[0].total.should.equal 1.01
      list[1].total.should.equal 3.03
      list[2].total.should.equal 4.04
      list[3].total.should.equal 6.06
      list[4].total.should.equal 7.07

# TODO:
# add a new schedule
# filter schedules
# caching NOT needed