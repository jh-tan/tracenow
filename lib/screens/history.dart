import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test1/models/notification.dart';
// import 'package:flutter_test1/widgets/expandable_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/widgets/history_card.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<DocumentSnapshot> riskHistory = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder<QuerySnapshot>(
          future: _getAllHistory(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              // Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
              riskHistory = snapshot.data!.docs;
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                  ),
                  title: const Text(
                    'Risk History',
                    style: TextStyle(color: Colors.black),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                ),
                body: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return HistoryCard(
                        date: riskHistory[index]['date'],
                        duration: riskHistory[index]['duration'].toString(),
                        index: index + 1,
                      );
                    },
                    itemCount: riskHistory.length,
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 1.h)),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    } catch (e) {
      print(e);
      return const Center(child: CircularProgressIndicator());
    }

    // -----------------
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: () => Navigator.pop(context),
    //       icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
    //     ),
    //     title: const Text('Risk History'),
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     centerTitle: true,
    //   ),
    //   body: ListView.builder(
    //     itemBuilder: (BuildContext context, int index) {
    //       return ExpandableTiles(
    //           date: riskHistory[index].date,
    //           distance: riskHistory[index].distance.toString(),
    //           duration: riskHistory[index].duration.toString(),
    //           proximity: riskHistory[index].proximity);
    //     },
    //     itemCount: riskHistory.length,
    //   ),
    // );
  }

  Future<QuerySnapshot> _getAllHistory() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? UUID = prefs.getString('UUID');
    const String? UUID = "B7E091D4FD89DB9168F6675F3020748E";

    return await FirebaseFirestore.instance
        .collectionGroup('encounterUser')
        .where('uuid', isEqualTo: UUID)
        .orderBy('date', descending: true)
        .get();
  }
}
