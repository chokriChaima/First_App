import 'package:brew_crew/models/coffee_drink.dart';
import 'package:flutter/material.dart';

class MenuItemScreen extends StatelessWidget {
  final CoffeeDrink drink;
  const MenuItemScreen({Key? key, required this.drink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(drink.name),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.play_arrow_outlined,
                  size: 26,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ]),
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(drink.img))),
            ),
            Column(
              children: [
                Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 38.0,vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Price",
                        style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                      Text(
                        drink.price.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
                      Icon(Icons.attach_money_rounded,
                          color: Theme.of(context).colorScheme.primary, size: 26),
                     
                    ],
                    
                  ),
                ),
                const SizedBox(height: 5,),
                 Divider(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    thickness: 2,
                  ),
              ],
            )
          ,
            Column(
              children: [
                Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 38.0,vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Calories",
                        style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                      Text(
                        drink.calories.toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(width: 2,),
                      Icon(Icons.contact_support_sharp,
                          color: Theme.of(context).colorScheme.primary, size: 26),
                     
                    ],
                    
                  ),
                ),
                const SizedBox(height: 5,),
                 Divider(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    thickness: 2,
                  ),
              ],
            )
          ],
          
        ));
  }
}
