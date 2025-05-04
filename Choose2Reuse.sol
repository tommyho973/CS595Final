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

    /* ─────────────────── Borrow / Return ─────────────────── */

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
        require(
            block.timestamp <= container.borrowTimestamp + borrowDuration,
            "Deposit already forfeited"
        );

        container.isBorrowed = false;
        for (uint256 i = 0; i < activeContainerIds.length; i++){
            if(keccak256(bytes(activeContainerIds[i])) == keccak256(bytes(containerId))){
                activeContainerIds[i] = activeContainerIds[activeContainerIds.length - 1];
                activeContainerIds.pop();
                break;
            }
        }
        emit ContainerReturned(containerId, msg.sender);

        // Refund deposit
        (bool sent, ) = msg.sender.call{value: depositAmount}("");
        require(sent, "Refund failed");
    }

    /* ─────────────────── Owner maintenance ─────────────────── */

    function forfeitExpiredDeposits() public onlyOwner {
        uint256 i = 0;
        while (i < activeContainerIds.length) {
            string memory containerId = activeContainerIds[i];
            Container storage container = containers[containerId];

            if (
                container.isBorrowed &&
                block.timestamp > container.borrowTimestamp + borrowDuration
            ) {
                container.isBorrowed = false;

                emit DepositForfeited(containerId, container.borrower);

                // Transfer deposit to owner
                (bool sent, ) = owner.call{value: depositAmount}("");
                require(sent, "Owner transfer failed");

                // Remove container from activeContainerIds array
                activeContainerIds[i] =
                    activeContainerIds[activeContainerIds.length - 1];
                activeContainerIds.pop();
            } else {
                i++;
            }
        }
    }

    /* ─────────────────── View helpers ─────────────────── */

    function getActiveContainers() public view returns (string[] memory) {
        return activeContainerIds;
    }

    /**
     * @notice Returns the Unix timestamp by which the specified container
     *         must be returned (borrowTimestamp + borrowDuration).
     * @dev    Reverts if the container has never been borrowed.
     */
    function getDueTimestamp(string memory containerId)
        public
        view
        returns (uint256)
    {
        Container storage container = containers[containerId];
        require(
            container.borrowTimestamp != 0,
            "Container has not been borrowed"
        );
        return container.borrowTimestamp + borrowDuration;
    }

    /**
     * @notice Returns the number of seconds remaining until the user's
     *         deposit would be forfeited. If the deadline has passed,
     *         the function returns 0.
     */
    function getTimeLeft(string memory containerId)
        external
        view
        returns (uint256)
    {
        uint256 due = getDueTimestamp(containerId);
        if (block.timestamp >= due) {
            return 0;
        }
        return due - block.timestamp;
    }

    /* ─────────────────── Admin setters ─────────────────── */

    function setDepositAmount(uint256 newAmount) public onlyOwner {
        depositAmount = newAmount;
    }

    function setBorrowDuration(uint256 newDuration) public onlyOwner {
        borrowDuration = newDuration;
    }
}
