// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Ownable.sol";

contract BookLibrary is Ownable{

    event BookAdded(uint id, string title, uint copiesCount);
    event BookBorrowed(uint bookId, address borrower);
    event BookReturned(uint bookId, address borrower);

    struct Book {
        string title;
        uint copies;
    }

    Book[] public books;
    mapping(string => bool) isBookAdded;

    address[] borrowers;
    mapping(address => mapping(uint => bool)) userBorrowed;

    function addBook(string memory _title, uint _copiesCount) external onlyOwner {
        require(!isBookAdded[_title], "This book is already added!");

        books.push(Book(_title, _copiesCount));
        isBookAdded[_title] = true;
        uint id = books.length - 1;

        emit BookAdded(id, _title, _copiesCount);
    }
    
    function borrowBook(uint _bookId) external {
        require(books[_bookId].copies > 0, "There are no copies left! Try again later.");
        require(!userBorrowed[msg.sender][_bookId], "You already own a copy of this book.");

        userBorrowed[msg.sender][_bookId] = true;
        borrowers.push(msg.sender);
        books[_bookId].copies--;
        
        emit BookBorrowed(_bookId, msg.sender);
    }


    function returnBook(uint _bookId) external {
        require(userBorrowed[msg.sender][_bookId] == true, "You don't own a copy of this book.");

        userBorrowed[msg.sender][_bookId] = false;
        books[_bookId].copies++;

        emit BookReturned(_bookId, msg.sender);
    }

    function getAllBooks() public view returns ( Book[] memory) {
        return books;
    }

    function getBorrowersHistory() public view returns ( address[] memory) {
        return borrowers;
    }
}
