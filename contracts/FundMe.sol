//SPDX-License-Identifier:MIT
pragma solidity 0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract FundMe{
    uint256 public minimumUsd=  50 * 1e18; //Solidity basically has problem handling Decimals , in conversion rate function it gives the opwith 18 decimals make sure you have 18 decimals equally everywhere
    // This line declares a public variable minimumUsd of type uint256 and initializes it with the value of 50 Ether converted to Wei (Wei is the smallest unit of Ether, and 1e18 represents 1 Ether in Wei). This variable represents the minimum amount of Ether in USD required for funding.
    address[] public funders;
    mapping( address => uint256 )public addressToAmountFunded;

    function fund()public payable {
        require(getConversionRate(msg.value)>=minimumUsd,"did'nt send enough eth");
        //1eth = 1000000000000000000 (18 decimal places)
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=msg.value;
    }

    function getPrice()public view returns (uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,)=priceFeed.latestRoundData();
        //the above line gives eth in terms of usd eg:3000 (00000000) 8 decimal places so ; but if you see msg.value which contains 18 dec places so see below step where we multiply 3000.... * 1e18 to have same decimal number as msg.value
        return uint256(price*1e10);// Typecasting ;since price is int256 because sometimes eth value maybe gets to '-' so to be it flexible its give int256 in the interface of dataFeed of chainlink;and while when we multiply to 1e10 its uint256 right so we cant multiply with int256* uint256 so ; typecasting..  
    }
    function getVersion()public view returns (uint256){ // This getversion tells the  latest version of chainlink
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount )public view returns (uint256){
        uint256 ethPrice=getPrice();
        //eth amount eg: 1eth that is in wei 1000000000000000000
        //ethPrice which holds the getprice() that is in wei 3000 000000000000000000000
        uint256 ethAmountInUsd=(ethPrice*ethAmount)/1e18;
        return ethAmountInUsd;

    }
    }
