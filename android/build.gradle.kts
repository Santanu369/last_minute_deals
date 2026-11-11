import com.android.build.gradle.BaseExtension
import java.io.File

/**
 * Root-level repositories
 */
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/**
 * 🔥 GLOBAL SDK VERSIONS (used by Flutter plugins)
 */
extra.apply {
    set("compileSdkVersion", 36)
    set("targetSdkVersion", 35)
    set("minSdkVersion", 21)
}

/**
 * Google Services plugin (used by :app)
 */
plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
}

/**
 * 🔥 FORCE compileSdk FOR ALL ANDROID MODULES (CRITICAL)
 * This fixes flutter_native_splash and other plugins compiling with android-31
 */
subprojects {
    afterEvaluate {
        extensions.findByName("android")?.let {
            (it as BaseExtension).apply {
                compileSdkVersion(36)
            }
        }
    }
}

/**
 * Unified build directory (Flutter recommended)
 */
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

/**
 * Ensure :app is evaluated first
 */
subprojects {
    evaluationDependsOn(":app")
}

/**
 * Clean task
 */
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
