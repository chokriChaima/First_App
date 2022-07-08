class Student{
  String? studentUID;
  String? userName ;
  // enumeration major 
  
  String? email;
  String? password;

  // gender

  // constuctor
  Student({this.studentUID,this.userName, this.email, this.password});

  // getting data from server
  factory Student.fromMap(map)
  {
    return Student(
      studentUID: map['studentUID'], 
      userName: map['userName'], 
      email:  map['email'],
      password:  map['password']
    );
  }

  // sending data to server
  Map<String, dynamic> toMap()
  {
    return {
      "studentUID": studentUID, 
      "userName": userName, 
      "email":  email,
      "password":  password,
    };
  }

}