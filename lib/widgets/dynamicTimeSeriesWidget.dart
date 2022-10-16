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
  late List<TimeDataModel> chartData=<TimeDataModel> [
  TimeDataModel.withAcc(t:DateTime(2022,10,5),ax:2,ay:6,az:2),
    TimeDataModel.withAcc(t:DateTime(2022,10,6),ax:2,ay:1,az:2),
    TimeDataModel.withAcc(t:DateTime(2022,10,7),ax:2,ay:3,az:2),
    TimeDataModel.withAcc(t:DateTime(2022,10,8),ax:2,ay:2,az:2),
    TimeDataModel.withAcc(t:DateTime(2022,10,9),ax:2,ay:1,az:2)

  ];

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
              series:_getData(),
              title:ChartTitle(text:"chart flutter")
          ),
      ],
    );
  }
// maintenant, chartData est obtenu de dehors, il faut un moyen d'appeler updatadatasource depuis l'extérieur
  int i=10;
  void updateDataSource(Timer t){
    chartData.add(TimeDataModel.withAcc(t:DateTime(2022,10,i),ax:2,ay:math.Random().nextDouble()*10,az:2));
    i++;
    _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length-1
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
          xValueMapper: (TimeDataModel measures,_)=> measures.t.microsecondsSinceEpoch,
          yValueMapper: (TimeDataModel measures,_)=> measures.ay,
          onRendererCreated: (ChartSeriesController controller){
            _chartSeriesController=controller;
          },
      )
    ];
  }
  //JEN AI MARREEREHFUOIRHVUORVH
}
