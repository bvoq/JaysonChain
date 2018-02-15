pragma solidity ^0.4.19;

import "./Owned.sol";

contract JaysonChain is Owned {
	
	modifier isAssetOwner(uint assetID){
	    require(msg.sender == allAssets[assetID].owner);
	    _;
	}
	
	
	uint256 public globalInternalTimeStamp = 0;
	struct Attribute {
	    address author; //= msg.sender;
	    uint256 attributeIndex;
	    uint256 internalTimeStamp; //not unix time.
		uint256 unixTime; // = now;
	    string name;
	    string data;
	}
	
		
	function addActualAttribute(uint assetIndex, string name, string data) private {
	    address author = msg.sender; 

	    //Check if author may put name into allAssets[assetID].history, which is done in the permissionTable
	    WritePermissionEntry[] permissions = allAssets[assetIndex].writePermissionTable[author];
	    bool mayWrite = false;
	    for(uint256 i = 0; i < permissions.length; ++i) 
	        if(keccak256(permissions[i].attributeName) == keccak256(name) && permissions[i].writeAmount >= 1)
	            mayWrite = true;
	    require(mayWrite);
	    
	    permissions[i].writeAmount--; //no underflow possible, since writeAmount ≠ 0
	   
	   
	    Attribute newAttribute;
	    newAttribute.author = author;
	    newAttribute.attributeIndex = allAssets[assetIndex].history.length;
	    newAttribute.internalTimeStamp = globalInternalTimeStamp;
	    newAttribute.unixTime = now;
	    newAttribute.name = name;
	    newAttribute.data = data;
	    
	    allAssets[assetIndex].history.push(newAttribute);
	}
	
	//in order to add a single attribute 
	function addAttribute(uint assetIndex, string name, string data) public {
        addActualAttribute(assetIndex, name, data);
	    globalInternalTimeStamp++;
	}
	
	/*
	function addAttributes(uint[] assetIndices, string[] attributeNames, string[] data) public {
	    //here all have the same timestamp
	    require(assetIndices.length == attributeNames.length && attributeNames.length == data.length);
	    for(uint256 i = 0; i < assetIndices.length; ++i) addActualAttribute(assetIndices[i], attributeNames[i], data[i]);
    	globalInternalTimeStamp++;
	}*/
	
	function readAttribute(uint assetIndex, uint attributeIndex) public returns(Attribute) {
	    return allAssets[assetIndex].history[attributeIndex];
	}
	
	struct WritePermissionEntry {
	    //TODO timeout
	    string attributeName;
	    uint256 writeAmount;
	}
	
	
	struct ReadPermissionEntry {
	    //This is the attribute index to which you want to give access to. 
	    uint256 encryptedAttributeIndex;
	    
	    //This is the symmetric key to read the attribute encrypted with the public key of the one, you want to give read access.
	    uint256 encryptedSymmetricKey;
	}
	
	struct Asset {
	    address owner;
		uint256 assetIndex;

		Attribute[] history;
		mapping(address => ReadPermissionEntry[]) readPermissionTable;
		mapping(address => WritePermissionEntry[]) writePermissionTable; //you can add attributes with the following names. Later add timeout.
	}
	
	
	
	Asset[] public allAssets;

	function createAsset() public returns(uint256) {
	    Asset newAsset;
	    newAsset.owner = msg.sender;
	    newAsset.assetIndex = allAssets.length;
	    allAssets.push(newAsset);
	    return newAsset.assetIndex;
	}
	
	function allowRead(uint assetIndex, address allowTo, uint256 encryptedAssetIndex, uint256 encryptedAttributeIndex, uint256 encryptedSymmetricKey) public isAssetOwner(assetIndex) {
	    ReadPermissionEntry newPermissionEntry;
	    newPermissionEntry.encryptedAttributeIndex = encryptedAttributeIndex;
	    newPermissionEntry.encryptedSymmetricKey = encryptedSymmetricKey;
	    allAssets[assetIndex].readPermissionTable[allowTo].push(newPermissionEntry);
	}

	function setAllowWrites(uint assetIndex, address allowTo, string attributeName, uint256 writeAmount) public isAssetOwner(assetIndex) {
	    //First check if it already exists and if so set to the new writeAmount 
	    for(uint256 i = 0; i < allAssets[assetIndex].writePermissionTable[allowTo].length; ++i) {
            bytes32 hash1 = keccak256(allAssets[assetIndex].writePermissionTable[allowTo][i].attributeName);
            bytes32 hash2 = keccak256(attributeName);
            if(hash1 == hash2) {
                allAssets[assetIndex].writePermissionTable[allowTo][i].writeAmount = writeAmount;
                return;
            }
        }
	    
	    WritePermissionEntry newPermissionEntry;
	    newPermissionEntry.attributeName = attributeName;
	    newPermissionEntry.writeAmount = writeAmount;
        allAssets[assetIndex].writePermissionTable[allowTo].push(newPermissionEntry);
	}
	

	/*
	function allowWrite(uint assetIndex, address allowTo, string[] permissionNames) public isAssetOwner(assetIndex){ //todo make free for owner
	    for(uint256 i = 0; i < permissionNames.length; ++i) allowWrite(assetIndex, allowTo, permissionNames[i]);
	}*/
	
	function disallowAllWrites(uint256 assetIndex, address disallowTo, string attributeName) public isAssetOwner(assetIndex) { //TODO
        setAllowWrites(assetIndex, disallowTo, attributeName, 0);
        /*
        //require(allAssets[assetIndex].writePermissionTable[disallowTo] != 0);
        for(uint256 i = 0; i < allAssets[assetIndex].writePermissionTable[disallowTo].length; ++i) {
            bytes32 hash1 = keccak256(allAssets[assetIndex].writePermissionTable[disallowTo][i].attributeName);
            bytes32 hash2 = keccak256(attributeName);
            if(hash1 == hash2) {
                allAssets[assetIndex].writePermissionTable[disallowTo][i].writeAmount = 0;
            }
        }*/
	}
	
	
	//"verify" is an attribute
	//"attributeX was wrong" is a new attribute 
	
}

