import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


import '../models/timeDataModel.dart';
import 'dart:math' as math;


class TimeSeriesEditorController extends ChangeNotifier{
  int startOffSet=0;
  int endOffSet=0;

  TimeSeriesEditorController();

  updateStart(int newStartoffSet){
    startOffSet=newStartoffSet;
    notifyListeners();
  }
  updateEnd(int newEndoffSet){
    endOffSet=newEndoffSet;
    notifyListeners();
  }
  updateOffSets(int newStartoffSet,int newEndoffSet){
    startOffSet=newStartoffSet;
    endOffSet=newEndoffSet;
    notifyListeners();
  }
}

///widget pour afficher des series dynamiques
class EditedTimeSeriesWidget extends StatefulWidget {
  final TimeSeriesEditorController editorController;
  final List<TimeDataModel> inputChartData;


  EditedTimeSeriesWidget({Key? key,required this.inputChartData,required this.editorController}) : super(key: key);

  @override
  State<EditedTimeSeriesWidget> createState() => _EditedTimeSeriesWidgetState();
}

class _EditedTimeSeriesWidgetState extends State<EditedTimeSeriesWidget> {
  //late TooltipBehavior _tooltipBehavior; usefull ? useless ?
  late Timer timer;
  int startOffset=0;
  int endOffset=0;

  @override
  void initState() {
    super.initState();
    //_tooltipBehavior = TooltipBehavior( enable: true); useless ? usefull ?

    widget.editorController.addListener(() {
      updateEditionView();
    });

  }

  void updateEditionView(){
    setState((){
      startOffset=widget.editorController.startOffSet>widget.inputChartData.length ? widget.inputChartData.length-1:widget.editorController.startOffSet;
      endOffset=widget.editorController.endOffSet>widget.inputChartData.length ? widget.inputChartData.length-1:widget.editorController.endOffSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SfCartesianChart(
              primaryXAxis: NumericAxis(
                plotBands: <PlotBand>[
                  PlotBand(
                      isVisible: true,
                      start: widget.inputChartData[0].t,
                      end: widget.inputChartData[startOffset].t,
                    color: Colors.deepOrangeAccent
                  ),
                  PlotBand(
                      isVisible: true,
                      start: widget.inputChartData[widget.inputChartData.length-1-endOffset].t,
                      end: widget.inputChartData.last.t,
                      color: Colors.deepOrangeAccent
                  )
                ],
                // X axis is hidden now
                  isVisible: false
              ),
              series:_getData(),
              title:ChartTitle(text:"Crop Time Series")
          ),
      ],
    );
  }


  /// Sample time series data
  List<LineSeries<TimeDataModel,num>> _getData() {
    return <LineSeries<TimeDataModel,num>>[
      LineSeries<TimeDataModel,num>(
        enableTooltip: false,
          dataSource: widget.inputChartData,
          xValueMapper: (TimeDataModel measures,_)=> measures.t,
          yValueMapper: (TimeDataModel measures,_)=> measures.ay
      )
    ];
  }
  //JEN AI MARREEREHFUOIRHVUORVH
}
