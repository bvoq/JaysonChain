pragma solidity ^0.4.18;

contract DirectMessaging {
    struct WriteTableEntry {
        //This is public anyway, so we store it here.
        address sender;
        uint256 unixTime;

        string encryptedTo; //if decrypted, this is an address
        string encryptedMessage; //if decrypted, this is a string
    }
    WriteTableEntry[] writeTable;

    function sendMessage(string _encryptedTo, string _encryptedMessage) public {
        WriteTableEntry memory writeTableEntry;
        writeTableEntry.sender = msg.sender;
        writeTableEntry.unixTime = now;

        writeTableEntry.encryptedTo = _encryptedTo; 
        writeTableEntry.encryptedMessage = _encryptedMessage;
        writeTable.push(writeTableEntry);
    }

    function getMessage(uint256 entryIndex) view public returns (address sender, uint256 unixTime, string encryptedTo, string encryptedMessage) {
        return (writeTable[entryIndex].sender, writeTable[entryIndex].unixTime, writeTable[entryIndex].encryptedTo, writeTable[entryIndex].encryptedMessage);
    }
}

