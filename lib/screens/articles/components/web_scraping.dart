import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:psychoday/models/article.dart';

class WebScrapper{
  final String url="https://www.sciencenews.org/article/tag/mental-health";


  Future<List<Article>> extractData() async {
    http.Response response=await http.get(Uri.parse(url));
    List<Article> articles=[];
    if(response.statusCode == 200){
      final html = parser.parse(response.body);
      final container=html.querySelector('.river-with-sidebar__list___5dLsp')!.children;
      container.forEach((element) {
        try{
          final image=element.querySelector("figure a img")!.attributes['src'];
          final category=element.querySelector(".post-item-river__content___ueKx3 a")!.text;
          final title=element.querySelector(".post-item-river__content___ueKx3 h3 a")!.text;
          final author =element.querySelector(".post-item-river__content___ueKx3 .post-item-river__meta___Lx4Tk span a")!.text;
          final urlDetail=element.querySelector(".post-item-river__content___ueKx3 h3 a")!.attributes['href'];         
          articles.add(Article(image: image!,category: category, title: title, body: urlDetail!, author: author));
        }catch(e){
          print(e);
        }
      });
    }

    return articles;
  }

  Future<List<String>> extractBody(String url) async {
    http.Response response=await http.get(Uri.parse(url));
    List<String> texts=[];
    if(response.statusCode == 200){
      final html = parser.parse(response.body);
      final container=html.querySelector('.single__body___2pHuV')!.children;
      var node=container[0].querySelector('p');
      while(node!.nextElementSibling!.localName as String == 'p' || node.nextElementSibling!.localName as String == 'div'){
        
        if(node.nextElementSibling!.localName as String == 'p'){
            texts.add(node.text);
        }
        
        node=node.nextElementSibling;
        
        print(node!.nextElementSibling!.localName);
      }
      
    }
    return texts;
  }
}