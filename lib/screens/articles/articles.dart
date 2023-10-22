import 'package:flutter/material.dart';
import 'package:psychoday/models/article.dart';
import 'package:psychoday/navigations/bottom_nav_user.dart';
import 'package:psychoday/screens/articles/components/cell_article.dart';
import 'package:psychoday/screens/articles/components/web_scraping.dart';
import 'package:psychoday/utils/style.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  @override
  Widget build(BuildContext context) {
    WebScrapper webScrapper=WebScrapper();
    return Scaffold(
      appBar: AppBar(
        title: Style.titleText('NEWS', Style.whiteColor, 16),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
      
      
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
      
           // const OneArticle()
           FutureBuilder(
                    future:webScrapper.extractData(),
                    builder: (context, snapshot) {
                        if(snapshot.hasData){
                          List<Article> articles=snapshot.data as List<Article>;
                          return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OneArticle(article: articles[index]),
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
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavUser(),
    );
  }
}