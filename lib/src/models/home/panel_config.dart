


class PanelConfigList {

    List<PanelConfig> panelConfigJson = [];

    PanelConfigList.fromJsonList(List<dynamic> jsonList) {

      if (jsonList == null) return;

      jsonList.forEach((item) { 
        final panelConfig = new PanelConfig.fromJsonMap(item);
        panelConfigJson.add(panelConfig);
      });
    }
}

class PanelConfig {

    String type;
    double maxHeight;
    bool isSwipeable;

    PanelConfig.fromJsonMap( Map<String, dynamic> json) {
      type        = json['type'];
      maxHeight   = json['maxHeight'];
      isSwipeable = json['isSwipeable'];
    }
}