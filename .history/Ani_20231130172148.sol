// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Define contract
contract Ani {
    address public holder; 
    uint256 public totalSupply; 
    uint256 public initialSupply = 1000; 
    uint256 productCounter; 

    struct Product {
        uint256 productID;
        string name;
        uint256 quantityInKilograms;
        string physicalAddress;
        string "status"
    }

    struct Role {
        string role;
    }

    mapping(address => Product) public products;
    mapping(address => Role) public roles;

    modifier isHolder() {
        require(msg.sender == holder, "You are not the holder!");
        _;
    }

    modifier isProducer() {
        require(roles[holder].role == "Producer", "You are not a producer!");
        _;
    }

    modifier isDistributor() {
        require(roles[holder].role == "Distributor", "You are not a producer!");
        _;
    }

    modifier isRetailer() {
        require(roles[holder].role == "Retailer", "You are not a producer!");
        _;
    }

    constructor() {
        holder = msg.sender;
        totalSupply = initialSupply;
    }

    function checkHolder() external view isHolder returns (string memory) {
        return "I am still the holder!";
    }

    // PRODUCT REGISTRATION: Producer registers product with pertinent details
    function registerProduct(
        string memory _name,
        uint256 memory _quantityInKilograms,
        string memory _physicalAddress,
        string _status
    ) external isHolder isProducer {
        require(bytes(_name).length > 0, "Product name cannot be empty");
        require(bytes(_quantityInKilograms) > 0, "Quantity must be greater than 0");
        require(bytes(_physicalAddress).length > 0, "Physical address cannot be empty");
        require(bytes(_status).length > 0, "Status cannot be empty");

        //Increment product counter used in generating product IDs
        productCounter++;

        //Create new product object
        Product memory newProduct = Product({
            productID: productCounter,
            name: _name,
            quantityInKilograms: _quantityInKilograms,
            physicalAddress: _physicalAddress,
            status: _status
        });

        products[holder] = newProduct;
    }

    // TRANSFER PRODUCT : 
    function transferProduct(address recipient, uint256 productID) external isHolder{
        //Ensure that the holder currently holds the product
        require(products[holder].productID == productID, "Product not found");
        holder = recipient;
    }

    //View products registered by holder
    function getRegisteredProduct() external view isHolder returns (Product memory) {
        return products[holder];
    }
}
