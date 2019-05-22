pragma solidity ^0.5.0;


contract ERC20Basic
{
	function totalSupply() public view returns (uint256);

	function balanceOf(address who) public view returns (uint256);

	function transfer(address to, uint256 value) public returns (bool);

	event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic
{
	function allowance(address owner, address spender) public view returns (uint256);

	function transferFrom(address from, address to, uint256 value) public returns (bool);

	function approve(address spender, uint256 value) public returns (bool);

	event Approval(address indexed owner, address indexed spender, uint256 value);
}




contract MultisigWallet
{
	// Funds has arrived into the wallet (record how much).
	event Deposit(address indexed _from, uint256 _value);
	event Execute(address indexed _owner, uint256 _value, address indexed _to, ERC20 _token);
	event Conmfirm(address indexed _owner);
	event Rollback(address indexed _owner);

	address public owner1;
	address public owner2;

	address public initiator;
	address payable public to;
	uint256 public amount;
	ERC20 public token;

  constructor(address _owner1, address _owner2) public
	{
		require(_owner1 != address(0));
		require(_owner2 != address(0));
		require(_owner1 != owner2);

		owner1 = _owner1;
		owner2 = _owner2;
	}


  /**
   * @dev Fallback function, receives value and emits a deposit event.
   */
  function() external payable
	{
    // just being sent some cash?
    if (msg.value > 0)
      emit Deposit(msg.sender, msg.value);
  }

  /**
   * @param _to The receiver address
   * @param _value The value to send
   */
  function execute(address payable _to, uint256 _value, ERC20 _token) external
	{
		require((msg.sender == owner1) || (msg.sender == owner2));
		require(_to != address(0));
		require(_value > 0);

		initiator = msg.sender;
		to = _to;
		amount = _value;
		token = _token;

		emit Execute(msg.sender, amount, to, token);
  }

  function confirm() external
	{
		require((msg.sender == owner1) || (msg.sender == owner2));
		require(msg.sender != initiator);
		require(to != address(0));
		require(amount > 0);

		if(token == ERC20(address(0)))
		{
			address payable tmp_to = to;
			uint tmp_amount = amount;

			initiator = address(0);
			to = address(0);
			amount = 0;

			tmp_to.transfer(tmp_amount);

			emit Conmfirm(msg.sender);
		}
		else
		{
			address payable tmp_to = to;
			uint tmp_amount = amount;
			ERC20 tmp_token = token;

			initiator = address(0);
			to = address(0);
			amount = 0;
			token =	ERC20(address(0));

			require(tmp_token.transfer(tmp_to, tmp_amount));

			emit Conmfirm(msg.sender);
		}
  }

	function rollback() external
	{
		require(msg.sender == initiator);
		initiator = address(0);
		to = address(0);
		amount = 0;
		token = ERC20(address(0));

		emit Rollback(msg.sender);
	}

}
