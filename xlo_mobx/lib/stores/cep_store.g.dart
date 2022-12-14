// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cep_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CepStore on _CepStore, Store {
  Computed<String>? _$clearCepComputed;

  @override
  String get clearCep => (_$clearCepComputed ??=
          Computed<String>(() => super.clearCep, name: '_CepStore.clearCep'))
      .value;

  late final _$cepAtom = Atom(name: '_CepStore.cep', context: context);

  @override
  String get cep {
    _$cepAtom.reportRead();
    return super.cep;
  }

  @override
  set cep(String value) {
    _$cepAtom.reportWrite(value, super.cep, () {
      super.cep = value;
    });
  }

  late final _$addressAtom = Atom(name: '_CepStore.address', context: context);

  @override
  Address? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(Address? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$errorAtom = Atom(name: '_CepStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadingAtom = Atom(name: '_CepStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$_searchCepAsyncAction =
      AsyncAction('_CepStore._searchCep', context: context);

  @override
  Future<void> _searchCep() {
    return _$_searchCepAsyncAction.run(() => super._searchCep());
  }

  late final _$_CepStoreActionController =
      ActionController(name: '_CepStore', context: context);

  @override
  void setCep(String value) {
    final _$actionInfo =
        _$_CepStoreActionController.startAction(name: '_CepStore.setCep');
    try {
      return super.setCep(value);
    } finally {
      _$_CepStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _reset() {
    final _$actionInfo =
        _$_CepStoreActionController.startAction(name: '_CepStore._reset');
    try {
      return super._reset();
    } finally {
      _$_CepStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cep: ${cep},
address: ${address},
error: ${error},
loading: ${loading},
clearCep: ${clearCep}
    ''';
  }
}
