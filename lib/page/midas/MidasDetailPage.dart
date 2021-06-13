import 'package:hibi/common/CommonUtil.dart';
import 'package:hibi/styles/colors.dart';
import 'package:hibi/widget/AppBarReturn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class MidasDetailPage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MidasDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildDetail(){
    TextStyle tvTtitle = TextStyle(color: Colours.dark_text_gray.withOpacity(0.3),fontFamily: 'Din',fontSize: ScreenUtil().setSp(24));
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      child: Column(
        children: [
          Text('申购周期',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60),vertical: ScreenUtil().setHeight(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('res/midas_status1.png',width:ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),color:Colours.dark_text_gray.withOpacity(0.6),),
                Container(
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(2),
                  color: Colours.dark_text_gray.withOpacity(0.6),
                ),
                Image.asset('res/midas_status2.png',width:ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),color:Colours.dark_text_gray.withOpacity(0.6),),
                Container(
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(2),
                  color: Colours.dark_text_gray.withOpacity(0.6),
                ),
                Image.asset('res/midas_status3.png',width:ScreenUtil().setWidth(56),height: ScreenUtil().setWidth(56),color:Colours.dark_text_gray.withOpacity(0.6),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('申购',style: tvTtitle,),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text('2020-10-20 13:00:00',style: tvTtitle,),
                    ),
                  ],
                ),
                Container(
                  width: ScreenUtil().setWidth(1),
                  height: ScreenUtil().setHeight(2),
                ),
                Column(
                  children: [
                    Text('发放',style: tvTtitle,),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text('2020-10-20 13:00:00',style: tvTtitle,),
                    ),
                  ],
                ),
                Container(
                  width: ScreenUtil().setWidth(1),
                  height: ScreenUtil().setHeight(2),
                ),
                Column(
                  children: [
                    Text('交易',style: tvTtitle,),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text('2020-10-20 13:00:00',style: tvTtitle,),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(40)),
            child:Text('项目详情',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('项目详情介绍',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(80),bottom: ScreenUtil().setHeight(40)),
            child:Text('代币计划',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(32),fontFamily: 'Din'),),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
            child: Image.asset('res/splash_1.png',fit: BoxFit.fill,)
          ),
        ],
      ),
    );
  }
  
  Widget _buildItem(String title,String value){
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(92),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
              Text(value,style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'))
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  final TextEditingController _count = new TextEditingController();
  final TextEditingController _bbt = new TextEditingController();

  void purchase(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colours.dark_bg_gray,
        isScrollControlled: true,
        builder: (BuildContext context){
          return AnimatedPadding(
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(900),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(140),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('pocs_sg'.tr(),style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(40)),),
                        GestureDetector(
                          child: Image.asset('res/close.png',width: ScreenUtil().setWidth(32),height: ScreenUtil().setWidth(32),),
                          onTap: (){
                            setState(() {
                              _bbt.text = "";
                              _count.text = "";
                            });
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(32),right: ScreenUtil().setWidth(32)),
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'count'.tr(),
                                    style:TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))
                                ),
                              ],
                            )
                        ),
                        TextField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                          ],
                          onChanged: (e){
                            /*if(CommonUtil.isEmpty(e)){
                              setState(() {
                                _count.text = "";
                              });
                            }
                            Decimal price = Decimal.tryParse(pocsInfoData.nowPurchasePrice);
                            Decimal realCount = Decimal.tryParse(e) * price;
                            setState(() {
                              _count.text = realCount.toString();
                            });*/
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: _bbt,
                          autofocus: false,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: 'Din'
                          ),
                          decoration:InputDecoration(
                              hintText: 'pocs_qsrsgsl'.tr(),
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                              suffixIcon: Container(
                                width: ScreenUtil().setWidth(200),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                       /* setState(() {
                                          _bbt.text = aboutUSDTMoney;
                                        });
                                        Decimal price = Decimal.tryParse(pocsInfoData.nowPurchasePrice);
                                        Decimal realCount = Decimal.tryParse(aboutUSDTMoney) * price;
                                        setState(() {
                                          _count.text = formatNum(realCount.toDouble(), 2);
                                        });*/
                                      },
                                      child: Text('全部',style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                                    ),
                                    Text("BBT",style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                                  ],
                                ),
                              )
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('pocs_jrsy'.tr()+":"+" BBT",style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                            ],
                          ),
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        ),
                        Container(
                            padding: EdgeInsets.only(top:ScreenUtil().setHeight(64),bottom: ScreenUtil().setHeight(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'money'.tr(),
                                    style:TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24))
                                ),
                              ],
                            )
                        ),
                        TextField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp(r"[\d.]"))
                          ],
                          onChanged: (e){

                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: _count,
                          autofocus: false,
                          enabled: false,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: 'Din'
                          ),
                          decoration:InputDecoration(
                              contentPadding:EdgeInsets.only(bottom: ScreenUtil().setHeight(15),top: ScreenUtil().setHeight(25)),
                              suffixIcon: Container(
                                width: ScreenUtil().setWidth(200),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("USDT",style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(28),color: Color(0xffe0e0e7)),),
                                  ],
                                ),
                              )
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('keyongyue'.tr()+":"+" USDT",style: TextStyle(color: Color(0xff9496A2),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),)
                            ],
                          ),
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(42)),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(88),
                          child: RaisedButton(
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            color: Theme.of(context).accentColor,
                            child: Text("submit".tr()),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.dark_bg_gray,
      appBar: AppBar(
        leading: AppBarReturn(),
        title: Text('DFS'),
        centerTitle: false,
        elevation: 0,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: GestureDetector(
                onTap: (){

                },
                child: Center(
                    child: Row(
                      children: <Widget>[
                        Text('我的订单',style: TextStyle(
                            color: Colours.dark_text_gray.withOpacity(0.6)
                        ),),
                      ],
                    )
                ),
              )
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(200),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset('res/invite_bg.png',width: ScreenUtil().setWidth(144),height: ScreenUtil().setWidth(144),),
                          ),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('DFS - 基于信用的DeFi跨链平台',style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(32),color: Colors.white),),
                                    Text('是一条高通量、安全的区块链，在状态分片技书和点对点网络技术做了创新',style: TextStyle(fontFamily: 'Din',fontSize: ScreenUtil().setSp(24),color: Colours.dark_text_gray.withOpacity(0.6)))
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    _buildItem('状态', '未开始'),
                    _buildItem('申购开始时间', '2020-10-23 12:23:23'),
                    _buildItem('发行总量', '1000 DFS'),
                    _buildItem('本次申购总量', '1000 DFS'),
                    _buildItem('申购资格', '持有双星配套用户'),
                    _buildItem('申购额度比例', '1000 BBT = 1 DFS'),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(92),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('发行价格',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                              Text('1000 BBT = 1 DFS',style: TextStyle(color: Colours.dark_accent_color,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'))
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20),top: ScreenUtil().setHeight(40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('申购进度',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(24),fontFamily: 'Din'),),
                          Text('0%',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),)
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(12),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(12),
                            decoration: BoxDecoration(
                                color: Color(0xff8d8d94).withOpacity(0.2),
                                borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setHeight(12),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xff4a68ff),
                                    Color(0xff00ffb3),
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(156),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('10000 BBT',style: TextStyle(color: Colours.dark_text_gray,fontSize: ScreenUtil().setSp(36),fontFamily: 'Din'),),
                                  Text('≈'+'1000 USDT',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(28),fontFamily: 'Din'),),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                                child:Text('我的申购额度',style: TextStyle(color: Colours.dark_text_gray.withOpacity(0.6),fontSize: ScreenUtil().setSp(20)),),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child:  Container(
                              width: ScreenUtil().setWidth(152),
                              height: ScreenUtil().setHeight(76),
                              decoration: BoxDecoration(
                                  color: Colours.dark_accent_color,
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Text('pocs_sg'.tr()),
                              alignment: Alignment.center,
                            ),
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              purchase();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(10),
                color: Color(0xff171a22),
              ),
              _buildDetail(),
            ],
          ),
        ),
      )
    );
  }
}
