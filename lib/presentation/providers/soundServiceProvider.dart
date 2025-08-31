import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/audioplayers.dart';

final soundServiceProvider = Provider<SoundService>((ref) => SoundService());
