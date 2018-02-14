pragma solidity ^0.4.19;

contract JSONcontract {
	struct JSON {
        string leftval;
        string rightstr;
        uint rightint;
        JSON[] rightarr;
        uint8 rightvaltype; // 0 uint, 1 string, 2 JSON[] 
    }
}