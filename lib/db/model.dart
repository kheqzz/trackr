class Item {
  final int? id;
  final int? trackerItemId;

  final String note;
  final String latestItem;
  final String totalLoggedItem;
  final int entries;
  final DateTime createdAt;

  Item({
    this.id,
    required this.trackerItemId,

    required this.note,
    required this.latestItem,
    required this.totalLoggedItem,
    required this.entries,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_tracker': id,
      'id_tracker_item': trackerItemId,
      'note': note,
      'latestItem': latestItem,
      'totalLoggedItem': totalLoggedItem,
      'entries': entries,
      'createdAt': createdAt.toIso8601String().split('T').first,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      trackerItemId: map['id_tracker_item'],
      id: map['id_tracker'],

      note: map['note'] ?? "",
      latestItem: map['latestItem'] ?? "0",
      totalLoggedItem: map['totalLoggedItem'] ?? "0",
      entries: map['entries'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
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
      'tracker_name': trackerName,
      'type': type,
      'unit': unit,
      'icon_color': iconColor,
    };
  }

  factory TrackerItemPresets.fromMap(Map<String, dynamic> map) {
    return TrackerItemPresets(
      id: map['id_item'],
      trackerName: map['tracker_name'],
      type: map['type'],
      unit: map['unit'] ?? "",
      iconColor: map['icon_color'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class TrackedItem {
  final Item item;
  final TrackerItemPresets trackerItemPresets;

  TrackedItem({required this.item, required this.trackerItemPresets});

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'trackerItemPresets': trackerItemPresets.toMap(),
    };
  }

  factory TrackedItem.fromMap(Map<String, dynamic> map) {
    return TrackedItem(
      item: Item.fromMap(map),
      trackerItemPresets: TrackerItemPresets.fromMap(map),
    );
  }
}

class History {
  final int? id;
  final int? itemId;
  final String loggedItem;
  final DateTime createdAt;
  final String note;

  History({
    this.id,
    required this.itemId,
    required this.loggedItem,
    required this.createdAt,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_tracker': itemId,
      'logged_item': loggedItem,
      'createdAt': createdAt.toIso8601String().split('T').first,
      'note': note,
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id_history'],
      itemId: map['id_tracker'] ?? "",
      loggedItem: map['logged_item'] ?? "",
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      note: map['note'] ?? "",
    );
  }
}

class ItemQty {
  final int? id;
  final String? latestItem;
  final String? totalLoggedItem;

  ItemQty({this.id, this.latestItem, this.totalLoggedItem});

  factory ItemQty.fromMap(Map<String, dynamic> map) {
    return ItemQty(
      id: map['id_tracker'],
      latestItem: map['latestItem'],
      totalLoggedItem: map['totalLoggedItem'],
    );
  }
}
