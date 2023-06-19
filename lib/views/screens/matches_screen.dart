import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_celo_esports_platform/views/screens/create_match_screen.dart';
import 'package:flutter_celo_esports_platform/views/screens/match_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../match_model.dart';
import '../../web3_provider.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(web3Provider).getAllMatches();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(web3Provider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Matches'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.schedule),
                text: 'Scheduled',
              ),
              Tab(
                icon: Icon(Icons.sync),
                text: 'In Progress',
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline),
                text: 'Finished',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            state.getAllMatchesStatus == Status.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                  )
                : state.scheduledMatchList.isEmpty
                    ? const EmptyCard(text: 'There are no scheduled matches')
                    : MatchCardList(matchModel: state.scheduledMatchList),
            state.getAllMatchesStatus == Status.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                  )
                : state.inProgressMatchList.isEmpty
                    ? const EmptyCard(
                        text: 'There are no match currently in progress')
                    : MatchCardList(matchModel: state.inProgressMatchList),
            state.getAllMatchesStatus == Status.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                  )
                : state.finishedMatchList.isEmpty
                    ? const EmptyCard(text: 'There are no finished matches')
                    : MatchCardList(matchModel: state.finishedMatchList),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateMatchScreen(),
                ),
              );
            },
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class MatchCardList extends StatelessWidget {
  const MatchCardList({
    super.key,
    required this.matchModel,
  });

  final List<MatchModel> matchModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchDetailsScreen(
                  matchModel: matchModel[index],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 4,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matchModel[index].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                    'Start Time: ${DateFormat.jm().format(matchModel[index].startTime)}, ${DateFormat.MMMEd().format(matchModel[index].startTime)}'),
                Text(
                    'End Time: ${DateFormat.jm().format(matchModel[index].endTime)}, ${DateFormat.MMMEd().format(matchModel[index].endTime)}'),
              ],
            ),
          ),
        );
      },
      itemCount: matchModel.length,
    );
  }
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          size: 150,
          color: Colors.black.withOpacity(0.3),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
