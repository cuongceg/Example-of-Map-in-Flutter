void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller ;
  LatLng _currentUserLocation = const LatLng(20.980238, 105.844616);
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polyLines = <Polyline>{};
  List<LatLng> userPolyLinesLatLngList = [];
  bool _drawPolygonEnabled = false;
  bool _clearDrawing = false;
  int? _lastXCoordinate, _lastYCoordinate;
  double _initValue = 0.2;


  @override
  void initState(){
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: _toggleDrawing,
          onLongPress:_showModalBottomSheet,
          child: Icon((_drawPolygonEnabled) ? Icons.cancel : Icons.edit,color: CupertinoColors.systemBlue,size: 30,),
        ),
      ),
      body: CircularMenu(
        alignment: Alignment.bottomLeft,
        startingAngleInRadian: 3/2*pi,
        endingAngleInRadian:  2*pi-0.0001,
        toggleButtonAnimatedIconData: AnimatedIcons.add_close,
        reverseCurve: Curves.bounceInOut,
        radius: 100,
        toggleButtonColor: Colors.green,
        toggleButtonIconColor: Colors.white,
        items: [
          CircularMenuItem(
            icon: Icons.format_paint,
            iconSize: 25,
            onTap: () {

            },
            color: Colors.orange,
            iconColor: Colors.white,
          ),
          CircularMenuItem(
            icon: Icons.edit,
            iconSize: 25,
            onTap: () {

            },
            color: Colors.lightBlueAccent,
            iconColor: Colors.white,
          ),
          CircularMenuItem(
            icon: Icons.delete,
            iconSize: 25,
            onTap: () {
              _clearPolygons();
            },
            color: Colors.redAccent,
            iconColor: Colors.white,
          ),
        ],
        backgroundWidget: Stack(
            children: [
              GestureDetector(
                onPanUpdate: (_drawPolygonEnabled) ? _onPanUpdate : null,
                onPanEnd: (_drawPolygonEnabled) ? _onPanEnd : null,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _currentUserLocation,
                    zoom: 14.4746,
                  ),
                  polygons: _polygons,
                  polylines: _polyLines,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                ),
              ),
            ]
        ),
      ),
    );
  }

  _toggleDrawing() {
    if(!_drawPolygonEnabled){
      _clearPolygons();
    }
    setState(() => _drawPolygonEnabled = !_drawPolygonEnabled);
  }

  _onPanUpdate(DragUpdateDetails details) async {
    if (_clearDrawing) {
      _clearDrawing = false;
      _clearPolygons();
    }

    if (_drawPolygonEnabled) {
      double x, y;
      if (Platform.isAndroid) {
        // It times in 3 without any meaning,
        x = details.globalPosition.dx * 3;
        y = details.globalPosition.dy * 3;
      } else if (Platform.isIOS) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      }else{
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      }

      int xCoordinate = x.round();
      int yCoordinate = y.round();

      // prevent two fingers drawing.
      if (_lastXCoordinate != null && _lastYCoordinate != null) {
        var distance = math.sqrt(math.pow(xCoordinate - _lastXCoordinate!, 2) + math.pow(yCoordinate - _lastYCoordinate!, 2));
        // Check if the distance of point and point is large.
        if (distance > 80.0) return;
      }

      // Cached the coordinate.
      _lastXCoordinate = xCoordinate;
      _lastYCoordinate = yCoordinate;

      ScreenCoordinate screenCoordinate = ScreenCoordinate(x: xCoordinate, y: yCoordinate);

      LatLng latLng = await _controller.getLatLng(screenCoordinate);

      try {
        // Add new point to list.
        userPolyLinesLatLngList.add(latLng);
        _polyLines.removeWhere((polyline) => polyline.polylineId.value == 'user_polyline');
        _polyLines.add(
          Polyline(
            polylineId: const PolylineId('user_polyline'),
            points: userPolyLinesLatLngList,
            width: (_initValue*10).round(),
            color: Colors.blue,
          ),
        );
        debugPrint("Drawing Successfully");
      } catch (e) {
        debugPrint(" error painting $e");
      }
      setState(() {});
    }
  }

  _onPanEnd(DragEndDetails details) async {
    // Reset last cached coordinate
    _lastXCoordinate = null;
    _lastYCoordinate = null;

    if (_drawPolygonEnabled) {
      _polygons.removeWhere((polygon)=>polygon.polygonId.value == 'user_polygon');
      _polygons.add(
        Polygon(
          polygonId:  const PolygonId('user_polygon'),
          points: userPolyLinesLatLngList,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.4),
        ),
      );
      setState(() {
        _clearDrawing = true;
      });
      debugPrint("Clear Drawing, ${_polygons.last.polygonId},");
    }
  }

  _clearPolygons() {
    setState(() {
      _polyLines.clear();
      _polygons.clear();
      userPolyLinesLatLngList.clear();
    });
  }

  Future<void> _showModalBottomSheet(){
    return showModalBottomSheet(
        context: context, 
        builder: (context){
          return StatefulBuilder(
              builder: (BuildContext context,StateSetter setState){
                return SizedBox(
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel",style: TextStyle(fontSize:16),),
                          ),
                          const Text("Change the width of line",style: TextStyle(fontSize:14),),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("Save",style: TextStyle(fontSize:16,color:CupertinoColors.systemBlue),),
                          ),
                        ],
                      ),
                      Slider(
                          value: _initValue,
                          divisions: 10,
                          activeColor: CupertinoColors.systemBlue,
                          inactiveColor: CupertinoColors.lightBackgroundGray,
                          label: "${_initValue*10}",
                          onChanged: (selectedValue){
                            setState((){
                              _initValue = selectedValue;
                            });
                          }
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  Future<void> _checkPermission() async {
    bool enabled = false;
    LocationPermission permission;
    enabled = await Geolocator.isLocationServiceEnabled();
    if(!enabled){
      debugPrint("Please enable the location Service");
    }else{
      permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.deniedForever){
        debugPrint("Permission is denied forever");
      }else if( permission == LocationPermission.denied ){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.deniedForever){
          debugPrint("Permission is denied forever");
        }
      }else if( permission == LocationPermission.whileInUse){
        Position currentUserLocation = await Geolocator.getCurrentPosition();
        setState(() {
          _currentUserLocation = LatLng(currentUserLocation.latitude,currentUserLocation.longitude);
          _controller.animateCamera(
              CameraUpdate.newLatLng(_currentUserLocation)
          );
          debugPrint("My current location is ${currentUserLocation.latitude},${currentUserLocation.longitude}");
        });
      }
    }
  }

}
