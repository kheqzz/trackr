import 'package:flutter/material.dart';
import 'package:trackr/db/db_helper.dart';
import 'package:trackr/db/model.dart';
import 'package:trackr/page/tracker_create.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = fetchData();
  }

  void refreshData() {
    setState(() {
      _itemsFuture = fetchData();
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
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.note),
                );
              },
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackerCreate()),
              );
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
  print('fetching data from database');
  for (var item in data) {
    print('Is there any data? ${item.name}');
  }
  return data;
}
