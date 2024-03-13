
//version
pragma solidity >=0.7.0 <0.9.0;

contract Owner {

    address private owner;

    //set the address from one owner to other
    event OwnerSet(address indexed oldOwner, address indexed newOwner);


    // first argument-
    // if false -everything will cancel
    // second argument- 
    // to explain what the wrong
    modifier isOwner() {
        require(msg.sender == owner,"Caller is not owner");
        _;
    }

    //new owner- constructor
    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    //change owner
    function changeOwner(address newOwner) public isOwner {
       
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    //returns owner in the address
    function getOwner() external view returns (address) {
        return owner;
    }
} 
