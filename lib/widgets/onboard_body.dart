import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracenow/configs/size_config.dart';
import 'package:tracenow/widgets/onboard_content.dart';
import 'package:tracenow/models/onboard_screen_data.dart';
import 'package:tracenow/widgets/onboard_dot.dart';

class OnBoardBody extends StatefulWidget {
  const OnBoardBody({Key? key}) : super(key: key);

  @override
  _OnBoardBodyState createState() => _OnBoardBodyState();
}

class _OnBoardBodyState extends State<OnBoardBody> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: OnBoardData.length,
                itemBuilder: (context, index) => OnBoardContent(
                      title: OnBoardData[index]["title"],
                      text: OnBoardData[index]["text"],
                      image: OnBoardData[index]["image"],
                    )),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      OnBoardData.length,
                      (index) => OnBoardDot(
                        index: index,
                        current: currentPage,
                      ),
                    )),
                const Spacer(),
                SizedBox(
                  width: SizeConfig().getProportionalScreenWidth(320),
                  height: SizeConfig().getProportionalScreenHeight(60),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(currentPage != OnBoardData.length - 1){
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                      }else{
                        await _storeOnboardInfo();
                        Navigator.pushReplacementNamed(context, 'Login');
                      }
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: SizeConfig().getProportionalScreenWidth(18),
                          color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.lightBlueAccent[200]),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // const Spacer(flex: 3,),
        ],
      ),
    ));
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }
}
