class Music{
  final String name;
  final String composer;
  final String tag;
  final String category;
  final int size;
  final String type;

  Music(this.name, this.composer, this.tag, this.category, this.size,
      this.type);

  Map<String,dynamic> toMap(){
    Map<String,dynamic> mapMusic = {};
    mapMusic['name'] = name;
    mapMusic['composer'] = composer;
    mapMusic['tag'] = tag;
    mapMusic['category'] = category;
    mapMusic['size'] = size;
    mapMusic['type'] = type;

    return mapMusic;
  }
}