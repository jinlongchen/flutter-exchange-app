
import 'package:hibi/common/Global.dart';
import 'package:hibi/model/SymbolObject.dart';
import 'package:hibi/model/symbol_list_entity.dart';
import 'package:hibi/model/trade_summary_entity.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class SymbolState with ChangeNotifier{
  List<SymbolListData> _datas;
  get symbol => _datas;
  get symbolLength => _datas == null?0:_datas.length;

  List<SymbolListData> getCollectSymbols(){
    List<SymbolListData> collects = [];
    for(SymbolListData item in _datas){
      if(item.isCollect){
        collects.add(item);
      }
    }
    List<String> spcollect = SpUtil.getStringList('collect',defValue: []);
    List<SymbolListData> realCollects = [];

    for(String items in spcollect){
      for(SymbolListData item2 in collects){
        if(item2.symbol == items){
          realCollects.add(item2);
        }
      }
    }

    return realCollects;
  }

  SymbolListData getCurretSymbol(){
    int index = -1;
    for(int i=0;i<_datas.length;i++){
      if(_datas[i].symbol == Global.curretSymbol){
        index = i;
      }
    }
    if(index != -1){
      return _datas[index];
    }
  }

  void collectSymbol(String symbol){
    for(SymbolListData item in _datas){
      if(symbol == item.symbol){
        item.isCollect = !item.isCollect;
      }
    }
    notifyListeners();
  }


  void updateSymbolList(List<SymbolListData> list){
    _datas = list;
    notifyListeners();
  }

  void updateSymbol(TradeSummaryEntity data){
    int index = -1;
    for(int i=0;i<_datas.length;i++){
      if(_datas[i].symbol == data.symbol){
        index = i;
      }
    }
    if(index != -1){
      SymbolListData item = _datas[index];
      item.close = data.close;
      item.open = data.open;
      item.high = data.high;
      item.low = data.low;
      item.chg = data.chg;
      item.change = data.change;
      item.volume = data.volume;
      item.turnover = data.turnover;
      item.zone = data.zone;
    }
    notifyListeners();
  }

}