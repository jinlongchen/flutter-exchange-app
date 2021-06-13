# flutter_zendesk_support

A new flutter plugin project.

## Getting Started

get the following info from [https://YOUR_ACCOUNT_HERE.zendesk.com/agent/admin/mobile_sdk]()
```dart
var zendeskSupportSettings = SupportSettings(
  appId: "YOUR APP ID",
  clientId: "YOUR CLIENT ID",
  url: "https://YOURURL.zendesk.com",
);
```

```dart
class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    FlutterZendeskSupport.init(zendeskSupportSettings);
    
    //FlutterZendeskSupport.authenticate(SupportAuthentication.anonymous('user name', 'user@email.com'));
    FlutterZendeskSupport.authenticate(SupportAuthentication.jwt('test_token'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zendesk Support'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.live_help),
        //onPressed: () async => await FlutterZendeskSupport.openTickets(),
        //onPressed: () => FlutterZendeskSupport.openTicket(RequestTicket('12')),
        onPressed: () async => await FlutterZendeskSupport.openHelpCenter(),
      ),
    );
  }
}
```

