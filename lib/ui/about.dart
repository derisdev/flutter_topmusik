import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/background.jpeg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(80),
                    child: Center(
                      child: Image.asset('images/playstore.png', fit: BoxFit.cover,),

                    ),
                  ),
                  Text('BTS Music 2020', style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('V 1.0.1', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 40,
                  ),
                  ListTile(
                    title: Text('Kebijakan Privasi',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _launchPrivacy();
                    },
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2),),
                  ListTile(
                    title:
                        Text('Disclaimer', style: TextStyle(color: Colors.white)),
                        onTap: (){
                          confirm(context);
                        },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text('deris.dev7@gmail.com',
                      style: TextStyle(color: Colors.white)),
                  Text('Hak Cipta 2020', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _launchPrivacy() async {
    const url =
        'https://derisdev.blogspot.com/2020/01/privacy-policy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> confirm(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Disclaimer',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      Center(
                          child: Text(
                              '1.) Aplikasi ini memuat konten lagu-lagu BTS yang tersebar secara bebas dan gratis di internet\n2.) Konten yang berupa musik dan gambar adalah bukan hak cipta developer.\n 3) Kerusakan akibat kesalahan penggunaan aplikasi adalah tanggung jawab pengguna\n4) Beritahu kami bila anda pemilik resmi konten yang ada di dalam aplikasi ini, kami dengan senang hati akan menghapus konten dari daftar lagu yang ada di aplikasi.\n5) Developer dan pemilik resmi konten tidak ada perjanjian khusus dalam penerbitan aplikasi\n\n\nRoyalti bagi pemilik resmi konten akan di bayarkan melalui Lembaga Manajemen Kolektif Nasional')),
                      Container(
                        height: 20.0,
                      ),
                      Container(
                        height: 10.0,
                      ),
                    ],
                  )),
                ),
              ),
              RaisedButton(
                color: Colors.pink,
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        })) {
    }
  }
}
