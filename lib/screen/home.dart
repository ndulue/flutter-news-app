import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutternaijanews/model/article_model.dart';
import 'package:flutternaijanews/model/category_model.dart';
import 'package:flutternaijanews/provider/News.dart';
import 'package:flutternaijanews/provider/data.dart';
import 'package:flutternaijanews/screen/article_news.dart';
import 'package:flutternaijanews/screen/category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> article = new List<ArticleModel>();
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategory();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    article = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Naija ",style: TextStyle(
                  color: Colors.black
              ),
            ),
            Text("News", style: TextStyle(
                color: Colors.purple[300]
              ),
            )
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,

      ),
      body:
      _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) :
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              //Categories
              Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return CardTile(
                        cardName: categories[index].categoryName,
                        imageUrl: categories[index].imageUrl,
                      );
                    }
                ),
              ),

              //blog
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ListView.builder(
                  itemCount: article.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return BlogTile(
                        imageUrl: article[index].urlToImage,
                        title: article[index].title,
                        desc: article[index].description,
                        url: article[index].url
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class CardTile extends StatelessWidget {
  final String imageUrl;
  final String cardName;

  CardTile({this.cardName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryNews(
              category: cardName.toLowerCase(),
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 60,
                  fit: BoxFit.cover,
                )
            ),
            Container(
              alignment: Alignment.center,
              width: 120,  height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                cardName, style: TextStyle(
                  color: Colors.white
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl, title, desc, url;

  BlogTile({
    @required this.imageUrl,
    @required this.title,
    @required this.desc,
    @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(url)
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)
            ),
            SizedBox(height: 8,),
            Text(title, style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500
            ),
            ),
            SizedBox(height: 8,),
            Text(desc, style: TextStyle(
                color: Colors.black54
            ),
            )
          ],
        ),
      ),
    );
  }
}

