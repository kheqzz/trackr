class Item {
  final int? id;
  final String name;
  final String note;
  final int latestItem;
  final int totalLoggedItem;
  final int entries;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.name,
    required this.note,
    required this.latestItem,
    required this.totalLoggedItem,
    required this.entries,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'note': note,
      'latestItem': latestItem,
      'totalLoggedItem': totalLoggedItem,
      'entries': entries,
      'createdAt': createdAt.toIso8601String().split('T').first,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      note: map['note'],
      latestItem: map['latestItem'],
      totalLoggedItem: map['totalLoggedItem'],
      entries: map['entries'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class TrackerItemPresets {
  final int? id;
  final String trackerName;
  final String type;
  final String? unit;
  final String iconColor;
  final DateTime createdAt;

  TrackerItemPresets({
    this.id,
    required this.trackerName,
    required this.type,
    required this.unit,
    required this.iconColor,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracker_name': trackerName,
      'type': type,
      'unit': unit,
      'icon_color': iconColor,
      'createdAt': createdAt.toIso8601String().split('T').first,
    };
  }

  factory TrackerItemPresets.fromMap(Map<String, dynamic> map) {
    return TrackerItemPresets(
      id: map['id'],
      trackerName: map['tracker_name'],
      type: map['type'],
      unit: map['unit'] ?? "",
      iconColor: map['icon_color'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
