fs = require('fs').promises

log = console.log

delay = (ms)->
	return new Promise (resolve, reject)=>
		setTimeout resolve, ms


read = (file_name, res_file_name)->
	res = await fs.readFile './' + file_name
	res = String res
	arr = res.split '\r\n'

	id = 130
	res = ''
	for val in arr
		tmp = val.split '\t'
		if tmp[0].length is 42
			res += "#{id}\t#{tmp[0]}\t#{tmp[1]}\r\n"
			id += 1

	await fs.writeFile res_file_name, res



read './data/baunty.txt', './data/baunty.dat'



