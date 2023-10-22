import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/article.dart';
import 'package:psychoday/screens/articles/detail_article.dart';
import 'package:psychoday/utils/style.dart';

class OneArticle extends StatelessWidget {
  final Article article;
  const OneArticle({required this.article,super.key});

  @override
  Widget build(BuildContext context) {
    double width_screen=MediaQuery.of(context).size.width;
    double height_screen=MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailArticle(url: article.body, article: article),));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
    
    
          //image conatiner
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width_screen * 0.02),
            child: Container(
              width: width_screen,
              height: height_screen*0.18,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(article.image),fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(Radius.circular(12))
              ),
            ),
          ),
    
    
          SizedBox(height: height_screen*0.01,),
    
          //title container
    
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width_screen*0.03),
            child: Container(
              width: width_screen,
              height: height_screen*0.095,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Style.titleText(article.title.trim(), Style.blackColor, 14),
                  Style.sousTitleText('By ${article.author}', Style.second, 14)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}