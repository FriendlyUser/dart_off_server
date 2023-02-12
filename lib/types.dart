class SteamTopSeller {
  String? imageSrc;
  String? title;
  String? price;
  String? publishDate;
  String? discount;


  SteamTopSeller(this.imageSrc, this.title, this.price, this.publishDate, this.discount);

  fromJson(Map<String, dynamic> json) {
    this.imageSrc = json['imageSrc'];
    this.title = json['title'];
    this.price = json['price'];
    this.publishDate = json['publishDate'];
    this.discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'imageSrc': this.imageSrc,
      'title': this.title,
      'price': this.price,
      'publishDate': this.publishDate,
      'discount': this.discount,
    };
  }
}
