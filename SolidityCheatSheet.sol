// A single line comment

/*
 A multiline comment
*/

pragma solidity ^0.4.21; //Solidity version supported

contract ExampleContract {
    
    // NUMBERS
    uint8 public smallPublicInteger;
    uint256 private bigPrivateInteger;
    uint private alsoBigPrivateInteger;
    int256 constant public constantBigSignedInteger = 34;
    bool public booleanWithInitialisation = true;
    // no floats :P
    
    // STRINGS/BLOBS
    string public variableLenghtString;
    bytes12 public shortConstantLenghtString;
    bytes32 public longConstantLenghtString;

    // address    
    address public anAddress;
    
    // ARRAYS
    uint32[] public arrayOfIntegers;

    // COLLECTIONS
    // Note: collections are not iterable
    mapping(address => uint32) mapOfAddressToUnsignedInteger;
    mapping(address => mapping(uint32 => uint32)) mapOfMaps;

    
    // ENUM
    enum ExampleEnum {
        EnumValue1,
        EnumValue2
    }
    ExampleEnum public exampleEnum; 
    
    // CONSTRUCTOR
    function ExampleContract(uint8 someParameter) public {
        anAddress = msg.sender;
        smallPublicInteger = someParameter;
        bigPrivateInteger = 0;
    }
    
    // EVENT
    event EventExample(uint256 someValue);

    // FUNCTION MODIFIER    
    modifier onlyOwner() {
        require(msg.sender == anAddress);
        _; // the underscore represents the decorated function
    }
    
    // FUNCTION EXAMPLES

    // public payable (includes founds) function 
    function takeEthereum() public payable {
        bigPrivateInteger += msg.value;
        emit EventExample(bigPrivateInteger);
    }

    // private and view (does not mofify state) function returning a boolean
    function isIntegerInArray(uint32 someParameter) view returns(bool) {
        // For loop
        for (uint32 i = 0; i < arrayOfIntegers.length; ++i){
            // A conditional
            if (arrayOfIntegers[i] == someParameter) {
                return true;
            }
        }
        return false;
    }
}