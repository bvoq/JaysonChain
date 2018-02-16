pragma solidity ^0.4.18;

//For terminology purposes, the user that creates the contract is called the owner and the users using the contract as a messaging system are called accounts.
contract DirectMessagingKnowable {

    //Everyone that wants to use this contract must generate a private and public key according to some asymmetrical cryptograhy method, for example RSA.
    //Then he needs to call initAccount

    //The directMessagingKnowable adds the additional functionality that we can see whether a message was read.
    //This is done by adding a new information to AccountData, namely mostRecentlyReadIndex, which can be updated by the reader.
    //Messages should be read one after another in the messageTable 
    //If the user follows the protocol, you can now be sure that the receiver read the message, if mostRecentlyReadIndex is greater than the message index you sent.
    //This system basically works the same way WhatsApps blueflag system works, you can either tell everyone when you read the messages or nobody.
    //If you only want to notify certain people that you read their messages, you can create a new account for these specific people.

    //This system also enables a way to remember, what the last message was you read from the messageTable.

    modifier accountInitialized(address _address) {
        require(accountDatas[_address].account != 0);
        _;
    }

    struct AccountData {
        address account;
        uint256 publicKey;
        uint256 mostRecentlyReadIndex;
    }
    mapping(address => AccountData) accountDatas;

    function initAccount (uint256 _publicKey) public {
        require(accountDatas[msg.sender].account == 0); //checks if the account was never initialised before.
        AccountData memory accountData;
        accountData.account = msg.sender;
        accountData.publicKey = _publicKey;
        accountData.mostRecentlyReadIndex = messageTable.length - 1;
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

    function updateMostRecentlyReadIndex (uint256 _newIndex) public accountInitialized(msg.sender) {
        require(_newIndex < messageTable.length && accountDatas[msg.sender].mostRecentlyReadIndex < _newIndex);
        accountDatas[msg.sender].mostRecentlyReadIndex = _newIndex;
    }

    //In order to read a message 
    function getMessage(uint256 _messageIndex) view public accountInitialized(msg.sender)
    returns (address sender, uint256 unixTime, string encryptedTo, string encryptedMessage) {
        return (messageTable[_messageIndex].sender, messageTable[_messageIndex].unixTime, messageTable[_messageIndex].encryptedTo, messageTable[_messageIndex].encryptedMessage);
    }
}