import 'package:test/test.dart';
import 'package:awase_app/models/user.dart';

void main() {
  setUp(() async {
    // testを実行する前に初期化したい処理を記述する。
    // 各testが実行される前に初期化される。
  });

  tearDown(() async {
    // testが完了後に実行したい処理を記述する。
  });
  
  test("生成されたUserインスタンスの値が正しい", () {
    final neonankiti = User(id: "1", name: "neonankiti");

    expect(neonankiti.id, "2");
    expect(neonankiti.name, "neonankiti");
  });

  test("Userインスタンスの名前をリネームした結果が正しい。", () {
    final neonankiti = User(id: "1", name: "neonankiti");
    neonankiti.rename("bison");
    expect(neonankiti.name, "bison");
  });
}
//@immutable
//class User {
//  final String id;
//  final String name;
//
//  User({ @required this.id, @required this.name }):
//    assert(id != null),
//    assert(name != null);
//
//  static User fromJson(Map<String, dynamic> json) {
//    return User(
//      id: json['id'],
//      name: json['name'],
//    );
//  }
//}
