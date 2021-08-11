class TeacherModel {

  String id;
  String name;
  String email;
  String password;
  String qualification;
  var lat;
  var lng;
  String subjectID;
  String subjectName;
  String role;
  String location;
  String hourlyRate;
  String image;
  String exp;
  String contactNo;
  String bio;
  bool isOnline;

  TeacherModel(
      {this.name,
      this.id,
      this.email,
      this.password,
      this.qualification,
      this.lat,
      this.isOnline,
      this.role,
      this.lng,
      this.subjectName,
      this.location,
      this.image,
      this.bio,
      this.contactNo,
      this.exp,
      this.hourlyRate,
      this.subjectID});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    qualification = json['qualification'];
    lat = json['lat'];
    lng = json['lng'];
    subjectID = json['subjectID'];
    subjectName = json['subjectName'];
    hourlyRate = json['hourlyRate'];
    role = json['role'];
    location = json['location'];
    bio = json['bio'];
    image = json['image'];
    exp = json['exp'];
    contactNo = json['contactNo'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson(String id) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['qualification'] = this.qualification;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['subjectID'] = this.subjectID;
    data['subjectName'] = this.subjectName;
    data['role'] = this.role;
    data['location'] = this.location;
    data['hourlyRate'] = this.hourlyRate;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['contactNo'] = this.contactNo;
    data['exp'] = this.exp;
    return data;
  }
}
