plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "://company.com"
    compileSdk = flutter.compileSdkVersion
    
    // ⚡ تم توحيد إصدار الـ NDK المستقر الخاص بجهاز الماك بوك الشخصي حقك لإنهاء التعليق
    ndkVersion = "26.3.11579264"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "://company.com"
        minSdk = flutter.minSdkVersion
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

// 🛡️ دالة خارقة تمنع حزم Firebase من فرض فحص الـ NDK وتجبر الأندرويد على التجميع الفوري
configurations.all {
    resolutionStrategy.eachDependency {
        if (requested.group == "com.android.ndk" || requested.name.contains("ndk")) {
            useVersion("26.3.11579264")
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics")
}
