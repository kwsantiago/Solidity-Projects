// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";

contract genPhoneNumber is Ownable, VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal randomFee;
    uint256 public randomResult;
    
    uint256[] phoneNumber;
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Rinkeby
     * Chainlink VRF Coordinator address: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
     * LINK token address:                0x01BE23585060835E02B77ef475b0Cc51aA1e0709
     * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
     */
    constructor() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
        ) public
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        randomFee = 0.1 * 10 ** 18; // 0.1 LINK
    }
    
    /** 
     * Requests randomness from a user-provided seed
     */
    function getRandomNumber(uint256 userProvidedSeed) internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) > randomFee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, randomFee, userProvidedSeed);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        genNewPhoneNumber();
    }
    
    function genNewPhoneNumber() internal {
        uint256 tmp = randomResult;
        for(uint256 i = 0; i < 7; i++){
            phoneNumber.push(SafeMath.mod(tmp,9));
            tmp = SafeMath.div(tmp,9);
        }
    }
    
    function newPhoneNumber() external onlyOwner {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        getRandomNumber(blockValue);
    }

    function getPhoneNumber() public view returns (uint256[] memory) {
        return phoneNumber;
    }
}
