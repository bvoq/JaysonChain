pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

contract MinimalDecentralMessage {
    struct AccountData {
        uint256 publicKey;
    }
    mapping(string => AccountData) accountDatas;
    string[] users;

    function initAccount (string _username, uint256 _publicKey) public {
        //checks if the account was never initialised before
        require(accountDatas[_username].publicKey == 0);
        AccountData memory accountData;
        accountData.publicKey = _publicKey;
        accountDatas[_username] = accountData;
        users.push(_username);
    }
    function getUsers() public view returns (string[] userout) { return users; }
    function getAccountData(string _user) public view returns (uint256 _publicKey) { return accountDatas[_user].publicKey; }

    struct MessageTableEntry {
        string message;
    }
    MessageTableEntry[] messageTable;

    function addMessage(string _message, uint256 _expectedIndex) public {
        //guarantee that message will be inserted at expected index. Required for cryptographic uses.
        require(messageTable.length == _expectedIndex);
        MessageTableEntry memory entry;
        entry.message = _message;
        messageTable.push(entry);
    }

    function getMessage(uint256 _messageIndex) public view
    returns (string message) {
        require(messageTable.length > _messageIndex);
        MessageTableEntry storage entryPointer = messageTable[_messageIndex];
        return (entryPointer.message);
    }
    
    function getTableLength() public view returns (uint256 length) { return messageTable.length; }
}
