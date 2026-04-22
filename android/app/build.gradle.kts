import java.util.Properties
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    

}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

val releaseTasksRequested = gradle.startParameter.taskNames.any {
    it.contains("release", ignoreCase = true)
}

val hasEnvSigningConfig = listOf(
    "KEY_ALIAS",
    "KEY_PASSWORD",
    "KEYSTORE_PATH",
    "KEYSTORE_PASSWORD",
).all { !System.getenv(it).isNullOrBlank() }

val hasFileSigningConfig = keystorePropertiesFile.exists() &&
    !keystoreProperties["keyAlias"].toString().isBlank() &&
    !keystoreProperties["keyPassword"].toString().isBlank() &&
    !keystoreProperties["storeFile"].toString().isBlank() &&
    !keystoreProperties["storePassword"].toString().isBlank()

val hasReleaseSigningConfig = hasEnvSigningConfig || hasFileSigningConfig

if (releaseTasksRequested && !hasReleaseSigningConfig) {
    throw GradleException(
        "Missing release signing configuration. Copy android/key.properties.template to android/key.properties and fill it in, or set KEY_ALIAS, KEY_PASSWORD, KEYSTORE_PATH, and KEYSTORE_PASSWORD.",
    )
}

android {
    namespace = "com.moveit.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Application ID for MoveIT app on Play Store
        applicationId = "com.moveit.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasEnvSigningConfig) {
                keyAlias = System.getenv("KEY_ALIAS") ?: ""
                keyPassword = System.getenv("KEY_PASSWORD") ?: ""
                storeFile = System.getenv("KEYSTORE_PATH")?.let { file(it) }
                storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            } else if (hasFileSigningConfig) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
