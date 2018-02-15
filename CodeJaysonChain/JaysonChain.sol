pragma solidity ^0.4.19;

contract JaysonChain {
	
	modifier isAssetOwner(uint assetIndex){
	    require(msg.sender == allAssets[assetIndex].owner);
	    _;
	}
	
	modifier assetIndexInBound(uint assetIndex){
	    require(assetIndex < allAssets.length);
	    _;
	}
	
	modifier attributeIndexInBound(uint assetIndex, uint attributeIndex){
	    require(assetIndex < allAssets.length && attributeIndex < allAssets[assetIndex].history.length);
	    _;
	}
	
	
	uint256 public globalInternalTimeStamp = 0;
	
	struct Asset {
	    address owner;
		uint256 assetIndex;
		uint256 unixTime; //when this asset is created.
	    uint256 internalTimeStamp; //not unix time.

		Attribute[] history;
		mapping(address => ReadPermissionEntry[]) readPermissionTable;
		mapping(address => WritePermissionEntry[]) writePermissionTable; //you can add attributes with the following names. Later add timeout.
	}
	
	struct Attribute {
	    address author; //= msg.sender;
	    uint256 attributeIndex;
	    uint256 internalTimeStamp; //not unix time.
		uint256 unixTime; // = now;
	    string name;
	    string data;
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

	
	Asset[] public allAssets;
	Attribute[][] public allHistories;

	function createAsset() public returns(uint256) {
	    uint256 assetIndex = allAssets.length;
	    allHistories.push(new Attribute[](0));

	    Attribute[] storage hist = allHistories[assetIndex];
	    Asset memory newAsset = Asset({owner:msg.sender, assetIndex:assetIndex, unixTime:now, internalTimeStamp:globalInternalTimeStamp, history:hist});
	    allAssets.push(newAsset);
	    globalInternalTimeStamp++;
	    return newAsset.assetIndex;
	}
	
	
	
	function addAttribute(uint assetIndex, string name, string data) public
	assetIndexInBound(assetIndex)
	{
	    //TODO owner can always write and cannot give himself permission
        address author = msg.sender; 

	    //Check if author may put name into allAssets[assetID].history, which is done in the permissionTable
	    WritePermissionEntry[] memory permissions = allAssets[assetIndex].writePermissionTable[author];
	    bool mayWrite = false;
	    for(uint256 i = 0; i < permissions.length; ++i) {
	        if(keccak256(permissions[i].attributeName) == keccak256(name) && permissions[i].writeAmount >= 1){
	            mayWrite = true;   
	        }
	    }
	    require(mayWrite);
	    
	    permissions[i].writeAmount--; //no underflow possible, since writeAmount ≠ 0
	   
	   
	    Attribute storage newAttribute;
	    newAttribute.author = author;
	    newAttribute.attributeIndex = allAssets[assetIndex].history.length;
	    newAttribute.internalTimeStamp = globalInternalTimeStamp;
	    newAttribute.unixTime = now;
	    newAttribute.name = name;
	    newAttribute.data = data;
	    
	    allAssets[assetIndex].history.push(newAttribute);
	    globalInternalTimeStamp++;
	}
	
	
	//unimplemented function:
	/*
	function addAttributes(uint[] assetIndices, string[] attributeNames, string[] data) public {
	    //here all have the same timestamp
	    require(assetIndices.length == attributeNames.length && attributeNames.length == data.length);
	    for(uint256 i = 0; i < assetIndices.length; ++i) addActualAttribute(assetIndices[i], attributeNames[i], data[i]);
    	globalInternalTimeStamp++;
	}*/
	

	function readAttributeAuthor(uint assetIndex, uint attributeIndex) public view
	attributeIndexInBound(assetIndex, attributeIndex)
	returns(address author)
	{
	    return allAssets[assetIndex].history[attributeIndex].author;
	}
	
	
	function readAttributeInternalTimeStamp(uint assetIndex, uint attributeIndex) public view
	attributeIndexInBound(assetIndex, attributeIndex)
	returns(uint256 internalTimeStamp)
	{
	    return allAssets[assetIndex].history[attributeIndex].internalTimeStamp;
	}
	
	
	function readAttributeUnixTime(uint assetIndex, uint attributeIndex) public view
	attributeIndexInBound(assetIndex, attributeIndex)
	returns(uint256 internalTimeStamp)
	{
	    return allAssets[assetIndex].history[attributeIndex].unixTime;
	}
	
	function readAttributeName(uint assetIndex, uint attributeIndex) public view
	attributeIndexInBound(assetIndex, attributeIndex)
	returns(string name)
	{
	    return allAssets[assetIndex].history[attributeIndex].name;
	}
	
	
	function readAttributeData(uint assetIndex, uint attributeIndex) public view
	attributeIndexInBound(assetIndex, attributeIndex)
	returns(string data)
	{
	    return allAssets[assetIndex].history[attributeIndex].data;
	}
	

	function allowRead(uint assetIndex, address allowTo, uint256 encryptedAttributeIndex, uint256 encryptedSymmetricKey) public 
	isAssetOwner(assetIndex) 
	assetIndexInBound(assetIndex)
	{
	    require(assetIndex < allAssets.length);
	    ReadPermissionEntry storage newPermissionEntry;
	    newPermissionEntry.encryptedAttributeIndex = encryptedAttributeIndex;
	    newPermissionEntry.encryptedSymmetricKey = encryptedSymmetricKey;
	    allAssets[assetIndex].readPermissionTable[allowTo].push(newPermissionEntry);
	}


	function setAllowWrites(uint assetIndex, address allowTo, string attributeName, uint256 writeAmount) public 
	isAssetOwner(assetIndex) 
	assetIndexInBound(assetIndex)
	{
	    //First check if it already exists and if so set to the new writeAmount 
	    for(uint256 i = 0; i < allAssets[assetIndex].writePermissionTable[allowTo].length; ++i) {
            bytes32 hash1 = keccak256(allAssets[assetIndex].writePermissionTable[allowTo][i].attributeName);
            bytes32 hash2 = keccak256(attributeName);
            if(hash1 == hash2) {
                allAssets[assetIndex].writePermissionTable[allowTo][i].writeAmount = writeAmount;
                return;
            }
        }
	    
	    if(writeAmount == 0) return;
	     
	    WritePermissionEntry storage newPermissionEntry;
	    newPermissionEntry.attributeName = attributeName;
	    newPermissionEntry.writeAmount = writeAmount;
        allAssets[assetIndex].writePermissionTable[allowTo].push(newPermissionEntry);
	}


	function addAllowWrites(uint assetIndex, address allowTo, string attributeName, uint256 writeAmount) public 
	isAssetOwner(assetIndex) 
	assetIndexInBound(assetIndex)
	{
	    if(writeAmount == 0) return;
	    
	    //First check if it already exists and if so set to the new writeAmount 
	    for(uint256 i = 0; i < allAssets[assetIndex].writePermissionTable[allowTo].length; ++i) {
            bytes32 hash1 = keccak256(allAssets[assetIndex].writePermissionTable[allowTo][i].attributeName);
            bytes32 hash2 = keccak256(attributeName);
            if(hash1 == hash2) {
                //TODO checkOverflow
                allAssets[assetIndex].writePermissionTable[allowTo][i].writeAmount += writeAmount;
                return;
            }
        }
	    
	    WritePermissionEntry storage newPermissionEntry;
	    newPermissionEntry.attributeName = attributeName;
	    newPermissionEntry.writeAmount = writeAmount;
        allAssets[assetIndex].writePermissionTable[allowTo].push(newPermissionEntry);
	}

	
	function disallowAllWrites(uint256 assetIndex, address disallowTo, string attributeName) public
	isAssetOwner(assetIndex)
	{
        setAllowWrites(assetIndex, disallowTo, attributeName, 0);
	}
	
	
	//"verify" is an attribute
	//"attributeX was wrong" is a new attribute 
	
}

