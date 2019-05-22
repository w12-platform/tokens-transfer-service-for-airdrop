fs = require('fs').promises
axios = require('axios')
keys = require '../keys.js'

ADDR = 'http://api.etherscan.io/api'


log = (val...)->
	console.log val...


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
	res = await fs.readFile file_name
	res = String res
	arr = res.split '\r\n'

	time = 1544572800

	id = 1700
	res = ''
	summ = 0
	for val in arr
		tmp = val.split '\t'
#		if tmp[1].length is 42
#			vesting_time = time + parseInt(tmp[3]) * 30 * 24 * 60 * 60
#			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\t#{tmp[2]}\t#{vesting_time}\n"
		if tmp[0].length is 42
			vesting_time = time + parseInt(tmp[2]) * 30 * 24 * 60 * 60
			res += "#{id}\t#{id}\t#{tmp[0]}\t#{tmp[1]}\t#{vesting_time}\n"
			id += 1
			summ += parseInt(tmp[1])

	log file_name, summ


	await fs.writeFile res_file_name, res


read_sum = (file_name, spl, pos)->
	res = await fs.readFile file_name
	res = String res
	arr = res.split spl

	strings = 0

	summ = 0
	for val in arr
		tmp = val.split '\t'
		if tmp.length is 1
			tmp = val.split '  '

		summ += parseInt(tmp[pos])

	log file_name, summ



read_sum2 = (file_name, spl, pos)->
	res = await fs.readFile file_name
	res = String res
	arr = res.split spl

	arr = arr[1...]

#	log arr[0]

#	log arr

#	strings = 0
#
	summ = 0
	for val in arr
		tmp = val.split ';'
		if tmp.length is 1
			tmp = val.split '  '

		summ += parseInt(tmp[pos])

	log file_name, summ


read2 = (file_name, res_file_name)->
	res = await fs.readFile file_name
	res = String res
	arr = res.split '\n'

	id = 425000
	res = ''

	for val in arr
		tmp = val.split ';'
		if tmp[1].length is 42
			res += "#{id}\t#{tmp[1]}\t#{tmp[2]}\n"
			id += 1
		else
			log tmp

	log file_name

	await fs.writeFile res_file_name, res


read_vesting2 = (file_name, res_file_name)->
	res = await fs.readFile file_name
	res = String res
	arr = res.split '\n'

	time = 1551398400


	id = 426000
	res = ''
	summ = 0
	for val in arr
		tmp = val.split ';'
#		if tmp[1].length is 42
#			vesting_time = time + parseInt(tmp[3]) * 30 * 24 * 60 * 60
#			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\t#{tmp[2]}\t#{vesting_time}\n"
		if tmp[1].length is 42
			vesting_time = time + parseInt(tmp[3]) * 30 * 24 * 60 * 60
			res += "#{id}\t#{tmp[1]}\t#{tmp[2]}\t#{vesting_time}\n"
			id += 1
			summ += parseFloat tmp[2]

	log file_name, summ


	await fs.writeFile res_file_name, res


read_dups = (file_name)->
	res = await fs.readFile file_name
	res = String res
	arr = res.split '\n'

	cnt = 0

	addrs = {}

	for val in arr
		tmp = val.split '\t'
		addrs[tmp[0].toLowerCase()] = 1



	for k, v of addrs
		log k
		cnt++

	log cnt


#read_vesting2 './data/11/investors_lockup_20190220.csv', './data/11/investors_lockup_20190220.txt'
#read2 './data/11/investors_NO_lockup_20190220.csv', './data/11/investors_NO_lockup_20190220.txt'

#read2 './data/11/investors_NO_lockup_20190220.csv', './data/11/investors_NO_lockup_20190220.txt'

#read_vesting2 './data/15/w12_investors_LOCKUP.csv', './data/15/investors_lockup.txt'

#read_vesting2 './data/15/w12_investors_LOCKUP.csv', './data/15/w12_investors_lockup.txt'

#read_dups './data/15/singh.txt'

#read2 './data/17/bounty.csv', './data/17/bounty.txt'
read_vesting2 './data/17/bounty_lockup.csv', './data/17/bounty_lockup.txt'


