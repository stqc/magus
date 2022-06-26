pragma solidity >=0.8.0;

// SPDX-License-Identifier: No License


interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface nodeMethods{

   
    function confirmSaleOnP2P(address seller, address buyer, uint256 amount) external;

}

contract magusNodePeerExchange {

    struct orderData{
        uint256 nodeAmount;
        uint256 USDPrice;
        bool orderPlaced;
    }

    mapping(address=>orderData) public orders;
    mapping(address=>uint256) addressToIndex;
    mapping(uint256=>address) indexToAddress;

    address[] public orderPlacers;
    address public MagusAddress;
    address public USDC = 0xc21223249CA28397B4B6541dfFaEcC539BfF0c59;
    address public BigDaddy;
    bool occupied=false;

    uint256 platformFee = 10;
    
    modifier onlyDaddyCanTouchThis{
        require(msg.sender==BigDaddy,"You are not the Father");
        _;
    }

    modifier heyManThisIsOccupied{
        require(!occupied,"YO this is already occupied");
        occupied=true;
        _;
        occupied=false;

    }

    event orderPlaced(string);
    event orderCanceled(string);
    event orderCompleted(uint256 amount, address from, address to);

    constructor(){
        
        BigDaddy = msg.sender;
        MagusAddress = 0xA57ca211cd6820bd3d930978271538d07e31A212;
        orderPlacers.push(address(0));

    }

    function changeBigDaddy(address newDaddy) onlyDaddyCanTouchThis external{
        BigDaddy = newDaddy;
    }
    function changeMagusAddress(address newAddress) onlyDaddyCanTouchThis external{
        MagusAddress = newAddress;
    }

    function changeFee(uint256 newFee) onlyDaddyCanTouchThis external{
        platformFee = newFee;
    }
    
    function placeAnOrder(uint256 nodeAmount, uint256 USDPrice) external{
        require(!orders[msg.sender].orderPlaced,"You have already placed an order please cancel it or wait in order to place a new one");
        orderPlacers.push(msg.sender);
        orders[msg.sender].orderPlaced=true;
        orders[msg.sender].nodeAmount = nodeAmount;
        orders[msg.sender].USDPrice = USDPrice;
        indexToAddress[orderPlacers.length-1] = msg.sender;
        addressToIndex[msg.sender] = orderPlacers.length-1;
        emit orderPlaced("Your order has been placed");
    }

    function cancelAnOrder() external{
        require(orders[msg.sender].orderPlaced,"You have no orders placed yet");
        orderPlacers[addressToIndex[msg.sender]]=orderPlacers[orderPlacers.length-1];
        delete orderPlacers[orderPlacers.length-1];
        orders[msg.sender].orderPlaced=false;
        emit orderCanceled("Your Order has been canceled");
    }

    function completeTheOrder(address seller) heyManThisIsOccupied external{
        require(orders[seller].orderPlaced,"Order does not exist");
        nodeMethods Magus = nodeMethods(MagusAddress);
        IBEP20 USD = IBEP20(USDC);
        
        uint256 feeAmount = (orders[seller].USDPrice*10)/100;
        uint256 amountTobePaid = orders[seller].USDPrice-feeAmount;
        USD.transferFrom(msg.sender,BigDaddy,feeAmount);
        USD.transferFrom(msg.sender,seller,amountTobePaid);

        orderPlacers[addressToIndex[seller]]=orderPlacers[orderPlacers.length-1];
        delete orderPlacers[orderPlacers.length-1];
        Magus.confirmSaleOnP2P(seller,msg.sender,orders[seller].nodeAmount);
        orders[seller].orderPlaced=false;

        emit orderCompleted(orders[seller].nodeAmount,seller,msg.sender);
    }
}
