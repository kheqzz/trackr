import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:trackr/db/db_helper.dart';
import 'package:trackr/db/model.dart';
import 'package:trackr/helper/helper.dart';
import 'package:trackr/page/input_tracker.dart';
import 'package:trackr/page/tracker_create.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<TrackedItem>> _trackedItemsFuture;

  @override
  void initState() {
    super.initState();

    _trackedItemsFuture = fetchAllTrackedItems();
  }

  void refreshData() {
    setState(() {
      _trackedItemsFuture = fetchAllTrackedItems();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trackr'),
            Text(
              'Feel free to track your daily needs',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _trackedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final items = snapshot.data!;
            print(
              "Rendering tracked items: ${items.map((item) => item.toMap()).toList()}",
            );
            print("item id: ${items[0].item.id}");
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 7,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),

                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputTracker(
                                entries: item.item.entries,
                                iconColor: item.trackerItemPresets.iconColor
                                    .toColorFill(),
                                trackerName:
                                    item.trackerItemPresets.trackerName,
                                trackerId: item.item.id!,
                                trackerType: item.trackerItemPresets.type,
                                trackerUnit: item.trackerItemPresets.unit,
                                trackerPresetsId: item.trackerItemPresets.id,
                                latestItem: item.item.latestItem,
                                totalLoggedItem: item.item.totalLoggedItem,
                              ),
                            ),
                          );
                          refreshData();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              height: 50,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: item.trackerItemPresets.iconColor
                                        .toColorFill(),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.trackerItemPresets.trackerName
                                          .toInitials(),
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
                            title: Text(item.trackerItemPresets.trackerName),
                            subtitle: Text("${item.item.entries} entries"),
                            trailing: SizedBox(
                              width: 80,
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.end,

                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      item.item.latestItem != 0
                                          ? Text(
                                              item.item.latestItem.toString(),
                                            )
                                          : Icon(Icons.remove, size: 20),
                                      Text(
                                        'latest',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Center(
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.api_rounded,
                    size: 50,
                    color: Colors.black45,
                  ),
                ),
                Text(
                  'Nothing tracked yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Hit the button bellow to create your first tracker',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackerCreate()),
              );
              refreshData();
            },

            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 60),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Add new item",
              style: TextStyle(color: Color.fromARGB(255, 244, 230, 230)),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Item>> fetchData() async {
  final data = await DbHelper.instance.readAllItems();

  return data;
}

Future<List<TrackerItemPresets>> fetchTrackerItemPresets() async {
  return await DbHelper.instance.readAllTrackerItemsPresets();
}

Future<List<TrackedItem>> fetchAllTrackedItems() async {
  final data = await DbHelper.instance.readAllTrackedItems();

  print("Fetched tracked items: $data");
  return data;
}
