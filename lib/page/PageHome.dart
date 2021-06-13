/*
 * @Description: file
 * @Autor: dingyiming
 * @Date: 2021-06-14 06:21:49
 * @LastEditors: dingyiming
 * @LastEditTime: 2021-06-14 06:23:23
 */
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/common/Config.dart';
import 'package:hibi/common/DioManager.dart';
import 'package:hibi/common/Global.dart';
import 'package:hibi/common/Url.dart';
import 'package:hibi/event/event_bus.dart';
import 'package:hibi/generated/json/base/json_convert_content.dart';
import 'package:hibi/model/ItemObject.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/banner_entity.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/model/user_entity.dart';
import 'package:hibi/page/WebPage.dart';
import 'package:hibi/page/activity/RankPage.dart';
import 'package:hibi/page/contract/FinancialPage.dart';
import 'package:hibi/page/home/NoticePage.dart';
import 'package:hibi/page/midas/MidasPage.dart';
import 'package:hibi/page/mine/InvitePage.dart';
import 'package:hibi/page/mine/MinePage.dart';
import 'package:hibi/page/money/AssetsDepositPage.dart';
import 'package:hibi/page/stake/StakePage.dart';
import 'package:hibi/page/trading/KLinePage.dart';
import 'package:hibi/page/user/LoginPage.dart';
import 'package:hibi/page/user/RegisterPage.dart';
import 'package:hibi/state/SymbolState.dart';
import 'package:hibi/state/UserInfoState.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/MarketItemHomeView.dart';
import 'package:hibi/widget/MarketItemView.dart';
import 'package:hibi/widget/MyUnderlineTabIndicator.dart';
import 'package:hibi/widget/material_segmented_control.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_zendesk_support/flutter_zendesk_support.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hibi/model/login_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  List<BannerData> bannerList = [];
  TabController _tabController;
  List<dynamic> notices = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getData();
    initZendesk();
  }

  var zendeskSupportSettings = SupportSettings(
    appId: "9d87fecfa0812c6465aab6727a6749f6cb19a55cdd57f089",
    clientId: "mobile_sdk_client_c8668a4eb0c035194d9c",
    url: "https://HiBisupporthelp.zendesk.com",
  );

  void initZendesk() {
    FlutterZendeskSupport.init(zendeskSupportSettings);
  }

  Future<void> getData() async {
    if (Global.bannerList.length != 0) {
      setState(() {
        bannerList = Global.bannerList;
      });
    } else {
      DioManager.getInstance()
          .post(Url.HOME_BANNER, {"sysAdvertiseLocation": "0"}, (data) {
        BannerEntity bannerEntity = JsonConvert.fromJsonAsT(data);
        setState(() {
          bannerList = bannerEntity.data;
        });
      }, (error) {
        CommonUtil.showToast(error);
      });
    }

    if (Global.notices.length != 0) {
      setState(() {
        notices = Global.notices;
      });
    } else {
      DioManager.getInstance().get(Url.ZDEX_HELP, null, (data) {
        String dataStr = json.encode(data);
        Map<String, dynamic> dataMap = json.decode(dataStr);
        String content = dataMap['data'];
        Map<String, dynamic> dataMap2 = json.decode(content);
        List<dynamic> items = dataMap2['articles'];
        setState(() {
          notices = items;
        });
      }, (error) {
        CommonUtil.showToast(error);
      });
    }
  }

  Widget _buildTopSwiper() {
    return Consumer<SymbolState>(
      builder: (context, symbolState, child) {
        List<SymbolListData> info = symbolState.symbol;
        if (symbolState.symbolLength > 0) {
          var risePrice = TextStyle(
              color: Config.greenColor,
              fontSize: ScreenUtil().setSp(40),
              fontFamily: 'Din');
          var fallPrice = TextStyle(
              color: Config.redColor,
              fontSize: ScreenUtil().setSp(40),
              fontFamily: 'Din');
          var risePrice2 = TextStyle(
              color: Config.greenColor,
              fontSize: ScreenUtil().setSp(24),
              fontFamily: 'Din');
          var fallPrice2 = TextStyle(
              color: Colours.dark_text_gray.withOpacity(0.3),
              fontSize: ScreenUtil().setSp(24),
              fontFamily: 'Din');
          List<Widget> areaList = [];
          for (int i = 0; i < 3; i++) {
            areaList.add(Expanded(
              child: Container(
                  child: GestureDetector(
                onTap: () {
                  Global.curretSymbol = info[i].symbol;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return KLinePage();
                  }));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(right: ScreenUtil().setWidth(5)),
                          child: Text(
                            info[i].coinSymbol + '/' + info[i].baseSymbol,
                            style: TextStyle(
                                color: Colours.dark_text_gray,
                                fontSize: ScreenUtil().setSp(24),
                                fontFamily: 'Din'),
                          ),
                        ),
                        Text(CommonUtil.formatNum(info[i].chg * 100, 2) + "%",
                            style: TextStyle(
                                color: CommonUtil.isRise(info[i].chg)
                                    ? Config.greenColor
                                    : Config.redColor,
                                fontFamily: 'Din',
                                fontSize: ScreenUtil().setSp(20)))
                      ],
                    ),
                    Padding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            CommonUtil.isRise(info[i].chg)
                                ? 'res/chg_up.png'
                                : 'res/chg_down.png',
                            width: ScreenUtil().setWidth(12),
                            height: ScreenUtil().setHeight(7),
                          ),
                          Padding(
                            child: Text(
                              info[i].close.toString(),
                              style: CommonUtil.isRise(info[i].chg)
                                  ? risePrice
                                  : fallPrice,
                            ),
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10)),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(16),
                        bottom: ScreenUtil().setHeight(10),
                      ),
                    ),
                    Text(
                      '≈' +
                          CommonUtil.calcCny(info[i].close, info[i].priceCNY) +
                          ' CNY',
                      style: fallPrice2,
                    ),
                  ],
                ),
              )),
            ));
          }
          return Container(
              child: Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(32),
                      right: ScreenUtil().setWidth(32),
                      top: ScreenUtil().setHeight(50)),
                  child: Column(
                    children: <Widget>[
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: areaList)
                    ],
                  )));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildNewsView() {
    if (notices.length == 0) {
      return Container();
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(32),
            right: ScreenUtil().setWidth(32),
            top: ScreenUtil().setHeight(50)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              child: Container(
                  height: ScreenUtil().setHeight(50),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WebPage(
                              url: notices[index]['html_url'],
                            );
                          }));
                        },
                        child: Container(
                            child: Row(
                          children: <Widget>[
                            Padding(
                              child: Image.asset(
                                'res/ic_notice.png',
                                width: ScreenUtil().setWidth(30),
                              ),
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20),
                                  right: ScreenUtil().setWidth(20)),
                            ),
                            Text(
                              notices[index]['title'],
                              style: TextStyle(
                                  color:
                                      Colours.dark_text_gray.withOpacity(0.6),
                                  fontSize: ScreenUtil().setSp(24)),
                            )
                          ],
                        )),
                      );
                    },
                    itemCount: notices.length,
                    scrollDirection: Axis.vertical,
                    autoplay: true,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    if (bannerList.length == 0) {
      return Container();
    }

    return SizedBox(
      height: ScreenUtil().setHeight(332),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                if (bannerList[index].linkUrl.contains("activity/ranking")) {
                  if (Provider.of<UserInfoState>(context, listen: false)
                      .isLogin) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RankPage();
                    }));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  }
                  return;
                }
                if (CommonUtil.isEmpty(bannerList[index].linkUrl)) {
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WebPage(
                    url: bannerList[index].linkUrl,
                  );
                }));
              },
              child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(332),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(32),
                      right: ScreenUtil().setWidth(32)),
                  decoration: BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: bannerList[index].url,
                      fit: BoxFit.fill,
                    ),
                  )));
        },
        itemCount: bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(
                color: Colors.grey, activeColor: Colors.white)),
      ),
    );
  }

  int segmentedControlValue = 0;

  Widget _buildBiBi() {
    return Consumer<SymbolState>(
      builder: (context, symbolState, child) {
        List<SymbolListData> info = symbolState.symbol;
        return ListView.builder(
          padding: EdgeInsets.only(top: 0),
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: info == null ? 0 : info.length, //数据的数量
          itemBuilder: (BuildContext context, int index) {
            return MarketItemHomeView(
              itemObject: info[index],
            );
          },
        );
      },
    );
  }

  Widget _buildLoginView() {
    return Consumer<UserInfoState>(builder: (context, user, child) {
      UserData data = user.userInfoModel;
      return Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(110),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(32), right: ScreenUtil().setWidth(32)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'res/home_avatar.png',
                    width: ScreenUtil().setWidth(64),
                    height: ScreenUtil().setWidth(64),
                  ),
                  Padding(
                    child: Text(
                      !user.isLogin ? 'home_label_login'.tr() : data.username,
                      style: TextStyle(
                          color: Colours.dark_text_gray.withOpacity(0.6),
                          fontSize: ScreenUtil().setSp(28)),
                    ),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  )
                ],
              ),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (user.isLogin) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MinePage();
                  }));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
            ),
            GestureDetector(
              child: Image.asset(
                'res/home_notice.png',
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setWidth(36),
              ),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NoticePage();
                }));
              },
            )
          ],
        ),
      );
    });
  }

  Widget _buildTabbar() {
    TextStyle tvTitle = TextStyle(
        color: Colours.dark_text_gray,
        fontSize: ScreenUtil().setSp(24),
        fontFamily: 'Din');
    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "res/home_cb.png",
                width: ScreenUtil().setWidth(72),
                height: ScreenUtil().setWidth(72),
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
                  child: Text(
                    'assets_cb'.tr(),
                    style: tvTitle,
                  ))
            ],
          ),
          onTap: () {
            if (Provider.of<UserInfoState>(context, listen: false).isLogin) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AssetsDepositPage();
              }));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            }
          },
          behavior: HitTestBehavior.opaque,
        )),
        Expanded(
            child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "res/home_yq.png",
                width: ScreenUtil().setWidth(72),
                height: ScreenUtil().setWidth(72),
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
                  child: Text(
                    'home_yq'.tr(),
                    style: tvTitle,
                  ))
            ],
          ),
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (Provider.of<UserInfoState>(context, listen: false).isLogin) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return InvitePage();
              }));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            }
          },
        )),
        Expanded(
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "res/home_lc.png",
                  width: ScreenUtil().setWidth(72),
                  height: ScreenUtil().setWidth(72),
                ),
                Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
                    child: Text(
                      'home_lc'.tr(),
                      style: tvTitle,
                    ))
              ],
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (Provider.of<UserInfoState>(context, listen: false).isLogin) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FinancialPage();
                }));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              }
            },
          ),
        ),
        Expanded(
            child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "res/home_defi.png",
                width: ScreenUtil().setWidth(72),
                height: ScreenUtil().setWidth(72),
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(12)),
                  child: Text(
                    'Midas',
                    style: tvTitle,
                  ))
            ],
          ),
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (Provider.of<UserInfoState>(context, listen: false).isLogin) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MidasPage();
              }));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            }
            //await FlutterZendeskSupport.openTickets();
          },
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        body: Container(
            child: CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: ScreenUtil.statusBarHeight,
              ),
              _buildLoginView(),
              _buildBanner(),
              _buildNewsView(),
              _buildTopSwiper(),
            ],
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: MyDynamicHeader(
              mTabbar: _buildTabbar(), tabController: _tabController),
        ),
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildBiBi(),
            ],
          ),
        )
      ],
    )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MyDynamicHeader extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> pages = [
    'tab_bibi'.tr(),
    'tab_hy'.tr(),
  ];
  final Widget mTabbar;

  MyDynamicHeader({@required this.tabController, this.mTabbar});

  int index = 0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Color colorDiver = Colours.dark_text_gray.withOpacity(0.05);
    if (shrinkOffset > 0) {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Stack(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height:
                      ScreenUtil().setHeight(300) + ScreenUtil.statusBarHeight,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil.statusBarHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(196),
                        child: mTabbar,
                        decoration: BoxDecoration(
                            color: CommonUtil.isDark(context)
                                ? Colours.dark_bg_gray
                                : Colours.bg_gray,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setWidth(40)),
                                topRight: Radius.circular(
                                    ScreenUtil().setWidth(40)))),
                      ),
                      Divider(
                        height: ScreenUtil().setHeight(2),
                      ),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(100),
                        color: CommonUtil.isDark(context)
                            ? Colours.dark_bg_gray
                            : Colours.bg_gray,
                        child: TabBar(
                          labelStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(32)),
                          labelColor: Color(0xFFE0E0E7),
                          unselectedLabelColor:
                              Color(0xFFE0E0E7).withOpacity(0.3),
                          controller: tabController,
                          isScrollable: true,
                          indicator: MyUnderlineTabIndicator(
                              borderSide: BorderSide(
                                  width: 2.0,
                                  color: Theme.of(context).accentColor)),
                          tabs: pages.map((String title) {
                            return Tab(
                              text: title,
                            );
                          }).toList(),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(32),
                            right: ScreenUtil().setWidth(32)),
                        child: Divider(
                          height: ScreenUtil().setHeight(2),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        );
      });
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight / 2),
          child: Stack(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(300) +
                      ScreenUtil.statusBarHeight / 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(196),
                        child: mTabbar,
                        decoration: BoxDecoration(
                            color: CommonUtil.isDark(context)
                                ? Colours.dark_bg_gray
                                : Colours.bg_gray,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setWidth(40)),
                                topRight: Radius.circular(
                                    ScreenUtil().setWidth(40)))),
                      ),
                      Divider(
                        color: colorDiver,
                        height: ScreenUtil().setHeight(2),
                      ),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(100),
                        color: CommonUtil.isDark(context)
                            ? Colours.dark_bg_gray
                            : Colours.bg_gray,
                        child: TabBar(
                          labelStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(32)),
                          labelColor: Color(0xFFE0E0E7),
                          unselectedLabelColor:
                              Color(0xFFE0E0E7).withOpacity(0.3),
                          controller: tabController,
                          isScrollable: true,
                          indicator: MyUnderlineTabIndicator(
                              borderSide: BorderSide(
                                  width: 2.0,
                                  color: Theme.of(context).accentColor)),
                          tabs: pages.map((String title) {
                            return Tab(
                              text: title,
                            );
                          }).toList(),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(32),
                            right: ScreenUtil().setWidth(32)),
                        child: Divider(
                          color: colorDiver,
                          height: ScreenUtil().setHeight(2),
                        ),
                      ),
                      Container(
                        height: ScreenUtil.statusBarHeight / 2,
                        color: Colours.dark_bg_gray,
                      )
                    ],
                  )),
            ],
          ),
        );
      });
    }
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent =>
      ScreenUtil().setHeight(300) + ScreenUtil.statusBarHeight;

  @override
  double get minExtent =>
      ScreenUtil().setHeight(300) + ScreenUtil.statusBarHeight;
}
