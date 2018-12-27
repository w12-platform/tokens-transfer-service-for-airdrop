keys = require '../keys.js'
fs = require('fs').promises

Eth = require 'ethjs'


#100 test
#130 baunty
#500 vesting test
#1000 vesting
#5000 telegram

log = console.log

ether = (val)->
	Eth.fromWei val, 'ether'


wei = (val)->
	Eth.toWei val, 'ether'


bn = (val)->
	return new Eth.BN val, 10


delay = (ms)->
	return new Promise (resolve, reject)=>
		setTimeout resolve, ms

```
const getNonce = account => new Promise((resolve, reject) => {
	web3.eth.getTransactionCount(account, (err, result) => {

		if(err)
		{
			return reject(err);
		}

		resolve(result);
	});
});
```

send = ->

	sender = artifacts.require 'MassSender'
	sender_addr = '0xcdbB5a2D305f179fcfF384499cDef4D6265B3082'.toLowerCase()

	try
		res = await fs.readFile './data/telegram.dat'
		res = String res
		arr = res.split '\n'
	catch err
		log err
		return

	data = []
	for val in arr
		tmp = val.split '\t'
		data.push {id: tmp[0], addr: tmp[1], amount: tmp[2]}

#	sender = await sender.deployed()

	sender = await sender.at sender_addr

	nonce = await getNonce keys.owner

	size = 50

	for i in [0...data.length] by size
		arr = data[i...i + size]
		ids = (val.id for val in arr)
		receivers = (val.addr for val in arr)
		amounts = ((bn(val.amount).mul(bn(10).pow(bn(18)))).toString() for val in arr)

		for j in [0..2]
			res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, {nonce}
			log res
			nonce += 1

	await delay 1000


vesting_send = ->

	sender = artifacts.require 'MassVestingSender'

	sender_addr = '0xCBC66115e9d8655709c3408D0e320410Aef1161A'.toLowerCase()

	try
		res = await fs.readFile './data/vesting_transfer.dat'
		res = String res
		arr = res.split '\n'
	catch err
		log err
		return

	data = []
	for val in arr
		tmp = val.split '\t'
		data.push {id: tmp[0], addr: tmp[2], amount: wei(parseInt(tmp[3])).toString(), vesting: tmp[4]}

##	sender = await sender.deployed()

	sender = await sender.at sender_addr

	nonce = await getNonce keys.owner

	size = 5

	for i in [0...data.length] by size

		arr = data[i...i + size]

		ids = (val.id for val in arr)
		receivers = (val.addr for val in arr)
		amounts = (val.amount for val in arr)
		vestings = (val.vesting for val in arr)

		for j in [0...2]
			try
				res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, vestings, {nonce}
				log res
			catch err
				log err
			nonce += 1


module.exports = (cb)->
	vesting_send()
