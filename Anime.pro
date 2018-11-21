TEMPLATE = app
TARGET = AnimeRisuto

QT += network quick widgets gui

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS \
    QTADMOB_QML


# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
QT_MESSAGE_PATTERN="%{message}"

SOURCES += \
        main.cpp \
        src/utils/utils.cpp \
        src/api/SingletonNetworkAccessManager.cpp \
        src/api/AnimeRisutoApi.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =



# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


# Default rules for deployment.
include(deployment.pri)
HEADERS += \
    qtquickcontrolsapplication.h \
    src/utils/utils.h \
    src/api/EnumEndpoint.h \
    src/utils/call_once.h \
    src/utils/singleton.h \
    src/api/SingletonNetworkAccessManager.h \
    src/api/AnimeRisutoApi.h \
    src/api/model/AnimeListItem.h \
    src/api/model/Paging.h \
    src/utils/uihelper.h



DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

include(QtAdMob/QtAdMob.pri)
ios {
    include(Firebase/Firebase.pri)
}
QTADMOB_LIB_DIR = $$PWD/QtAdMob



android {
    QT += androidextras gui-private
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    DISTFILES += \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradle/wrapper/gradle-wrapper.jar \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradlew \
        $$ANDROID_PACKAGE_SOURCE_DIR/src/main/res/values/libs.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/build.gradle \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradle/wrapper/gradle-wrapper.properties \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradlew.bat \
        $$ANDROID_PACKAGE_SOURCE_DIR/AndroidManifest.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/project.properties \
        $$ANDROID_PACKAGE_SOURCE_DIR/src/main/com/animerisuto/qtadmob/QtAdMobActivity.java


    contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
        ANDROID_EXTRA_LIBS = \
            #$$PWD/android-sources/jni/armeabi-v7a/libcrashlytics.so \
            #$$PWD/android-sources/jni/armeabi-v7a/libcrashlytics-envelope.so
    }
}


# copydata.commands = $(COPY_DIR) $$shell_path($$PWD/android) $$shell_path($$DESTDIR/android)


