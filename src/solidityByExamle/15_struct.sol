
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.24 and less than 0.9.0
pragma solidity ^0.8.18;

contract Todos{

    struct Todo{
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) public {
        todos.push(Todo({
            text: _text,
            completed: false
        }));
    }
    function get(uint256 index) public view returns(string memory text, bool completed){
        return (todos[index].text,todos[index].completed);
    }

}
