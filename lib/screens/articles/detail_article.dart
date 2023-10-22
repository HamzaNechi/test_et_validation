import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/article.dart';
import 'package:psychoday/screens/articles/components/web_scraping.dart';
import 'package:psychoday/utils/style.dart';

class DetailArticle extends StatelessWidget {
  final String url;
  final Article article;
  const DetailArticle({required this.url,required this.article,super.key});

  @override
  Widget build(BuildContext context) {
    WebScrapper webScrapper=WebScrapper();
    return Scaffold(
      appBar: AppBar(
        title:Style.titleText(article.category, Style.whiteColor, 16) ,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height*0.05),
      
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Style.titleText('Health & Medicin', Style.primary, 16),
            //   ),
      
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(image: NetworkImage(article.image),fit: BoxFit.cover),
                ),
              ),
              ),
      
              SizedBox(height: MediaQuery.of(context).size.height*0.02),
      
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Style.titleText(article.title, Style.blackColor, 15),
                    Style.sousTitleText('By ${article.author}', Style.second, 16)
                  ],
                ),
                ),
      
      
      
      
              SizedBox(height: MediaQuery.of(context).size.height*0.05),
      
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                child: Expanded
                (
                  child: FutureBuilder(
                    future:webScrapper.extractBody(article.body) ,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<String> bodys=snapshot.data as List<String>;
                        return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: bodys.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Style.sousTitleText(bodys[index], Style.blackColor, 16),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.05),
                                  
                                ],
                              ),
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
    );
  }
}