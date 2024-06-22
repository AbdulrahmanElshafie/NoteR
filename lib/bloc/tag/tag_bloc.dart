import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:noter/shared/network/local/local_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  late LocalDbService localDbService;
  TagBloc(SharedPreferences prefs) : super(TagInitial()) {
    localDbService = LocalDbService(prefs);
    on<TagEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
