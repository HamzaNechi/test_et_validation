import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:psychoday/models/article.dart';
import 'package:psychoday/navigations/bottom_nav_user.dart';
import 'package:psychoday/screens/articles/components/web_scraping.dart';
import 'package:psychoday/screens/dashboard/components/card_start_test.dart';
import 'package:psychoday/screens/dashboard/components/cellArticle.dart';
import 'package:psychoday/screens/dashboard/components/circular_button.dart';
import 'package:psychoday/screens/dashboard/components/topscreen.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';

class DashboardUser extends StatefulWidget {
  const DashboardUser({super.key});

  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenUser(), 
      desktop:DesktopScreenUser());
  }
}

// ignore: slash_for_doc_comments
/******************************************Mobile screen for dashboard user ****************************** */


class MobileScreenUser extends StatefulWidget {
  const MobileScreenUser({super.key});

  @override
  State<MobileScreenUser> createState() => _MobileScreenUserState();
}

class _MobileScreenUserState extends State<MobileScreenUser> {
  @override
  Widget build(BuildContext context) {
    WebScrapper webScrapper=WebScrapper();
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children:[
            const TopScreen(),
            const SizedBox(height: 20,),
            const StartTestCard(),
      
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Style.titleText('Explore articles', Style.blackColor, 16),
                ],
              ),
            ),
      
            const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Expanded
              (
                child: FutureBuilder(
                  future:webScrapper.extractData(),
                  builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<Article> articles=snapshot.data as List<Article>;
                        return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CellArticle(article: articles[index]),
                          );
                        },
                      );
                    }else{
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                  }, 
                ),
              ),
            ),
            
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavUser(),
    );
  }
}


/******************************************End Mobile screen for dashboard user ****************************** */



/****************************************** Desktop Screen for dashboard user********************************** */

class DesktopScreenUser extends StatefulWidget {
  const DesktopScreenUser({super.key});

  @override
  State<DesktopScreenUser> createState() => _DesktopScreenUserState();
}

class _DesktopScreenUserState extends State<DesktopScreenUser> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/****************************************** End Desktop Screen for dashboard user********************************** */