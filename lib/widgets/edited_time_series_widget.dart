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

  setStart(int finalStart){
    startOffSet=finalStart;
  }

  setEnd(int finalEnd){
    endOffSet=finalEnd;
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
      startOffset=math.max(0,math.min(widget.inputChartData.length-1,widget.editorController.startOffSet));
      endOffset=math.max(0,math.min(widget.inputChartData.length-1,widget.editorController.endOffSet));
    });
  }

  updateStartOffset(int delta){
    if(delta>0){
      //si on drag vers la droit

      if(startOffset<widget.inputChartData.length-1){
        //si l'offset n'est pas deja au max

        startOffset+=delta;
        //pour avoir une correspondance exacte entre le drag et le deplacement
        //il faudrait connaitre la gesturedetectorsize et faire
        //delta*inputChartDataLength/gestureDetectorSize mais je sais pas faire


      }
    }else{
      //si on drag vers la gauche

      if(startOffset>0){
        //si l'offset n'est pas deja au min

        startOffset+=delta;
        //pour avoir une correspondance exacte entre le drag et le deplacement
        //il faudrait connaitre la gesturedetectorsize et faire
        //delta*inputChartDataLength/gestureDetectorSize mais je sais pas faire
      }
    }
  }

  double originalX=0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details){

        originalX=details.globalPosition.dx;


      },
      onHorizontalDragUpdate: (DragUpdateDetails details){

        updateStartOffset((details.delta.dx).round());
        setState(() {

        //chercher un moyen de gérer à la fois l'offset start et l'offset end
          //peut etre utiliser les zones de textes / bouton pour choisir l'offset qu'on veut modifier ?
          //un bouton zone de text ? avec le text modifé par le drag, ou par le clavier


          //a start drag, seulement lancer si on est proche de l'offset ??

          //il faudra sortir gesturedetector de ce widget car on a besoin des données d'offset pour modifier la série
        });
      },
      onHorizontalDragEnd: (DragEndDetails){
        this.widget.editorController.setStart(this.startOffset);
      },
      child: Container(
          height: 250,
           child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  plotBands: <PlotBand>[
                    PlotBand(
                        isVisible: true,
                        start: widget.inputChartData[0].t,
                        end: widget.inputChartData[getStartOffSet()].t,
                      color: Colors.deepOrangeAccent
                    ),
                    PlotBand(
                        isVisible: true,
                        start: widget.inputChartData[widget.inputChartData.length-1-getEndOffSet()].t,
                        end: widget.inputChartData.last.t,
                        color: Colors.deepOrangeAccent
                    )
                  ],

                    isVisible: false //hide x axis
                ),
                primaryYAxis: NumericAxis(
                    isVisible: false
                ),
                series:_getData(),
            ),
      ),
    );
  }

  int getStartOffSet(){
    return math.max(0,math.min(widget.inputChartData.length-1,startOffset));
  }

  int getEndOffSet(){
    return math.max(0,math.min(widget.inputChartData.length-1,endOffset));
  }

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
}
