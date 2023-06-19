import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../match_model.dart';
import '../../web3_provider.dart';
import 'custom_text_field.dart';

class PlayersExpandablePanel extends StatelessWidget {
  const PlayersExpandablePanel({
    super.key,
    required this.matchModel,
    required this.state,
    required this.isTeamA,
  });

  final MatchModel matchModel;
  final Web3Provider state;
  final bool isTeamA;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      collapsed: ExpandableButton(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTeamA ? 'TeamA Players' : 'TeamB Players',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.expand_more,
              ),
            ],
          ),
        ),
      ),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpandableButton(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isTeamA ? 'TeamA Players' : 'TeamB Players',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.expand_less,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    '${index + 1}. ${isTeamA ? matchModel.teamAPlayers[index] : matchModel.teamBPlayers[index]}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                );
              },
              itemCount: isTeamA
                  ? matchModel.teamAPlayers.length
                  : matchModel.teamBPlayers.length,
            ),
          ),
          Center(
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: state.createMatchStatus == Status.loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Add/Remove players',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                onPressed: () {
                  buildShowDialog(context);
                },
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Workouts'),
          content: CustomTextField(
            controller: controller,
            hintText: 'Enter player name',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Consumer(builder: (context, ref, child) {
              return TextButton(
                child:
                    ref.watch(web3Provider).removePlayerStatus == Status.loading
                        ? const CircularProgressIndicator(
                            color: Colors.teal,
                          )
                        : const Text('Remove'),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    ref.read(web3Provider).removePlayer(matchModel.title,
                        controller.text.trim(), isTeamA, context);
                  }
                },
              );
            }),
            Consumer(builder: (context, ref, child) {
              return TextButton(
                child: isTeamA
                    ? ref.watch(web3Provider).updateTeamAStatus ==
                            Status.loading
                        ? const CircularProgressIndicator(
                            color: Colors.teal,
                          )
                        : const Text('Add')
                    : ref.watch(web3Provider).updateTeamBStatus ==
                            Status.loading
                        ? const CircularProgressIndicator(
                            color: Colors.teal,
                          )
                        : const Text('Add'),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    isTeamA
                        ? ref.read(web3Provider).updateTeamA(
                              matchModel.title,
                              [controller.text.trim()],
                              context,
                            )
                        : ref.read(web3Provider).updateTeamB(
                              matchModel.title,
                              [controller.text.trim()],
                              context,
                            );
                  }
                },
              );
            }),
          ],
        );
      },
    );
  }
}
