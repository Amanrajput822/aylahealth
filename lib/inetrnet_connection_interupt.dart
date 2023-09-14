import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';


class InternetConnection extends StatelessWidget {
  static const String route = "/InternetConnection";



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
               Image.asset('assets/no_internet.png',
                height: 150,
              ),
              const SizedBox(height: 30),
              Text(
                'Oops, No Internet Connection',
                style:  TextStyle(
                    fontFamily: fontFamilyText,
                    fontSize: 20,
                    color: colorErrorColor,
                    fontWeight: fontWeight600
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Please check your internet connectivity \nand try again',
                style: TextStyle(
                  fontFamily: fontFamilyText,
                  fontSize: 16,
                  color: colorErrorColor,
                  fontWeight: fontWeight400
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),

                  fixedSize: MaterialStateProperty.all(
                    Size(width, 45),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "Retry",
                  style:  TextStyle(
                      fontFamily: fontFamilyText,
                      fontSize: 16,
                      color: colorWhite,
                      fontWeight: fontWeight400
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
