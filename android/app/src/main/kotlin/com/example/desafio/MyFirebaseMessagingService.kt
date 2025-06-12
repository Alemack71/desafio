package com.example.desafio

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.util.Log

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d("MyFirebaseMessagingService", "Message received from: ${remoteMessage.from}")

        remoteMessage.notification?.let {
            Log.d("MyFirebaseMessagingService", "Notification Title: ${it.title}")
            Log.d("MyFirebaseMessagingService", "Notification Body: ${it.body}")
        }

        remoteMessage.data.isNotEmpty().let {
            Log.d("MyFirebaseMessagingService", "Data Payload: ${remoteMessage.data}")
        }
    }

    override fun onNewToken(token: String) {
        Log.d("MyFirebaseMessagingService", "Refreshed token: $token")
        // Aqui você pode enviar o token pro seu servidor, se quiser
        // sendRegistrationToServer(token)
    }
}