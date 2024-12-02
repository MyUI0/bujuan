import '../../common/music_api.dart';
import '../../common/music_interceptors.dart';
import '../api.dart';

mixin AlbumApi {
  /// 最新专辑
  ///
  /// [limit] （可选，默认30）
  /// [offset]（可选，默认0）
  /// [area] 地区 ALL:全部,ZH:华语,EA:欧美,KR:韩国,JP:日本（可选，默认为 ALL）
  /// [total] 是否请求全部（可选，默认为 total）
  void newAlbum({
    int limit = 30,
    int offset = 0,
    String area = 'ALL',
    bool total = true,
  }) {
    final data = {
      'limit': limit,
      'offset': offset,
      'area': area,
      'total': total,
    };
    BujuanMusicManager().post(url: Api.newAlbum, options: createOption(), data: data);
  }

  /// 专辑内容
  ///
  /// [id] 专辑ID（必选）
  void albumInfo({required int id}) {
    BujuanMusicManager().post(url: '${Api.albumInfo}/$id', options: createOption());
  }

  /// 歌手专辑
  ///
  /// [id] 歌手ID（必选）
  /// [limit] （可选，默认30）
  /// [offset]（可选，默认0）
  /// [total] 是否请求全部（可选，默认为 total）
  void artistAlbum({
    required int id,
    int limit = 30,
    int offset = 0,
    bool total = true,
  }) {
    final data = {
      'limit': limit,
      'offset': offset,
      'total': total,
    };
    BujuanMusicManager().post(url: '${Api.albumInfo}/$id', options: createOption(), data: data);
  }
}
