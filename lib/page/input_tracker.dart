import 'package:flutter/material.dart';

import 'dart:async';

import 'package:trackr/db/db_helper.dart';
import 'package:trackr/db/model.dart';
import 'package:trackr/helper/helper.dart';

class InputTracker extends StatefulWidget {
  final int? trackerId;
  final Color? iconColor;
  final String? trackerName;
  final String trackerType;
  final String? trackerUnit;
  final String? latestItem;
  final int? trackerPresetsId;
  final String? totalLoggedItem;
  final int? entries;
  const InputTracker({
    super.key,
    this.trackerPresetsId,
    this.iconColor,
    this.trackerName,
    required this.trackerType,
    this.trackerUnit,
    this.latestItem,
    this.totalLoggedItem,
    this.trackerId,
    this.entries,
  });

  @override
  State<InputTracker> createState() => _InputTrackerState();
}

class _InputTrackerState extends State<InputTracker> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late Future<List<History>> _historyFuture;
  late Future<List<ItemQty>> _mandatoryItemFuture;
  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _valueController.text = widget.latestItem?.toString() ?? '';
    _historyFuture = getHistoryByTrackerId(widget.trackerId!);
    _mandatoryItemFuture = getMandatoryItemByTrackerId(widget.trackerId!);
  }

  void refreshData() {
    setState(() {
      _historyFuture = getHistoryByTrackerId(widget.trackerId!);
      _mandatoryItemFuture = getMandatoryItemByTrackerId(widget.trackerId!);
    });
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: _mandatoryItemFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No mandatory items available.'));
                  }
                  if (snapshot.hasData) {
                    final items = snapshot.data!;

                    return Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Latest'),
                                  Row(
                                    children: [
                                      (items.first.latestItem ?? 0) != 0
                                          ? Text(
                                              items.first.latestItem.toString(),
                                            )
                                          : Icon(
                                              Icons.remove,
                                              size: 40,
                                              color: Colors.grey[600],
                                            ),
                                      SizedBox(width: 5),
                                      widget.trackerType == 'number'
                                          ? Text(
                                              widget.trackerUnit ?? "",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          : Text('Items Logged'),
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
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Logged'),
                                  Row(
                                    children: [
                                      (items.first.totalLoggedItem ?? 0) != 0
                                          ? Text(
                                              items.first.totalLoggedItem
                                                  .toString(),
                                            )
                                          : Icon(
                                              Icons.remove,
                                              size: 40,
                                              color: Colors.grey[600],
                                            ),
                                      SizedBox(width: 5),
                                      widget.trackerType == 'number'
                                          ? Text(
                                              widget.trackerUnit ?? "",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          : Text('Items Logged'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(child: Text('No mandatory items available.'));
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Add Entry',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    controller: _valueController,
                                    keyboardType: widget.trackerType == 'number'
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: widget.trackerType == 'number'
                                          ? 'Value (${widget.trackerUnit})'
                                          : 'Enter text',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey[400]!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  TextField(
                                    controller: _noteController,
                                    decoration: InputDecoration(
                                      labelText: 'Note (Optional)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey[400]!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Get current item data to calculate accurate totals
                                          final currentItems = await DbHelper
                                              .instance
                                              .readSelectedItem(
                                                widget.trackerId!,
                                              );
                                          final currentTotal =
                                              currentItems.isNotEmpty
                                              ? currentItems
                                                        .first
                                                        .totalLoggedItem ??
                                                    "0"
                                              : "0";
                                          final currentEntries =
                                              currentItems.isNotEmpty
                                              ? (await DbHelper.instance
                                                        .readAllHistoryByTrackerId(
                                                          widget.trackerId!,
                                                        ))
                                                    .length
                                              : 0;

                                          final newValue =
                                              _valueController.text;
                                          dynamic fixValue;
                                          if (int.tryParse(newValue) == null) {
                                            fixValue =
                                                (int.parse(currentTotal) + 1)
                                                    .toString();
                                          } else {
                                            fixValue =
                                                (int.parse(currentTotal) +
                                                        int.parse(newValue))
                                                    .toString();
                                          }

                                          final addNewValue = Item(
                                            id: widget.trackerId!,
                                            trackerItemId:
                                                widget.trackerPresetsId,
                                            note: _noteController.text,
                                            latestItem: newValue.toString(),
                                            totalLoggedItem: fixValue,

                                            entries: currentEntries + 1,
                                            createdAt: DateTime.now(),
                                          );
                                          final newHistory = History(
                                            itemId: widget.trackerId,
                                            loggedItem: _valueController.text,
                                            createdAt: DateTime.now(),
                                            note: _noteController.text,
                                          );
                                          await DbHelper.instance.updateItem(
                                            addNewValue,
                                          );

                                          await DbHelper.instance.createHistory(
                                            newHistory.toMap(),
                                          );
                                          if (!context.mounted) return;

                                          Navigator.of(context).pop();
                                          // Refresh data after dialog is closed to ensure proper UI update
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                if (mounted) {
                                                  refreshData();
                                                }
                                              });
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      refreshData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '+ Add Entry',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No history available.'));
                  } else {
                    final historyList = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final history = historyList[index];
                        return ListTile(
                          title: Text(history.loggedItem),
                          subtitle: Text(history.note),
                          trailing: Text(
                            '${history.createdAt.toLocal()}'.split(' ')[0],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<History>> getHistoryByTrackerId(int trackerId) async {
  return await DbHelper.instance.readAllHistoryByTrackerId(trackerId);
}

Future<List<ItemQty>> getMandatoryItemByTrackerId(int trackerId) async {
  return await DbHelper.instance.readSelectedItem(trackerId);
}
