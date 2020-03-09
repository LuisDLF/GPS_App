package com.elsheimus.gps_app;

import android.Manifest;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;

import android.location.Location;
import android.location.LocationManager;

import android.os.Build;
import android.telephony.SmsManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.work.Worker;
import androidx.work.WorkerParameters;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


public class PeriodicSendGeo extends Worker {

    private OkHttpClient client;
    private Context context;
    private Date nowTime;
    private LocationManager manager;
    static final String TAG = "PERIODICSENDGEO";

    public PeriodicSendGeo(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        this.context = context;
    }

    private Location getLocation() {
        if (ActivityCompat.checkSelfPermission(this.context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                || ActivityCompat.checkSelfPermission(this.context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return null;
        } else {
            if (this.manager == null) {
                this.manager = (LocationManager) this.context.getSystemService(Context.LOCATION_SERVICE);
            }
            List<String> providers = this.manager.getProviders(true);
            Location bestLocation = null, locationTmp = null;
            for (String provider : providers) {
                locationTmp = this.manager.getLastKnownLocation(provider);
                if (locationTmp == null) continue;

                if (bestLocation == null || locationTmp.getAccuracy() < bestLocation.getAccuracy()) {
                    bestLocation = locationTmp;
                }
            }

            return bestLocation;
        }
    }

    private void post() throws IOException {
        this.client = new OkHttpClient();
        Location location = this.getLocation();
        String id = null;

        try {
            SharedPreferences prefs = this.context.getSharedPreferences("FlutterSharedPreferences",
                    Context.MODE_PRIVATE);
            id = String.valueOf(prefs.getLong("flutter.Id_Disp", 0));
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (location != null && id != null) {
            RequestBody body = new FormBody.Builder()
                    .add("Id_Disp", id)
                    .add("Lat", String.valueOf(location.getLatitude()))
                    .add("Lon", String.valueOf(location.getLongitude()))
                    .build();

            Request request = new Request.Builder()
                    .url("http://sotepsa.com/services/Gps_Upload.php")
                    .post(body)
                    .build();

            client.newCall(request).execute();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void post2() throws IOException, JSONException {
        this.client = new OkHttpClient();
        Location location = this.getLocation();
         Timestamp timestamp = new Timestamp(System.currentTimeMillis());

        String id = null;

        try {
            SharedPreferences prefs = this.context.getSharedPreferences("FlutterSharedPreferences",
                    Context.MODE_PRIVATE);
            id = String.valueOf(prefs.getLong("flutter.Id_Disp", 0));
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (location != null && id != null) {
            RequestBody body = new FormBody.Builder()
                    .add("Id_Disp", id)
                    .add("Lat", String.valueOf(location.getLatitude()))
                    .add("Lon", String.valueOf(location.getLongitude()))
                    .build();

            Request request = new Request.Builder()
                    .url("http://sotepsa.com/services/Alarma_read.php")
                    .post(body)
                    .build();

            Response response = client.newCall(request).execute();
            String json = Objects.requireNonNull(response.body()).string();
            Log.i("WORKER", json);

            SmsManager smsManager = SmsManager.getDefault();
            JSONArray array = new JSONArray(json);
            JSONObject object = null;
            String data = null;

            for (int i = 0; i < array.length(); i++) {
                object = array.getJSONObject(i);
                Log.i("WORKER", object.toString());
                data = "Nombre de usuario: " + object.getString("Nombre");
                data += ", Nombre de la tarea: " + object.getString("Nombre_Tarea");
                data += "y Distancia: " + object.getString("Distancia") + " M";

                smsManager.sendTextMessage(object.getString("Tel"), null,
                        data, null, null);
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @NonNull
    @Override
    public Result doWork() {
        Log.i("WORKER", "INIT");

        while (true) {
            try {
                this.nowTime = new Date();
                Log.i("WORKER", "NOW: " + this.nowTime.toString());

                this.post();
                Thread.sleep(4000);

                this.post2();
                Thread.sleep(4000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (NullPointerException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }
}
