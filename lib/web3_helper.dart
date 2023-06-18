import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

final client = Web3Client('https://alfajores-forno.celo-testnet.org', Client());

const abi = [
  {
    "inputs": [
      {"internalType": "string", "name": "_title", "type": "string"},
      {"internalType": "uint256", "name": "_startTime", "type": "uint256"},
      {"internalType": "uint256", "name": "_endTime", "type": "uint256"}
    ],
    "name": "createMatch",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "title",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "startTime",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "endTime",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "address",
        "name": "matchCreator",
        "type": "address"
      }
    ],
    "name": "MatchCreated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "title",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "teamAScore",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "teamBScore",
        "type": "string"
      }
    ],
    "name": "MatchScoreUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "title",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "status",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "winner",
        "type": "string"
      }
    ],
    "name": "MatchUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "title",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "team",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "player",
        "type": "string"
      }
    ],
    "name": "PlayerRemoved",
    "type": "event"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_matchTitle", "type": "string"},
      {"internalType": "string", "name": "_playerName", "type": "string"},
      {"internalType": "bool", "name": "_isTeamA", "type": "bool"}
    ],
    "name": "removePlayer",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "title",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "team",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "bool",
        "name": "isAdded",
        "type": "bool"
      }
    ],
    "name": "TeamUpdated",
    "type": "event"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_matchTitle", "type": "string"},
      {"internalType": "string", "name": "_teamAScore", "type": "string"},
      {"internalType": "string", "name": "_teamBScore", "type": "string"}
    ],
    "name": "updateMatchScore",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_matchTitle", "type": "string"},
      {"internalType": "string", "name": "_status", "type": "string"}
    ],
    "name": "updateMatchStatus",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_matchTitle", "type": "string"},
      {"internalType": "string", "name": "_winner", "type": "string"}
    ],
    "name": "updateMatchWinner",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_matchTitle", "type": "string"},
      {"internalType": "string[]", "name": "_players", "type": "string[]"}
    ],
    "name": "updateTeamA",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_matchTitle", "type": "string"},
      {"internalType": "string[]", "name": "_players", "type": "string[]"}
    ],
    "name": "updateTeamB",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getAllMatches",
    "outputs": [
      {
        "components": [
          {"internalType": "string", "name": "title", "type": "string"},
          {"internalType": "string[]", "name": "teamA", "type": "string[]"},
          {"internalType": "string[]", "name": "teamB", "type": "string[]"},
          {"internalType": "uint256", "name": "startTime", "type": "uint256"},
          {"internalType": "uint256", "name": "endTime", "type": "uint256"},
          {"internalType": "string", "name": "matchStatus", "type": "string"},
          {"internalType": "string", "name": "winner", "type": "string"},
          {"internalType": "string", "name": "teamAScore", "type": "string"},
          {"internalType": "string", "name": "teamBScore", "type": "string"},
          {"internalType": "address", "name": "matchCreator", "type": "address"}
        ],
        "internalType": "struct EsportsPlatform.Match[]",
        "name": "",
        "type": "tuple[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "name": "matches",
    "outputs": [
      {"internalType": "string", "name": "title", "type": "string"},
      {"internalType": "uint256", "name": "startTime", "type": "uint256"},
      {"internalType": "uint256", "name": "endTime", "type": "uint256"},
      {"internalType": "string", "name": "matchStatus", "type": "string"},
      {"internalType": "string", "name": "winner", "type": "string"},
      {"internalType": "string", "name": "teamAScore", "type": "string"},
      {"internalType": "string", "name": "teamBScore", "type": "string"},
      {"internalType": "address", "name": "matchCreator", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  }
];
// Replace these with your actual contract ABI and remove the string quote

final contractAddress = EthereumAddress.fromHex(
    '0x5102609037bc756b50645036D8a9c30765C64257'); // replace with your actual contract address
final contractABI = json.encode(abi);

class Web3Helper {
// Create a contract instance that we can interact with
  final contract = DeployedContract(
    ContractAbi.fromJson(contractABI, "EsportsPlatform"),
    contractAddress,
  );

  final credentials = EthPrivateKey.fromHex(
      "88093061c7ffd4701cd6c37532868e34043ad3f57ab3f2c08e1d290401b2a7b4"); // replace with your celo wallet private key

  Future sendTransaction(ContractFunction function, List parameters) async {
    print(function.parameters);
    print(parameters);
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: parameters,
      ),
      chainId: 44787,
    );
    while (true) {
      final receipt = await client.getTransactionReceipt(response);
      if (receipt != null) {
        print('Transaction successful');
        print(receipt);
        break;
      }
      // Wait for a while before polling again
      await Future.delayed(const Duration(seconds: 2));
    }
    return response;
  }

  Future getAllMatches() async {
    final function = contract.function('getAllMatches');
    final response = await client.call(
      sender: credentials.address,
      contract: contract,
      function: function,
      params: [],
    );
    print(response);
    return response;
  }

  Future createMatch(String title, int startTime, int endTime) async {
    final function = contract.function('createMatch');
    final response = await sendTransaction(
        function, [title, BigInt.from(startTime), BigInt.from(endTime)]);
    return response;
  }

  Future updateTeamA(String matchTitle, List<String> players) async {
    final function = contract.function('updateTeamA');
    final response = await sendTransaction(
      function,
      [matchTitle, players],
    );
    return response;
  }

  Future updateTeamB(String matchTitle, List<String> players) async {
    final function = contract.function('updateTeamB');
    final response = await sendTransaction(
      function,
      [matchTitle, players],
    );
    return response;
  }

  Future removePlayer(
      String matchTitle, String playerName, bool isTeamA) async {
    final function = contract.function('removePlayer');
    final response = await sendTransaction(
      function,
      [matchTitle, playerName, isTeamA],
    );
    return response;
  }

  Future updateMatchStatus(String matchTitle, String status) async {
    final function = contract.function('updateMatchStatus');
    final response = await sendTransaction(
      function,
      [matchTitle, status],
    );
    return response;
  }

  Future updateMatchScore(
      String matchTitle, String teamAScore, String teamBScore) async {
    final function = contract.function('updateMatchScore');
    final response = await sendTransaction(
      function,
      [matchTitle, teamAScore, teamBScore],
    );
    return response;
  }

  Future updateMatchWinner(String matchTitle, String winner) async {
    final function = contract.function('updateMatchWinner');
    final response = await sendTransaction(
      function,
      [matchTitle, winner],
    );
    return response;
  }
}
