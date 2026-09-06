import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:trackr/db/db_helper.dart';
import 'package:trackr/db/model.dart';
import 'package:trackr/helper/helper.dart';

class TrackerCreate extends StatefulWidget {
  const TrackerCreate({super.key});

  @override
  State<TrackerCreate> createState() => _TrackerCreateState();
}

class _TrackerCreateState extends State<TrackerCreate> {
  String? _selectedType;
  final Color _selectedColor = Colors.white;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  late Future<List<TrackerItemPresets>> _trackerPresetsFuture;
  @override
  void initState() {
    super.initState();
    _trackerPresetsFuture = fetchTrackerPresets();
  }

  Future<List<TrackerItemPresets>> fetchTrackerPresets() async {
    final data = await DbHelper.instance.readAllTrackerItemsPresets();
    return data;
  }

  void refreshData() {
    setState(() {
      _trackerPresetsFuture = fetchTrackerPresets();
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
        future: _trackerPresetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final preset = snapshot.data!;
            print(preset[0].id);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Tracker',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            'Quick Presets',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: preset.map((presets) {
                              print("presets.id: ${presets.id}");
                              return Row(
                                spacing: 5,
                                mainAxisSize: MainAxisSize.min,
                                children: [iconButtonWord(presets)],
                              );
                            }).toList(),
                          ),

                          const Divider(color: Colors.grey),
                          Text(
                            'Create Custom Presets',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          customPresets(context, preset),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  SizedBox customPresets(
    BuildContext context,
    List<TrackerItemPresets> preset,
  ) {
    return SizedBox(
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name', style: TextStyle(color: Colors.black54)),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Tracker Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffd7d5cd)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffd7d5cd)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Color'),
                    TextField(
                      controller: _colorController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.color_lens_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              useSafeArea: true,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                Color tempColor = _selectedColor;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 20,
                                      ),
                                      child: Text(
                                        "Select Color",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ColorPicker(
                                      pickerColor: tempColor,
                                      onColorChanged: (value) {
                                        tempColor = value;
                                      },
                                      paletteType: PaletteType.hsvWithHue,
                                      pickerAreaBorderRadius:
                                          BorderRadius.circular(50),

                                      enableAlpha: false,
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        spacing: 10,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _colorController.text =
                                                  '#${tempColor.toHexString()}';
                                              Navigator.pop(context);
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        hintText: 'Color',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xffd7d5cd)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xffd7d5cd)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          'Select Type',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        value: _selectedType,
                        items: preset
                            .map((e) => e.type)
                            .toSet()
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              _selectedType == 'number'
                  ? Expanded(
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Unit'),
                          TextField(
                            controller: _unitController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xffd7d5cd),
                                ),
                              ),
                              hint: Text('e.g. kg, IDR'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xffd7d5cd),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _selectedType == null ||
                        _colorController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all required fields'),
                        ),
                      );
                      return;
                    }
                    final newPreset = TrackerItemPresets(
                      trackerName: _nameController.text,
                      type: _selectedType!,
                      unit: _unitController.text,
                      iconColor: _colorController.text,
                      createdAt: DateTime.now(),
                    );
                    await DbHelper.instance.createTrackerItem(
                      newPreset.toMap(),
                    );
                    refreshData();
                  },
                  child: Text('Save'),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Material iconButtonWord(TrackerItemPresets presets) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final newItem = Item(
            trackerItemId: presets.id,

            note: ' ',
            latestItem: "0",
            totalLoggedItem: "0",
            entries: 0,
            createdAt: DateTime.now(),
          );
          await DbHelper.instance.createItem(newItem);
          if (!mounted) return;
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffd7d5cd)),
          ),
          child: Row(
            spacing: 5,
            children: [
              SizedBox(
                height: 28,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: presets.iconColor.toColorFill(),
                    ),
                    child: Center(
                      child: Text(
                        presets.trackerName.toInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(presets.trackerName),
            ],
          ),
        ),
      ),
    );
  }
}
