// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dynamicLessonHash() => r'8f8a2fa269ebc7da7bdfe58978ddd1a25924b0ab';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [dynamicLesson].
@ProviderFor(dynamicLesson)
const dynamicLessonProvider = DynamicLessonFamily();

/// See also [dynamicLesson].
class DynamicLessonFamily extends Family<AsyncValue<LessonContent>> {
  /// See also [dynamicLesson].
  const DynamicLessonFamily();

  /// See also [dynamicLesson].
  DynamicLessonProvider call({
    required String topic,
    required String level,
  }) {
    return DynamicLessonProvider(
      topic: topic,
      level: level,
    );
  }

  @override
  DynamicLessonProvider getProviderOverride(
    covariant DynamicLessonProvider provider,
  ) {
    return call(
      topic: provider.topic,
      level: provider.level,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dynamicLessonProvider';
}

/// See also [dynamicLesson].
class DynamicLessonProvider extends AutoDisposeFutureProvider<LessonContent> {
  /// See also [dynamicLesson].
  DynamicLessonProvider({
    required String topic,
    required String level,
  }) : this._internal(
          (ref) => dynamicLesson(
            ref as DynamicLessonRef,
            topic: topic,
            level: level,
          ),
          from: dynamicLessonProvider,
          name: r'dynamicLessonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dynamicLessonHash,
          dependencies: DynamicLessonFamily._dependencies,
          allTransitiveDependencies:
              DynamicLessonFamily._allTransitiveDependencies,
          topic: topic,
          level: level,
        );

  DynamicLessonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topic,
    required this.level,
  }) : super.internal();

  final String topic;
  final String level;

  @override
  Override overrideWith(
    FutureOr<LessonContent> Function(DynamicLessonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DynamicLessonProvider._internal(
        (ref) => create(ref as DynamicLessonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topic: topic,
        level: level,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LessonContent> createElement() {
    return _DynamicLessonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DynamicLessonProvider &&
        other.topic == topic &&
        other.level == level;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topic.hashCode);
    hash = _SystemHash.combine(hash, level.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DynamicLessonRef on AutoDisposeFutureProviderRef<LessonContent> {
  /// The parameter `topic` of this provider.
  String get topic;

  /// The parameter `level` of this provider.
  String get level;
}

class _DynamicLessonProviderElement
    extends AutoDisposeFutureProviderElement<LessonContent>
    with DynamicLessonRef {
  _DynamicLessonProviderElement(super.provider);

  @override
  String get topic => (origin as DynamicLessonProvider).topic;
  @override
  String get level => (origin as DynamicLessonProvider).level;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
