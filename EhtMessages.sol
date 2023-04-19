// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VotingSystem {
    struct Message {
        uint id;
        uint timestamp;
        address from;
        string text;
        uint votes;
    }
    
    mapping(uint => Message) public messages;
    uint public messageCount;
    
    function addMessage(string memory _text) public {
        messages[messageCount] = Message(
            messageCount, 
            block.timestamp, 
            msg.sender, 
            _text, 
            0
        );
        messageCount++;
    }
    
    function vote(uint _messageId) public {
        require(_messageId < messageCount, "Invalid message ID");
        messages[_messageId].votes++;
    }
    
    function getMessages() public view returns (string[] memory,  uint[] memory, uint[] memory) {
        string[] memory texts = new string[](messageCount);
        uint[] memory votes = new uint[](messageCount);
        uint[] memory ids = new uint[](messageCount);
        
        for (uint i = 0; i < messageCount; i++) {
            texts[i] = messages[i].text;
            ids[i] = i;
            votes[i] = messages[i].votes;
        }
        
        for (uint i = 0; i < messageCount - 1; i++) {
            for (uint j = i + 1; j < messageCount; j++) {
                if (votes[j] > votes[i]) {
                    uint tempVotes = votes[i];
                    uint tempId = ids[i];
                    string memory tempText = texts[i];
                    
                    votes[i] = votes[j];
                    ids[i] = ids[j];
                    texts[i] = texts[j];
                    
                    votes[j] = tempVotes;
                    ids[j] = tempId;
                    texts[j] = tempText;
                }
            }
        }
        
        return (texts, ids, votes);
    }
}