pragma solidity ^0.4.19;

import "./Owned.sol";

contract JaysonChain is Owned {
	
	modifier isAssetOwner(uint assetID){
	    require(msg.sender == allAssets[assetID].owner);
	    _;
	}
	
	
	uint256 globalInternalTimeStamp = 0;
	struct Attribute {
	    address author; //= msg.sender;
	    uint256 attributeIndex;
	    uint256 internalTimeStamp; //not unix time.
		uint256 unixTime; // = now;
	    string name;
	    string data;
	}
		
	function addActualAttribute(uint assetIndex, string name, string data) private {
	    //TODO check if msg.sender may put name into allAssets[assetID].history, which we can check in permissionTable
	    //TODO make sure allowance is deleted from permissionTable	
	    Attribute newAttribute;
	    newAttribute.author = msg.sender;
	    newAttribute.attributeIndex = allAssets[assetIndex].history.length;
	    newAttribute.internalTimeStamp = globalInternalTimeStamp;
	    newAttribute.unixTime = now;
	    newAttribute.name = name;
	    newAttribute.data = data;
	}
	
	//in order to add a single attribute 
	function addAttribute(uint assetIndex, string name, string data) public {
        addActualAttribute(assetIndex, name, data);
	    globalInternalTimeStamp++;
	}
	
		
	function addAttributes(uint[] assetIndices, string[] attributeNames, string[] data) public {
	    //here all have the same timestamp
	    require(assetIndices.length == attributeNames.length && attributeNames.length == data.length);
	    for(uint256 i = 0; i < assetIndices.length; ++i) addActualAttribute(assetIndices[i], attributeNames[i], data[i]);
    	globalInternalTimeStamp++;
	}
	
	function readAttribute(uint assetIndex, uint historyNo) public returns(Attribute) {
	    return allAssets[assetIndex].history[historyNo];
	}
	
	struct PermissionEntry {
	    //TODO timeout
	    string attributeNames;
	}
	
	struct Asset {
	    address owner;
		uint256 assetIndex;

		Attribute[] history;
		
		mapping(address => PermissionEntry[]) permissionTable; //you can add attributes with the following names. Later add timeout.
	}
	Asset[] allAssets;

	function createAsset() public {
	    Asset newAsset;
	    newAsset.owner = msg.sender;
	    newAsset.assetIndex = allAssets.length;
	    allAssets.push(newAsset);
	}

	function allowWrite(uint assetIndex, address allowTo, string permissionName) private isAssetOwner(assetIndex) {
	    PermissionEntry newPermissionEntry;
	    newPermissionEntry.attributeNames = permissionName;
        allAssets[assetIndex].permissionTable[allowTo].push(newPermissionEntry);
	}
	
	function allowWrite(uint assetIndex, address allowTo, string[] permissionNames) public isAssetOwner(assetIndex){ //todo make free for owner
	    for(uint256 i = 0; i < permissionNames.length; ++i) allowWrite(assetIndex, allowTo, permissionNames[i]);
	}
	
	function disallowAllWrites(uint assetIndex, address disallowTo) public isAssetOwner(assetIndex) { //TODO
	    
	}
	
	
	//"verify" is an attribute
	//"attributeX was wrong" is a new attribute 

	
	
	


	
	
	
}

