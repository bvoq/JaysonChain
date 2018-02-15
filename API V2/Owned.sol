pragma solidity ^0.4.19;
// Owner-specific contract interface
contract Owned {
	event NewOwner(address indexed old, address indexed current);

	modifier only_owner {
		require (msg.sender == owner);
		_;
	}

	address public owner = msg.sender;

	function setOwner(address _new) public only_owner {
		NewOwner(owner, _new);
		owner = _new;
	}
}