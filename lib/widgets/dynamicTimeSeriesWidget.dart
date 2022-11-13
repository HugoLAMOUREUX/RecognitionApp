import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


import '../models/timeDataModel.dart';
import 'dart:math' as math;


class TimeSeriesUpdateController extends ChangeNotifier{
  TimeSeriesUpdateController();
  update(){
    notifyListeners();
  }
}

///widget pour afficher des series dynamiques
class DynamicTimeSeriesWidget extends StatefulWidget {
  final TimeSeriesUpdateController updateController;
  final List<TimeDataModel> inputChartData;

  DynamicTimeSeriesWidget({Key? key,required this.inputChartData,required this.updateController}) : super(key: key);

  @override
  State<DynamicTimeSeriesWidget> createState() => _DynamicTimeSeriesWidgetState();
}

class _DynamicTimeSeriesWidgetState extends State<DynamicTimeSeriesWidget> {
  //late TooltipBehavior _tooltipBehavior; usefull ? useless ?
  late ChartSeriesController _chartSeriesController;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    //_tooltipBehavior = TooltipBehavior( enable: true); useless ? usefull ?

   widget.updateController.addListener(() {
     updateSensorView();
   });


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SfCartesianChart(
              primaryXAxis: NumericAxis(
                // X axis is hidden now
                  isVisible: false
              ),
              primaryYAxis: NumericAxis(
                //to hide labels but keep the grid
                  labelStyle: TextStyle(
                    fontSize: 0
                  )
              ),
              series:_getData(),
              title:ChartTitle(text:"Real Time Accelerometer Values")
          ),
      ],
    );
  }

  int j=0;
  void updateSensorView(){
    j++;
    _chartSeriesController.updateDataSource(
        addedDataIndex: j
    );
  }


  /// Sample time series data
  List<LineSeries<TimeDataModel,num>> _getData() {
    return <LineSeries<TimeDataModel,num>>[
      LineSeries<TimeDataModel,num>(
        enableTooltip: false,
          dataSource: widget.inputChartData,
          xValueMapper: (TimeDataModel measures,_)=> measures.t,
          yValueMapper: (TimeDataModel measures,_)=> measures.ay,
          onRendererCreated: (ChartSeriesController controller){
            _chartSeriesController=controller;
          },
      )
    ];
  }
  //JEN AI MARREEREHFUOIRHVUORVH
}
