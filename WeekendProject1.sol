// HelloWorld.sol
pragma solidity ^0.8.0;

contract HelloWorld {
    string public message;
    address public owner;

    constructor(string memory initialMessage) {
        message = initialMessage;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function setMessage(string memory newMessage) public onlyOwner {
        message = newMessage;
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
