import 'package:built_value/built_value.dart';

part 'repo_info_model.g.dart';

abstract class RepoInfoModel
    implements Built<RepoInfoModel, RepoInfoModelBuilder> {
  RepoInfoModel._();

  String get ownerLogin;

  String get name;

  @nullable
  String get description;

  int get starsCount;

  int get forksCount;

  int get issueCount;

  int get pullRequestCount;

  @nullable
  String get readMe;

  factory RepoInfoModel([void Function(RepoInfoModelBuilder) updates]) =
      _$RepoInfoModel;
}
