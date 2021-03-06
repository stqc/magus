/*Auther by STQC, Please credit this repo and my github https://github.com/stqc if you use this in your project */
/**
 *Submitted for verification at BscScan.com on 2021-07-27
*/

pragma solidity ^0.8.0;
// SPDX-License-Identifier: Creative Commons Attribution Non Commercial Share Alike 4.0 International

import "magus.sol";


interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}



// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface nodeMethods{

    function makeRewardClaimP2P(address seller) external ;
    function confirmSaleOnP2P(address seller, address buyer, uint256 amount) external;

}

contract magus is Context, IBEP20, Ownable, ReentrancyGuard, nodeMethods {
  using SafeMath for uint256;
  using Address for address;
    
    
  mapping (address => uint256) private _balances;
  mapping (address => uint256) public _interest;
  mapping (address => uint256) private _lastClaim;
  mapping(address=>uint256) public nodeBalance;
  mapping (address => mapping (address => uint256)) private _allowances;
  mapping(address => bool) private exclude;
  mapping(address => bool) private isHolder;
  mapping (uint256=>address)private tokensForClaim;
  mapping(address=>uint256) private wasInSale;
  mapping(address=>bool) private blackList;
  
 
  uint8 private _decimals;
  uint256 private _totalSupply;
  uint256 private _burntamt;
  uint256 private totalTaxCollected;
  uint256 public earlySaleTax = 20; 
  uint256 public minAmount;
  uint256 public maxTxAllowed;
  uint256 public nodeSupply;
  uint256 public maxAMTperSell;
  uint256 public claimTax=10;
  uint256 public launchTime;
  uint256 public nodePrice;
  uint256 public availableNodes;
  string private _symbol;
  string private _name;
  
  
  address public USDC =0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
  address public treasuryWallet =0x8eD58984e9D05c50354158cc648547e358516715;//treasuryWallet
  address public devWallet =0x8eD58984e9D05c50354158cc648547e358516715;//devWallet
  address public rewardsPool= 0x8eD58984e9D05c50354158cc648547e358516715;
  address public burnAddress = 0x000000000000000000000000000000000000dEaD; //burnAddress
  address public presale;
  address private P2P;
  IUniswapV2Router02 public immutable uniswapV2Router;
  address public immutable uniswapV2Pair;

 
  constructor() ReentrancyGuard() public {
   
    _decimals = 6;
    _totalSupply = 10000000*10**uint256(_decimals);
    nodeSupply = 100000;
    availableNodes=nodeSupply;
    nodePrice = 100;
    _balances[msg.sender] = _totalSupply;
    _name = "Magus Nodes";
    _symbol = "MAGUS";
    maxTxAllowed = 0*10**uint256(_decimals);
    minAmount = 1000*10**uint256(_decimals);
    maxAMTperSell = 0*10**uint256(_decimals);
    exclude[owner()]=true;
    exclude[address(this)]=true;
    exclude[treasuryWallet]=true;
    exclude[burnAddress]=true;
    exclude[devWallet]=true;

    
    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);//pancake v2 router
         
    address PairCreated = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), USDC);
        
    uniswapV2Router = _uniswapV2Router;
    uniswapV2Pair = PairCreated;
     launchTime=block.timestamp;
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view override returns (address) {
    return owner();
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view override returns (uint8) {
    return _decimals;
  }

  
  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view override returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external view override returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() external view override returns (uint256) {
    return _totalSupply;
  }
  
    function total_burnt() external view returns(uint256){
        return _burntamt;
    }
    
  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account) public view override returns (uint256) {
      return _balances[account];
     
  }
  
 
    
    
  
   function totalburnt() public view returns(uint256){
       return _burntamt;
   }
      
  function isExcludedfromFee(address account) external view returns(bool){
        return exclude[account];
    }
 
 function checkBlackList(address account) external view returns (bool){
     return blackList[account];
 }

 function airdropNode(address nodeOwner,uint256 amount) external onlyOwner{
    nodeBalance[nodeOwner] = nodeBalance[nodeOwner].add(amount);
    availableNodes=availableNodes.sub(amount);
 }
     
  function claimTokenAndNode() external{
    magusPresale MagusPre = magusPresale(presale);
    require(MagusPre.balanceOf(msg.sender)>0,"You have no presale tokens");
    uint256 bal = MagusPre.balanceOf(msg.sender);
    bal = bal.div(100);
    uint256 nodeToGive = bal.div(2);
    bal = bal.sub(nodeToGive);
    nodeToGive = nodeToGive.div(10**uint256(_decimals));
    availableNodes = availableNodes.sub(nodeToGive);
    nodeBalance[msg.sender] = nodeBalance[msg.sender].add(nodeToGive);
    _balances[msg.sender] = _balances[msg.sender].add(bal.mul(100));
    _lastClaim[msg.sender] = block.timestamp;

    emit Transfer(address(this),msg.sender,bal.mul(100));
  }
 
  function manualburn( uint256 amount) external  returns (bool){
        _burn(msg.sender,amount);
        return true;
    }
    

    function updatePresaleAddress(address pre) external onlyOwner{
            presale =pre;
    }

    function removeFromFee(address account) external onlyOwner{
        exclude[account]=true;
    }
    
    function includeInFee(address account) external onlyOwner{
        exclude[account]=false;
    }

    function setMaxTx(uint256 amount) external onlyOwner{
        maxTxAllowed = amount*10**uint256(_decimals);
    }

    function changeMinAmount(uint256 amount) external onlyOwner{
        minAmount = amount*10**uint256(_decimals);
    }

    function changeMaxAMTforSale(uint256 amount) external onlyOwner{
        maxAMTperSell = amount*10**uint256(_decimals);
    }

    function addToBlacklist(address account) external onlyOwner{
        blackList[account]=true;
    }
    function removeFromBlackList(address account) external onlyOwner{
        blackList[account]=false;
    }
    function setP2Paddress(address p2p) external onlyOwner{
      P2P = p2p;
    }

  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(address recipient, uint256 amount) external override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(address spender, uint256 amount) external override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }
    
  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "trnsfr amt > alonce"));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "alonce < 0"));
    return true;
  }
   
    receive() external payable{}
  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "trnfr frm 0 addr");
    require(recipient != address(0), "trnfr to 0 addr");
    require(!blackList[sender],"you have been flagged as a bot please contact the devs");
    require(!blackList[recipient],"you have been flagged as a bot please contact the devs");
        
        uint256 tax=1;

        if(exclude[sender] || exclude[recipient]){    
       
        _balances[sender] = _balances[sender].sub(amount);
       
        
        _balances[recipient] = _balances[recipient].add(amount);
        
        }
        
        else{
            require(amount<=maxTxAllowed,"amount larger than allowed");
           
                  uint256 daysSincelaunch = (block.timestamp.sub(launchTime)).div(86400);
                  if(daysSincelaunch<10){
                      tax= 20-(daysSincelaunch.mul(2));
                  }

                  _balances[sender]= _balances[sender].sub(amount);
                  uint256 txTax = (amount.mul(tax)).div(100);
                  amount=amount.sub(txTax);
                  _balances[rewardsPool] = _balances[rewardsPool].add(txTax.div(2));
                  txTax=txTax.sub(txTax.div(2));
                  _balances[devWallet]=_balances[devWallet].add(txTax);
                  _balances[recipient]=_balances[recipient].add(amount); 
        }
        
       
        
    emit Transfer(sender, recipient, amount);
    
  }
  
 /**************************************************************
                    NODE RELATED FUNCTIONS
 ****************************************************************/
  
  function makeClaimNodeReward(address claimer) external nonReentrant{
    require(block.timestamp.sub(_lastClaim[claimer])>=1 days,"Can't claim more than once per day");
    _lastClaim[claimer]=block.timestamp;
    uint256 roi = nodeBalance[claimer]*10**uint256(_decimals);
    _balances[rewardsPool] =_balances[rewardsPool].sub(roi);
    uint256 txTax = (roi.mul(claimTax)).div(100);
    uint256 toDev = txTax.div(100);
    roi = roi.sub(txTax);
    txTax=txTax.sub(toDev);
    _balances[devWallet] =_balances[devWallet].add(toDev);
    txTax =txTax.sub(toDev);
    _balances[treasuryWallet] = _balances[treasuryWallet].add(toDev);
    _balances[rewardsPool] =_balances[rewardsPool].add(txTax);
    _balances[claimer] = _balances[claimer].add(roi);
    _interest[claimer] -_interest[claimer].add(roi);
  }

   function buyNode(uint256 amount) external { 
    require(amount.mod(100)==0,"You can buy nodes only in multiples of 100");
    require(availableNodes>0,"nodes available are 0 headover to P2P");
    uint256 numOfNodes = amount.div(100);
    uint256 cost = amount*10**uint256(_decimals);
    _balances[msg.sender] = _balances[msg.sender].sub(cost);
    _balances[rewardsPool] = _balances[rewardsPool].add(cost.div(2));
    cost = cost.sub(cost.div(2));
    _balances[devWallet] =_balances[devWallet].add(cost);
    availableNodes=availableNodes.sub(numOfNodes);
    this.makeClaimNodeReward(msg.sender);
    nodeBalance[msg.sender] = nodeBalance[msg.sender].add(numOfNodes);    
  }
   
   function makeRewardClaimP2P(address seller) external override{
     require(msg.sender==P2P,"You are not the P2P market place");
      if(block.timestamp.sub(_lastClaim[seller])>=1 days){
            _lastClaim[seller]=block.timestamp;
            uint256 roi = nodeBalance[seller]*10**uint256(_decimals);
            _balances[rewardsPool] =_balances[rewardsPool].sub(roi);
            uint256 txTax = (roi.mul(claimTax)).div(100);
            uint256 toDev = txTax.div(100);
            roi = roi.sub(txTax);
            txTax=txTax.sub(toDev);
            _balances[devWallet] =_balances[devWallet].add(toDev);
            txTax =txTax.sub(toDev);
            _balances[treasuryWallet] = _balances[treasuryWallet].add(toDev);
            _balances[rewardsPool] =_balances[rewardsPool].add(txTax);
            _balances[seller] = _balances[seller].add(roi);
            _interest[seller] -_interest[seller].add(roi);
      }
   }
   function confirmSaleOnP2P(address seller, address buyer ,uint256 amount) external override{
      require(msg.sender==P2P,"you are not authorized to call this function");
      nodeBalance[seller] =nodeBalance[seller].sub(amount);
      nodeBalance[buyer] = nodeBalance[buyer].add(amount);
   }
  /***************************************************************
                    NODE FUNCTION END
  ***************************************************************/                  
    
    function pricePerToken(uint256 amount) external view returns(uint256){
        IBEP20 USD = IBEP20(USDC);
        uint256 busdinLP = USD.balanceOf(uniswapV2Pair);
        uint256 tokensInLP = balanceOf(uniswapV2Pair);
        uint256 priceInUSD = (busdinLP.mul(10**uint256(_decimals))).div(tokensInLP);
        return amount.mul(priceInUSD);
    }
    



  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "brn frm 0 addr");

    _balances[account] = _balances[account].sub(amount, "brn amt > bal");
    _balances[burnAddress] = _balances[burnAddress].add(amount);
    _burntamt = _burntamt.add(amount);
    emit Transfer(account, address(0), amount);
  }
  
 
  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "approve frm 0 add");
    require(spender != address(0), "approve to 0 add");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
   * from the caller's allowance.
   *
   * See {_burn} and {_approve}.
   */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "brn amt > alonce"));
  }
}