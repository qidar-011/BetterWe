// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationStore on NotificationStoreBase, Store {
  late final _$mRemindListAtom =
      Atom(name: 'NotificationStoreBase.mRemindList', context: context);

  @override
  List<ReminderModel> get mRemindList {
    _$mRemindListAtom.reportRead();
    return super.mRemindList;
  }

  @override
  set mRemindList(List<ReminderModel> value) {
    _$mRemindListAtom.reportWrite(value, super.mRemindList, () {
      super.mRemindList = value;
    });
  }

  late final _$addToReminderAsyncAction =
      AsyncAction('NotificationStoreBase.addToReminder', context: context);

  @override
  Future<void> addToReminder(ReminderModel data) {
    return _$addToReminderAsyncAction.run(() => super.addToReminder(data));
  }

  late final _$storeNotificationDataAsyncAction = AsyncAction(
      'NotificationStoreBase.storeNotificationData',
      context: context);

  @override
  Future<void> storeNotificationData() {
    return _$storeNotificationDataAsyncAction
        .run(() => super.storeNotificationData());
  }

  late final _$clearReminderAsyncAction =
      AsyncAction('NotificationStoreBase.clearReminder', context: context);

  @override
  Future<void> clearReminder() {
    return _$clearReminderAsyncAction.run(() => super.clearReminder());
  }

  late final _$NotificationStoreBaseActionController =
      ActionController(name: 'NotificationStoreBase', context: context);

  @override
  void addAllReminderListItem(List<ReminderModel> reminderList) {
    final _$actionInfo = _$NotificationStoreBaseActionController.startAction(
        name: 'NotificationStoreBase.addAllReminderListItem');
    try {
      return super.addAllReminderListItem(reminderList);
    } finally {
      _$NotificationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mRemindList: ${mRemindList}
    ''';
  }
}
