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
		res = await fs.readFile './data/5/investors_2.dat'
		res = String res
		arr = res.split '\n'
	catch err
		log err
		return

	data = []
	for val in arr
		tmp = val.split '\t'
		data.push {id: tmp[0], addr: tmp[1], amount: wei(tmp[2]).toString()}

#	sender = await sender.deployed()

	sender = await sender.at sender_addr

	nonce = await getNonce keys.owner

	size = 50


	for i in [0...data.length] by size
		arr = data[i...i + size]
		ids = (val.id for val in arr)
		receivers = (val.addr for val in arr)
		amounts = (val.amount for val in arr)

		for j in [0..2]
			res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, {nonce}
			log res
			nonce += 1

	await delay 1000


vesting_send = ->

	sender = artifacts.require 'MassVestingSender'

	sender_addr = '0xCBC66115e9d8655709c3408D0e320410Aef1161A'.toLowerCase()

	try
		res = await fs.readFile './data/3/managers_vesting_2.dat'
		res = String res
		arr = res.split '\n'
	catch err
		log err
		return

#	data = []
#	for val in arr
#		tmp = val.split '\t'
#		data.push {id: tmp[0], addr: tmp[2], amount: wei(tmp[3]).toString(), vesting: tmp[4]}

	data = [
		{id: 515, addr: '0xF9c024A74938F8e9172C14dE7b513D3ce4329B49'.toLowerCase(), amount: '1', vesting: '1546003486'},
		{id: 516, addr: '0xF9c024A74938F8e9172C14dE7b513D3ce4329B49'.toLowerCase(), amount: '1', vesting: '1546003486'},
		{id: 517, addr: '0xF9c024A74938F8e9172C14dE7b513D3ce4329B49'.toLowerCase(), amount: '1', vesting: '1546003486'}
		]

##	sender = await sender.deployed()

#	0xb901bdbcfe5470b854c4434b987e29ea1290dd5a
#	0x1b68e9b0dc65d5822e078667184cc0fa64b4931f
#	0xc6f695202eb1190f53a6e2b32351e1f2ef4ab78e

	sender = await sender.at sender_addr

	nonce = await getNonce keys.owner

	size = 5

	for i in [0...data.length] by size

		arr = data[i...i + size]

		ids = (val.id for val in arr)
		receivers = (val.addr.toLowerCase() for val in arr)
		amounts = (val.amount for val in arr)
		vestings = (val.vesting for val in arr)

		for j in [0...2]
			try
				res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, vestings, {nonce}
				log res
			catch err
				log err
			nonce += 1


vesting_logs = (res_file_name)->
	try
		sender = artifacts.require 'MassVestingSender'

		sender_addr = '0xCBC66115e9d8655709c3408D0e320410Aef1161A'.toLowerCase()


		#	sender = await sender.deployed()

		sender = await sender.at sender_addr


		data = []

		vesting_transfer = sender.VestingTransfer({}, {fromBlock: 0, toBlock: 'latest'})
		vesting_transfer.get (error, logs)=>

			for val in logs
				data.push
					recipient: val.args._recipient
					lock: val.args._lock
					amount: ether(val.args._amount)
					vesting: val.args._vesting.toString()

			res = 'recipient;lock;amount;vesting\r\n'

			for val in data
				res += "#{val.recipient};#{val.lock};#{val.amount};#{val.vesting}\r\n"

			await fs.writeFile res_file_name, res

			log 'cmpl'

			return




		await delay 1000

	catch err
		log err



#module.exports = (cb)->
#	send()


