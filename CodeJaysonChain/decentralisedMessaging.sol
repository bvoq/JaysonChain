pragma solidity ^0.4.18;

//For terminology purposes, the user that creates the contract is called the owner and the users using the contract as a messaging system are called accounts.
contract DecentralisedMessaging {
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

    //Also the blockchain hinders spamming to the messageTable, since every add costs gas. Reads don't cost anything, so having a large messageTable wouldn't even charge gas, but would only cost more local computational time.

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
    function sendMessage(string _encryptedTo, string _encryptedMessage, uint256 _expectedLengthOfMessageTable) public accountInitialized(msg.sender) {
        require(_expectedLengthOfMessageTable == messageTable.length);
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
