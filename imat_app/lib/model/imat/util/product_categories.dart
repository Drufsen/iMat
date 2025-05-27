import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';

String getCategoryName(ProductCategory category) {
  switch (category) {
    case ProductCategory.POD:
      return "Ärtor och baljväxter";
    case ProductCategory.BREAD:
      return "Bröd";
    case ProductCategory.DAIRIES:
      return "Mejeriprodukter";
    case ProductCategory.MEAT:
      return "Kött";
    case ProductCategory.BERRY:
      return "Bär";
    case ProductCategory.FISH:
      return "Fisk och skaldjur";
    case ProductCategory.CABBAGE:
      return "Kål";
    case ProductCategory.CITRUS_FRUIT:
      return "Citrusfrukter";
    case ProductCategory.COLD_DRINKS:
      return "Kalla drycker";
    case ProductCategory.HOT_DRINKS:
      return "Varma drycker";
    case ProductCategory.EXOTIC_FRUIT:
      return "Exotiska frukter";
    case ProductCategory.FRUIT:
      return "Frukter";
    case ProductCategory.HERB:
      return "Örter";
    case ProductCategory.MELONS:
      return "Meloner";
    case ProductCategory.NUTS_AND_SEEDS:
      return "Nötter och frön";
    case ProductCategory.PASTA:
      return "Pasta";
    case ProductCategory.POTATO_RICE:
      return "Potatis och ris";
    case ProductCategory.ROOT_VEGETABLE:
      return "Rotfrukter";
    case ProductCategory.SWEET:
      return "Sötsaker";
    case ProductCategory.VEGETABLE_FRUIT:
      return "Grönsaksfrukter";
    case ProductCategory.FLOUR_SUGAR_SALT:
      return "Mjöl, socker och salt";
    default:
      return "Okänd kategori";
  }
}

Map<String, List<Product>> buildCategorizedProducts(ImatDataHandler iMat) {
  final Map<String, List<Product>> categorizedProducts = {};

  // Add "Favoriter" only when not searching
  if (!iMat.isSearching) {
    final favoriteProducts = iMat.favorites;
    if (favoriteProducts.isNotEmpty) {
      categorizedProducts['Favoriter'] = favoriteProducts;
    }
  }

  // Add regular categories
  for (var category in ProductCategory.values) {
    final productsInCategory =
        iMat.selectProducts
            .where((product) => product.category == category)
            .toList();

    if (productsInCategory.isNotEmpty) {
      categorizedProducts[getCategoryName(category)] = productsInCategory;
    }
  }

  return categorizedProducts;
}
