import 'package:hibi/common/Config.dart';
import 'package:hibi/page/market/MarketSelfEditPage.dart';
import 'package:hibi/page/treaty/MarketTreatyPage.dart';
import 'package:hibi/widget/MyUnderlineTabIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'MarketSelfPage.dart';
import 'MarketUSDTPage.dart';

class MarketPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MarketPage> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController _tabController;
  final List<String> pages = ['zixuan'.tr(),'tab_bibi'.tr(),'tab_hy'.tr()];
  int curretIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: null,
          title: Text('quotation'.tr()),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: ImageIcon(
                  AssetImage('res/edit.png'),
                  size:ScreenUtil().setWidth(30)
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MarketSelfEditPage();
                }));
              },
            ),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.centerLeft,
                child: TabBar(
                  onTap: (e){
                    setState(() {
                      curretIndex = e;
                    });
                  },
                  labelStyle: TextStyle(fontSize: ScreenUtil().setSp(32)),
                  labelColor: Color(0xFFE0E0E7),
                  unselectedLabelColor: Color(0xFFE0E0E7).withOpacity(0.3),
                  controller: _tabController,
                  isScrollable: true,
                  indicator: MyUnderlineTabIndicator(borderSide:  BorderSide(width: 2.0, color: Theme.of(context).accentColor)),
                  tabs: pages.map((String title) {
                    return Tab(
                      text: title,
                    );
                  }).toList(),
                ),
              )
          )
      ),
      body: TabBarView(
        children: <Widget>[
          MarketSelfPage(),
          MarketUSDTPage(),
          MarketTreatyPage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar widget;
  final Color color;

  const SliverTabBarDelegate(this.widget, {this.color})
      : assert(widget != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: widget,
      color: color,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;
}
