import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/domain/models/filters_model.dart';
import 'package:pw5/domain/models/user_model.dart';
import 'package:pw5/ui/pages/allreservations/allreservations__bloc/allreservations_bloc.dart';
import 'package:pw5/ui/pages/allreservations/allreservations_screen.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key, required this.bloc});
  final AllReservationsBloc bloc;
  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  bool isLoading = true;
  List<UserGetAll> emailList = [];
  String? selectedValue;
  AuthRepository auth = AuthRepository();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    try {
      List<UserGetAll> emails = await auth.getAllUsers();
      setState(() {
        emailList = emails;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController dateInput = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();

  String formatTime(TimeOfDay time) {
    var formatter = intl.DateFormat("HH:mm");
    return formatter.format(DateTime(0, 0, 0, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 564,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      height: 100,
                      child: SizedBox(
                        height: 60,
                        width: 200,
                        child: ListTile(
                          leading: const Icon(Icons.date_range, size: 20),
                          title: TextField(
                            controller: dateInput,
                            decoration: const InputDecoration(
                                labelText: "Enter Date"),
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Card(
              child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.access_time),
                title: TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(labelText: "Start Time"),
                  readOnly: true,
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        });
                    if (pickedTime != null) {
                      setState(() {
                        startTimeController.text = formatTime(pickedTime);
                      });
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(labelText: "End Time"),
                  readOnly: true,
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        });
                    if (pickedTime != null) {
                      setState(() {
                        endTimeController.text = formatTime(pickedTime);
                      });
                    }
                  },
                ),
              ),
            ],
          )),
          const SizedBox(
            height: 30,
          ),
          if (!isLoading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "User Email",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (emailList.isNotEmpty)
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: emailList
                                  .map((email) => DropdownMenuItem(
                                        value: email.email,
                                        child: Text(
                                          email.email,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 200,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 130,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController: textEditingController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: 'Search for an item...',
                                      hintStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  return item.value
                                      .toString()
                                      .contains(searchValue);
                                },
                              ),
                              //This to clear the search value when you close the menu
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  textEditingController.clear();
                                }
                              },
                            ),
                          )
                        else if (emailList.isEmpty)
                          const Text(
                            "No users available",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (isLoading) const SizedBox(),
          const SizedBox(height: 136),
          ElevatedButton(
            onPressed: () {
              formaFiltriApriAllReservations();
            },
            child: const Text("Filter"),
          ),
        ],
      ),
    );
  }

  static Logger log = Logger();
  void formaFiltriApriAllReservations() {
    DateTime? giornoSelezionato;
    DateTime? startDateSelected;
    DateTime? endDateSelected;

    // Converti dateInput.text in DateTime se non è vuoto
    if (dateInput.text.isNotEmpty) {
      giornoSelezionato = DateTime.parse(dateInput.text);

      //start e end sono entrambi vuoti?
      if (startTimeController.text.isEmpty && endTimeController.text.isEmpty) {
        startDateSelected = giornoSelezionato.add(
          const Duration(
            hours: 0,
            minutes: 0,
          ),
        );
        endDateSelected = giornoSelezionato.add(
          const Duration(
            hours: 23,
            minutes: 59,
          ),
        );
      } else {
        if (startTimeController.text.isNotEmpty) {
          TimeOfDay pickedTime = TimeOfDay(
            hour: int.parse(startTimeController.text.split(":")[0]),
            minute: int.parse(startTimeController.text.split(":")[1]),
          );

          startDateSelected = giornoSelezionato.add(
            Duration(
              hours: pickedTime.hour,
              minutes: pickedTime.minute,
            ),
          );
        }
        if (endTimeController.text.isNotEmpty) {
          TimeOfDay pickedTime = TimeOfDay(
            hour: int.parse(endTimeController.text.split(":")[0]),
            minute: int.parse(endTimeController.text.split(":")[1]),
          );

          endDateSelected = giornoSelezionato.add(
            Duration(
              hours: pickedTime.hour,
              minutes: pickedTime.minute,
            ),
          );
        }
      }
    }
    log.d("$endDateSelected $startDateSelected $selectedValue");
    Filters filters = Filters(
        dateEnd: endDateSelected,
        dateStart: startDateSelected,
        email: selectedValue);

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllReservationsScreen(filters: filters)));
  }
}

void showFilterModal(BuildContext context, AllReservationsBloc bloc) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return FilterModal(bloc: bloc);
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    isScrollControlled: true,
  );
}
