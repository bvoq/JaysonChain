pragma solidity ^0.4.18;

contract DirectMessagingKnowable {
    struct WriteTableEntry {
        //This is public anyway, so we store it here.
        address sender;
        uint256 unixTime;

        string encryptedTo; //if decrypted, this is an address
        string encryptedMessage; //if decrypted, this is a string
    }
    WriteTableEntry[] writeTable;

    struct OwnerData {
        address owner; 
        uint256 mostRecentlyReadMessage;
    }
 
    mapping(address => OwnerData) ownerDatas;
    function initAccount () public {
        require(ownerDatas[msg.sender].owner == 0); //only initialise, if not yet initialised.
        OwnerData memory ownerData;
        ownerData.owner = msg.sender;
        ownerData.mostRecentlyReadMessage = writeTable.length-1; //he did not receive a message if he didn't exist on the blockchain before. Technically somoene could send him a message before, but it doesn't matter.
        ownerDatas[msg.sender] = ownerData;
    }

    function sendMessage(string _encryptedTo, string _encryptedMessage) public {
        WriteTableEntry memory writeTableEntry;
        writeTableEntry.sender = msg.sender;
        writeTableEntry.unixTime = now;

        writeTableEntry.encryptedTo = _encryptedTo; 
        writeTableEntry.encryptedMessage = _encryptedMessage;
        writeTable.push(writeTableEntry);
    }

    function getMessage(uint256 _entryIndex) public returns (address sender, uint256 unixTime, string encryptedTo, string encryptedMessage) {
        require(_entryIndex <= ownerDatas[msg.sender].mostRecentlyReadMessage + 1); //This forces him to read only messages he read before or he can read one new message in order.
        if(_entryIndex > ownerDatas[msg.sender].mostRecentlyReadMessage) ownerDatas[msg.sender].mostRecentlyReadMessage = _entryIndex;

        return (writeTable[_entryIndex].sender, writeTable[_entryIndex].unixTime, writeTable[_entryIndex].encryptedTo, writeTable[_entryIndex].encryptedMessage);
    }
}