import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/credentials.dart';
import 'package:irmamobile/src/screens/wallet/models/wallet_events.dart';
import 'package:irmamobile/src/screens/wallet/models/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  StreamSubscription<Credentials> credentialStreamSubscription;

  @override
  final WalletState initialState;

  WalletBloc() : initialState = WalletState() {
    credentialStreamSubscription = IrmaRepository.get().getCredentials().listen((allCredentials) {
      final credentials = allCredentials.rebuiltRemoveWhere(_isMyIRMACredential);
      String newCardHash;
      final newKeyIndexes = _getIndexesOfNewKeys(currentState.credentials, credentials);
      if (newKeyIndexes.isNotEmpty) {
        newCardHash = credentials.values.elementAt(newKeyIndexes.first).hash;
      }

      dispatch(CredentialUpdate(credentials, newCardHash, showNewCardAnimation: newCardHash != null));
    });
  }

  List<int> _getIndexesOfNewKeys(Credentials previousCredentials, Credentials newCredentials) {
    final List<int> newKeyIndexes = <int>[];
    if (previousCredentials == null || newCredentials == null) {
      return <int>[];
    }

    for (int i = 0; i < newCredentials.keys.length; i++) {
      if (!previousCredentials.containsKey(newCredentials.keys.elementAt(i))) {
        newKeyIndexes.add(i);
      }
    }

    return newKeyIndexes;
  }

  bool _isMyIRMACredential(_, Credential credential) {
    return ["pbdf.sidn-pbdf.irma", "pbdf.pbdf.mijnirma"].contains(credential.info.credentialType.fullId);
  }

  @override
  void dispose() {
    credentialStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is CredentialUpdate) {
      yield currentState.copyWith(
          credentials: event.credentials,
          newCardHash: event.newCardHash,
          showNewCardAnimation: event.showNewCardAnimation);
    }

    if (event is NewCardAnitmationShown) {
      yield currentState.copyWith(showNewCardAnimation: false);
    }
  }
}
