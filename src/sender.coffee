keys = require '../keys.js'
fs = require('fs').promises

Eth = require 'ethjs'

sender = artifacts.require 'MassSender'

sender_addr = '0xcdbB5a2D305f179fcfF384499cDef4D6265B3082'.toLowerCase()



log = console.log

ether = (val)->
	Eth.fromWei val, 'ether'


wei = (val)->
	Eth.toWei val, 'ether'


bn = (val)->
	return new Eth.BN val, 10


gas = (val, gas_price)->
	return (bn val).mul(bn '1000000000').mul(bn gas_price).toString()


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

#data = [
#	{id: 110, addr: '0x72106A27c20453999447628EaE3413F1845d7634',	amount: 40}
#	{id: 111, addr: '0xA301F00b655a45D454747B4b8fb3dcEFD8C4D66f',	amount: 80}
#	{id: 112, addr: '0xf8b6f255103658c028a5b8dcbf4f762ff26e0a79',	amount: 80}
#	{id: 113, addr: '0x74F65fd4820Cd5C6314f12b48dcDbb79253ba5bC',	amount: 101}
#	{id: 114, addr: '0x3492D93Eee9F1AD0B53f29F22bC837Edb7FD9c3a',	amount: 120}
#	{id: 115, addr: '0x53AFB0932eE852a680066dd651FD41a9c95b8Eba',	amount: 200}
#	{id: 116, addr: '0xbDE13f2078FB4CEf1E7a6898C37Ee5D74858909e',	amount: 200}
#	{id: 117, addr: '0xd1E70063DC1438223926b30b752fBeA10BC002d3',	amount: 200}
#	{id: 118, addr: '0x3ff9c32C439c44F4f66f0bA87Ff730CfA93EAC34',	amount: 200}
#	{id: 119, addr: '0x60b5a9A3f279eD741aC992d894a5C2854a6E8915',	amount: 200}
#	{id: 120, addr: '0xeC1bdB3A270f16F2Ceeb8217C7efd8B63177cCca',	amount: 200}
#	{id: 121, addr: '0x81A7D9994260C895622F164c8812E90DAb328408',	amount: 200}
#	{id: 122, addr: '0x6b5dfDB24897529Cdf4a67cAC6f4bd5983ED8922',	amount: 200}
#	{id: 123, addr: '0x1B8501b59AA00DAAcDdf5DaD445F23A317b5BC93',	amount: 221}
#	{id: 124, addr: '0xD3489b36655faA8F9CD68AB6e7B96C93A31AA09B',	amount: 240}
#	{id: 125, addr: '0xbeBB0c5f0ADfB8916895E06194b134496399f8aB',	amount: 240}
#	{id: 126, addr: '0xe5672c9Bc9Fcd7B96BC46107791b604aCd5d2435',	amount: 240}
#	{id: 127, addr: '0x319D1c2150aE81C624726bC3F54349139dC17742',	amount: 240}
#	{id: 128, addr: '0xd08bE1f67b6135c5A8e3D54A7303023184e066E8',	amount: 240}
#	{id: 129, addr: '0xd1Db4aC24Bf9162a3A4E9b78aa13ecbF4c20C3ee',	amount: 240}
#	]



module.exports = (cb)->

	eth = new Eth web3.currentProvider

	wei = (val)->
		val = to_fix val.toString(), 18
		return Eth.toWei(val, 'ether').toString()

	try
		res = await fs.readFile './data/baunty.dat'
		res = String res
		arr = res.split '\r\n'
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

	size = 10

	for i in [0...data.length] by size
		arr = data[i...i + size]
		ids = (val.id for val in arr)
		receivers = (val.addr for val in arr)
		amounts = ((bn(val.amount).mul(bn(10).pow(bn(18)))).toString() for val in arr)

		for j in [0..5]
			res = await sender.bulkTransfer '0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, {nonce}
			log res
			nonce += 1

	await delay 1000


#	log nonce

#// for(let i = 0; i < data.length; i += size)
#// {
#// 	const slice = data.slice(i, i + size);
#// 	const ids = slice.map(s => s[0]);
#// 	const receivers = slice.map(s => s[1]);
#// 	const amounts = slice.map(s => s[2].mul(new BigNumber(10).pow(18)));
#//
#// 	// console.log(ids, receivers, amounts);
#//
#// 	console.log(`last processed address: ${receivers[receivers.length - 1]}`);
#//
#// 	for(let j = 0; j < 5; j++)
#// 		sender.bulkTransfer('0xbf799a2f71d020a4a8c10e7406e2bf970b3d734b', ids, receivers, amounts, {nonce: nonce++});
#//
#// 	sleep.sleep(1);
#// }
