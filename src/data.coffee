fs = require('fs').promises
axios = require('axios')
keys = require '../keys.js'

ADDR = 'http://api.etherscan.io/api'


log = console.log

delay = (ms)->
	return new Promise (resolve, reject)=>
		setTimeout resolve, ms


read = (file_name, res_file_name)->
	res = await fs.readFile './' + file_name
	res = String res
	arr = res.split '\r\n'



	id = 5000
	res = ''
	for val in arr
		tmp = val.split '\t'
		if tmp[0].length is 42
			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\n"
			id += 1

	await fs.writeFile res_file_name, res


read_vesting = (file_name, res_file_name)->
	res = await fs.readFile './' + file_name
	res = String res
	arr = res.split '\n'

	time = 1544572800

	id = 1000
	res = ''
	summ = 0
	for val in arr
		tmp = val.split '\t'
		if tmp[1].length is 42
			vesting_time = time + parseInt(tmp[3]) * 30 * 24 * 60 * 60
			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\t#{tmp[2]}\t#{vesting_time}\n"
			id += 1
			summ += parseInt(tmp[2])

	log summ


	await fs.writeFile res_file_name, res


#2699000



check = (file_name)->
#	res = await fs.readFile './' + file_name
#	res = String res
#	arr = res.split '\r\n'

#https://api.etherscan.io/api?module=logs&action=getLogs
#&fromBlock=379224
#&toBlock=latest
#&address=0x33990122638b9132ca29c723bdf037f1a891a70c
#&topic0=0xf63780e752c6a54a94fc52715dbc5518a3b4c3c2833d301a204226548a2a8545
#&apikey=YourApiKeyToken

#	block = 100
#	to_block = 'latest'
#	addr = '0xcdbB5a2D305f179fcfF384499cDef4D6265B3082'.toLowerCase()
#
#	res = await axios.get "#{ADDR}?module=logs&action=getLogs&fromBlock=#{block}&toBlock=#{to_block}
#		&address=#{addr}&apikey#{keys.APIKEY}"
#
#	log res.data






#check()


#read './data/baunty.txt', './data/baunty.dat'
#read './data/telegram.txt', './data/telegram.dat'

read_vesting './data/vesting_transfer.txt', './data/vesting_transfer.dat'







