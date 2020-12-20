import 'package:EnQ/const/style.dart';
import 'package:EnQ/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:EnQ/services/auth_service.dart';
import 'package:EnQ/pages/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginButton extends StatelessWidget {
  final String _title;
  final String _imgUrl;
  final String _type;
  // final Function isLogin;
  LoginButton(this._title, this._imgUrl, this._type);
  final AuthService auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        minWidth: double.infinity,
        height: 60,
        onPressed: () {
          if (this._type == 'GG') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                      child: SpinKitWave(
                    color: Colors.purple[50],
                  ));
                });
            try {
              auth.handleSignIn().whenComplete(() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Home(uidCurrentUser: auth.currentUser.uid)));
              });
            } catch (err) {
              print("ERROR: $err");
            }
          } else if (this._type == 'FB') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('This feature will be enable in future',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: FontName)),
                  );
                });
          }
        },
        color: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              this._imgUrl,
              width: 24.0,
              height: 24.0,
            ),
            Text(
              this._title,
              style: TextStyle(
                  fontSize: SmallText,
                  fontFamily: FontName,
                  fontWeight: FontWeight.w200),
            ),
            // Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
