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
