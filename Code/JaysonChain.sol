pragma solidity ^0.4.19;

import "./Owned.sol";

contract JaysonChain is Owned {
	
	modifier isAssetOwner(uint assetID){
	    require(msg.sender == allAssets[assetID].owner);
	    _;
	}
	
	struct Attribute {
	    uint attributeID;
	    string name;
	    string data;
	}
	
	
	struct WriteEntry {
	    string 
	}
	
	struct Asset {
		uint256 assetID;
		uint256 internalTime; //not unix time.
		uint256 unixTime = now;
	    address owner;

		Attribute[] history;
		
		mapping(address => string[]) permissionTable; //you can add attributes with the following names.
	}
	
	
	function allowWrite(uint assetID, address allowTo, string permissionNames) isAssetOwner(assetID){

	}
	
	function allowWrite(uint assetID, address allowTo, string[] permissionNames) isAssetOwner(assetID){
	    for(int i = 0; i < permissionNames.length; ++i) allowWrite(assetID, allowTo, permissionNames[i]);
	}
	
	Asset[] allAssets;
	
	function createAsset() public {
	    Asset newAsset;
	    newAsset.blockChainId = msg.sender;
	    newAsset.assetID = 12;
	}
	
	function addAttribute(uint assetID, string name, string data) public {
	    //TODO check if msg.sender may put name into allAssets[assetID].history, which we can check in permissionTable
	    //TODO make sure allowance is deleted from writeTable
	}
	
	function readAttribute(uint assetID, uint historyNo) public returns(Attribute) {
	    return allAssets[assetID].history[historyNo];
	}
	
	
	
	//consortium blockchain
	
	function createAsset() private {
	}
}

