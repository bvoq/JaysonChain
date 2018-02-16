


if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

web3.eth.defaultAccount = web3.eth.accounts[0];

JaysonChainContract = new web3.eth.Contract([
	{
		"constant": true,
		"inputs": [],
		"name": "globalInternalTimeStamp",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "attributeIndex",
				"type": "uint256"
			}
		],
		"name": "readAttributeName",
		"outputs": [
			{
				"name": "name",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "attributeIndex",
				"type": "uint256"
			}
		],
		"name": "readAttributeInternalTimeStamp",
		"outputs": [
			{
				"name": "internalTimeStamp",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "attributeIndex",
				"type": "uint256"
			}
		],
		"name": "readAttributeData",
		"outputs": [
			{
				"name": "data",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "attributeIndex",
				"type": "uint256"
			}
		],
		"name": "readAttributeAuthor",
		"outputs": [
			{
				"name": "author",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "attributeIndex",
				"type": "uint256"
			}
		],
		"name": "readAttributeUnixTime",
		"outputs": [
			{
				"name": "internalTimeStamp",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "allAssets",
		"outputs": [
			{
				"name": "owner",
				"type": "address"
			},
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "unixTime",
				"type": "uint256"
			},
			{
				"name": "internalTimeStamp",
				"type": "uint256"
			},
			{
				"name": "historyLength",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "allowTo",
				"type": "address"
			},
			{
				"name": "attributeName",
				"type": "string"
			},
			{
				"name": "writeAmount",
				"type": "uint256"
			}
		],
		"name": "addAllowWrites",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "allowTo",
				"type": "address"
			},
			{
				"name": "attributeName",
				"type": "string"
			},
			{
				"name": "writeAmount",
				"type": "uint256"
			}
		],
		"name": "setAllowWrites",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "data",
				"type": "string"
			}
		],
		"name": "addAttribute",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "disallowTo",
				"type": "address"
			},
			{
				"name": "attributeName",
				"type": "string"
			}
		],
		"name": "disallowAllWrites",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			},
			{
				"name": "allowTo",
				"type": "address"
			},
			{
				"name": "encryptedAttributeIndex",
				"type": "uint256"
			},
			{
				"name": "encryptedSymmetricKey",
				"type": "uint256"
			}
		],
		"name": "allowRead",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "createAsset",
		"outputs": [
			{
				"name": "assetIndex",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
])

JaysonChainContract.options.address = "0xd7dd6b46b7ba1044d3857be3abe02de2eb1b832b";
JaysonChainContract.options.gas = 500000;
/*console.log(Jayson);

Jayson.createAsset(function(result){
    if(!error)
        {
            $("#aId").html(result);
            console.log(result);
        }
    else
        console.error(error);
});*/


$("#newAssetButton").click(function() {
	JaysonChainContract.methods.createAsset.call(function(error, result) {
	  if (!error)
		console.log(result)
	  else
		console.log(error)
	});
});

$("#AssetButton").click(function() {
	JaysonChain.methods.allAssets.call($("#assetid").val(), function(error, result) {
	  if (!error) {
		$("#text").html(result[0] + '\n' + result[1] + '\n' + result[2] + '\n' + result[3] + '\n' + result[4])
	  } else {
		console.log(error);
	  }
	})
  });