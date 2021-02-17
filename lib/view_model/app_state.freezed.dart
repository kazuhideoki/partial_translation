// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return _AppState.fromJson(json);
}

/// @nodoc
class _$AppStateTearOff {
  const _$AppStateTearOff();

// ignore: unused_element
  _AppState call(
      {int count = 0,
      bool longTapToTranslate = false,
      bool selectParagraph = false}) {
    return _AppState(
      count: count,
      longTapToTranslate: longTapToTranslate,
      selectParagraph: selectParagraph,
    );
  }

// ignore: unused_element
  AppState fromJson(Map<String, Object> json) {
    return AppState.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $AppState = _$AppStateTearOff();

/// @nodoc
mixin _$AppState {
  int get count;
  bool get longTapToTranslate;
  bool get selectParagraph;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $AppStateCopyWith<AppState> get copyWith;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
  $Res call({int count, bool longTapToTranslate, bool selectParagraph});
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;

  @override
  $Res call({
    Object count = freezed,
    Object longTapToTranslate = freezed,
    Object selectParagraph = freezed,
  }) {
    return _then(_value.copyWith(
      count: count == freezed ? _value.count : count as int,
      longTapToTranslate: longTapToTranslate == freezed
          ? _value.longTapToTranslate
          : longTapToTranslate as bool,
      selectParagraph: selectParagraph == freezed
          ? _value.selectParagraph
          : selectParagraph as bool,
    ));
  }
}

/// @nodoc
abstract class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) then) =
      __$AppStateCopyWithImpl<$Res>;
  @override
  $Res call({int count, bool longTapToTranslate, bool selectParagraph});
}

/// @nodoc
class __$AppStateCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(_AppState _value, $Res Function(_AppState) _then)
      : super(_value, (v) => _then(v as _AppState));

  @override
  _AppState get _value => super._value as _AppState;

  @override
  $Res call({
    Object count = freezed,
    Object longTapToTranslate = freezed,
    Object selectParagraph = freezed,
  }) {
    return _then(_AppState(
      count: count == freezed ? _value.count : count as int,
      longTapToTranslate: longTapToTranslate == freezed
          ? _value.longTapToTranslate
          : longTapToTranslate as bool,
      selectParagraph: selectParagraph == freezed
          ? _value.selectParagraph
          : selectParagraph as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_AppState with DiagnosticableTreeMixin implements _AppState {
  const _$_AppState(
      {this.count = 0,
      this.longTapToTranslate = false,
      this.selectParagraph = false})
      : assert(count != null),
        assert(longTapToTranslate != null),
        assert(selectParagraph != null);

  factory _$_AppState.fromJson(Map<String, dynamic> json) =>
      _$_$_AppStateFromJson(json);

  @JsonKey(defaultValue: 0)
  @override
  final int count;
  @JsonKey(defaultValue: false)
  @override
  final bool longTapToTranslate;
  @JsonKey(defaultValue: false)
  @override
  final bool selectParagraph;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppState(count: $count, longTapToTranslate: $longTapToTranslate, selectParagraph: $selectParagraph)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppState'))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('longTapToTranslate', longTapToTranslate))
      ..add(DiagnosticsProperty('selectParagraph', selectParagraph));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AppState &&
            (identical(other.count, count) ||
                const DeepCollectionEquality().equals(other.count, count)) &&
            (identical(other.longTapToTranslate, longTapToTranslate) ||
                const DeepCollectionEquality()
                    .equals(other.longTapToTranslate, longTapToTranslate)) &&
            (identical(other.selectParagraph, selectParagraph) ||
                const DeepCollectionEquality()
                    .equals(other.selectParagraph, selectParagraph)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(count) ^
      const DeepCollectionEquality().hash(longTapToTranslate) ^
      const DeepCollectionEquality().hash(selectParagraph);

  @JsonKey(ignore: true)
  @override
  _$AppStateCopyWith<_AppState> get copyWith =>
      __$AppStateCopyWithImpl<_AppState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AppStateToJson(this);
  }
}

abstract class _AppState implements AppState {
  const factory _AppState(
      {int count, bool longTapToTranslate, bool selectParagraph}) = _$_AppState;

  factory _AppState.fromJson(Map<String, dynamic> json) = _$_AppState.fromJson;

  @override
  int get count;
  @override
  bool get longTapToTranslate;
  @override
  bool get selectParagraph;
  @override
  @JsonKey(ignore: true)
  _$AppStateCopyWith<_AppState> get copyWith;
}
