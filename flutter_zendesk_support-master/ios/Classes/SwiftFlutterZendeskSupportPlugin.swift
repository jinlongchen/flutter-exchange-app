import Flutter
import UIKit
import SupportSDK
import ZendeskCoreSDK

public class SwiftFlutterZendeskSupportPlugin: NSObject, FlutterPlugin, UINavigationControllerDelegate
{
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_zendesk_support", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterZendeskSupportPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ flutterMethodCall: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = flutterMethodCall.arguments as? NSDictionary

    if flutterMethodCall.method.elementsEqual("init"){
        let url = args!["url"] as? String
        let appId = args!["appId"] as? String
        let clientId = args!["clientId"] as? String

        Zendesk.initialize(appId: appId!,
                           clientId: clientId!,
                           zendeskUrl: url!)
        
        Support.initialize(withZendesk: Zendesk.instance)

        let identity = Identity.createAnonymous()
        Zendesk.instance?.setIdentity(identity)

        result(true)
    }
    else if flutterMethodCall.method.elementsEqual("authenticate")
    {
        let token = args!["token"] as? String
        let name = args!["name"] as? String
        let email = args!["email"] as? String

        var identity : Identity;
        if (token != nil) {
            identity = Identity.createJwt(token: token!)
        } else {
            identity = Identity.createAnonymous(name:name, email:email)
        }
        
        Zendesk.instance?.setIdentity(identity)

        result(true)
    }
    else if flutterMethodCall.method.elementsEqual("openHelpCenter")
    {
        // HELP CENTER
        //TODO : check if inited & auth done
        let groupType = args!["groupType"] as? String
        let groupIds = args!["groupIds"] as? [NSNumber]

        // todo: multiple grouptypes possible
        let hcConfig = HelpCenterUiConfiguration()
        switch(groupType) {
        case "category":
            hcConfig.groupType = .category
        case "section":
            hcConfig.groupType = .section
        default:
            hcConfig.groupType = .default
        }
        if (groupIds != nil) {
            hcConfig.groupIds = groupIds!
        }
        let vc = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])

        self.openViewController(vc:vc)

        result(true)
    }
    else if flutterMethodCall.method.elementsEqual("openTicket")
    {
        // REQUESTS
        //TODO : check if inited & auth done
        let id = args!["id"] as! String
        let title = args!["title"] as? String
        let tags = args!["tags"] as? [String]

        let config = RequestUiConfiguration()
        if (title != nil) { config.subject = title! }
        if (tags != nil) { config.tags = tags! }
        let vc = RequestUi.buildRequestUi(requestId: id, configurations: [config])

        self.openViewController(vc:vc)

        result(true)
    }
    else if flutterMethodCall.method.elementsEqual("openTickets")
    {
        // REQUESTS
        //TODO : check if inited & auth done
        let vc = RequestUi.buildRequestList()

        self.openViewController(vc:vc)
        
        result(true)
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
  }

  func openViewController(vc: UIViewController){
    let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    
    if let navigationController = window.rootViewController as? UINavigationController {
        navigationController.pushViewController(vc, animated: true)
        return
    }

    let flutterViewController = window.rootViewController as! FlutterViewController;

    // MODAL
    //vc.modalPresentationStyle = .
    //flutterViewController?.present(vc, animated: true, completion: {})

    // PUSH
    window.rootViewController = nil
    let navigationController = UINavigationController(rootViewController: flutterViewController)
    navigationController.delegate = self
    navigationController.setNavigationBarHidden(false, animated: false)
    window.rootViewController = navigationController
    //window.makeKeyAndVisible()
    navigationController.pushViewController(vc, animated: true)
  }
    
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
  {
    if (viewController is FlutterViewController) {
      navigationController.setNavigationBarHidden(true, animated: false)
    }else{
      navigationController.setNavigationBarHidden(false, animated: false)
    }
  }
}
