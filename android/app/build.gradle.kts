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
        minSdk = 26
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

    
    flavorDimensions += listOf("device", "brand")
    productFlavors {
        // Dimensão de dispositivo (GPOS)
        create("gpos760") {
            dimension = "device"
        }
        create("gpos780") {
            dimension = "device"
        }

        // Dimensão de marca
        create("devee") {
            dimension = "brand"
            applicationIdSuffix = ".devee"
            manifestPlaceholders["appName"] = "Devee"
        }
        create("yano") {
            dimension = "brand"
            applicationIdSuffix = ".yano"
            manifestPlaceholders["appName"] = "Yano"
        }
        create("bandcard") {
            dimension = "brand"
            applicationIdSuffix = ".bandcard"
            manifestPlaceholders["appName"] = "Bandcard"
        }
        create("jbcard") {
            dimension = "brand"
            applicationIdSuffix = ".jbcard"
            manifestPlaceholders["appName"] = "JBCard"
        }
        create("taustepay") {
            dimension = "brand"
            applicationIdSuffix = ".taustepay"
            manifestPlaceholders["appName"] = "Taustepay"
        }
        create("queirozpremium") {
            dimension = "brand"
            applicationIdSuffix = ".queirozpremium"
            manifestPlaceholders["appName"] = "Queiroz Premium"
        }
        create("tridico") {
            dimension = "brand"
            applicationIdSuffix = ".tridicopay"
            manifestPlaceholders["appName"] = "Tridicopay"
        }
        create("sindbank") {
            dimension = "brand"
            applicationIdSuffix = ".sindbank"
            manifestPlaceholders["appName"] = "Sindbank"
        }
    }

    // Adicionar dependências de libs por device após as variants serem criadas
    applicationVariants.all {
        val variantName = name
        when {
            variantName.contains("gpos760", ignoreCase = true) -> {
                project.dependencies.add("${variantName}Implementation", fileTree(mapOf("dir" to "libs/760", "include" to listOf("*.aar"))))
            }
            variantName.contains("gpos780", ignoreCase = true) -> {
                project.dependencies.add("${variantName}Implementation", fileTree(mapOf("dir" to "libs/780", "include" to listOf("*.aar"))))
            }
        }
    }
}

dependencies {
}

flutter {
    source = "../.."
}
