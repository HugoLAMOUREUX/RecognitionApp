import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/timeSerieModel.dart';
import '../widgets/edited_time_series_widget.dart';
import 'LabelizeScreen.dart';

/* A FAIRE

1)
mettre le graph avec les plot band dans un component seul
le component recoit un controlleur avec la largeur des bandes et appelle une fonction avec un set state
le reste reste dans le crop_ts_screen
donc gestureDetector sort de edited_time_series_widget
plus besoin de faire un aller retour de ses valeurs, startoffset et endoffset seront au meme niveaux que le gesture
detector et du text input

2)
trouver un moyen d'avoir un deplacement proprtionnel a la taille de la série
...comment connaitre la taille du gesturedetector ?

3)
trvouer un moyen de mettre à jour les text input si on modifie avec la zone tactile




 */
class CropTsScreen extends StatefulWidget {
  final TimeSerieModel timeSerie;

  const CropTsScreen({Key? key,required this.timeSerie}) : super(key: key);

  @override
  State<CropTsScreen> createState() => _CropTsScreenState();
}

class _CropTsScreenState extends State<CropTsScreen> {

  final _TimeSeriesEditorController = TimeSeriesEditorController();

  final _firstTextController=TextEditingController();
  final _secondTextController=TextEditingController();

  @override
  void dispose(){
    _TimeSeriesEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, //pour cacher la flèche arrière
            title: Text("Time Series Details")
        ),
        body:SingleChildScrollView(
          child: Column(

              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Please crop the time series to keep the activity only",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 300,
                    child: Center(
                        child:EditedTimeSeriesWidget(inputChartData: widget.timeSerie.getTimeSerieModel(),editorController: _TimeSeriesEditorController)
                    )
                ),


                //je pensais me débarasser des text inputs mais j'arrive pas encore a faire fonctionner
                //le horizental drag comme je veux donc bon tjr là
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text("Number of start points to remove :",
                        style: TextStyle(
                        fontSize: 15,
                    )
                    ),
                    SizedBox(
                        width: 100,
                        child:TextField(
                          controller:_firstTextController ,
                          decoration: const InputDecoration(labelText: "Crop start"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text){
                            //if text non vide

                            if(text.isNotEmpty) {
                              _TimeSeriesEditorController.updateStart(int.parse(text));
                            }
                          },// Only numbers can be entered
                        )),

                  ],
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Number of end points to remove :",
                        style: TextStyle(
                          fontSize: 15,
                        )
                    ),
                    SizedBox(
                        width: 100,
                        child:TextField(
                          controller:_secondTextController ,
                          decoration: const InputDecoration(labelText: "Crop end"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text){
                            if(text.isNotEmpty) {
                              _TimeSeriesEditorController.updateEnd(int.parse(text));
                            }
                          },// Only numbers can be entered
                        )
                    )
                  ],
                ),
                SizedBox(width: double.infinity,height: 50,),
                ElevatedButton(
                  onPressed: () {
                    TimeSerieModel toSend=this.widget.timeSerie.crop(this._TimeSeriesEditorController.startOffSet,this._TimeSeriesEditorController.endOffSet);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LabelizeScreen(timeSerie: toSend)),
                            //fonctionne pas encore pb de range
                            (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'continue'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
        )
      ),
    );
  }




}
