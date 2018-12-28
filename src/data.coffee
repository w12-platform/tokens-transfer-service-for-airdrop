fs = require('fs').promises
axios = require('axios')
keys = require '../keys.js'

ADDR = 'http://api.etherscan.io/api'


log = console.log

delay = (ms)->
	return new Promise (resolve, reject)=>
		setTimeout resolve, ms


read = (file_name, res_file_name)->
	res = await fs.readFile file_name
	res = String res
	arr = res.split '\n'

	id = 3000
	res = ''
	summ = 0
	for val in arr
		tmp = val.split '\t'
		if tmp[0].length is 42
			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\n"
			id += 1
			summ += parseInt(tmp[1])
		else
			log tmp

	log file_name, summ

	await fs.writeFile res_file_name, res


read_vesting = (file_name, res_file_name)->
	res = await fs.readFile './' + file_name
	res = String res
	arr = res.split '\n'

	time = 1544572800

	id = 1500
	res = ''
	summ = 0
	for val in arr
		tmp = val.split '\t'
		if tmp[1].length is 42
			vesting_time = time + parseInt(tmp[3]) * 30 * 24 * 60 * 60
			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\t#{tmp[2]}\t#{vesting_time}\n"
			id += 1
			summ += parseInt(tmp[2])

	log file_name, summ


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

#read './data/2/blog.txt', './data/2/blog.dat'
#read './data/2/bugs&audit.txt', './data/2/bugs&audit.dat'
#read './data/2/bugs.txt', './data/2/bugs.dat'
#read './data/2/proj.txt', './data/2/proj.dat'
#read './data/2/reddit.txt', './data/2/reddit.dat'
#read './data/2/ref.txt', './data/2/ref.dat'
#read './data/2/sig.txt', './data/2/sig.dat'
#read './data/2/translation.txt', './data/2/translation.dat'
#read './data/2/youtube.txt', './data/2/youtube.dat'

#read './data/2/icoreview.csv', './data/2/icoreview.dat'
#read './data/2/managers.csv', './data/2/managers.dat'
#read './data/2/otherservice.csv', './data/2/otherservice.dat'


read './data/5/investors_2.csv', './data/5/investors_2.dat'

#read './data/2/dat.txt', './data/2/dat.dat'



#read_vesting './data/vesting_transfer.txt', './data/vesting_transfer.dat'

#read_vesting './data/3/managers_vesting_1.csv', './data/3/managers_vesting_1.dat'
#read_vesting './data/3/managers_vesting_2.csv', './data/3/managers_vesting_2.dat'


#bugs&audit.txt 45436
#blog.txt 218036
#bugs.txt 3146
#proj.txt 23232
#translation.txt 75000
#youtube.txt 149975
#reddit.txt 74124
#ref.txt 319216
#sig.txt 366749
#icoreview.csv 110837
#otherservice.csv 172498
#managers.csv 1088729

#log 45436 + 218036 + 3146 + 23232 + 75000 + 149975 + 74124 + 319216 + 366749 + 110837 + 172498 + 1088729 - 1280000


#managers_vesting_1.csv 1088729
#managers_vesting_2.csv 1088729
#2177458

