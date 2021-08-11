class StudentModel {

  String id;
  String name;
  String email;
  String password;
  String address;
  String role;
  bool isOnline;

  StudentModel({
    this.name,
    this.id,
    this.email,
    this.address,
    this.password,
    this.role,
    this.isOnline,
  });

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    role = json['role'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson(String id) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['address'] = this.address;
    data['role'] = this.role;
    data['isOnline'] = this.isOnline;
    return data;
  }
}
