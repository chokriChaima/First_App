import 'package:brew_crew/models/coffee_drink.dart';
import 'package:brew_crew/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../sql_dependencies/db_brew_crew.dart';
import 'menu_item_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final BrewCrewDatabase instance = BrewCrewDatabase.instance;

  List<CoffeeDrink> _drinks = [];
  void getDrinks() async {
    Database db = await instance.database;
    // await instance.insert(db);
    _drinks = await instance.get(db);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // instance.deleteAllRows(CoffeeDrinkSql.table);
  }

  @override
  void didChangeDependencies() {
    getDrinks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen())),
                icon: const Icon(Icons.person))
          ],
        ),
        body: _drinks.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, inex) => Divider(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  thickness: 2,
                ),
                itemBuilder: (
                  context,
                  index,
                ) =>
                    ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
                  leading: Icon(
                    Icons.coffee,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    _drinks[index].name,
                    style: const TextStyle(fontSize: 16.5),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MenuItemScreen(
                                  drink: _drinks[index],
                                ))),
                    icon: const Icon(Icons.play_arrow),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                itemCount: _drinks.length,
              ));
  }
}
