// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Define contract
contract Ani {
    address public holder; 
    uint256 public totalSupply; 
    uint256 public initialSupply = 1000; 

    struct Product {
        string name;
        string productType;
        uint256 quantityInKilograms;

        //uint256 plantingDate;
        //uint256 expectedHarvestTime;
    }

    mapping(address => Product) public products;

    modifier isHolder() {
        require(msg.sender == holder, "You are not the holder!");
        _;
    }

    constructor() {
        //holder = msg.sender;
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
        string memory _productType,

        //uint256 _plantingDate,
        //uint256 _expectedHarvestTime
    ) external isHolder {
        require(bytes(_name).length > 0, "Product name cannot be empty");
        require(bytes(_productType).length > 0, "Produce type cannot be empty");
        require(_expectedHarvestTime > _plantingDate, "Invalid expected harvest time");

        Product memory newProduct = Product({
            name: _name,
            productType: _productType,
            plantingDate: _plantingDate,
            expectedHarvestTime: _expectedHarvestTime
        });

        products[msg.sender] = newProduct;
    }

    function getRegisteredProduct() external view isHolder returns (Product memory) {
        return products[msg.sender];
    }
}
