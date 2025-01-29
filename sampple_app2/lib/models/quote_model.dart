/// here we create quoted model
class QuoteModel {
  String author;
  String quote;
  int id;

  /// create constructor
  QuoteModel({required this.author, required this.id, required this.quote});

  /// Map(JSON) -> Model ,, convert map to model
  /// fromJson
  factory QuoteModel.myFromJson(Map<String, dynamic> json) {
    return QuoteModel(
        author: json['author'], id: json['id'], quote: json['quote']);
  }
}

/// here we create main model
class QuoteDataModel {
  int limit;
  int skip;
  int total;

  /// quotes is list of model
  List<QuoteModel> quotes = [];

  /// constructor
  QuoteDataModel({
    required this.quotes,
    required this.total,
    required this.skip,
    required this.limit,
  });

  /// fromMap
  factory QuoteDataModel.myFromJson(Map<String, dynamic> json) {
    List<QuoteModel> mQuotes = [];
    for (Map<String, dynamic> eachQuotes in json['quotes']) {
      var eachQuotesModel = QuoteModel.myFromJson(eachQuotes);
      mQuotes.add(eachQuotesModel);
    }
    return QuoteDataModel(
        limit: json['limit'],
        skip: json['skip'],
        total: json['total'],
        quotes: mQuotes);
  }
}
