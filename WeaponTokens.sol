pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract WeaponTokens {

    struct Weapon {
        string name;
        uint distance;
        uint reloadTime;
        uint price;    
    }

    Weapon[] weapons;
    mapping (uint => uint) tokenToOwner;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier Accept {
		tvm.accept();
		_;
	}


    function createToken(string name, uint distance, uint reloadTime, uint price) public Accept {
        bool isUniq = true;
        for (uint i = 0; i < weapons.length; i++) {
            if (weapons[i].name == name) {
                isUniq = false;
                break;
            }
        }
        require(isUniq, 101);
        weapons.push(Weapon(name, distance, reloadTime, price));
        uint keyAsLastNum = weapons.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }

    function getTokenOwner(uint tokenId) public view returns(uint) {
        return tokenToOwner[tokenId];
    }

    function getTokenInfo(uint tokenId) public view returns (string tokenName, uint tokenDistance, uint tokenReloadTime, uint tokenPrice) {
        tokenName = weapons[tokenId].name;
        tokenDistance = weapons[tokenId].distance;
        tokenReloadTime = weapons[tokenId].reloadTime;
        tokenPrice = weapons[tokenId].price;
    }

    function makeOnSale(uint tokenId, uint price) public Accept returns (uint){
        require(msg.pubkey() == tokenToOwner[tokenId], 101);
        return price;
    }
}