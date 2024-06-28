import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeline extends StatefulWidget {
  final Function(DateTime) onDateChange;

  const CustomDateTimeline({Key? key, required this.onDateChange}) : super(key: key);

  @override
  _CustomDateTimelineState createState() => _CustomDateTimelineState();
}

class _CustomDateTimelineState extends State<CustomDateTimeline> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> getLast7Days() {
    return List.generate(7, (index) => DateTime.now().subtract(Duration(days: index))).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final days = getLast7Days();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: days.map((date) {
        final isSelected = date.day == selectedDate.day && date.month == selectedDate.month && date.year == selectedDate.year;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
            widget.onDateChange(date);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat.E().format(date),
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
                Text(
                  DateFormat.d().format(date),
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
