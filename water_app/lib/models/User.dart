class User {
  double Peso;

  User({ this.Peso });

  User.FromJson(Map<String, dynamic> json) {
    Peso = json['peso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['peso'] = this.Peso;
    return data;
  }

}