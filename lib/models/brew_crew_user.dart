class BrewCrewUser{
  String? brewCrewUserUID;
  String? userName ;
  // enumeration major 
  
  String? email;
  String? password;
  String? drink;

  // gender

  // constuctor
  BrewCrewUser({this.brewCrewUserUID,this.userName, this.email, this.password,this.drink});

  // getting data from server
  factory BrewCrewUser.fromMap(map)
  {
    return BrewCrewUser(
      brewCrewUserUID: map['BrewCrewUserUID'], 
      userName: map['userName'], 
      email:  map['email'],
      password:  map['password'],
      drink:  map['drink'],
      

    );
  }

  // sending data to server
  Map<String, dynamic> toMap()
  {
    return {
      "BrewCrewUserUID": brewCrewUserUID, 
      "userName": userName, 
      "email":  email,
      "password":  password,
      "drink" : drink
    };
  }

}