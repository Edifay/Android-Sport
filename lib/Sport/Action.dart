class Action {
  String name;
  int time;

  Action(this.name, this.time);

  set setName(String name) => this.name = name;

  Map toJson() {
    return {
      'name': this.name,
      'time': this.time,
    };
  }

  factory Action.fromJson(dynamic json) => Action(json['name'] as String, json['time'] as int);

  Action clone(){
    return Action(this.name, this.time);
  }
}

class Repos extends Action {
  Repos(int time) : super("Repos", time);
}
