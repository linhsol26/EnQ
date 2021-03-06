import 'package:EnQ/components/history_review_button.dart';
import 'package:EnQ/components/popular_card.dart';
import 'package:EnQ/const/size_config.dart';
import 'package:EnQ/const/style.dart';
import 'package:EnQ/models/user.dart';
import 'package:EnQ/models/leader.dart';
import 'package:EnQ/pages/history.dart';
import 'package:EnQ/services/history_service.dart';
import 'package:EnQ/services/user_service.dart';
import 'package:EnQ/services/leader_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:EnQ/pages/profile.dart';
import 'package:EnQ/pages/categories.dart';
import 'package:EnQ/pages/leader_board.dart';

class Home extends StatefulWidget {
  final String uidCurrentUser;

  Home({Key key, @required this.uidCurrentUser});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LeaderBoard(
                      uidCurrentUser: widget.uidCurrentUser,
                      leadersDay: this.leadersDay,
                      leadersWeek: this.leadersWeek)));
          break;
        case 2:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Categories(
                        uidCurrentUser: widget.uidCurrentUser,
                      )));
          break;
        case 3:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => History(
                      uidCurrentUser: widget.uidCurrentUser, user: this.user)));
          break;
        case 4:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Profile(
                      uidCurrentUser: widget.uidCurrentUser, user: this.user)));
          break;
        default:
      }
    });
  }

  Future<User> user;
  Future<List<dynamic>> recentHistory;
  Future<Leader> leadersDay;
  Future<Leader> leadersWeek;

  @override
  void initState() {
    user = UserService().getUser(widget.uidCurrentUser, this.context);
    leadersDay = LeaderService().getLeadersDay();
    leadersWeek = LeaderService().getLeadersWeek();
    recentHistory = HistoryService().getRecentHistory(widget.uidCurrentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: Future.wait([user, recentHistory]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight / 2.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Hello, ${snapshot.data[0].userName}",
                                style: ScriptStyle,
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(snapshot.data[0].photoUrl),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Popular",
                              style: TextStyle(
                                  fontSize: 22.5, fontFamily: FontName),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 200,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  PopularCard(
                                      'assets/images/undraw_book_lover_mkck.png'),
                                  PopularCard(
                                      'assets/images/undraw_book_reading_kx9s.png'),
                                  PopularCard(
                                      'assets/images/undraw_Reading_book_re_kqpk.png'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight / 2.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Recent",
                              style: TextStyle(
                                  fontSize: 22.5, fontFamily: FontName),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) =>
                                  HistoryReviewButton(
                                      histories: snapshot.data[1][index],
                                      index: index,
                                      currentUser: snapshot.data[0]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error} from Home");
              }
              return SpinKitWave(
                color: Colors.purple[50],
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.barChartOutline),
                title: Text('Leader'),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.listOutline),
                title: Text('Categories'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text('History'),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.personOutline),
                title: Text('Profile'),
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.black,
            selectedFontSize: 12,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
