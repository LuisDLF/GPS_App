package com.elsheimus.gps_app;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.work.ExistingWorkPolicy;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i("WORKER", "onCreate");
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                || ActivityCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED
                || ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
                || ActivityCompat.checkSelfPermission(this, Manifest.permission.INTERNET) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{
                            Manifest.permission.INTERNET,
                            Manifest.permission.SEND_SMS,
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION,
                    }, 1212);

        } else {
            Log.i("WORKER", "Iniciando");
            OneTimeWorkRequest request = new OneTimeWorkRequest
                    .Builder(PeriodicSendGeo.class)
                    .addTag(PeriodicSendGeo.TAG)
                    .build();
            WorkManager.getInstance(this.getContext())
                    .enqueueUniqueWork(
                            PeriodicSendGeo.TAG,
                            ExistingWorkPolicy.REPLACE,
                            request
                    );
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case 1212:
                OneTimeWorkRequest request = new OneTimeWorkRequest
                        .Builder(PeriodicSendGeo.class)
                        .addTag(PeriodicSendGeo.TAG)
                        .build();
                WorkManager.getInstance(this.getContext())
                        .enqueueUniqueWork(
                                PeriodicSendGeo.TAG,
                                ExistingWorkPolicy.REPLACE,
                                request
                        );
                break;
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
