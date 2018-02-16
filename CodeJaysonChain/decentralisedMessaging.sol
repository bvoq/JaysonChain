pragma solidity ^0.4.18;

//For terminology purposes, the user that creates the contract is called the owner and the users using the contract as a messaging system are called accounts.
contract DecentralisedMessaging {
    //DM Features:
    //Everyone that wants to use this contract must generate a private and public key according to some asymmetrical cryptograhy method, for example RSA.
    //Then he needs to call initAccount and publish his public key to the blockchain.
    //If account A wants to send a message to account B, account A simply encrypts his message and the receiver account with the public key of account B and pushes it to the messageTable.
    //Account B locally reads all of the messageTable entries he didn't read already and tries to decrypt each message with his private key.
    //If it worked, the decrypted receive address should match the address of account B and the decrypted message can now be read by account B.
    
    modifier accountInitialized(address _address) {
        require(accountDatas[_address].account != 0);
        _;
    }

    struct AccountData {
        address account;
        uint256 publicKey;
    }
    mapping(address => AccountData) public accountDatas;

    function getPublicKey (address from) view public accountInitialized(msg.sender) accountInitialized(from) returns (uint256 publicKey) {
        return accountDatas[from].publicKey;
    }

    function initAccount (uint256 _publicKey) public {
        require(accountDatas[msg.sender].account == 0); //checks if the account was never initialised before.
        AccountData memory accountData;
        accountData.account = msg.sender;
        accountData.publicKey = _publicKey;
        accountDatas[msg.sender] = accountData;
    }


    struct MessageTableEntry {
        //This is public anyway, so we store it here.
        address sender;
        uint256 unixTime;

        string encryptedTo; //if decrypted, this is an address
        string encryptedMessage; //if decrypted, this is a string
    }
    MessageTableEntry[] public messageTable;


    //In order to send a message, you have to encrypt the parameters of sendMessage with the public key of the receiver.
    function sendMessage(string _encryptedTo, string _encryptedMessage) public accountInitialized(msg.sender) {
        MessageTableEntry memory messageTableEntry;
        messageTableEntry.sender = msg.sender;
        messageTableEntry.unixTime = now;

        messageTableEntry.encryptedTo = _encryptedTo; 
        messageTableEntry.encryptedMessage = _encryptedMessage;
        messageTable.push(messageTableEntry);
    }

    //This reads a message from the message table containing all the information (encryptedTo, encryptedMessage).
    //Locally the reader then needs to decrypt the encryptedTo with his private key and then needs to check whether the decrypted address is the same as the readers.
    //Then encryptedMessage needs to get decrypted with the readers private key to get the message.
    function getMessage(uint256 _messageIndex) view public accountInitialized(msg.sender)
    returns (address sender, uint256 unixTime, string encryptedTo, string encryptedMessage) {
        return (messageTable[_messageIndex].sender, messageTable[_messageIndex].unixTime, messageTable[_messageIndex].encryptedTo, messageTable[_messageIndex].encryptedMessage);
    }
}
