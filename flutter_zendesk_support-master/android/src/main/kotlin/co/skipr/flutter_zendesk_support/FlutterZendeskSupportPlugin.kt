package co.skipr.flutter_zendesk_support

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import zendesk.core.AnonymousIdentity
import zendesk.core.Identity
import zendesk.core.JwtIdentity
import zendesk.core.Zendesk
import zendesk.support.Support
import zendesk.support.guide.HelpCenterActivity
import zendesk.support.request.RequestActivity
import zendesk.support.requestlist.RequestListActivity

class FlutterZendeskSupportPlugin(private val registrar: Registrar) : MethodCallHandler {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_zendesk_support")
      channel.setMethodCallHandler(FlutterZendeskSupportPlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "init" -> {
        val url = call.argument<String>("url")
        val appId = call.argument<String>("appId")
        val clientId = call.argument<String>("clientId")

        Zendesk.INSTANCE.init(registrar.context(), url!!, appId!!, clientId)

        /*List<Long> list = new ArrayList<>()
        list.add(0, 1234L);
        list.add(0, 5678L);
        HelpCenterActivity.builder()
                .withArticlesForSectionIds(list)
                .show(registrar.activity());
        */

        val identity = AnonymousIdentity();
        Zendesk.INSTANCE.setIdentity(identity)

        Support.INSTANCE.init(Zendesk.INSTANCE)

        result.success(true)
      }
      "authenticate" -> {
        val token = call.argument<String?>("token")
        val name = call.argument<String?>("name")
        val email = call.argument<String?>("email")

        val identity : Identity
        if (token != null) {
          identity = JwtIdentity(token)
        } else {
          identity = AnonymousIdentity.Builder()
            .withNameIdentifier(name)
            .withEmailIdentifier(email)
            .build()
        }
        Zendesk.INSTANCE.setIdentity(identity)

        result.success(true)
      }
      "openHelpCenter" -> {
        var helpCenter = HelpCenterActivity.builder()

        val groupType = call.argument<String?>("groupType")
        val groupIds = call.argument<List<Long>?>("groupIds")

        when(groupType) {
          "category" -> {
            helpCenter = helpCenter.withArticlesForCategoryIds(groupIds!!)
          }
          "section" -> {
            helpCenter = helpCenter.withArticlesForSectionIds(groupIds!!)
          }
        }

        helpCenter.show(registrar.activity())

        result.success(true)
      }
      "openTicket" -> {
        val id = call.argument<String>("id")
        val title = call.argument<String?>("title")
        val tags = call.argument<List<String>?>("tags")

        var builder = RequestActivity.builder()

        builder = builder.withRequestId(id!!)

        if (title != null)
          builder = builder.withRequestSubject(title)
        if (tags != null)
          builder = builder.withTags(tags)

        builder.show(registrar.activity())
      }
      "openTickets" -> {
        RequestListActivity.builder().show(registrar.activity())

        result.success(true)
      }
      else -> result.notImplemented()
    }
  }
}
