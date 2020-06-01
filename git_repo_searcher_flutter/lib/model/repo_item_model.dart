import 'package:built_value/built_value.dart';

part 'repo_item_model.g.dart';

abstract class RepoItemModel
    implements Built<RepoItemModel, RepoItemModelBuilder> {
  RepoItemModel._();

  int get id;

  String get title;

  @nullable
  String get description;

  String get owner;

  factory RepoItemModel([void Function(RepoItemModelBuilder) updates]) =
      _$RepoItemModel;
}
