class User {
  User({
    bool? state,
    String? email,
    int? id,
    LinkInfo? link,}){
    _state = state;
    _email = email;
    _id = id;
    _links = link;
  }

  User.fromJson(dynamic json) {
    _state = json['state'];
    _email = json['email'];
    _id = json['id'];
    _links = json['links'] != null ? LinkInfo.fromJson(json['links']) : null;
  }
  bool? _state;
  String? _email;
  int? _id;
  LinkInfo? _links;

  bool? get state => _state;
  String? get email => _email;
  int? get id => _id;
  LinkInfo? get links => _links;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['state'] = _state;
    map['email'] = _email;
    map['id'] = _id;
    if (_links != null) {
      map['links'] = _links?.toJson();
    }
    return map;
  }

}

/// count : 8
/// sum_total : 142
/// sum_today : 2

class LinkInfo {
  LinkInfo({
    int? count,
    int? sumTotal,
    int? sumToday,}){
    _count = count;
    _sumTotal = sumTotal;
    _sumToday = sumToday;
  }

  LinkInfo.fromJson(dynamic json) {
    _count = json['count'];
    _sumTotal = json['sum_total'];
    _sumToday = json['sum_today'];
  }
  int? _count;
  int? _sumTotal;
  int? _sumToday;

  int? get count => _count;
  int? get sumTotal => _sumTotal;
  int? get sumToday => _sumToday;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['sum_total'] = _sumTotal;
    map['sum_today'] = _sumToday;
    return map;
  }
}



class Links {
  Links({
    required this.link,
  });
  late final List<Link> link;

  Links.fromJson(Map<String, dynamic> json){
    link = List.from(json['link']).map((e)=>Link.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['link'] = link.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Link {
  Link({
    required this.id,
    required this.state,
    required this.mode,
    required this.prefix,
    required this.suffix,
    required this.rootPath,
    required this.owner,
    required this.content,
    required this.createdDate,
    required this.lastSeenDate,
    required this.totalUsedTimes,
    required this.todayUsedTimes,
  });
  late final int id;
  late final bool state;
  late final String mode;
  late final String prefix;
  late final String suffix;
  late final String rootPath;
  late final int owner;
  late final Content content;
  late final String createdDate;
  late final String lastSeenDate;
  late final int totalUsedTimes;
  late final int todayUsedTimes;

  Link.fromJson(Map<String, dynamic> json){
    id = json['id'];
    state = json['state'];
    mode = json['mode'];
    prefix = json['prefix'];
    suffix = json['suffix'];
    rootPath = json['root_path'] ?? "";
    owner = json['owner'];
    content = Content.fromJson(json['content']);
    createdDate = json['created_date'];
    lastSeenDate = json['last_seen_date'];
    totalUsedTimes = json['total_used_times'];
    todayUsedTimes = json['today_used_times'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['state'] = state;
    _data['mode'] = mode;
    _data['prefix'] = prefix;
    _data['suffix'] = suffix;
    _data['root_path'] = rootPath;
    _data['owner'] = owner;
    _data['content'] = content.toJson();
    _data['created_date'] = createdDate;
    _data['last_seen_date'] = lastSeenDate;
    _data['total_used_times'] = totalUsedTimes;
    _data['today_used_times'] = todayUsedTimes;
    return _data;
  }
}

class Content {
  Content({
    required this.type,
    required this.title,
    required this.content,
    required this.needPassword,
    required this.variable
  });
  late final String type;
  late final String title;
  late final String content;
  late final bool needPassword;
  late final Variables? variable;

  Content.fromJson(Map<String, dynamic> json){
    type = json['type'];
    title = json['title'] ?? "";
    content = json['content'];
    needPassword = json['need_password'];
    if(json['variable'] != null) {
      variable = Variables.fromJson(json['variable']);
    } else {
      variable = Variables.fromJson([]);
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['title'] = title;
    _data['content'] = content;
    _data['need_password'] = needPassword;
    return _data;
  }
}
class Variables {
  Variables({
    required this.variables
  });
  late final List<Variable> variables;

  Variables.fromJson(List<dynamic> json){
    variables = [];
    for (var element in json) {
      variables.add(Variable.fromJson(element));
    }
  }

  List<Map<String,String>> toJson() {
    final List<Map<String,String>> _data = [];
    for(int i=0;i<variables.length;i++){
      // _data[variables[i].key] = variables[i].value;
      // print(variables[i].toJson());
      _data.add(variables[i].toJson());
    }
    return _data;
  }
}

class Variable {
  Variable({
    required this.key,
    required this.value
  });
  late final String key;
  late final String value;

  Variable.fromJson(Map<String,dynamic> json){
    for (var element in json.keys) {key = element;value = json[element].toString();}
  }

  Map<String,String> toJson(){
    final _data = <String, String>{};
    _data[key] = value;
    return _data;
  }
}