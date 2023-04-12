class Eventos {
  bool? error;
  List<DataEventos>? data;

  Eventos({this.error, this.data});

  Eventos.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <DataEventos>[];
      json['data'].forEach((v) {
        data!.add(DataEventos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataEventos {
  int? id;
  String? dia;
  String? mes;
  String? horaInicio;
  String? horaFinal;
  String? fechaInicio;
  String? fechaFinal;
  String? titulo;
  String? descripcion;
  List<Tags>? tags;

  DataEventos(
      {this.id,
      this.dia,
      this.mes,
      this.horaInicio,
      this.horaFinal,
      this.fechaInicio,
      this.fechaFinal,
      this.titulo,
      this.descripcion,
      this.tags});

  DataEventos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dia = json['dia'];
    mes = json['mes'];
    horaInicio = json['horaInicio'];
    horaFinal = json['horaFinal'];
    fechaInicio = json['fechaInicio'];
    fechaFinal = json['fechaFinal'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dia'] = dia;
    data['mes'] = mes;
    data['horaInicio'] = horaInicio;
    data['horaFinal'] = horaFinal;
    data['fechaInicio'] = fechaInicio;
    data['fechaFinal'] = fechaFinal;
    data['titulo'] = titulo;
    data['descripcion'] = descripcion;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  String? tag;
  int? estado;

  Tags({this.tag, this.estado});

  Tags.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    data['estado'] = estado;
    return data;
  }
}
