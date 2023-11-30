// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Define contract
contract Ani {
    address public holder; 
    uint256 public totalSupply; 
    uint256 public initialSupply = 1000; 

    struct Product {
        string name;
        uint256 quantityInKilograms;
        string physicalAddress;

        //uint256 plantingDate;
        //uint256 expectedHarvestTime;
    }

    mapping(address => Product) public products;

    modifier isHolder() {
        require(msg.sender == holder, "You are not the holder!");
        _;
    }

    constructor() {
        holder = msg.sender;
        totalSupply = initialSupply;
    }

    function transfer(address add) external isHolder {
        holder = add;
    }

    function checkHolder() external view isHolder returns (string memory) {
        return "I am still the holder!";
    }

    // PRODUCT REGISTRATION: Farmer registers product with harvesttime and plantDate
    function registerProduct(
        string memory _name,
        uint256 memory _quantityInKilograms,
        string memory _physicalAddress
    ) external isHolder {
        require(bytes(_name).length > 0, "Product name cannot be empty");
        require(bytes(_quantityInKilograms) > 0, "Quantity must be greater than 0");
        require(bytes(_physicalAddress).length > 0, "Physical address cannot be empty");

        //Create new product object
        Product memory newProduct = Product({
            name: _name,
            quantityInKilograms: _quantityInKilograms,
            physicalAddress: _physicalAddress
        });

        products[holder] = newProduct;
    }

    function getRegisteredProduct() external view isHolder returns (Product memory) {
        return products[msg.holder];
    }
}
