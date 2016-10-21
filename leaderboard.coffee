#meteor add session
#meteor add accounts-password
#meteor add accounts-ui
#meteor reset destroy data in mongo database
#meteor remove autopublic
#meteor remove insecure
#meteor add coffeescript -------Smart coffee script
#meteor deploy try-meteor.meteor.com
#meteor deploy try-meteor.meteor.com
@PlayersList = new Mongo.Collection('players')
if Meteor.isClient
	Template.leaderboard.helpers
		'player'	:  ->
			currentUserId = Meteor.userId();
			return PlayersList.find({createdBy: currentUserId}, 
			{sort: {score: -1, name: 1} })

		'selectedClass' : ->
			playerId = this._id
			selectedPlayer = Session.get 'selectedPlayer'
			if playerId == selectedPlayer
				return "selected"

		'selectedPlayer': ->
			selectedPlayer = Session.get 'selectedPlayer'
			return PlayersList.findOne({_id: selectedPlayer})
#Events############
	
	Template.leaderboard.events
		'click .player' : ->
			playerId = this._id
			Session.set 'selectedPlayer', playerId
		
		'click .increment': ->
			selectedPlayer = Session.get 'selectedPlayer'
			PlayersList.update({_id: selectedPlayer},{$inc:{score:5}})

		'click .decrement' : ->
			selectedPlayer = Session.get 'selectedPlayer'
			PlayersList.update({_id: selectedPlayer},{$inc:{score:-5}})

		'click .remove' : ->
			selectedPlayer = Session.get 'selectedPlayer'
			PlayersList.remove({_id: selectedPlayer})



	Template.addPlayerForm.events
		'submit form': (event) ->
			event.preventDefault()
			playerNameVar  = event.target.playerName.value
			currentUserId = Meteor.userId()
			PlayersList.insert({
				name: playerNameVar,
				score: 0,
				createdBy: currentUserId
			})
			event.target.playerName.value = ""
		Meteor.subscribe('thePlayers')			


if Meteor.isServer
	Meteor.publish('thePlayers', ->
		currentUserId = this.userId
		return PlayersList.find({createdBy: currentUserId})
	)
	console.log("Hello Server!?!?!")
