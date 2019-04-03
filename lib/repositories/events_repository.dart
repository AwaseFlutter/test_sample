import 'dart:async';
import 'package:awase_app/entities/data_with_cursor.dart';
import 'package:awase_app/entities/event.dart';

class EventsRepository {
  Future<DataWithCursor<Event>> index({ String cursor }) async {
    final json = {
      'cursor': 'ae0a7968-3841-42aa-891d-bf1ef685aaa8',
      'data': [
        {
          'id': '960c2eea-3c4b-4149-9a52-062c7ee7d8bd',
          'title': '森林浴に行ってみよう！',
          'description': '都会を離れて、森林浴に行ってみませんか？',
          'image_url': 'https://www.pakutaso.com/shared/img/thumb/PAK86_komorebitohizashi_TP_V4.jpg',
        },
        {
          'id': '8d3ce015-89b9-4f14-a893-227efd500dec',
          'title': '東京 夜景スポット',
          'description': '都心の摩天楼から浅草を一望\n幻想的な夜景がご覧いただけます。',
          'image_url': 'https://www.pakutaso.com/shared/img/thumb/KZKHDSC00280-Edit_TP_V4.jpg',
        },
      ],
    };

    return DataWithCursor.fromJson<Event>(json, (attrs) => Event.fromJson(attrs));
  }

  Future<Event> show(String id) async {
    final list = await index();
    return list.data.firstWhere((e) => e.id == id);
  }
}
