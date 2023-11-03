// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20TD is ERC20 {

mapping(address => bool) public teachers;
mapping(address => bool) public allowedUsers;

mapping(address => uint256) public userTiers;

event DenyTransfer(address recipient, uint256 amount);
event DenyTransferFrom(address sender, address recipient, uint256 amount);

constructor(string memory name, string memory symbol,uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        teachers[msg.sender] = true;
    }

function addToAllowList(address user, uint256 tier) public {
        allowedUsers[user] = true;
        userTiers[user] = tier;
    }

    modifier onlyAllowed() {
        require(allowedUsers[msg.sender], "You are not allowed to call this function.");
        _;
    }


function distributeTokens(address tokenReceiver, uint256 amount) 
public
onlyTeachers
{
	uint256 decimals = decimals();
	uint256 multiplicator = 10**decimals;
  _mint(tokenReceiver, amount * multiplicator);
}

function setTeacher(address teacherAddress, bool isTeacher) 
public
onlyTeachers
{
  teachers[teacherAddress] = isTeacher;
}

modifier onlyTeachers() {

    require(teachers[msg.sender]);
    _;
  }

function transfer(address recipient, uint256 amount) public override returns (bool) {
	emit DenyTransfer(recipient, amount);
        return false;
    }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
  emit DenyTransferFrom(sender, recipient, amount);
        return false;
    }

function isCustomerWhiteListed(address customerAddress) external returns (bool) {
    return allowedUsers[customerAddress];
}

function customerTierLevel(address customerAddress) external returns (uint256) {
  return userTiers[customerAddress];

}

function getToken() external payable onlyAllowed returns (bool) {

    uint256 tokensToMint = 10 * 1 * (10 ** decimals());
    _mint(msg.sender, tokensToMint);

    return true;
}

function buyToken() external payable onlyAllowed returns (bool) {
    require(msg.value > 0, "You must send some ETH to exchange for these tokens");

        uint256 tokensToMint;
        uint256 userTier = userTiers[msg.sender];
        if (userTier == 1) {
            tokensToMint = msg.value * 1 * 10 ** uint256(decimals());
        } else if (userTier == 2) {
            tokensToMint = msg.value * 2 * 10 ** uint256(decimals());
        } else if (userTier == 3) {
            tokensToMint = msg.value * 3 * 10 ** uint256(decimals());
        } else {
            revert("You are not allowed to call this function.");
        }

        _mint(msg.sender, tokensToMint);
        return true;
}

}