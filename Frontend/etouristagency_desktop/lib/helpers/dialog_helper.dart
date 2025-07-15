import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static void openSuccessDialog(
    BuildContext context,
    String text,
    VoidCallback onPressedMethod,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(text, style: TextStyle(fontSize: 18)),
        icon: Icon(Icons.check_circle, color: AppColors.primary),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: onPressedMethod,
              child: Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  static void openConfirmationDialog(BuildContext builderContext,
    String title,
    String text,
    VoidCallback onPressedMethod){
      showDialog(context: builderContext, builder: (context)=> AlertDialog(title : Text(title),
      content: IntrinsicHeight(child: Center(child: Text(text))),
      icon: Icon(Icons.warning),
      actions: [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        ElevatedButton(onPressed: onPressedMethod, child: Text("DA")),
        SizedBox(width:20),
        ElevatedButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("NE"))
      ],)],
      ));
    }

  static Widget openSpinner(BuildContext context, String text) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 70,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
