class PostInfo {
  String id;
  String user;
  String description;
  String imageURL;
  int daysAgo;
  List<String> likes;

  PostInfo(this.id, this.user, this.description, this.imageURL, this.daysAgo, this.likes);
}

class Comment {
  String id;
  String user;
  String comment;
  int daysAgo;

  Comment(this.id, this.user, this.comment, this.daysAgo);
}

class Item {
  String id;
  String eid;
  String username;
  String name;
  String alternateNames;
  String material;
  String whichBin;
  String image;
  String info;
  String category;
  String links;

  Item(this.id, this.eid, this.username, this.name, this.alternateNames, this.material, this.whichBin, this.image, this.info, this.category, this.links);
}