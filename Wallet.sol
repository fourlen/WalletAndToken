pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Wallet {
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}


    function sendTransactionWithoutFees(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 0);
    }

    function sendTransactionWithFees(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 1);
    }

    function sendAllMoneyAndDestroy(address dest, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(1, bounce, 160);
    }
}