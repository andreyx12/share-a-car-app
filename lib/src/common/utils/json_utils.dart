

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/models/home/panel_config.dart';

class JsonUtils {

  static Future<List<PanelConfig>> getPanelConfig() async {
      String data = await rootBundle.loadString('assets/json/panel_config.json');
      final jsonResult = json.decode(data);
      return PanelConfigList.fromJsonList(jsonResult).panelConfigJson;
  }

  static Future<PanelConfig> getPanelConfigByType(ModalStatus modalStatus) async {
      List<PanelConfig> panelConfigList = await getPanelConfig();
      return panelConfigList.firstWhere((element) => element.type == modalStatus.toString());
  }
}