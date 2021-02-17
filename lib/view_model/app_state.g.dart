// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppState _$_$_AppStateFromJson(Map<String, dynamic> json) {
  return _$_AppState(
    count: json['count'] as int ?? 0,
    isLongTapToTranslate: json['isLongTapToTranslate'] as bool ?? false,
    isSelectParagraph: json['isSelectParagraph'] as bool ?? false,
  );
}

Map<String, dynamic> _$_$_AppStateToJson(_$_AppState instance) =>
    <String, dynamic>{
      'count': instance.count,
      'isLongTapToTranslate': instance.isLongTapToTranslate,
      'isSelectParagraph': instance.isSelectParagraph,
    };
