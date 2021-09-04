import 'dart:async';

import 'package:ad_catalog/blocs/loja_bloc.dart';
import 'package:ad_catalog/blocs/processamento_bloc.dart';
import 'package:ad_catalog/models/loja.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc extends BlocBase {
  final _carregarUsuarioController = BehaviorSubject<String>();
  final _processamentoBloc = BlocProvider.getBloc<ProcessamentoBloc>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _firebaseUser;
  Loja _loja;

  Stream get acompanharCarregamento => _carregarUsuarioController.stream;
  Loja get obterLoja {
    return _loja != null ? _loja : Loja(vazia: true);
  }
  set atualizarLoja(novaLoja) {
    _loja = novaLoja;
  }

  UsuarioBloc() {
    print('Instancia de UsuarioBloc criada');
  }

  void carregarUsuario() {
    _carregarUsuarioController.add('carregando');

    _auth.currentUser().then((usuario) {
      if (usuario != null) {
        //print('USUARIO BLOC CARREGAMENTO: ${usuario.uid}');
        _firebaseUser = usuario;
        _receberLoja(usuario.uid, _concluirCarregamento);
      } else {
        //print('USUARIO BLOC CARREGAMENTO: Nenhum usuario logado');
        _concluirCarregamento();
      }
    }, onError: (erro) {
      print('Erro no carregamento?');
      _concluirCarregamento();
      //print('USUARIO BLOC CARREGAMENTO: $erro');
    }).whenComplete(() {
      //print('USUARIO BLOC CARREGAMENTO: Completo');
    });
  }

  void logar(email, senha) async {
    _iniciarProcessamento();
    try{
      _firebaseUser = await _auth.signInWithEmailAndPassword(email: email, password: senha);
        _receberLoja(_firebaseUser.uid, _concluirProcessamento);
    } catch( erro){
      _concluirComErros(erro);
    } 
  
  }

  void _receberLoja(String id, Function concluir) {
    final bloc = BlocProvider.getBloc<LojaBloc>();
    final escuta = bloc.obterLojaUsuario.listen(null);
    escuta.onData((loja) {
      //print('USUARIO BLOC: Instancia de Loja recebida');
      if (loja.id == id) {
        _loja = loja;
        escuta.cancel();
        concluir();
      }
    });
    bloc.especificarLoja(id, paraUsuario: true);
  }

  void _iniciarProcessamento() {
    _processamentoBloc.atualizarEstadoPara('processando');
  }

  void _concluirCarregamento() {
    _carregarUsuarioController.sink.add('carregou');
  }

  void _concluirComErros(erro) {
    print(erro);
    _processamentoBloc.atualizarEstadoPara('concluidoComErros');
  }

  void _concluirProcessamento() {
    _processamentoBloc.atualizarEstadoPara('concluido');
  }

  void cadastrar(email, senha, demaisDados) {
    _iniciarProcessamento();
    _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: senha,
    )
        .then((usuario) {
      final bloc = BlocProvider.getBloc<LojaBloc>();
      final escuta = bloc.obterLojaUsuario.listen(null);
      escuta.onData((loja) {
        //print('USUARIO BLOC: Instancia de Loja recebida');
        if (loja.id == usuario.uid) {
          _loja = loja;
          escuta.cancel();
          _concluirProcessamento();
        }
      });
      _firebaseUser = usuario;
      bloc.cadastrarLoja(_firebaseUser.uid, demaisDados);
    }).catchError(_concluirComErros);
  }
  /*
  Errors:
  ERROR_INVALID_EMAIL - If the [email] address is malformed.
  ERROR_WRONG_PASSWORD - If the [password] is wrong.
  ERROR_USER_NOT_FOUND - If there is no user corresponding to the given [email] address, or if the user has been deleted.
  ERROR_USER_DISABLED - If the user has been disabled (for example, in the Firebase console)
  ERROR_TOO_MANY_REQUESTS - If there was too many attempts to sign in as this user.
  ERROR_OPERATION_NOT_ALLOWED - Indicates that Email & Password accounts are not enabled.
   */

  void deslogar() async {
    _iniciarProcessamento();
    //print('USUARIO BLOC: Deslogando');
    _auth.signOut().then((resultado) {
      //print('USUARIO BLOC: Deslogou');
      _firebaseUser = null;
      _loja = null;

      //print('USUARIO BLOC: Concluindo processamento');
    }).whenComplete(() {
      _concluirProcessamento();
      //print('USUARIO BLOC: Processamento concluido');
    });
  }

  bool estaLogado() {
    return _firebaseUser != null;
  }

  void recuperarSenha(email) {
    _iniciarProcessamento();
    _auth
        .sendPasswordResetEmail(email: email)
        .then((resultado) => _concluirProcessamento())
        .catchError(_concluirComErros);
  }

  @override
  void dispose() {
    _carregarUsuarioController.close();
    super.dispose();
  }
}
