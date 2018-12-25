[log, to_fix, get_user, inc_time, CNS, asrt] = require './src/js/lib'
keys = require './keys.js'


Eth = require 'ethjs'


choam = artifacts.require 'CHOAM'


ether = (val)->
	Eth.fromWei val, 'ether'


wei = (val)->
	Eth.toWei val, 'ether'


bn = (val)->
	return new Eth.BN val, 10


gas = (val, gas_price)->
	return (bn val).mul(bn '1000000000').mul(bn gas_price).toString()



module.exports = (cb)->

	eth = new Eth web3.currentProvider

	wei = (val)->
		val = to_fix val.toString(), 18
		return Eth.toWei(val, 'ether').toString()


	choam = await choam.deployed()

	data =
		date: '01.01.2018'
		document: 'dfsdfsdfsdf'
		ticker: 'ETH'
		desc: 'asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd'
		sum: '1000000000000000000000000000000000'
		desc11: 'asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd'
		desc55: 'asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd'

	data_str = JSON.stringify data

	log data_str

	try
		res = await choam.set_data 1, data_str,
			from: keys.owner
			data: '0x'

		log res

	catch err
		log err


	try
		res = await choam.set_data 2, data_str,
			from: keys.owner
			data: '0x'

		log res

	catch err
		log err


	try
		res = await choam.set_data 3, data_str,
			from: keys.owner
			data: '0x'

		log res

	catch err
		log err

{"date":"01.01.2018","document":"dfsdfsdfsdf","ticker":"ETH","desc":"asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd","sum":"1000000000000000000000000000000000","desc11":"asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd","desc55":"asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd"}


#	res = await heap.set_master keys.master,
#		from: keys.owner
#		data: '0x'
#
#	log res

#	res = await choam.transferOwnership keys.OWNER,
#		from: keys.owner
#		data: '0x'
#
#	log res


#	res = await choam.buy_spice_melange
#		from: keys.user5
#		gas: '1500000'
#		value: wei 1.0
#		data: '0x'
#
#	log res
#
#
#	res = await choam.sell_spice_melange wei(0.1),
#		from: keys.user5
#		gas: '1500000'
#		data: '0x'
#
#	log res


#	res = await choam.step
#		from: keys.user4
#		gas: '1500000'
#		data: '0x'
#
#	log res
#
#	res = await choam.step
#		from: keys.user4
#		gas: '1500000'
#		data: '0x'
#
#	log res
#
#	res = await choam.step
#		from: keys.user4
#		gas: '1500000'
#		data: '0x'
#
#	log res
#
#	res = await choam.step
#		from: keys.user4
#		gas: '1500000'
#		data: '0x'
#
#	log res
#
#
#	res = await choam.get_player_state
#		from: keys.user4
#		gas: '1500000'
#		data: '0x'
#
#	log res[0].toString()
#	log res[1].toString()
#
#	res = await choam.get_player_state
#		from: keys.user3
#		gas: '1500000'
#		data: '0x'
#
#	log res[0].toString()
#	log res[1].toString()


#	res = await choam.buy_planet
#		from: keys.user4
#		gas: '1500000'
#		data: '0x'

#	log res




