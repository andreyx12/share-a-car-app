
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:images_picker/images_picker.dart";
import 'package:share_a_car/src/blocs/driver_license/driver_license_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/models/driver_license/driver_license.dart';


class DriverLicensePage extends StatefulWidget {
  @override
  _DriverLicensePageState createState() => _DriverLicensePageState();
}

class _DriverLicensePageState extends State<DriverLicensePage> {

  /* Flag que indica que los datos de carga iniciales ya se realizaron */
  bool isInitialDataValidated = false;
  /* Flag que indica que el usuario ya subió una licencia */
  bool userAlreadyUploadedLicense = false;
  
  /* Path de imagen local */
  String localPath;

  DriverLicenseBloc driverLicenseBloc;

  @override
  void initState() { 
    super.initState();
    driverLicenseBloc = BlocProvider.of<DriverLicenseBloc>(context);
    context.read<DriverLicenseBloc>().add(OnRequestDriverLicenseStatus());
  }

  @override
  void dispose() {
    super.dispose();
    driverLicenseBloc.add(OnInitialState());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Licencia de conducir"),
      ),
      body: Column(
        children: [
         buildImageContainer(),
         SizedBox(height: 20.0,),
          getCardInfo()
        ]
      ),
      bottomNavigationBar: buildBottomNavigationBar()
    );
  }

  Widget buildImageContainer() {

     return BlocBuilder<DriverLicenseBloc, DriverLicenseState>(
        builder: ( _ , state) {

          String placeholderImage = state.driverLicense == null ? Constants.LOADING_IMAGE_PATH : Constants.PLACEHOLDER_IMAGE_PATH;

            return GestureDetector(
              onTap: allowAddOrUpdateDriverLicense(state.driverLicense) ? getImage : (){},
              child: Container(
                width: double.infinity,
                height: 300.0,
                decoration: new BoxDecoration(
                  color: Color.fromRGBO(233, 238, 241, 1.0),
                  image: DecorationImage(
                    repeat: ImageRepeat.noRepeat,
                    image: state.driverLicense?.image == null ? localPath != null ? FileImage(File(localPath)) : AssetImage(placeholderImage) : Image.memory(base64Decode(state.driverLicense.image)).image,
                    fit: BoxFit.cover
                  ),
                )
              )
            );
        }
    );
  }

  Widget getCardInfo() {
    return  BlocBuilder<DriverLicenseBloc, DriverLicenseState>(
        builder: ( _ , state) {
          if (state.driverLicense != null && !state.uploadingImage) {

            if (state.driverLicense.errorCode == Constants.RESOURCE_NOT_FOUND_ERROR_CODE || state.driverLicense.errorCode == null) {
              return Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(15.0),
                  dense: true,
                  leading: getDriverLicenseIcon(state.driverLicense.status),
                  title: Text("Estado de la licencia", style: TextStyle(fontSize: 20.0)),
                  subtitle: Text(getDriverLicenseStatus(state.driverLicense.status), style: TextStyle(fontSize: 18.0)),
                ),
              );
              
            } else {
              return Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(15.0),
                  dense: true,
                  leading: Icon(Icons.clear, size: 30, color: Colors.red),
                  title: Text("Error " + state.driverLicense.errorCode, style: TextStyle(fontSize: 20.0)),
                  subtitle: Text(state.driverLicense.errorMessage, style: TextStyle(fontSize: 18.0)),
                ),
              ); 
            }
            
          } else {
            return Container(
              margin: EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator()
            ); 
          }
        }
    );
  }

  Widget buildBottomNavigationBar() {
    return  BlocBuilder<DriverLicenseBloc, DriverLicenseState>(
        builder: ( _ , state) {

          if (state.driverLicense != null) {

            if (allowAddOrUpdateDriverLicense(state.driverLicense) && !state.uploadingImage) {
               String buttonTitle = state.driverLicense.status != null ? "Modificar licencia" : "Agregar licencia";

              return SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: Platform.isAndroid ? 5.0 : 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
                        enableFeedback: true,
                        minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                        backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
                      ),
                      label: Text(buttonTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                      icon: Icon(Icons.cloud_upload),
                      onPressed: () {
                        getImage();
                      },
                    ),
                ),
              );
            } else {
              return SizedBox();
            }
          } else {
            return SizedBox();
          }
        }
    );
  }

  getImage() async {
    List<Media> res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image
    );
    setState(() {
      localPath = res[0].path;
    });
    buildBase64Image(res[0].path);
  }

  buildBase64Image(String path) {
    File file = File(path);
    Uint8List bytes = file.readAsBytesSync();
    String base64Image = base64Encode(bytes);
    driverLicenseBloc.add(OnUploadLicense(base64Image));
  }

  Widget getDriverLicenseIcon (String status) {
    switch (status) {
      case Constants.DRIVER_LICENSE_STATUS_PENDING:
        return Icon(Icons.query_builder, size: 30, color: Colors.yellow[800]);
      break;
      case Constants.DRIVER_LICENSE_STATUS_APPROVED:
        return Icon(Icons.check, size: 30, color: Colors.green[700]);
      break;
      case Constants.DRIVER_LICENSE_STATUS_DENIED:
        return Icon(Icons.clear, size: 30, color: Colors.red);
      break;
      default:
        return Icon(Icons.file_upload, size: 30, color: Colors.grey[600]);
      break;
    }
  }

  String getDriverLicenseStatus (String status) {

    switch (status) {
      case Constants.DRIVER_LICENSE_STATUS_PENDING:
        return "Pendiente de aprobación";
      break;
      case Constants.DRIVER_LICENSE_STATUS_APPROVED:
        return "Aprobado";
      break;
      case Constants.DRIVER_LICENSE_STATUS_DENIED:
        return "Denegado";
      break;
      default:
        return "Pendiente de agregar";
      break;
    }
  }

   bool allowAddOrUpdateDriverLicense (DriverLicense driverLicense) {
      return (driverLicense != null && (driverLicense.status == Constants.DRIVER_LICENSE_STATUS_DENIED || driverLicense?.errorCode == Constants.RESOURCE_NOT_FOUND_ERROR_CODE));
  }
}