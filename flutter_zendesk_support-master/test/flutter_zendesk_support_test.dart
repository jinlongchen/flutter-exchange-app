import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zendesk_support/flutter_zendesk_support.dart';
import 'package:flutter_zendesk_support/flutter_zendesk_support_dtos.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_zendesk_support');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('init', () async {
    var settings = SupportSettings(
      appId: "",
      clientId: "",
      url: ""
    );
    expect(await FlutterZendeskSupport.init(settings), true);
  });

  test('openRequests', () async {
    expect(await FlutterZendeskSupport.openTicket(RequestTicket("ABCD")), true);
  });

  test('openHelp', () async {
    expect(await FlutterZendeskSupport.openHelpCenter(
        groupType:HelpCenterOverviewGroupType.none,
        groupIds:[12]
    ), true);
  });
}
