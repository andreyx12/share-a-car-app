
import 'package:flutter/material.dart';

import 'package:share_a_car/src/blocs/home/map_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/pages/home/components/slideup_generic_content.dart';
import 'package:share_a_car/src/pages/home/components/slideup_reservation_process.dart';
import 'package:share_a_car/src/pages/home/components/slideup_route_in_progress.dart';
import 'package:share_a_car/src/pages/home/components/slideup_selected_marker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlideUpContentBuilder extends StatelessWidget {

  final MapBloc mapBloc;
  final ModalStatus modalStatus;
  final PanelController panelController;

  SlideUpContentBuilder({Key key, this.mapBloc, this.modalStatus, this.panelController}): super(key: key);

  final Decoration decoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    )
  );
   
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: _getPanelContent(context)
    );
  }

  Widget _getPanelContent(BuildContext context) {
    switch (modalStatus) {
       case ModalStatus.init:
          return GenericContentPanelWidget(
            text: 'Seleccione un vehículo en el mapa para empezar a viajar.',
            icon: Icons.location_on,
          );

        case ModalStatus.licenseNotRegistered:
          return GenericContentPanelWidget(
            text: _getLicenseNoRegisteredMessage(mapBloc.state),
            icon: Icons.cancel,
            color: Colors.red,
          );

        case ModalStatus.selectedMarker:
          return SelectedMarkerPanelWidget(
            mapBloc: mapBloc,
            panelController: panelController,
            dragIconWidget: _buildDragIcon()
          );

        case ModalStatus.reservationProcess:
          return ReservationProcessPanelWidget(
              mapBloc: mapBloc,
              panelController: panelController,
              dragIconWidget: _buildDragIcon()
            );

        case ModalStatus.routeInProgresss:
          return RouteInProgress(
            mapBloc: mapBloc,
            panelController: panelController,
            dragIconWidget: _buildDragIcon()
          );

        case ModalStatus.finishingTrip:
          return GenericContentPanelWidget(
            text: 'Finalizando el viaje...',
            icon: Icons.car_rental,
          );
      default:
        return GenericContentPanelWidget(
          text: 'Seleccione un vehículo en el mapa para empezar a viajar.',
          icon: Icons.location_on,
        );
     }
  }

   Widget _buildDragIcon() => GestureDetector(
      onTap: () => !panelController.isPanelOpen ? panelController.open() :  panelController.close(),
      child: Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8)
      ),
      width: 40,
      height: 6,
    ),
  );

  String _getLicenseNoRegisteredMessage(MapState state) {
    String licenseStatusMessage;
    switch(state.driverLicenseStatus) {
      case Constants.DRIVER_LICENSE_STATUS_PENDING:
        licenseStatusMessage = "Debe esperar que la licencia sea aprobada para alquilar un vehículo.";
        break;
      case Constants.DRIVER_LICENSE_STATUS_DENIED:
        licenseStatusMessage =  "La licencia fue rechazada, favor proceder a registrar una nueva.";
        break;
      case Constants.DRIVER_LICENSE_STATUS_NOT_REGISTERED:
        licenseStatusMessage = "Debe registrar una licencia para poder alquilar un vehículo.";
        break;
    }
    return licenseStatusMessage;
  }
}