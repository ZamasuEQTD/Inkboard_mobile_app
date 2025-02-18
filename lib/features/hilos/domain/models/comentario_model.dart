import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

class ComentarioModel {
  final String id;
  final String texto;
  final DateTime createdAt;
  final String? autorId;
  final bool esAutor;
  final bool destacado;
  final List<String> respondidoPor;
  final List<String> respondeA;
  final bool esOp;
  final String tag;
  final String? tagUnico;
  final bool? recibirNotificaciones;
  final String color;
  final String? dados;
  final MediaModel? media;
  final String autorRole;
  final String autor;

  const ComentarioModel({
    required this.id,
    required this.texto,
    required this.createdAt,
    this.autorId,
    required this.esAutor,
    required this.destacado,
    required this.respondidoPor,
    required this.respondeA,
    required this.esOp,
    required this.tag,
    this.tagUnico,
    this.recibirNotificaciones,
    required this.color,
    this.dados,
    this.media,
    required this.autorRole,
    required this.autor,
  });

  ComentarioModel copyWith({
    String? id,
    String? texto,
    DateTime? createdAt,
    String? autorId,
    bool? esAutor,
    bool? destacado,
    List<String>? respondidoPor,
    List<String>? respondeA,
    bool? esOp,
    String? tag,
    String? tagUnico,
    bool? recibirNotificaciones,
    String? color,
    String? dados,
    MediaModel? media,
    String? autorRole,
    String? autor,
  }) {
    return ComentarioModel(
      id: id ?? this.id,
      texto: texto ?? this.texto,
      createdAt: createdAt ?? this.createdAt,
      autorId: autorId ?? this.autorId,
      esAutor: esAutor ?? this.esAutor,
      destacado: destacado ?? this.destacado,
      respondidoPor: respondidoPor ?? this.respondidoPor,
      respondeA: respondeA ?? this.respondeA,
      esOp: esOp ?? this.esOp,
      tag: tag ?? this.tag,
      tagUnico: tagUnico ?? this.tagUnico,
      recibirNotificaciones:
          recibirNotificaciones ?? this.recibirNotificaciones,
      color: color ?? this.color,
      dados: dados ?? this.dados,
      media: media ?? this.media,
      autorRole: autorRole ?? this.autorRole,
      autor: autor ?? this.autor,
    );
  }

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      id: json['id'],
      texto: json['texto'],
      createdAt: DateTime.parse(json['created_at']),
      autorId: json['autor_id'],
      esAutor: json['es_autor'],
      destacado: json['destacado'],
      respondidoPor: List<String>.from(json['respondido_por']),
      respondeA: List<String>.from(json['responde_a']),
      esOp: json['es_op'],
      tag: json['tag'],
      tagUnico: json['tag_unico'],
      recibirNotificaciones: json['recibir_notificaciones'],
      color: json['color'],
      dados: json['dados'],
      media: json['media'] != null ? MediaModel.fromJson(json['media']) : null,
      autorRole: json['autor_role'],
      autor: json['autor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'texto': texto,
      'created_at': createdAt.toIso8601String(),
      'autor_id': autorId,
      'es_autor': esAutor,
      'destacado': destacado,
      'respondido_por': respondidoPor,
      'responde_a': respondeA,
      'es_op': esOp,
      'tag': tag,
      'tag_unico': tagUnico,
      'recibir_notificaciones': recibirNotificaciones,
      'color': color,
      'dados': dados,
      'media': media?.toJson(),
      'autor_role': autorRole,
      'autor': autor,
    };
  }
}
