class RecipeModel {
  String label;
  String image;
  String source;
  String url;

  RecipeModel({this.url, this.source, this.image, this.label});

  factory RecipeModel.fromMap(Map<String,dynamic> parsedJson){
    return RecipeModel(
      url: parsedJson["url"],
      label: parsedJson["label"],
      source: parsedJson["source"],
      image: parsedJson["image"],
    );
  }
}