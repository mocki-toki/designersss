import 'dart:convert';

import 'package:shared_backend/domain.dart';
import 'package:postgres/postgres.dart';

const _tableName = 'collection_link';

// CREATE TABLE collection_link (
//   dateTime TIMESTAMPTZ PRIMARY KEY,
//   items JSONB
// );

final class CollectionLinkManager {
  CollectionLinkManager(this._connection);

  final Connection _connection;

  Future<List<Date>> getDates() async {
    return (await _connection.execute(
      Sql.named('SELECT dateTime FROM $_tableName ORDER BY dateTime DESC'),
    ))
        .map((e) => Date(e[0] as DateTime))
        .toList();
  }

  Future<List<CollectionLink>> getLinksByDate(Date date) async {
    final items = (await _connection.execute(
      Sql.named('SELECT items FROM $_tableName WHERE dateTime=@dateTime'),
      parameters: {'dateTime': date.dateTime.toIso8601String()},
    ))
        .first[0] as List;

    return items
        .map((e) => CollectionLink.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> existsDate(Date date) async {
    return (await _connection.execute(
      Sql.named('SELECT dateTime FROM $_tableName WHERE dateTime=@dateTime'),
      parameters: {'dateTime': date.dateTime.toIso8601String()},
    ))
        .isNotEmpty;
  }

  Future<void> deleteByDate(Date date) {
    return _connection.execute(
      Sql.named('DELETE FROM $_tableName WHERE dateTime=@dateTime'),
      parameters: {'dateTime': date.dateTime.toIso8601String()},
    );
  }

  Future<void> setLinksByDate(
    Date date,
    List<CollectionLink> links,
  ) async {
    if (await existsDate(date)) {
      if (links.isEmpty) return deleteByDate(date);

      await _connection.execute(
        Sql.named(
            'UPDATE $_tableName SET items=@items WHERE dateTime=@dateTime'),
        parameters: {
          'dateTime': date.dateTime.toIso8601String(),
          'items': jsonEncode(links.map((e) => e.toJson()).toList()),
        },
      );
    } else {
      await _connection.execute(
        Sql.named(
            'INSERT INTO $_tableName (dateTime, items) VALUES (@dateTime, @items)'),
        parameters: {
          'dateTime': date.dateTime.toIso8601String(),
          'items': jsonEncode(links.map((e) => e.toJson()).toList()),
        },
      );
    }
  }
}
