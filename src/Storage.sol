// vesion
pragma solidity >=0.7.0 <0.9.0;



contract Storage {

    uint256 number;

    //like set
    function store(uint256 num) public {
        number = num;
    }

    //like get
    function retrieve() public view returns (uint256) {
        return number;
    }
}
