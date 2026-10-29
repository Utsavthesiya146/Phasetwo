import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "ca.phasetwo.phasetwo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Specify application ID for PhaseTwo production release
        applicationId = "ca.phasetwo.phasetwo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val keyAliasProp = keystoreProperties.getProperty("keyAlias")
                val keyPasswordProp = keystoreProperties.getProperty("keyPassword")
                val storeFileProp = keystoreProperties.getProperty("storeFile")
                val storePasswordProp = keystoreProperties.getProperty("storePassword")
                if (keyAliasProp.isNullOrBlank() || keyPasswordProp.isNullOrBlank() || storeFileProp.isNullOrBlank() || storePasswordProp.isNullOrBlank()) {
                    throw GradleException("Production release signing error: 'key.properties' is missing required fields (storeFile, storePassword, keyAlias, keyPassword).")
                }
                val keystoreFile = rootProject.file(storeFileProp)
                if (!keystoreFile.exists()) {
                    throw GradleException("Production release signing error: Upload keystore file '${keystoreFile.absolutePath}' not found.")
                }
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp
                storeFile = keystoreFile
                storePassword = storePasswordProp
            }
        }
    }

    buildTypes {
        release {
            if (!keystorePropertiesFile.exists()) {
                throw GradleException("Production release signing error: 'android/key.properties' not found. Debug-signing fallback has been removed. You must configure secure upload signing credentials for release builds.")
            }
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
