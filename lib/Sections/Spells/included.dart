class Spell {
  String? name;
  String? source;
  int? page;
  int? level;
  String? school;
  List<Time>? time;
  Range? range;
  Components? components;
  List<SpellDuration>? duration;
  List<String>? entries;
  List<EntriesHigherLevel>? entriesHigherLevel;
  List<String>? miscTags;
  Classes? classes;

  Spell(
      {this.name,
      this.source,
      this.page,
      this.level,
      this.school,
      this.time,
      this.range,
      this.components,
      this.duration,
      this.entries,
      this.entriesHigherLevel,
      this.miscTags,
      this.classes});

  Spell.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    source = json['source'];
    page = json['page'];
    level = json['level'];
    school = json['school'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time!.add(new Time.fromJson(v));
      });
    }
    range = json['range'] != null ? new Range.fromJson(json['range']) : null;
    components = json['components'] != null
        ? new Components.fromJson(json['components'])
        : null;
    if (json['duration'] != null) {
      duration = <SpellDuration>[];
      json['duration'].forEach((v) {
        duration!.add(new SpellDuration.fromJson(v));
      });
    }
    entries = json['entries'].cast<String>();
    if (json['entriesHigherLevel'] != null) {
      entriesHigherLevel = <EntriesHigherLevel>[];
      json['entriesHigherLevel'].forEach((v) {
        entriesHigherLevel!.add(new EntriesHigherLevel.fromJson(v));
      });
    }
    miscTags = json['miscTags']?.cast<String>();
    classes =
        json['classes'] != null ? new Classes.fromJson(json['classes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['source'] = this.source;
    data['page'] = this.page;
    data['level'] = this.level;
    data['school'] = this.school;
    if (this.time != null) {
      data['time'] = this.time!.map((v) => v.toJson()).toList();
    }
    if (this.range != null) {
      data['range'] = this.range!.toJson();
    }
    if (this.components != null) {
      data['components'] = this.components!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.map((v) => v.toJson()).toList();
    }
    data['entries'] = this.entries;
    if (this.entriesHigherLevel != null) {
      data['entriesHigherLevel'] =
          this.entriesHigherLevel!.map((v) => v.toJson()).toList();
    }
    data['miscTags'] = this.miscTags;
    if (this.classes != null) {
      data['classes'] = this.classes!.toJson();
    }
    return data;
  }
}

class Time {
  int? number;
  String? unit;

  Time({this.number, this.unit});

  Time.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['unit'] = this.unit;
    return data;
  }
}

class Range {
  String? type;
  Distance? distance;

  Range({this.type, this.distance});

  Range.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    return data;
  }
}

class Distance {
  String? type;
  int? amount;
  Distance({this.type, this.amount});

  Distance.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['amount'] = this.amount;
    return data;
  }
}

class Components {
  bool? v;
  bool? s;
  Materials? m;
  Components({this.v, this.s, this.m});

  Components.fromJson(Map<String, dynamic> json) {
    v = json['v'];
    s = json['s'];
    var temp = json['m'];
    switch (temp.runtimeType) {
      case String:
        m = Materials.fromJson({"text": temp});
        break;
      case Null:
        m = Materials.fromJson({"text": temp});
        break;
      default:
        m = Materials.fromJson(temp);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v'] = this.v;
    data['s'] = this.s;
    data['m'] = this.m;
    return data;
  }
}

class Materials {
  String? text;
  int? cost;
  Materials({this.text, this.cost});

  Materials.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['cost'] = this.cost;
    return data;
  }
}

class SpellDuration {
  String? type;
  SpellDuration? duration;
  bool? concentration;

  SpellDuration({this.type, this.duration, this.concentration});

  SpellDuration.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    duration = json['duration'] != null
        ? new SpellDuration.fromJson(json['duration'])
        : null;
    concentration = json['concentration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    data['concentration'] = this.concentration;
    return data;
  }
}

class Duration2 {
  String? type;
  int? amount;

  Duration2({this.type, this.amount});

  Duration2.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['amount'] = this.amount;
    return data;
  }
}

class EntriesHigherLevel {
  String? type;
  String? name;
  List<String>? entries;

  EntriesHigherLevel({this.type, this.name, this.entries});

  EntriesHigherLevel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    entries = json['entries'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['entries'] = this.entries;
    return data;
  }
}

class Classes {
  List<FromClassList>? fromClassList;

  Classes({this.fromClassList});

  Classes.fromJson(Map<String, dynamic> json) {
    if (json['fromClassList'] != null) {
      fromClassList = <FromClassList>[];
      json['fromClassList'].forEach((v) {
        fromClassList!.add(new FromClassList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fromClassList != null) {
      data['fromClassList'] =
          this.fromClassList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FromClassList {
  String? name;
  String? source;

  FromClassList({this.name, this.source});

  FromClassList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['source'] = this.source;
    return data;
  }
}
