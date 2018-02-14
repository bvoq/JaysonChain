pragma solidity ^0.4.19;

import "./JSONcontract.sol";
import "./Owned.sol";

contract JaysonChain is Owned {
	struct action {
		string type; //moved, consumed/sold, used(in machine) 
		JSON data; //timestamp, location form to, temp, humidity,... etc
	}
	
	struct Asset {
		uint assetID;
		string state; //consumed, defect, built-in, stolen/lost.
		string location;
		JSON data;
		action[] actionhistory;
	}
	
	struct prod{
		uint[] inputs; //input AssetIDs
		uint[] outputs; //output AssetIDs
		JSON data; //addistional data (timestamp, etc)
	}
	

	
	
	Asset[] allAssets;
	
	function createAsset() private {
		allAssets.len
	}
}
