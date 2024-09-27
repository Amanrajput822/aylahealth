import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/styles/const.dart';
import 'notificationScreenProvider.dart';

class Notifocation_Screen extends StatefulWidget {
  const Notifocation_Screen({Key? key}) : super(key: key);

  @override
  State<Notifocation_Screen> createState() => _Notifocation_ScreenState();
}

class _Notifocation_ScreenState extends State<Notifocation_Screen> {



  @override
  void initState() {
    super.initState();

    final NotificationScreenModelData =  Provider.of<NotificationScreenProvider>(context, listen: false);
    NotificationScreenModelData.customerNotificationSetting_api();

  }

  @override
  Widget build(BuildContext context) {
    final NotificationScreenModelData = Provider.of<NotificationScreenProvider>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,color: colorRichblack,),
        ),
      ),
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.all(15),
        child:NotificationScreenModelData.loading
            ? const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ):   Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('  Notifications',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: fontFamilyText,
                  color: colorPrimaryColor,
                  fontWeight: fontWeight600,
                  overflow: TextOverflow.ellipsis
              ),
              maxLines: 1,
            ),
            Text('   Manage your notification settings.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamilyText,
                color: colorRichblack,
                fontWeight: fontWeight400,
              ),
            ),

            ListTile(
              title: Text('New Modules',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ),
              subtitle:Text('Be notified when we add a new module!',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: fontFamilyText,
                    color: HexColor('#6A707F'),
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ) ,
              tileColor: colorWhite,
              textColor: colorRichblack,
              trailing: Switch(

                onChanged: (a){
                  setState(() {
                    if(NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus == true)
                    {
                      NotificationScreenModelData.updateCustomerNotificationSetting_api(
                          NotificationScreenModelData.notificationSettingData!.first.cnsId!,
                          NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus == true?1:0,0,'cns_module_status');

                      NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus = false;
                    }
                    else if(NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus == false)
                    {
                      NotificationScreenModelData.updateCustomerNotificationSetting_api(
                          NotificationScreenModelData.notificationSettingData!.first.cnsId!,
                          NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus == true?1:0,1,'cns_module_status');

                      NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus = true;
                    }

                  });
                },
                value: NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus!,
                activeColor: HexColor('#2D3091'),
                activeTrackColor: HexColor('#2D3091').withOpacity(0.4),
                inactiveThumbColor: colorgrey,
                inactiveTrackColor: HexColor('#2D3091').withOpacity(0.4),
              ),

            ),
            Divider(
              thickness: 1,height: 1,
              color: HexColor('#E9ECF1'),
            ),
            ListTile(
              title: Text('New Recipes',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ),
              subtitle:Text('Be notified when we add new recipes!',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: fontFamilyText,
                    color: HexColor('#6A707F'),
                    fontWeight: fontWeight400,
                    overflow: TextOverflow.ellipsis
                ),
                maxLines: 1,
              ) ,
              tileColor: colorWhite,
              textColor: colorRichblack,
              trailing: Switch(
                onChanged: (value){
                  setState(() {
                    if(NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus == true)
                      {
                        NotificationScreenModelData.updateCustomerNotificationSetting_api(
                            NotificationScreenModelData.notificationSettingData!.first.cnsId!,
                            0,NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus == true?1:0,'cns_recipe_status');

                        NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus = false;
                      }
                   else if(NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus == false)
                    {
                      NotificationScreenModelData.updateCustomerNotificationSetting_api(
                          NotificationScreenModelData.notificationSettingData!.first.cnsId!,
                          1,NotificationScreenModelData.notificationSettingData!.first.cnsModuleStatus == true?1:0,'cns_recipe_status');

                      NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus = true;
                    }

                  });
                },
                value: NotificationScreenModelData.notificationSettingData!.first.cnsRecipeStatus!,
                activeColor: HexColor('#2D3091'),
                activeTrackColor: HexColor('#2D3091').withOpacity(0.4),
                inactiveThumbColor: colorgrey,
                inactiveTrackColor: HexColor('#2D3091').withOpacity(0.4),
              ),

            ),
            Divider(
              thickness: 1,height: 1,
              color: HexColor('#E9ECF1'),
            ),

          ],
        ),
      ),
    );
  }
}
