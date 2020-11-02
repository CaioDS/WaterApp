class Water {
  int Id;
  bool Active;

  Water({ this.Id, this.Active });

  Water.FromJson(Map<String, dynamic> json) {
    Id = json['copo'];
    Active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['copo'] = this.Id;
    data['active'] = this.Active;
    return data;
  }

}