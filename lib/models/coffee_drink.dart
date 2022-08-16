class CoffeeDrinkSql {
  static const String table = "coffee_drink_table";
  static const String id = "id_coffee_drink";
  static const String name = "name";
  static const String price = "price";
  static const String calories = "calories";
  static const String img = "img";
}

class CoffeeDrink {
  int? id;
  String img;
  String name;
  double price;
  double calories;

  CoffeeDrink(
      {this.id,
      required this.img,
      required this.name,
      required this.price,
      required this.calories});

  Map<String, Object?> toJson() => {
        CoffeeDrinkSql.id: id,
        CoffeeDrinkSql.name: name,
        CoffeeDrinkSql.img: img,
        CoffeeDrinkSql.price: price,
        CoffeeDrinkSql.calories: calories
      };

  factory CoffeeDrink.fromJson(Map<String, Object?> json) => CoffeeDrink(
        id: json[CoffeeDrinkSql.id] as int?,
        name: json[CoffeeDrinkSql.name] as String,
        img: json[CoffeeDrinkSql.img] as String,
        price: json[CoffeeDrinkSql.price] as double,
        calories: json[CoffeeDrinkSql.calories] as double,
      );
}

class CoffeeDrinkLocalInfo {
  static List<CoffeeDrink> get data => [
        CoffeeDrink(
            img:
                "https://st2.depositphotos.com/9876904/44485/v/380/depositphotos_444855556-stock-illustration-paper-coffee-cup-isolated-transparent.jpg?forcejpeg=true",
            name: "Brew Crew Latte",
            price: 5.0,
            calories: 150),
        CoffeeDrink(
            img:
                "https://img.freepik.com/free-vector/morning-coffee-cup-with-hot-freshly-brewed-espresso-americano-mug-aromatic-caffeine-drink-with-steam-saucer-beans-simple-flat-vector-illustration-isolated-white-background_198278-10924.jpg?w=2000",
            name: "Brew Crew Americano",
            price: 7.0,
            calories: 100),
        CoffeeDrink(
            img:
                "https://cdn2.vectorstock.com/i/1000x1000/46/56/espresso-coffee-cup-icon-isolated-on-white-vector-33544656.jpg",
            name: "Brew Crew Espresso",
            price: 3.0,
            calories: 77)
      ];
}
