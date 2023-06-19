import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../web3_provider.dart';
import '../widgets/custom_text_field.dart';

class CreateMatchScreen extends ConsumerStatefulWidget {
  const CreateMatchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateMatchScreen> createState() => _SetIdentityScreenState();
}

class _SetIdentityScreenState extends ConsumerState<CreateMatchScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController endTimeController = TextEditingController();

  late int startDate;
  late int endDate;

  Future<dynamic> pickDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked == null) {
      return 'n';
    } else {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        picked = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
      return picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(web3Provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: titleController,
                hintText: 'Enter name',
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: startTimeController,
                readOnly: true,
                hintText: 'Select date',
                iconButton: IconButton(
                  onPressed: () async {
                    dynamic date = await pickDate();
                    if (date == 'n') return;
                    String pickedDate =
                        '${DateFormat.jm().format(date)}, ${DateFormat.MMMEd().format(date)}';
                    // String pickedDate = DateFormat('yyyy-MM-dd').format(date);
                    setState(() {
                      startDate = date.millisecondsSinceEpoch;
                      startTimeController.text = pickedDate;
                    });
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: endTimeController,
                readOnly: true,
                hintText: 'Select end date',
                iconButton: IconButton(
                  onPressed: () async {
                    dynamic date = await pickDate();
                    if (date == 'n') return;
                    String pickedDate =
                        '${DateFormat.jm().format(date)}, ${DateFormat.MMMEd().format(date)}';
                    // String pickedDate = DateFormat('yyyy-MM-dd').format(date);
                    setState(() {
                      endDate = date.millisecondsSinceEpoch;
                      endTimeController.text = pickedDate;
                    });
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                  child: state.createMatchStatus == Status.loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Create Match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        startTimeController.text.trim().isEmpty ||
                        endTimeController.text.trim().isEmpty) {
                      return;
                    }
                    state.createMatch(
                      titleController.text.trim(),
                      startDate,
                      endDate,
                      context,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
