
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/json_utils.dart';
import 'package:share_a_car/src/layouts/custom_app_bar.dart';
import 'package:share_a_car/src/layouts/custom_drawer.dart';
import 'package:share_a_car/src/models/home/panel_config.dart';
import 'package:share_a_car/src/pages/home/components/slideup_content_builder.dart';
import 'package:share_a_car/src/pages/home/components/map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'components/invoice.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  bool isDraggable = false;
  double panelHeightOpen = Platform.isAndroid ? 245 : 265;

  final double _initFabHeight = 120.0;
  double _panelHeightClosed = 95.0;

  MapBloc mapBloc;

  @override
  void initState() {
    super.initState();
    mapBloc = BlocProvider.of<MapBloc>(context);
    context.read<MapBloc>().initLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    mapBloc.add(OnInitialState());
    mapBloc.mapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid && state == AppLifecycleState.resumed) {
       context.read<MapBloc>().addMapStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: ( _ , state) {
        return Scaffold(
          drawer: CustomDrawer(mapBloc),
          appBar: CustomAppBar(mapBloc),
          body: Stack(
            children: [
              _slideUpPanel(),
              _buildFloatingActionButton(),
              _loadingContentInMap(),
              _generalLoading(),
            ]
          )
        );
      }
    );
  }

  Widget _slideUpPanel() {

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return SlidingUpPanel(
      controller: context.read<MapBloc>().panelController,
      panel: _panelSlideUpContent(),
      body: _bodySlideUpContent(),
      margin: EdgeInsets.only(top: 20.0),
      parallaxEnabled: true,
      parallaxOffset: 1,
      defaultPanelState: PanelState.CLOSED,
      maxHeight: panelHeightOpen,
      minHeight: _panelHeightClosed,
      isDraggable: isDraggable,
      borderRadius: radius,
      onPanelSlide: (double pos) {
        mapBloc.add(OnMovePanel(pos * (panelHeightOpen - _panelHeightClosed) + _initFabHeight));
      }
    );
  }
  
  Widget _panelSlideUpContent() {
    return BlocConsumer<MapBloc, MapState>(
      listenWhen: (previous, current) {
        return previous.modalStatus != current.modalStatus;
      },
      listener: ( _ , MapState mapState) {
        _changeDraggableStatus(mapState.modalStatus);
        _showInvoice(mapState);
      },
      builder: ( _ , state) {
        return SlideUpContentBuilder(
          mapBloc: mapBloc,
          modalStatus: state.modalStatus,
          panelController: context.read<MapBloc>().panelController,
        );
      }
    );
  }

  Widget _bodySlideUpContent() {
    return  BlocBuilder<MapBloc, MapState>(
        builder: ( _ , state) {
          if (state.currentPosition == null && !state.mapReady) {
            return Container();
          } else {
            return Container(
              child: MapWidget(
                mapBloc: mapBloc,
                panelController: context.read<MapBloc>().panelController,
                onMapReady: () {
                  
                },
              ),
            );
          }
        }
    );
  }

   Widget _generalLoading() {
    return  BlocBuilder<MapBloc, MapState>(
        builder: ( _ , state) {   
          if (!state.mapReady) {
           return Container(
             color: Colors.white,
              child: Center(
                child: CircularProgressIndicator()
              ),
           );
          } else {
            return Container();
          }
        }
    );
  }

  Widget _loadingContentInMap() {
    return BlocBuilder<MapBloc, MapState>(
      builder: ( _ , state) {
        if (state.loadingRouteInMap) {
          return Stack(
            children: [
              Container(
                decoration: new BoxDecoration(
                  color: new Color.fromRGBO(0, 0, 0, 0.5)
                ),
              ),
              Center(
                child: CircularProgressIndicator()
              ),
            ],
          );
        } else {
            return Container();
        }
      }
    );
  }

  Widget _buildFloatingActionButton() {
    return  BlocBuilder<MapBloc, MapState>(
      builder: ( _ , state) {
          return Positioned(
            right: 20.0,
            bottom: state.panelHeight,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "fb1",
                  child: Icon(
                    Icons.gps_fixed,
                    color: Colors.black,
                  ),
                  onPressed: (){
                    mapBloc.moveCamera(mapBloc.state.currentPosition, Constants.DEFAULT_MAP_ZOOM_OUT);
                  },
                  backgroundColor: Colors.white,
                ),
              ]
            ),
          );
        }
    );
  }

  void _changeDraggableStatus(ModalStatus modalStatus) async {
  
    PanelConfig panelElementConfig = await JsonUtils.getPanelConfigByType(modalStatus);
    double maxHeight = Platform.isAndroid ? panelElementConfig.maxHeight : (panelElementConfig.maxHeight + 20);

    setState(() {
      isDraggable = panelElementConfig.isSwipeable;
      panelHeightOpen = maxHeight;
    });
  }

  void _showInvoice(MapState mapState) async {
    if(mapState?.trip?.invoiceId != null) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (BuildContext buildContext, __, ___) {
          return InvoicePage(
            modalBuildContext: buildContext,
            mapState: mapState
          );
        },
      );
    }
  }
}