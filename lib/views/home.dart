import 'dart:convert';
import 'package:food_ingredients/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_ingredients/models/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {

  List<RecipeModel> recipes = new List<RecipeModel>();
  TextEditingController textEditingController = new TextEditingController
    ();

  getRecipes(String query) async{
    String url = 'https://api.edamam.com/search?q=$query&app_id=b19c64d9&app_key=2caa2eac49c06da53d763650ad648de8';

    var response = await http.get(url);
    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element){
      //print(element.toString());

      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    setState(() {});
    print("${recipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff213A50),
                  const Color(0xff071930),
                ]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: Platform.isAndroid ? 60 : 30, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: kIsWeb ? MainAxisAlignment.start :
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Kitchen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                        'Khazana',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.0,),
                    Text(
                        'What will you cook today?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "We got it all handled. Just enter the ingredient you have",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 27),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your ingredients',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.amber,
                            ),
                          ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          if(textEditingController.text.isNotEmpty){
                            getRecipes(textEditingController.text);
                            print("Just do it");
                          } else{
                            print("Just don't do it");
                          }
                        },
                        child:  Container(
                          child: Icon(Icons.search),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Expanded(
                    child: GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, mainAxisSpacing: 10
                      ),
                      children: List.generate(recipes.length, (index) {
                        return GridTile(
                            child: RecipeTile(
                              title: recipes[index].label,
                              desc: recipes[index].source,
                              imgUrl: recipes[index].image,
                              url: recipes[index].url,
                            ));
                      }),
                    )
                ),
               ],
            ),
          ),
        ],
      ));
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {

  _launchURL(String url) async{
    print(url);
    if (await canLaunch(url)){
      await launch(url);
    }else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if(kIsWeb){
              _launchURL(widget.url);
            } else {
              print(widget.url + "This is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white30, Colors.white],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                            widget.desc,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
