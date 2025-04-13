// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ChooseToReuse {
    // Deposit/fee required to borrow a container 
    uint256 public depositAmount = 0.001 ether;  

    // Track if a container (by QR code ID) is currently borrowed
    mapping(string => bool) public isBorrowed;
    // Track who has borrowed a given container (address of borrower)
    mapping(string => address) public borrowerOf;
    // Counter for total containers currently in circulation (borrowed out)
    uint256 public containersInCirculation;

    // Events for logging borrow and return actions
    event ContainerBorrowed(string containerId, address borrower);
    event ContainerReturned(string containerId, address returner);

    // Function to borrow a container. Must send ETH equal to depositAmount.
    function borrowContainer(string memory containerId) public payable {
        require(msg.value == depositAmount, "Must pay exact deposit");
        require(!isBorrowed[containerId], "Container already borrowed");
        // Mark container as borrowed by the caller
        isBorrowed[containerId] = true;
        borrowerOf[containerId] = msg.sender;
        containersInCirculation += 1;
        emit ContainerBorrowed(containerId, msg.sender);
    }

    // Function to return a container. Verifies the container is borrowed by the caller.
    function returnContainer(string memory containerId) public {
        require(isBorrowed[containerId], "Container is not currently borrowed");
        require(borrowerOf[containerId] == msg.sender, "Not the borrower of this container");
        // Mark container as returned
        isBorrowed[containerId] = false;
        containersInCirculation -= 1;
        delete borrowerOf[containerId];  // clear the borrower record
        emit ContainerReturned(containerId, msg.sender);
        // Refund the deposit to the returner
        (bool sent, ) = msg.sender.call{value: depositAmount}("");
        require(sent, "Failed to send refund");
    }
}
