import 'package:flutter/material.dart';
import 'package:flutter_celo_esports_platform/provider.dart';
import 'package:flutter_celo_esports_platform/views/widgets/custom_drop_down.dart';
import 'package:flutter_celo_esports_platform/views/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../match_model.dart';
import '../widgets/player_expandable_panel.dart';

class MatchDetailsScreen extends ConsumerWidget {
  const MatchDetailsScreen({Key? key, required this.matchModel})
      : super(key: key);

  final MatchModel matchModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(web3Provider);
    return Scaffold(
      appBar: AppBar(
        title: Text(matchModel.title),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {
              buildShowDialog(context);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              matchModel.status == MatchStatus.scheduled
                  ? 'Scheduled'
                  : matchModel.status == MatchStatus.inProgress
                      ? 'In Progress'
                      : 'Finished',
              style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  color: matchModel.winner == Winner.teamA ||
                          matchModel.winner == Winner.draw
                      ? Colors.green.withOpacity(0.2)
                      : null,
                  child: Column(
                    children: [
                      const Text(
                        'Team A',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        matchModel.teamAScore,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Text(
                  ' - ',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Container(
                  width: 100,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  color: matchModel.winner == Winner.teamB ||
                          matchModel.winner == Winner.draw
                      ? Colors.green.withOpacity(0.2)
                      : null,
                  child: Column(
                    children: [
                      const Text(
                        'Team B',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        matchModel.teamBScore,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Start Time: ${DateFormat.jm().format(matchModel.startTime)}, ${DateFormat.MMMEd().format(matchModel.startTime)}',
              style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'End Time: ${DateFormat.jm().format(matchModel.endTime)}, ${DateFormat.MMMEd().format(matchModel.endTime)}',
              style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            PlayersExpandablePanel(
              matchModel: matchModel,
              state: state,
              isTeamA: true,
            ),
            const SizedBox(
              height: 20,
            ),
            PlayersExpandablePanel(
              matchModel: matchModel,
              state: state,
              isTeamA: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Select an Option'),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                    child: const Text(
                      'Update Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      buildShowDialogEditStatus(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                    child: const Text(
                      'Update Score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      buildShowDialogEditScore(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: TextButton(
                    style:
                        TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                    child: const Text(
                      'Update Winner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      buildShowDialogUpdateWinner(context);
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<dynamic> buildShowDialogEditStatus(context) {
    String? selectedStatus;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Update Status'),
            content: CustomDropDown(
              hintText: 'Select status',
              textList: ['Scheduled', 'In Progress', 'Finished'],
              text: selectedStatus,
              onChanged: (val) {
                setState(() {
                  selectedStatus = val;
                });
              },
            ),
            actions: <Widget>[
              Column(
                children: [
                  Consumer(builder: (context, ref, child) {
                    return SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {
                          ref.read(web3Provider).updateMatchStatus(
                              matchModel.title, selectedStatus!, context);
                        },
                        child:
                            ref.watch(web3Provider).updateMatchStatusStatus ==
                                    Status.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Update Status',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> buildShowDialogEditScore(context) {
    TextEditingController aController = TextEditingController();
    TextEditingController bController = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Score'),
          content: SizedBox(
            height: 140,
            child: Column(
              children: [
                CustomTextField(
                  controller: aController,
                  hintText: 'Enter Team A score',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: bController,
                  hintText: 'Enter Team B score',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Consumer(builder: (context, ref, child) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        ref.read(web3Provider).updateMatchScore(
                              matchModel.title,
                              aController.text.trim(),
                              bController.text.trim(),
                              context,
                            );
                      },
                      child: ref.watch(web3Provider).updateMatchScoreStatus ==
                              Status.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Update Score',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> buildShowDialogUpdateWinner(context) {
    String? selectedStatus;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Update Winner'),
            content: CustomDropDown(
              hintText: 'Select status',
              textList: const ['TeamA', 'TeamB', 'Draw'],
              text: selectedStatus,
              onChanged: (val) {
                setState(() {
                  selectedStatus = val;
                });
              },
            ),
            actions: <Widget>[
              Column(
                children: [
                  Consumer(builder: (context, ref, child) {
                    return SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {
                          ref.read(web3Provider).updateMatchWinner(
                              matchModel.title, selectedStatus!, context);
                        },
                        child:
                            ref.watch(web3Provider).updateMatchWinnerStatus ==
                                    Status.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Update Winner',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}
