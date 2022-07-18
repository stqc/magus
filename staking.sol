pragma solidity >=0.8.0;

//SPDX-License-Identifier: Unlicensed
//code by stqc aka JdBomb https://github.com/stqc

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

contract stakeMagus{

    address public rewardsPool=0x3928a2798a0c857D286d657De9F7D286B08198Ae;
    address public magus=0x494b36A18778cE24A5179925c2d43590DB4ebFd6;
    address owner;
    uint256 public earlyClaimTax=30;
    uint256 public rewardsPercentage = 10;
    uint256 public minimumStakeDays= 10;
    bool public isPoolAlive=true;

    mapping(address=>uint256) public amountAdded;
    mapping(address=>uint256) public stakedAtTime;
    mapping(address=>uint256) public lastClaim;

    constructor(){
        owner = msg.sender;
    }
    
    modifier onlyBigDadday{
        require(msg.sender==owner,"You are not the owner");
        _;
    }

    function changeEarlyClaimTax(uint256 newTax) external onlyBigDadday{
        earlyClaimTax = newTax;
    }

    function killPool() external onlyBigDadday{
        isPoolAlive=false;
    }
    function daySince(address sender) public view returns(uint256){
         if(block.timestamp<lastClaim[sender] || lastClaim[sender]==0){
                return 0;
            }
            uint256 daysPassed = (block.timestamp-lastClaim[sender])/86400;
            return daysPassed;
    }
    function amountDue(address sender) public view  returns(uint256){ 
            uint256 daysPassed = daySince(sender);
            uint256 amountToBePaid = ((amountAdded[sender]*10*daysPassed*10**6)/365)/100;
        return amountToBePaid;
    }


    function stake(uint256 amount) external {
         require(isPoolAlive,"pool not active");
         harvest(msg.sender);
         stakedAtTime[msg.sender] =block.timestamp;
         IBEP20 mag = IBEP20(magus);
         mag.transferFrom(msg.sender,address(this),amount);
         amountAdded[msg.sender] += amount;


    }

    function unstake() external{
        IBEP20 mag = IBEP20(magus);
        harvest(msg.sender);
        mag.transferFrom(msg.sender,address(this),amountAdded[msg.sender]);
        amountAdded[msg.sender]=0;
    }

    function harvest(address sender) public{
        require(isPoolAlive,"pool not active");
        IBEP20 mag = IBEP20(magus);
        uint256 claimTax=0;
        if(block.timestamp-stakedAtTime[sender]<minimumStakeDays*1 days){
            claimTax = earlyClaimTax;
        }
        if(amountAdded[sender]>0 && lastClaim[sender]>0){
            uint256 amountToBePaid = amountDue(sender);
            amountToBePaid = amountToBePaid-((amountToBePaid*claimTax)/100);
            uint256 amountForPool = (amountToBePaid*claimTax)/100;
            mag.transfer(sender,amountToBePaid/10**6);
            mag.transfer(rewardsPool,amountForPool/10**6);
        }
        if(lastClaim[sender]>0){
            lastClaim[sender]+=daySince(sender)*1 days;
        }else{
            lastClaim[sender]=block.timestamp;
        }

    }

    function emergencyWithdraw() external {
        require(msg.sender==owner);
        IBEP20 mag = IBEP20(magus);
        mag.transfer(owner,mag.balanceOf(address(this)));
    }


}
