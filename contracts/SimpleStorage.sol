// SPDX-License-Identifier: MIT
// I'm a comment!

pragma solidity ^0.8.8;
// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {

    uint256 favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));// People memory newVar=  People({name:_name,favNumber:_favNum}); This also does the same , see the struct People and this statement that is commented out is based on the index in struct
        nameToFavoriteNumber[_name] = _favoriteNumber; // or totally write like this then no need for even newVar see...  people.push(People(_name,_favNum));

    }
}