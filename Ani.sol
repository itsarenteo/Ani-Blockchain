pragma solidity ^0.8.0;

//Define contract
contract Ani{
	address owner;
	string itemName;
	uint256 massInGrams;
	uint256 currentValue;
	uint256 farmGateValue;
	uint256 daysSinceHarvest;

	modifier isHolder() {
        require(msg.sender == holder, “You are not the holder!”);
        _;
    }

    constructor() { 
        holder = msg.sender;
        totalSupply = initialSupply;
        balances[holder] = totalSupply;
    }

    function transfer(address add) external isHolder { //
        holder = add;
    }

    function checkHolder() external  view isHolder returns (string memory) { //
        return "I am still the holder!";
    }
}