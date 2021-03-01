// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AppStateTearOff {
  const _$AppStateTearOff();

// ignore: unused_element
  _AppState call(
      {InAppWebViewController webView,
      ContextMenu contextMenu,
      int count = 0,
      String currentUrl = '',
      bool isLongTapToTranslate = false,
      bool isSelectParagraph = false}) {
    return _AppState(
      webView: webView,
      contextMenu: contextMenu,
      count: count,
      currentUrl: currentUrl,
      isLongTapToTranslate: isLongTapToTranslate,
      isSelectParagraph: isSelectParagraph,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $AppState = _$AppStateTearOff();

/// @nodoc
mixin _$AppState {
  InAppWebViewController get webView;
  ContextMenu get contextMenu;
  int get count;
  String get currentUrl;
  bool get isLongTapToTranslate;
  bool get isSelectParagraph;

  @JsonKey(ignore: true)
  $AppStateCopyWith<AppState> get copyWith;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
  $Res call(
      {InAppWebViewController webView,
      ContextMenu contextMenu,
      int count,
      String currentUrl,
      bool isLongTapToTranslate,
      bool isSelectParagraph});
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;

  @override
  $Res call({
    Object webView = freezed,
    Object contextMenu = freezed,
    Object count = freezed,
    Object currentUrl = freezed,
    Object isLongTapToTranslate = freezed,
    Object isSelectParagraph = freezed,
  }) {
    return _then(_value.copyWith(
      webView: webView == freezed
          ? _value.webView
          : webView as InAppWebViewController,
      contextMenu: contextMenu == freezed
          ? _value.contextMenu
          : contextMenu as ContextMenu,
      count: count == freezed ? _value.count : count as int,
      currentUrl:
          currentUrl == freezed ? _value.currentUrl : currentUrl as String,
      isLongTapToTranslate: isLongTapToTranslate == freezed
          ? _value.isLongTapToTranslate
          : isLongTapToTranslate as bool,
      isSelectParagraph: isSelectParagraph == freezed
          ? _value.isSelectParagraph
          : isSelectParagraph as bool,
    ));
  }
}

/// @nodoc
abstract class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) then) =
      __$AppStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {InAppWebViewController webView,
      ContextMenu contextMenu,
      int count,
      String currentUrl,
      bool isLongTapToTranslate,
      bool isSelectParagraph});
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
    Object webView = freezed,
    Object contextMenu = freezed,
    Object count = freezed,
    Object currentUrl = freezed,
    Object isLongTapToTranslate = freezed,
    Object isSelectParagraph = freezed,
  }) {
    return _then(_AppState(
      webView: webView == freezed
          ? _value.webView
          : webView as InAppWebViewController,
      contextMenu: contextMenu == freezed
          ? _value.contextMenu
          : contextMenu as ContextMenu,
      count: count == freezed ? _value.count : count as int,
      currentUrl:
          currentUrl == freezed ? _value.currentUrl : currentUrl as String,
      isLongTapToTranslate: isLongTapToTranslate == freezed
          ? _value.isLongTapToTranslate
          : isLongTapToTranslate as bool,
      isSelectParagraph: isSelectParagraph == freezed
          ? _value.isSelectParagraph
          : isSelectParagraph as bool,
    ));
  }
}

/// @nodoc
class _$_AppState with DiagnosticableTreeMixin implements _AppState {
  const _$_AppState(
      {this.webView,
      this.contextMenu,
      this.count = 0,
      this.currentUrl = '',
      this.isLongTapToTranslate = false,
      this.isSelectParagraph = false})
      : assert(count != null),
        assert(currentUrl != null),
        assert(isLongTapToTranslate != null),
        assert(isSelectParagraph != null);

  @override
  final InAppWebViewController webView;
  @override
  final ContextMenu contextMenu;
  @JsonKey(defaultValue: 0)
  @override
  final int count;
  @JsonKey(defaultValue: '')
  @override
  final String currentUrl;
  @JsonKey(defaultValue: false)
  @override
  final bool isLongTapToTranslate;
  @JsonKey(defaultValue: false)
  @override
  final bool isSelectParagraph;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppState(webView: $webView, contextMenu: $contextMenu, count: $count, currentUrl: $currentUrl, isLongTapToTranslate: $isLongTapToTranslate, isSelectParagraph: $isSelectParagraph)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppState'))
      ..add(DiagnosticsProperty('webView', webView))
      ..add(DiagnosticsProperty('contextMenu', contextMenu))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('currentUrl', currentUrl))
      ..add(DiagnosticsProperty('isLongTapToTranslate', isLongTapToTranslate))
      ..add(DiagnosticsProperty('isSelectParagraph', isSelectParagraph));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AppState &&
            (identical(other.webView, webView) ||
                const DeepCollectionEquality()
                    .equals(other.webView, webView)) &&
            (identical(other.contextMenu, contextMenu) ||
                const DeepCollectionEquality()
                    .equals(other.contextMenu, contextMenu)) &&
            (identical(other.count, count) ||
                const DeepCollectionEquality().equals(other.count, count)) &&
            (identical(other.currentUrl, currentUrl) ||
                const DeepCollectionEquality()
                    .equals(other.currentUrl, currentUrl)) &&
            (identical(other.isLongTapToTranslate, isLongTapToTranslate) ||
                const DeepCollectionEquality().equals(
                    other.isLongTapToTranslate, isLongTapToTranslate)) &&
            (identical(other.isSelectParagraph, isSelectParagraph) ||
                const DeepCollectionEquality()
                    .equals(other.isSelectParagraph, isSelectParagraph)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(webView) ^
      const DeepCollectionEquality().hash(contextMenu) ^
      const DeepCollectionEquality().hash(count) ^
      const DeepCollectionEquality().hash(currentUrl) ^
      const DeepCollectionEquality().hash(isLongTapToTranslate) ^
      const DeepCollectionEquality().hash(isSelectParagraph);

  @JsonKey(ignore: true)
  @override
  _$AppStateCopyWith<_AppState> get copyWith =>
      __$AppStateCopyWithImpl<_AppState>(this, _$identity);
}

abstract class _AppState implements AppState {
  const factory _AppState(
      {InAppWebViewController webView,
      ContextMenu contextMenu,
      int count,
      String currentUrl,
      bool isLongTapToTranslate,
      bool isSelectParagraph}) = _$_AppState;

  @override
  InAppWebViewController get webView;
  @override
  ContextMenu get contextMenu;
  @override
  int get count;
  @override
  String get currentUrl;
  @override
  bool get isLongTapToTranslate;
  @override
  bool get isSelectParagraph;
  @override
  @JsonKey(ignore: true)
  _$AppStateCopyWith<_AppState> get copyWith;
}
