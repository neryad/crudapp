import 'dart:convert';

Articles articlesFromJson(String str) => Articles.fromJson(json.decode(str));

String articlesToJson(Articles data) => json.encode(data.toJson());

class Articles {
    Articles({
        this.id,
        this.name,
          this.fecha,
    });

    int id;
    String name;
    String fecha;

    factory Articles.fromJson(Map<String, dynamic> json) => Articles(
        id: json["id"],
        name: json["name"],
        fecha: json["fecha"],

        
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fecha": fecha,
    };
}