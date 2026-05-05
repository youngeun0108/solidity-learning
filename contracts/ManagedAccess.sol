pragma solidity ^0.8.28;

abstract contract ManagedAccess {
    address public owner;
    address public manager;

    mapping(address => bool) public managers;
    mapping(address => bool) public confirmed;

    uint256 public managerCount;
    uint256 public confirmedCount;

    constructor(address _owner, address _manager) {
        owner = _owner;
        manager = _manager;

        managers[_manager] = true;
        managerCount = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        _;
    }

    modifier onlyManager() {
        require(
            msg.sender == manager,
            "You are not authorized to manage this contract"
        );
        _;
    }

    modifier onlyAllConfirmed() {
        require(
            managers[msg.sender],
            "You are not a manager"
        );
        require(
            managerCount >= 3 && confirmedCount == managerCount,
            "Not all confirmed yet"
        );
        _;
    }

    function addManager(address _manager) external onlyOwner {
        require(!managers[_manager], "Already manager");

        managers[_manager] = true;
        managerCount += 1;
    }

    function confirm() external {
        require(managers[msg.sender], "You are not a manager");
        require(!confirmed[msg.sender], "Already confirmed");

        confirmed[msg.sender] = true;
        confirmedCount += 1;
    }
}