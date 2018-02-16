pragma solidity ^0.4.18;

//For terminology purposes, the user that creates the contract is called the owner and the users using the contract as a messaging system are called accounts.
contract DecentralisedMessagingKnowable {
    //DM Features (Decentralised Messaging):
    //Everyone that wants to use this contract must generate a private and public key according to some asymmetrical cryptograhy method, for example RSA.
    //Then he needs to call initAccount and publish his public key to the blockchain.
    //Using the blockchain we can now solve decentralised messaging as follows. Account A can send a message to account B using the following way:
    //1. Account A encrypts his message with a symmetric key, which is equal to the hash of the length of the messageTable.
    //This has to be a symmetric encryption scheme, where every possible hash can be used as a symmetric key.
    //For example: The length of the message table could be hashed using SHA-256. Then you use this 256 hash as a symmetric key for AES-256.
    //2. On top of that, account A then encrypts the message with the public key of account B.
    //3. Now account A writes to the messageTable, but this only works if the messageTable didn't in change in length. This can be achieved, by using the following method defined below:
    // function sendMessage(string _encryptedTo, string _encryptedMessage, uint256 _expectedLengthOfMessageTable);
    //If the length changed, the transaction will simply revert and account A has to retry (start at step 1 again).
    //4. Account B then decrypts every message he hasn't read yet with his private key. After this decryption he also decrypts the message with the hash of the messageTable index.
    //5. If the decrypted receiver address is equal to the address of account B, then B knows the message was intended for him. He also knows that the message is from A (proof of origin)
    //by checking MessageTableEntry.sender
    //6. He then only needs to decrypt the message with the same decryption scheme (first RSA, then AES-256 of the SHA-256 hash of the message index)


    //DMK Features (Decentralised Messaging Knowable):
    //The decentralisedMessagingKnowable contract adds the additional functionality that we can tell the other party that we read the message.
    //This is done by adding a new information to AccountData, namely mostRecentlyReadIndex, which can be updated by the reader.
    //If the reader sets mostRecentlyReadIndex, then he not only shows that he has read that particular message, but also every message, which came before that message.
    //This system basically works the same way WhatsApps doubleflag system works, you can either tell everyone when you received the messages or nobody.
    //You cannot receive some messages and not receive some previous ones.
    //If you only want to notify certain people that you read their messages, you can always create a new account for these specific people. Then you can tell some people you read the message and don't tell others.
    //Additionally, this system also enables a way to remember, what the last message was, that you read from the messageTable.
    //This way, if you read the messageTable from latest to most recent, you can just continue reading messages where you left off.

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

    function sendMessage(string _encryptedTo, string _encryptedMessage, uint256 _expectedLengthOfMessageTable) public accountInitialized(msg.sender) {
        require(_expectedLengthOfMessageTable == messageTable.length);
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

    function getMessage(uint256 _messageIndex) view public accountInitialized(msg.sender)
    returns (address sender, uint256 unixTime, string encryptedTo, string encryptedMessage) {
        return (messageTable[_messageIndex].sender, messageTable[_messageIndex].unixTime, messageTable[_messageIndex].encryptedTo, messageTable[_messageIndex].encryptedMessage);
    }
}