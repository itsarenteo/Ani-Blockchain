// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Define contract
contract Ani {
    address public holder; 
    uint256 public totalSupply; 
    uint256 public initialSupply = 1000; 
    uint256 productCounter; 
    uint256 supplyNodeCounter; 

    struct Product {
        uint256 productID;
        string name;
        uint256 quantityInKilograms;
        string physicalAddress;
        string status;
    }

    struct SupplyNode {
        uint256 supplyNodeID;
        string name;
        string role;
    }

    mapping(address => Product) public products;
    mapping(address => SupplyNode) public supplyNodes;

    modifier isHolder() {
        require(msg.sender == holder, "You are not the holder!");
        _;
    }

    function compare(string memory str1, string memory str2) public pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    modifier isProducer() {
        require(compare(supplyNodes[holder].role, "Producer"), "You are not a producer!");
        _;
    }

    modifier isDistributor() {
        require(compare(supplyNodes[holder].role, "Distributor"), "You are not a distributor!");
        _;
    }

    modifier isRetailer() {
        require(compare(supplyNodes[holder].role, "Retailer"), "You are not a retailer!");
        _;
    }

    constructor() {
        holder = msg.sender;
        totalSupply = initialSupply;
    }

    function checkHolder() external view isHolder returns (string memory) {
        return "I am still the holder!";
    }

    // SUPPLY NODE REGISTRAITON: Register supply node
    function registerSupplyNode(
        string memory _name,
        string memory _role
    ) external isHolder{
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_role).length > 0, "Role field required");
        require(compare(_role, "Producer") || compare(_role, "Distributor") || compare(_role, "Retailer"), "Role must either be Producer, Distributor, or Retailer");


        //Increment holder counter used in generating holder IDs
        supplyNodeCounter++;

        //Create new supply node object
        SupplyNode memory newSupplyNode = SupplyNode({
            supplyNodeID: supplyNodeCounter,
            name: _name,
            role: _role
        });

    supplyNodes[holder] = newSupplyNode;

    }

    // PRODUCT REGISTRATION: Producer registers product with pertinent details
    function registerProduct(
        string memory _name,
        uint256 _quantityInKilograms,
        string memory _physicalAddress,
        string memory _status
    ) external isHolder isProducer {
        require(bytes(_name).length > 0, "Product name cannot be empty");
        require(_quantityInKilograms > 0, "Quantity must be greater than 0");
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

    // TRANSFER PRODUCT : Any holder transfers product to any other holder
    function transferProduct(address recipient, uint256 productID) external isHolder{
        //Ensure that the holder currently holds the product
        require(products[holder].productID == productID, "Product not found");

        //Recreate product within recipient's product mapping
        products[recipient] = Product({
            productID: productID,
            name: products[holder].name,
            quantityInKilograms: products[holder].quantityInKilograms,
            physicalAddress: products[holder].physicalAddress,
            status: products[holder].status
        });

        // Delete the product entry from the current holder's mapping
        delete products[holder];

        //Update holder
        holder = recipient;
    }

    //View products registered by holder
    function getRegisteredProduct() external view isHolder returns (Product memory) {
        return products[holder];
    }
}
