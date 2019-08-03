class ActivityItem {

  static const TYPE_NONE = 0;

  static const TYPE_READING = 1<<1;
  static const TYPE_COMPUTER = 1<<2;
  static const TYPE_TV = 1<<3;
  static const TYPE_PHONE = 1<<4;
  static const TYPE_SPORTS = 1<<5;
  static const TYPE_HIKE = 1<<6;
  static const TYPE_SWIM = 1<<7;
  static const TYPE_CUSTOM = 1<<8;

  static const TYPE_INDOOR = 1<<9;
  static const TYPE_OUTDOOR = 1<<10;

  /// Activity id
  int id;
  /// Activity type one of [TYPE_READING], [TYPE_COMPUTER],
  /// [TYPE_TV], [TYPE_PHONE], [TYPE_CUSTOM],
  /// [TYPE_SPORTS], [TYPE_HIKE], [TYPE_SWIM]
  int type;
  /// Activity Custom Type id
  int customType;
  /// Target using time of this activity(unit: second)
  int target;
  /// Actual using time of this activity
  int actual;
  /// Create Time of this activity
  int time;

  ActivityItem({
    this.id,
    this.time,
    this.type,
    this.customType,
    this.target,
    this.actual,
  });

  ActivityItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    type = json['type'];
    customType = json['custom_type'];
    target = json['target'];
    actual = json['actual'];
  }

  ActivityItem.fromSql(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    type = json['type'];
    customType = json['custom_type'];
    target = json['target'];
    actual = json['actual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['type'] = this.type;
    data['custom_type'] = this.customType;
    data['target'] = this.target;
    data['actual'] = this.actual;
    return data;
  }
}
