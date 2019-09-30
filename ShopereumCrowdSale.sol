pragma solidity 0.4.24;

import "./Crowdsale.sol";
import "./Ownable.sol";
import "./ShopereumToken.sol";
import "./ERC20.sol";


contract ShopereumCrowdSale is Crowdsale, Ownable {

  using SafeMath for uint;

  // 600M tokens at 20000 per eth is 30 000 ETH
  uint public constant ETH_CAP = 30000 * (10 ** 8);

  struct Stage {
    uint stageRate;     // tokens for one ETH
    uint stageCap;      // max ETH to be raised at this stage
    uint stageRaised;   // amount raised in ETH
  }

  Stage[7] public stages;

  uint public currentStage = 0;

  bool private isOpen = true;

  modifier isSaleOpen() {
    require(isOpen);
    _;
  }

  /**
  * @param _rate is the amount of tokens for 1ETH at the main event
  * @param _wallet the address of the owner
  * @param _token the address of the token contract
  */
  constructor(uint256 _rate, address _wallet, ShopereumToken _token) public Crowdsale(_rate, _wallet, _token) {
    // hardcode stages
    stages[0] = Stage(30000, 1500 * (10 ** 8), 0);
    stages[1] = Stage(25000, 4500 * (10 ** 8), 0);
    stages[2] = Stage(24000, ETH_CAP, 0);
    stages[3] = Stage(23000, ETH_CAP, 0);
    stages[4] = Stage(22000, ETH_CAP, 0);
    stages[5] = Stage(21000, ETH_CAP, 0);
    stages[6] = Stage(20000, ETH_CAP, 0);

    // call superclass constructor and set rate at current stage
    currentStage = 0;
  }

  /**
  * Set new crowdsale stage
  */
  function setStage(uint _stage) public onlyOwner {
    require(_stage > currentStage);
    currentStage = _stage;
    rate = stages[currentStage].stageRate;
  }

  function open() public onlyOwner {
    isOpen = true;
  }

  function close() public onlyOwner {
    isOpen = false;
  }

  /**
  * Closes the sale
  */
  function finalize() public onlyOwner {
    isOpen = false;
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isSaleOpen {
    // make sure we don't raise more than cap for each stage
    require(stages[currentStage].stageRaised < stages[currentStage].stageCap, "Stage Cap reached");
    stages[currentStage].stageRaised = stages[currentStage].stageRaised.add(_weiAmount);
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }
}