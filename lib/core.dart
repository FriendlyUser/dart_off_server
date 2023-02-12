import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:http/http.dart' as http;
// ignore_for_file: constant_identifier_names
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import './types.dart';


Future<SearchResult> search(Map<String, String> query) {
  var parametersList = <Parameter>[];
  // check for terms in query

  if (query.containsKey('terms')) {
    var terms = query['terms'];
    if (terms != null && terms.isNotEmpty) {
      parametersList.add(SearchTerms(terms: terms.split(',')));
    }
  }
  // check for withoutAddictives
  if (query.containsKey('withoutAdditives')) {
    var withoutAdditives = query['withoutAdditives'];
    if (withoutAdditives != null && withoutAdditives == "true") {
      parametersList.add(WithoutAdditives());
    }
  }

  if (query.containsKey('sort')) {
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
    var size = query['size'];
    if (size != null && size.isNotEmpty) {
      parametersList.add(PageSize(size: int.parse(size)));
    }
  }

  // page number
  if (query.containsKey('page')) {
    var page = query['page'];
    if (page != null && page.isNotEmpty) {
      parametersList.add(PageNumber(page: int.parse(page)));
    }
  }

  // by tags
  if (query.containsKey('tags')) {
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


// function that scans for top steam charts

Future<List<SteamTopSeller>> findTopSteamSellers() async {
  var url = Uri.https('store.steampowered.com', 'search/?filter=topsellers');
  var html = await http.get(url);
  return parseSteamTopSellers(html.body);
}

List<SteamTopSeller> parseSteamTopSellers(String rawHTML ) {
  BeautifulSoup  soup = BeautifulSoup(rawHTML);
  var searchResultsDiv = soup.find('div', attrs: {'id': 'search_resultsRows'});
  if (searchResultsDiv == null) {
    return <SteamTopSeller>[];
  }
  var topSellers = searchResultsDiv.findAll('a');

  if (topSellers.isEmpty) {
    return <SteamTopSeller>[];
  }
  var topSellersList = <SteamTopSeller>[];
  for (var topSeller in topSellers) {
    var imageDiv = topSeller.find('img');
    String? imageSrc = '';
    if (imageDiv != null) {
      imageSrc = imageDiv.attributes['src'];
    }
    var title = topSeller.find('span', attrs: {'class': 'title'})?.text;
    var publishDate = topSeller.find('div', attrs: {'class': 'col search_released responsive_secondrow'})?.text;
    // var publishDate = topSeller.find('div', attrs: {'class': 'tab_item_top_tags'}).text;
    // get data-price-final
    var price = topSeller.find('div', attrs: {'class': 'search_price_discount_combined'})?.attributes['data-price-final'];
    var discountDiv = topSeller.find('div', attrs: {'class': 'search_discount'});
    String discount = "";
    if (discountDiv != null) {
      var discountSpan = discountDiv.find("span");
      if (discountSpan != null) {
        discount = discountSpan.text;
      }
    }
    topSellersList.add(SteamTopSeller(imageSrc, title, price, publishDate, discount));
  }

  return topSellersList;
}