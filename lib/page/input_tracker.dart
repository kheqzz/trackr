import 'package:flutter/material.dart';
import 'package:trackr/helper/helper.dart';

class InputTracker extends StatefulWidget {
  final Color? iconColor;
  final String? trackerName;
  final String trackerType;
  final String? trackerUnit;
  final int? latestItem;
  final int? totalLoggedItem;
  const InputTracker({
    super.key,
    this.iconColor,
    this.trackerName,
    required this.trackerType,
    this.trackerUnit,
    this.latestItem,
    this.totalLoggedItem,
  });

  @override
  State<InputTracker> createState() => _InputTrackerState();
}

class _InputTrackerState extends State<InputTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(18),
          child: const SizedBox(),
        ),
        title: Row(
          spacing: 10,
          children: [
            SizedBox(
              height: 45,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.iconColor,
                  ),
                  child: Center(
                    child: Text(
                      widget.trackerName!.toInitials(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(widget.trackerName!),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latest'),
                          Row(
                            children: [
                              widget.trackerUnit != ""
                                  ? (widget.latestItem! != 0
                                        ? Text(widget.latestItem.toString())
                                        : Icon(Icons.remove))
                                  : Text(widget.trackerUnit!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('History')],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
