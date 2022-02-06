import 'package:secondtry/Sport/Action.dart';

class Entrainement {
  String name;
  List<Action> actions = [];

  Entrainement(this.name, {this.actions}) {
    if (this.actions == null) this.actions = [];
  }

  void addAction(Action ac) => actions.add(ac);

  void addActions(List<Action> acs) => this.actions.addAll(acs);

  set setName(String name) => this.name = name;

  void removeAction(Action ac) => this.actions.remove(ac);


  int get duration {
    int total = 0;
    for (var ac in actions) total += ac.time;
    return total;
  }

  Map toJson() => {
        'name': this.name,
        'actions': this.actions.map((e) => e.toJson()).toList(),
      };

  factory Entrainement.fromJson(dynamic json) {
    return Entrainement(json['name'] as String,
        actions: (json['actions'] as List<dynamic>)
            .map((e) => Action.fromJson(e))
            .toList());
  }
}
