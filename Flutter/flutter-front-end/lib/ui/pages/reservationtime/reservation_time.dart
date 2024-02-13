import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pw5/data/repositories/resource_repository.dart';
import 'package:pw5/domain/models/building_model.dart';
import 'package:pw5/domain/models/reservation_time_range_model.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/roommap/roommap_screen.dart';

class ReservationTimeScreen extends StatefulWidget {
  final Building building;
  const ReservationTimeScreen({
    super.key,
    required this.building,
  });

  @override
  State<ReservationTimeScreen> createState() => _ReservationTimeScreenState();
}

class _ReservationTimeScreenState extends State<ReservationTimeScreen> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  String timeDropdownTime = '';
  String initialTime = '';
  String finaleTime = '';
  bool isCustomTimeSelected = false;

  bool isLoading = false;

  final ResourceRepository resourceRepository = ResourceRepository();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SnackBar _createSnackbar(String msg) {
    return SnackBar(
      elevation: 5.0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
      content: Wrap(
        children: [
          Center(
            child: Text(msg),
          ),
        ],
      ),
    );
  }

  void submitData() async {
    String startTime = startTimeController.text.isEmpty
        ? initialTime
        : startTimeController.text;
    String endTime =
        endTimeController.text.isEmpty ? finaleTime : endTimeController.text;

    DateTime startDateTime = DateTime.parse('${dateInput.text}T$startTime');
    DateTime endDateTime = DateTime.parse('${dateInput.text}T$endTime');

    ReservationTimeRange reservationTimeRange = ReservationTimeRange(
      buildingId: widget.building.buildingId,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
    );

    if (_formKey.currentState!.validate()) {
      if (timeDropdownTime == "Orari personalizzati") {
        if (startTimeController.text.isEmpty ||
            endTimeController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              _createSnackbar("Please select both start and end times."));
          return;
        }
        if (startTimeController.text.compareTo(endTimeController.text) > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              _createSnackbar("Start time must be earlier than end time."));
          return;
        }
        if (startDateTime.hour == endDateTime.hour) {
          ScaffoldMessenger.of(context).showSnackBar(_createSnackbar(
              'The hours of the reservation time cannot be consistent'));
          return;
        }
      }

      setState(() {
        isLoading = true;
      });
      await resourceRepository
          .getResourceFromRangeDate(reservationTimeRange)
          .then((freeResourceDataList) {
        if (freeResourceDataList.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomMapScreen(
                    building: widget.building,
                    reservationTimeRange: reservationTimeRange)),
          ).then((_) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LayoutScreen()),
                (route) => false);
            setState(() {
              isLoading = false;
            });
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(_createSnackbar('Date Invalid'));
              
          setState(() {
            isLoading = false;
          });
        }
      }).catchError((error) {
        debugPrint("Request failed: $error");
        ScaffoldMessenger.of(context)
            .showSnackBar(_createSnackbar('Request failed.'));
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  String formatTime(TimeOfDay time) {
    var formatter = intl.DateFormat("HH:mm");
    return formatter.format(DateTime(0, 0, 0, time.hour, time.minute));
  }

  Future<void> showTimePickerAndUpdate(TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = formatTime(pickedTime);
      });
    }
  }

  void updateTime(Map<String, String> selectedTime) {
    setState(() {
      timeDropdownTime = selectedTime['name']!;
      initialTime = selectedTime['initialTime']!;
      finaleTime = selectedTime['finaleTime']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Reservation Time"),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        height: 100,
                        child: ListTile(
                          leading: const Icon(Icons.date_range),
                          title: TextFormField(
                            controller: dateInput,
                            decoration: const InputDecoration(
                              labelText: "Enter Date",
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                String formattedDate =
                                    intl.DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                setState(() {
                                  dateInput.text = formattedDate;
                                });
                              } else {}
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TimeDropdown(updateTime: updateTime),
                (timeDropdownTime == "Orari personalizzati"
                    ? Card(
                        child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: TextField(
                              controller: startTimeController,
                              decoration: const InputDecoration(
                                  labelText: "Start Time"),
                              readOnly: true,
                              onTap: () =>
                                  showTimePickerAndUpdate(startTimeController),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: TextField(
                              controller: endTimeController,
                              decoration:
                                  const InputDecoration(labelText: "End Time"),
                              readOnly: true,
                              onTap: () =>
                                  showTimePickerAndUpdate(endTimeController),
                            ),
                          ),
                        ],
                      ))
                    : const SizedBox())
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: isLoading ? null : submitData,
              child:  isLoading ? const Text('Loading...') : const Text('Submit'),
            ),
          ),
        ));
  }
}

class TimeDropdown extends StatefulWidget {
  final Function(Map<String, String>) updateTime;
  const TimeDropdown({required this.updateTime, Key? key}) : super(key: key);
  @override
  State<TimeDropdown> createState() => _TimeDropdownState();
}

class _TimeDropdownState extends State<TimeDropdown> {
  late Map<String, String> _bankChoose;

  final bankDataList = [
    {
      "name": "Mattina",
      "initialTime": "09:00",
      "finaleTime": "13:00",
      "logo": "assets/icons/pc.png"
    },
    {
      "name": "Pomeriggio",
      "initialTime": "14:00",
      "finaleTime": "18:00",
      "logo": "assets/icons/pc.png"
    },
    {
      "name": "Tutto il giorno",
      "initialTime": "09:00",
      "finaleTime": "18:00",
      "logo": "assets/icons/pc.png"
    },
    {
      "name": "Orari personalizzati",
      "initialTime": "",
      "finaleTime": "",
      "logo": "assets/icons/pc.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _bankChoose = bankDataList[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateTime(_bankChoose);
    });
  }

  void _onDropDownItemSelected(Map<String, String> newSelectedBank) {
    setState(() {
      _bankChoose = newSelectedBank;
    });
  }

  void _onDropDownItemTapped(Map<String, String> value) {
    if (value.containsKey('name') &&
        value.containsKey('initialTime') &&
        value.containsKey('finaleTime')) {
      widget.updateTime(value);
    } else {
      debugPrint(
          'Warning: The selected item does not contain all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Map<String, String>>(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: "verdana_regular",
                ),
                hint: const Text(
                  "Select Moment",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                  ),
                ),
                items: bankDataList.map((Map<String, String> value) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: value,
                    onTap: () => _onDropDownItemTapped(value),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(value['logo']!),
                        ),
                        const SizedBox(width: 10),
                        Text(
                            "${value['name']}${value['name'] != "Orari personalizzati" ? " (${value['initialTime']} - ${value['finaleTime']})" : ""}"),
                      ],
                    ),
                  );
                }).toList(),
                isExpanded: true,
                isDense: true,
                onChanged: (Map<String, String>? newSelectedBank) {
                  if (newSelectedBank != null) {
                    _onDropDownItemSelected(newSelectedBank);
                  }
                },
                value: _bankChoose,
              ),
            ),
          );
        },
      ),
    );
  }
}
