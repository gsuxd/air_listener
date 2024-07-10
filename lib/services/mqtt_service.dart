import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MqttServerClient client;

  MQTTService(this.client) {
    client.setProtocolV311();
    final connMess = MqttConnectMessage()
        .withClientIdentifier('TV')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    debugPrint('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;
  }

  Future<void> connect({required String user, required String password}) async {
    await client.connect(user, password);
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('EXAMPLE::Mosquitto client connected');
    } else {
      debugPrint(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      return;
    }
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
}
