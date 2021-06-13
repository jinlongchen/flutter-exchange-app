import 'dart:async';

import 'package:flutter/services.dart';

import 'flutter_zendesk_support_dtos.dart';

export 'flutter_zendesk_support_dtos.dart';

class FlutterZendeskSupport {
  static const MethodChannel _channel =
      const MethodChannel('flutter_zendesk_support');

  static Future<bool?> init(SupportSettings settings) async {
    return await _channel.invokeMethod('init', settings.toJson());
  }

  static Future<bool?> authenticate(SupportAuthentication auth) async {
    return await _channel.invokeMethod('authenticate', auth.toJson());
  }

  static Future<bool?> openHelpCenter({
    HelpCenterOverviewGroupType groupType = HelpCenterOverviewGroupType.none,
    List<int>? groupIds
  }) async {
    var map = Map<String, dynamic>();
    if (groupType != HelpCenterOverviewGroupType.none)
      map['groupType'] = (groupType == HelpCenterOverviewGroupType.category)
        ? "category"
        : "section";

    if (groupIds != null)
      map['groupIDs'] = groupIds;

    return await _channel.invokeMethod('openHelpCenter', map);
  }

  static Future<bool?> openTicket(RequestTicket ticket) async {
    return await _channel.invokeMethod('openTicket', ticket.toJson());
  }

  static Future<bool?> openTickets() async {
    return await _channel.invokeMethod('openTickets');
  }
}