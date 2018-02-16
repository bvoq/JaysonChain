pragma solidity ^0.4.18;

//For terminology purposes, the user that creates the contract is called the owner and the users using the contract as a messaging system are called accounts.
contract DecentralisedMessaging {
    //Everyone that wants to use this contract must generate a private and public key according to some asymmetrical cryptograhy method, for example RSA.
    //Then he needs to call initAccount
    
    modifier accountInitialized(address _address) {
        require(accountDatas[_address].account != 0);
        _;
    }

    struct AccountData {
        address account;
        uint256 publicKey;
    }
    mapping(address => AccountData) accountDatas;

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
    MessageTableEntry[] messageTable;


    //In order to send a message, you have to encrypt the parameters of sendMessage with the public key of the receiver.
    function sendMessage(string _encryptedTo, string _encryptedMessage) public accountInitialized(msg.sender) {
        MessageTableEntry memory messageTableEntry;
        messageTableEntry.sender = msg.sender;
        messageTableEntry.unixTime = now;

        messageTableEntry.encryptedTo = _encryptedTo; 
        messageTableEntry.encryptedMessage = _encryptedMessage;
        messageTable.push(messageTableEntry);
    }

    //In order to read a message 
    function getMessage(uint256 _messageIndex) view public accountInitialized(msg.sender)
    returns (address sender, uint256 unixTime, string encryptedTo, string encryptedMessage) {
        return (messageTable[_messageIndex].sender, messageTable[_messageIndex].unixTime, messageTable[_messageIndex].encryptedTo, messageTable[_messageIndex].encryptedMessage);
    }
}