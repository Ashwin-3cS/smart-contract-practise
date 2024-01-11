//SPDX-License-Identifier:MIT
pragma solidity 0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract FundMe{
    uint256 public minimumUsd=  50 * 1e18; //Solidity basically has problem handling Decimals , in conversion rate function it gives the opwith 18 decimals make sure you have 18 decimals equally everywhere
    address[] public funders;
    mapping( address => uint256 )public addressToAmountFunded;





    function fund()public payable {
        require(getConversionRate(msg.value)>=minimumUsd,"did'nt send enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=msg.value;
    }

    function getPrice()public view returns (uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,)=priceFeed.latestRoundData();
        return uint256(price*1e10);// Typecasting ;since price is int256 because sometimes eth value maybe gets to '-' so to be it flexible its give int256 in the interface of dataFeed of chainlink;and while when we multiply to 1e10 its uint256 right so we cant multiply with int256* uint256 so ; typecasting..  
    }
    function getVersion()public view returns (uint256){ // This getversion tells the  latest version of chainlink
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount )public view returns (uint256){
        uint256 ethPrice=getPrice();
        uint256 ethAmountInUsd=(ethPrice*ethAmount)/1e18;
        return ethAmountInUsd;

    }
    }
