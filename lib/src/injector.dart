import 'package:auto_injector/auto_injector.dart';

import 'modules/core/services/local_storage/local_storage_service.dart';
import 'modules/freezer/data/repositories/freezer_repository.dart';
import 'modules/freezer/data/repositories/meat_repository.dart';
import 'modules/freezer/domain/viewmodels/freezer_view_model.dart';
import 'modules/freezer/domain/viewmodels/meat_view_model.dart';

final injector = AutoInjector();

void initInjector() {
  injector.addLazySingleton<LocalStorageService>(() {
    return RemoteLocalStorageService();
  });

  injector.add<FreezerRepository>(
    () => RemoteFreezerRepository(injector<LocalStorageService>()),
  );
  injector.add<MeatRepository>(
    () => RemoteMeatRepository(injector<LocalStorageService>()),
  );

  injector.addLazySingleton<MeatViewModel>(() => MeatViewModel(
        injector<MeatRepository>(),
      ));

  injector.addLazySingleton<FreezerViewModel>(() => FreezerViewModel(
        injector<FreezerRepository>(),
      ));

  injector.commit();
}
