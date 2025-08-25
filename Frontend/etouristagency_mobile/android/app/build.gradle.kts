plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // DODANO: Google Services plugin
}

android {
    namespace = "com.example.etouristagency_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // DODANO: kompatibilna NDK verzija

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.etouristagency_mobile"
        minSdk = 23  // DODANO: Firebase messaging zahtijeva 23+
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
