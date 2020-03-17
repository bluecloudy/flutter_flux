// Copyright 2016 The Chromium Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show State, StatefulWidget, protected;
import 'package:flutter_flux/flutter_flux.dart' as flutter_flux;

/// Listens to changes in a number of different actions.
/// Used by to track which actions the widget is listening and to usubscribe from him when disposed.
mixin ActionWatcherMixin<T extends StatefulWidget> on State<T> {
  final Map<flutter_flux.Action, flutter_flux.ActionSubscription>
      _actionsSubscriptions =
      <flutter_flux.Action, flutter_flux.ActionSubscription>{};

  /// Stop receiving notifications from the given action.
  @protected
  void unlistenFromAction(flutter_flux.Action actionToUnsusbscribe) {
    _actionsSubscriptions.forEach((actionReference, subscription) {
      if (actionReference == actionToUnsusbscribe) {
        subscription.cancel();
      }
    });
  }

  /// Listen to a given action and automatically cancel subscriptions when widget is disposed
  @protected
  void listenToAction(flutter_flux.Action action, flutter_flux.OnData onData) {
    _actionsSubscriptions.addAll({action: action.listen(onData)});
  }

  /// Cancel all actions listen (subscriptions).
  @override
  void dispose() {
    final Iterable<flutter_flux.ActionSubscription> actionSubscriptions =
        _actionsSubscriptions.values;
    for (final flutter_flux.ActionSubscription actionSubscription
        in actionSubscriptions) actionSubscription.cancel();
  }
}
