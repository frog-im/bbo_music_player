/*
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.br.musicplayer.bbo_music_player"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.frogim.tageditor"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
*/
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.br.musicplayer.bbo_music_player"

    // ✅ 정책 충족: API 35 명시
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        // 앱 패키지명
        applicationId = "com.frogim.tageditor"

        // Flutter 템플릿 기본값(대개 23). 바꾸고 싶으면 숫자로 명시 가능.
        minSdk = flutter.minSdkVersion

        // ✅ 정책 충족: target 35 명시
        targetSdk = 35

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // JDK 17 권장 (AGP 8.x, 최신 Flutter와 궁합)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // 데모 키로 서명 중. 실제 배포 전 release 서명 구성 필요.
            signingConfig = signingConfigs.getByName("debug")
            // 필요 시 아래 최적화 활성화
            // isMinifyEnabled = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }
}

flutter {
    source = "../.."
}
