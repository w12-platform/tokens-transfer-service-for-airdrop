keys = require '../keys.js'
fs = require('fs').promises

axios = require 'axios'


Eth = require 'ethjs'

abi = require 'ethjs-abi'


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


```
var id_arr = [
  200244,
  200245,
  200246,
  200247,
  200248,
  200249 ];
var addr_arr = [
];
var amount_arr = [
  '104400000000000000000',
  '487200000000000000000',
  '452400000000000000000',
  '348000000000000000000',
  '417600000000000000000',
  '278400000000000000000' ];

```

send = ->

	sender = artifacts.require 'MassSender'
	sender_addr = '0xcdbB5a2D305f179fcfF384499cDef4D6265B3082'.toLowerCase()

	try
		res = await fs.readFile './data/11/investors_NO_lockup_20190220.txt'
		res = String res
		arr = res.split '\n'
	catch err
		log err
		return


	data = []
	for val in arr
		tmp = val.split '\t'

		data.push {id: tmp[0], addr: tmp[1].toLowerCase(), amount: wei(tmp[2]).toString()}
#	sender = await sender.deployed()

	sender = await sender.at sender_addr

	nonce = await getNonce keys.owner

	size = 50

	for i in [0...data.length] by size
		arr = data[i...i + size]
		ids = (val.id for val in arr)
		receivers = (val.addr for val in arr)
		amounts = (val.amount for val in arr)

		log ids
		log receivers
		log amounts

		for j in [0..2]

			try
				res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, {nonce}
				log res
				nonce += 1
			catch err
				log err
				return

		await delay 1000

	log 'cmpl'


send_step = ->

	sender = artifacts.require 'MassSender'
	sender_addr = '0xcdbB5a2D305f179fcfF384499cDef4D6265B3082'.toLowerCase()

	sender = await sender.at sender_addr

	nonce = await getNonce keys.owner

	for i in [0...id_arr.length]
		ids = [id_arr[i]]
		receivers = [addr_arr[i].toLowerCase()]
		amounts = [amount_arr[i]]

		log ids
		log receivers
		log amounts

		for j in [0..1]

			try
				res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, {nonce}
				log res
				nonce += 1
			catch err
				log err
				return


		await delay 1000

	log 'cmpl'



vesting_send = ->
	sender = artifacts.require 'MassVestingSender'

	sender_addr = '0xCBC66115e9d8655709c3408D0e320410Aef1161A'.toLowerCase()

	try
		res = await fs.readFile './data/11/investors_lockup_20190220.txt'
		res = String res
		arr = res.split '\n'
	catch err
		log err
		return

	data = []
	for val in arr
		tmp = val.split '\t'
		data.push {id: tmp[0], addr: tmp[1], amount: wei(tmp[2]).toString(), vesting: tmp[3]}

##	sender = await sender.deployed()

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

	log 'cmpl'


vesting_logs = (res_file_name)->
	try
		sender = artifacts.require 'MassVestingSender'

		sender_addr = '0xCBC66115e9d8655709c3408D0e320410Aef1161A'.toLowerCase()


		#	sender = await sender.deployed()

		sender = await sender.at sender_addr



		data = []

		vesting_transfer = sender.VestingTransfer({}, {fromBlock: 7245554, toBlock: 'latest'})


		vesting_transfer.get (error, logs)=>

			for val in logs

				if val.args._recipient isnt '0xacE624812a8E2d8Ff0112784BBB3dE26355b0A3B'.toLowerCase()
					if val.args._recipient isnt '0xF9c024A74938F8e9172C14dE7b513D3ce4329B49'.toLowerCase()
						data.push
							recipient: val.args._recipient
							lock: val.args._lock
							amount: ether(val.args._amount)
							vesting: val.args._vesting.toString()

			res = 'recipient;lock;amount;vesting\r\n'

			for val in data
				res += "#{val.recipient};#{val.lock};#{val.amount};#{val.vesting}\r\n"

			log data.length

			await fs.writeFile res_file_name, res

			log 'cmpl'

			return

	catch err
		log err

	return





logs = (res_file_name)->

	addr = '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b'.toLowerCase()
	sender_addr = '0x000000000000000000000000cdbb5a2d305f179fcff384499cdef4d6265b3082'.toLowerCase()
	block = 6952961
	max = 6975700

	res = 'recipient;amount\r\n'

	while block < max

		data = await axios.get "https://api.etherscan.io/api?module=logs&action=getLogs&fromBlock=#{block}&toBlock=#{block + 10}&address=#{addr}&topic1=#{sender_addr}&apikey=#{keys.APIKEY}"

		for val in data.data.result
			res += "0x#{val.topics[2][26..]};#{abi.decodeParams(['uint'], val.data)[0].toString()}\r\n"

		log block, data.statusText

		block = block + 11

		await delay 1000

	await fs.writeFile res_file_name, res

	return


logs2 = ()->

	res = await fs.readFile './data/all_log.csv'
	res = String res
	arr = res.split('\r\n')

	res = arr[0] + '\r\n'
	arr = arr[1...]

	for val in arr
		tmp = val.split ';'
		res += "#{tmp[0]};#{ether(tmp[1])}\r\n"

	await fs.writeFile './data/all_log2.csv', res

	return


logs3 = (res_file_name)->

	addr = '0x8839a76591F98759B238A0d9D7a41Ab6f5129AC9'.toLowerCase()
	block = 6841198

#	max = 6975700

#	res = 'recipient;amount\r\n'

	data = await axios.get "https://api.etherscan.io/api?module=logs&action=getLogs&fromBlock=#{block}&toBlock=#{7140359}&address=#{addr}&apikey=#{keys.APIKEY}"


#	log data.data.result

	res2 = 0

	for val in data.data.result
		if val.topics.length is 3
			res = await axios.get "https://api.etherscan.io/api?module=proxy&action=eth_getTransactionByHash&txHash=#{val.transactionHash}&apikey=#{keys.APIKEY}"
			value = parseFloat(ether(abi.decodeParams(['uint'], res.data.result.value)[0]))
			kvt = ether((abi.decodeParams(['uint'], val.data)[0]).mul(bn 10000000000)).toString()
			log val.transactionHash + '\t' + value + '\t' + kvt
			res2 += value
		await delay 500

	log res2


#
#	await fs.writeFile res_file_name, res

	return


logs5 = (res_file_name)->

	addr = '0xCBC66115e9d8655709c3408D0e320410Aef1161A'.toLowerCase()
	block = 7245554
	max = 7245951

	res = 'recipient;lock;amount;vesting\r\n'

	while block < max

		data = await axios.get "https://api.etherscan.io/api?module=logs&action=getLogs&fromBlock=#{block}&toBlock=#{block + 10}&address=#{addr}&apikey=#{keys.APIKEY}"

		for val in data.data.result
			amnt = abi.decodeParams(['uint'], val.data)[0].toString()
			vesting = abi.decodeParams(['uint'], val.topics[3])[0].toString()
			res += "0x#{val.topics[1][26..]};0x#{val.topics[2][26..]};#{amnt};#{vesting}\r\n"

		log block, data.statusText

		block = block + 11

		await delay 1000

	await fs.writeFile res_file_name, res

	return


#module.exports = (cb)->
#	try
#		vesting_send()
#	catch err
#		log err





