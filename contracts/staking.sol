// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./myNFT.sol";

contract staking is ERC721 {
    mapping(address => uint256) public checkpoints;
    mapping(address => uint256) public deposited_tokens;
    mapping(address => bool) public has_deposited;
    mapping(address => uint256) public time_stamp;
    ERC721 public my_token;

    uint256 public REWARD_PER_BLOCK = 100000000;
    uint256 public SECONDS_TILL_WITHDRAW = 2592000; //30 days
    // uint256 time_stamp;


    constructor(address token) ERC721("Staking Token", "ST") {
        my_token = ERC721(token);
    }
    // constructor() ERC721("Staking Token", "ST") {
    //     my_token = ERC721(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47);
    // }

// MODIFIERS
    modifier forStaker() {
        require(has_deposited[msg.sender] = true,"Only staker can call function");
        _;
    }

    modifier forNotStaker() {
        require(!has_deposited[msg.sender], "Sender already deposited");
        _;
    }

    modifier availableForWithdraw() {
        require(time_stamp[msg.sender] + SECONDS_TILL_WITHDRAW <= block.timestamp);
        _;
    }

    modifier senderIsOwner(uint256 tokenId) {
        require(msg.sender == my_token.ownerOf(tokenId),"Sender must be owner");
        _;
    }


// FUNCTIONS
    function deposit(uint256 tokenId) external senderIsOwner(tokenId) forNotStaker {
        // require(
        //     msg.sender == my_token.ownerOf(tokenId),
        //     "Sender must be owner"
        // );
        // require(!has_deposited[msg.sender], "Sender already deposited");

        if (checkpoints[msg.sender] == 0) {
            checkpoints[msg.sender] = block.number;
        }
        collect(msg.sender);
        my_token.transferFrom(msg.sender, address(this), tokenId);
        deposited_tokens[msg.sender] = tokenId;
        has_deposited[msg.sender] = true;
        time_stamp[msg.sender] = block.timestamp;
    }

    function withdraw() external forStaker availableForWithdraw{
        // require(has_deposited[msg.sender], "No tokens to withdarw");
        // require(time_stamp + SECONDS_TILL_WITHDRAW <= block.timestamp);
        collect(msg.sender);
        my_token.transferFrom(
            address(this),
            msg.sender,
            deposited_tokens[msg.sender]
        );
        has_deposited[msg.sender] = false;
    }

    function collect(address beneficiary) public availableForWithdraw{
        // require(time_stamp + SECONDS_TILL_WITHDRAW <= block.timestamp);
        uint256 reward = calculateReward(beneficiary);
        checkpoints[beneficiary] = block.number;
        _mint(msg.sender, reward);
    }

    function calculateReward(address beneficiary)
        public
        view
        returns (uint256)
    {
        if (!has_deposited[msg.sender]) {
            return 0;
        }
        uint256 checkpoint = checkpoints[beneficiary];
        return REWARD_PER_BLOCK * (block.number - checkpoint);
    }

    function validators(address addr) public view returns (uint256) {
        return checkpoints[addr];
    }

    function isValidator(address addr) public view returns (bool) {
        return has_deposited[addr];
    }

    function depositedTokens(address addr) public view returns (uint256) {
        return deposited_tokens[addr];
    }
}

