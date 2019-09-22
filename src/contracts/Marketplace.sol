pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );
     event ProductPurchased(
       uint id,
       string name,
       uint price,
       address payable owner,
       bool purchased
     );
    constructor() public {
        name = "Dapp University Marketplace";
    }


    function createProduct(string memory _name, uint _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // Increment product count
        productCount ++;
        // Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable{
      //fetch product
      Product memory _product = products[_id];

      //fetch owner
      address payable _seller = _product.owner;

      //make sure purchase is valid
      require(_product.id > 0 && _product.id <= productCount);

      //require enough ether in transactions
      require(msg.value >= _product.price);

      // require  product not purchased already
      require(!_product.purchased);
      //require buyer is not _seller
      require(_seller != msg.sender);

      //purchase it transfer ownership to buyer
      _product.owner = msg.sender;

      //mark as purchase Product
      _product.purchased = true;
      products[_id] = _product;

      // pay the seller sending them ether
      address(_seller).transfer(msg.value);
      // trigger an event
      emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);

    }
}
