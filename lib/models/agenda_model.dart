class AgendaModel {
  int? success;
  List<DataAgenda>? agenda;

  AgendaModel({this.success, this.agenda});

  AgendaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['agenda'] != null) {
      agenda = <DataAgenda>[];
      json['agenda'].forEach((v) {
        agenda!.add(DataAgenda.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (agenda != null) {
      data['agenda'] = agenda!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataAgenda {
  String? id;
  String? idUsuario;
  String? dia;
  String? mes;
  String? horaInicio;
  String? horaFinal;
  String? fechaInicio;
  String? fechaFinal;
  String? titulo;
  String? descripcion;
  String? estado;
  String? tipo;
  List<Tags>? tags;

  DataAgenda(
      {this.id,
      this.idUsuario,
      this.dia,
      this.mes,
      this.horaInicio,
      this.horaFinal,
      this.fechaInicio,
      this.fechaFinal,
      this.titulo,
      this.descripcion,
      this.estado,
      this.tipo,
      this.tags});

  DataAgenda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUsuario = json['idUsuario'];
    dia = json['dia'];
    mes = json['mes'];
    horaInicio = json['horaInicio'];
    horaFinal = json['horaFinal'];
    fechaInicio = json['fechaInicio'];
    fechaFinal = json['fechaFinal'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    estado = json['estado'];
    tipo = json['tipo'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['idUsuario'] = this.idUsuario;
    data['dia'] = this.dia;
    data['mes'] = this.mes;
    data['horaInicio'] = this.horaInicio;
    data['horaFinal'] = this.horaFinal;
    data['fechaInicio'] = this.fechaInicio;
    data['fechaFinal'] = this.fechaFinal;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['estado'] = this.estado;
    data['tipo'] = this.tipo;
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  String? id;
  String? idAgenda;
  String? idUsuario;
  String? tag;
  String? color;
  String? activo;

  Tags(
      {this.id,
      this.idAgenda,
      this.idUsuario,
      this.tag,
      this.color,
      this.activo});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idAgenda = json['idAgenda'];
    idUsuario = json['idUsuario'];
    tag = json['tag'];
    color = json['color'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['idAgenda'] = this.idAgenda;
    data['idUsuario'] = this.idUsuario;
    data['tag'] = this.tag;
    data['color'] = this.color;
    data['activo'] = this.activo;
    return data;
  }
}
