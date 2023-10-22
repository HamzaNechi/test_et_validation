import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/article.dart';
import 'package:psychoday/screens/articles/detail_article.dart';
import 'package:psychoday/screens/dashboard/components/circular_button.dart';
import 'package:psychoday/utils/style.dart';

class CellArticle extends StatefulWidget {

  final Article article;
  const CellArticle({required this.article,super.key});

  @override
  State<CellArticle> createState() => _CellArticleState();
}

class _CellArticleState extends State<CellArticle> {
  @override
  Widget build(BuildContext context) {
    return //cell
                InkWell(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => DetailArticle(url: widget.article.body, article: widget.article)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 205,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image:DecorationImage(
                              image: NetworkImage(widget.article.image),//AssetImage(widget.article.image), //"Assets/images/article.png"
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                          
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 95,
                              child: Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Style.titleText(widget.article.category, Style.primary, 14),
                                    Style.titleText(widget.article.title.trim(), Style.blackColor, 14),
                                    Style.sousTitleText("By ${widget.article.author}", Style.secondLight, 14),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );

                //end cell;
  }
}