package com.example.ad_catalog;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkRequest;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
    cm.registerNetworkCallback(new NetworkRequest.Builder().build(), new ConnectivityManager.NetworkCallback() {
      MethodChannel mc = new MethodChannel(getFlutterView(), "com.example.ad_catalog/internet");
      {
        mc.setMethodCallHandler(
          new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
              if(call.method.equals("obter")){
                ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
              
                if(cm != null && cm.getActiveNetworkInfo() != null && cm.getActiveNetworkInfo().isConnectedOrConnecting()){
                  enviarConectado();
                }
                else{
                  enviarDesconectado();
                }
              }
            }
          }
        );
      }

      private void enviarConectado(){
        mc.invokeMethod("atualizar", "conectado");
      }
      private void enviarDesconectado(){
        mc.invokeMethod("atualizar", "desconectado");
      }

      @Override
      public void onAvailable(Network network) {
        enviarConectado();
      }

      @Override
      public void onLost(Network network){
        enviarDesconectado();
      }

      @Override
      public void onUnavailable(){
        enviarDesconectado();
      }
    });


  }
}
