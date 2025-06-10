part of 'manage_group_tests_bloc.dart';

sealed class ManageGroupTestsEvent extends Equatable {
  const ManageGroupTestsEvent();

  @override
  List<Object> get props => [];
}

final class ManageGroupTestsLoadEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsLoadEvent({
    required this.group,
    required this.isCourseSubscribersGroup,
  });
  final Group group;
  final bool isCourseSubscribersGroup;
  @override
  List<Object> get props => [];
}

final class ManageGroupTestsSaveChangesEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsSaveChangesEvent();
  @override
  List<Object> get props => [];
}

final class ManageGroupTestsStartPickTestEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsStartPickTestEvent();

  @override
  List<Object> get props => [];
}

final class ManageGroupTestsAddTestEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsAddTestEvent(this.test);
  final Test test;
  @override
  List<Object> get props => [test];
}

final class ManageGroupTestsRemoveTestEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsRemoveTestEvent(this.test);
  final Test test;
  @override
  List<Object> get props => [test];
}

final class ManageGroupTestsOpenFolderEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsOpenFolderEvent(this.folder);
  final String folder;
  @override
  List<Object> get props => [folder];
}

final class ManageGroupTestsOpenDirectoryEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsOpenDirectoryEvent(this.directory);
  final String directory;
  @override
  List<Object> get props => [];
}

final class ManageGroupTestsPopBackEvent extends ManageGroupTestsEvent {
  const ManageGroupTestsPopBackEvent();
  @override
  List<Object> get props => [];
}
