import 'package:dynamic_library_path_test/src/devices/external/interface/external.dart';

import 'command_status.dart';

typedef CommandCallback<S, F> = void Function(CommandStatus<S, F> status);

abstract interface class Command<E extends External> {
  void execute(E External);

  String templatizeToString();
}
