import 'package:openfoodfacts/openfoodfacts.dart';

Future<SearchResult> search(Map<String, String> query) {
  var parametersList = <Parameter>[];
  // check for terms in quer
  if (query.containsKey('terms')) {
    // print('terms: ${query['terms']}');
    var terms = query['terms'];
    if (terms != null && terms.isNotEmpty) {
      parametersList.add(SearchTerms(terms: terms.split(',')));
    }
  }
  // check for withoutAddictives
  if (query.containsKey('withoutAdditives')) {
    // print('withoutAdditives: ${query['withoutAdditives']}');
    var withoutAdditives = query['withoutAdditives'];
    if (withoutAdditives != null && withoutAdditives == "true") {
      parametersList.add(WithoutAdditives());
    }
  }

  if (query.containsKey('sort')) {
    // print('sort: ${query['sort']}');
    var sort = query['sort'];
    if (sort != null && sort.isNotEmpty) {
      var option = SortOption.values.firstWhere(
          (e) => e.toString() == sort,
          orElse: () => SortOption.PRODUCT_NAME);
      parametersList.add(SortBy(option: option));
    }
  }

  if (query.containsKey('pnnsGroup2')) {
    // print('pnnsGroup2: ${query['pnnsGroup2']}');
    var pnnsGroup2 = query['pnnsGroup2'];
    if (pnnsGroup2 != null && pnnsGroup2.isNotEmpty) {
       var option = PnnsGroup2.values.firstWhere(
          (e) => e.toString() == pnnsGroup2,
          orElse: () => PnnsGroup2.PIZZA_PIES_AND_QUICHE);
      parametersList.add(PnnsGroup2Filter(pnnsGroup2: option));
    }
  }

  // page size
  if (query.containsKey('size')) {
    // print('size: ${query['size']}');
    var size = query['size'];
    if (size != null && size.isNotEmpty) {
      parametersList.add(PageSize(size: int.parse(size)));
    }
  }

  // page number
  if (query.containsKey('page')) {
    // print('page: ${query['page']}');
    var page = query['page'];
    if (page != null && page.isNotEmpty) {
      parametersList.add(PageNumber(page: int.parse(page)));
    }
  }

  // by tags
  if (query.containsKey('tags')) {
    // print('tags: ${query['tags']}');
    var rawTags = query['tags'];
    if (rawTags != null && rawTags.isNotEmpty) {
      var tags = rawTags.split(',');
      // iterate over tags
      for (var tag in tags) {
        // check for tag with value
        // check tag
        if (tag.contains(':')) {
          var tagParts = tag.split(':');
          var tagName = tagParts[0];
          var tagValue = tagParts[1];
          var tagType = TagFilterType.values.firstWhere(
              (e) => e.toString() == tagName,
              orElse: () => TagFilterType.CATEGORIES);
          parametersList.add(TagFilter.fromType(tagFilterType: tagType, tagName: tagValue));
        }
      }
    }
  }

  ProductSearchQueryConfiguration configuration =
      ProductSearchQueryConfiguration(
    parametersList: parametersList,
    version: ProductQueryVersion.v3,
  );
  return OpenFoodAPIClient.searchProducts(
    User(userId: '', password: ''),
    configuration,
  );
}

void mkConfiguration() {
  OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'dart_off_server',
      url: 'https://friendlyuser-dart-off-server.hf.space/');
  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH
  ];

  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;
}
