import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share/share.dart';
import 'package:topmusik/ui/about.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerHome extends StatefulWidget {
  @override
  _DrawerHomeState createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  @override
  Widget build(BuildContext context) {
    return  Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color(0xff0e1318)
            ),
            child: Drawer(
              child: ListView(
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ExactAssetImage('images/drawer.jpg'),
                            fit: BoxFit.fill)),
                  ),
                  ListTile(
                    leading: Icon(Icons.star, color: Colors.white),
                    title: Text('Beri Rating', style: TextStyle(color: Colors.white),),
                    onTap: () {
                      _launchRate();
                    },
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  ListTile(
                    leading: Icon(Icons.share, color: Colors.white),
                    title: Text('Beri tahu teman', style: TextStyle(color: Colors.white),),
                    onTap: () {
                      Share.share('Bergabung bersama saya di BTS Music 2020');
                    },
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  ListTile(
                    leading: Icon(Icons.chat_bubble_outline, color: Colors.white),
                    title: Text('Feedback', style: TextStyle(color: Colors.white),),
                    onTap: () {
                      _sendEmail();
                    },
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.white),
                    title: Text('Tentang', style: TextStyle(color: Colors.white),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => About()
                      ));
                    },
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  
                ],
              ),
            ),
          ),
        );
  }
  _launchRate() async {
  const url = 'https://play.google.com/store/apps/details?id=id.deris.btsmusic';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  Future _sendEmail() async {
    final Email email = Email(
  body: '',
  subject: 'BTS Music-Feedback',
  recipients: ['deris.dev7@gmail.com'],
);

await FlutterEmailSender.send(email);
  }
}
