import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.zeeppay"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.zeeppay"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 22
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
     
    }



   signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"]?.toString() ?: error("Missing keyAlias in key.properties")
        keyPassword = keystoreProperties["keyPassword"]?.toString() ?: error("Missing keyPassword in key.properties")
        storeFile = keystoreProperties["storeFile"]?.toString()?.let { file(it) }
            ?: error("Missing storeFile in key.properties")
        storePassword = keystoreProperties["storePassword"]?.toString() ?: error("Missing storePassword in key.properties")
    }
}



   buildTypes {
    getByName("release") {
        isMinifyEnabled = false
        isShrinkResources = false
        signingConfig = signingConfigs.getByName("release")
    }
    getByName("debug") {
        isDebuggable = true
        signingConfig = signingConfigs.getByName("release")
    }
}

    
    flavorDimensions += "product"
    productFlavors {
        create("devee") {
            dimension = "product"
            applicationIdSuffix = ".devee"
            versionNameSuffix = "-devee"
        }
        create("yano") {
            dimension = "product"
            applicationIdSuffix = ".yano"
            versionNameSuffix = "-yano"
        }
        create("bandcard") {
            dimension = "product"
            applicationIdSuffix = ".bandcard"
            versionNameSuffix = "-bandcard"
        }
        create("jbcard") {
            dimension = "product"
            applicationIdSuffix = ".jbcard"
            versionNameSuffix = "-jbcard"
        }
        create("taustepay") {
            dimension = "product"
            applicationIdSuffix = ".taustepay"
            versionNameSuffix = "-taustepay"
        }
        create("queirozpremium") {
            dimension = "product"
            applicationIdSuffix = ".queirozpremium"
            versionNameSuffix = "-queirozpremium"
        }
        create("tridicopay") {
            dimension = "product"
            applicationIdSuffix = ".tridicopay"
            versionNameSuffix = "-tridicopay"
        }
    }
}
dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.aar"))))
}

flutter {
    source = "../.."
}
