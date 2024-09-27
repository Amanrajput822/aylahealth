import 'package:aylahealth/screens/subscription_screens/sub_popup/subPlanPopupScreen.dart';
import 'package:flutter/material.dart';


void showSubscriptionPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular border
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // Circular container
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: subPlanPopupScreen(), // Embed your Subscription_screen widget here
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

