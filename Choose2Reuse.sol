// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ChooseToReuse {
    uint256 public depositAmount = 0.001 ether;
    uint256 public borrowDuration = 7 days;
    address public owner;

    struct Container {
        bool isBorrowed;
        address borrower;
        uint256 borrowTimestamp;
    }

    mapping(string => Container) public containers;
    string[] public activeContainerIds;

    event ContainerBorrowed(string containerId, address borrower);
    event ContainerReturned(string containerId, address returner);
    event DepositForfeited(string containerId, address forfeiter);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function borrowContainer(string memory containerId) public payable {
        require(msg.value == depositAmount, "Must pay exact deposit");
        require(!containers[containerId].isBorrowed, "Container already borrowed");

        containers[containerId] = Container({
            isBorrowed: true,
            borrower: msg.sender,
            borrowTimestamp: block.timestamp
        });
        activeContainerIds.push(containerId);

        emit ContainerBorrowed(containerId, msg.sender);
    }

    function returnContainer(string memory containerId) public {
        Container storage container = containers[containerId];
        require(container.isBorrowed, "Container not borrowed");
        require(container.borrower == msg.sender, "Not the borrower");
        require(block.timestamp <= container.borrowTimestamp + borrowDuration, "Deposit already forfeited");

        container.isBorrowed = false;

        emit ContainerReturned(containerId, msg.sender);

        // Refund deposit
        (bool sent, ) = msg.sender.call{value: depositAmount}("");
        require(sent, "Refund failed");
    }

    function forfeitExpiredDeposits() public onlyOwner {
        uint256 i = 0;
        while (i < activeContainerIds.length) {
            string memory containerId = activeContainerIds[i];
            Container storage container = containers[containerId];

            if (container.isBorrowed && block.timestamp > container.borrowTimestamp + borrowDuration) {
                container.isBorrowed = false;
                
                emit DepositForfeited(containerId, container.borrower);

                // Transfer deposit to owner
                (bool sent, ) = owner.call{value: depositAmount}("");
                require(sent, "Owner transfer failed");

                // Remove container from activeContainerIds array
                activeContainerIds[i] = activeContainerIds[activeContainerIds.length - 1];
                activeContainerIds.pop();
            } else {
                i++;
            }
        }
    }

    function getActiveContainers() public view returns (string[] memory) {
        return activeContainerIds;
    }

    function setDepositAmount(uint256 newAmount) public onlyOwner {
        depositAmount = newAmount;
    }

    function setBorrowDuration(uint256 newDuration) public onlyOwner {
        borrowDuration = newDuration;
    }
}
