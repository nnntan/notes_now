import 'package:isar/isar.dart';

// This line;
// dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;
  late DateTime lastModified;
}
