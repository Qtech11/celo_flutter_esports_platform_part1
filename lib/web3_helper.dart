import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

final client = Web3Client('https://alfajores-forno.celo-testnet.org', Client());

const abi =
    '<your_actual_abi>'; // Replace these with your actual contract ABI and remove the string quote

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
      "8043ad3f57a701cd6c37532868e341d290b3f2c08e8093061c7ffd4401b2a7b4"); // replace with your celo wallet private key

  Future sendTransaction(ContractFunction function, List parameters) async {
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
