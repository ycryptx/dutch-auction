pragma solidity ^0.4.18;
import "./Auction.sol";

contract DutchAuction is Auction {

    uint public initialPrice;
    uint public biddingPeriod;        //this makes the min cap implicit
    uint public offerPriceDecrement;  //the rate at which the price decrements

    uint public timer;
    address public sellerAddress;

    // constructor
    function DutchAuction(address _sellerAddress,
                          address _judgeAddress,
                          address _timerAddress,
                          uint _initialPrice,
                          uint _biddingPeriod,
                          uint _offerPriceDecrement) public
             Auction (_sellerAddress, _judgeAddress, _timerAddress) {

        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        offerPriceDecrement = _offerPriceDecrement;

        timer = time();
        sellerAddress = _sellerAddress;
    }


    function bid() public payable{
        uint margin = time() - timer;                                         //the time interval that already passed in the auction
        if (margin > biddingPeriod) suicide(msg.sender);                      //bid after the end period, return funds
        uint rightPrice = (initialPrice - (offerPriceDecrement * (margin)));  //calculate the current price
        if (msg.value >= rightPrice) {
          sellerAddress.transfer(rightPrice);
          suicide(msg.sender);                //MAYDAY!! does this act upon the correct contract balance a.k.a does msg.sender  work???
        };
        msg.sender.transfer(msg.value);
    }

}
