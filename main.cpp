#include <QFontDatabase>
#include <QQmlApplicationEngine>
#include <QScreen>
#include "qtquickcontrolsapplication.h"

#include "src/api/AnimeRisutoApi.h"
#include "src/api/EnumEndpoint.h"
#include "src/api/SingletonNetworkAccessManager.h"
#include "src/utils/singleton.h"
#include "src/utils/utils.h"
#include "src/utils/uihelper.h"
#include "QtAdMob/QtAdMobHelper.h"


#define AnimeRisutoAPIInstance Singleton<AnimeRisutoAPI>::instance()

void messageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg){
    QByteArray localMsg = msg.toLocal8Bit();
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "Debug: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtWarningMsg:
        fprintf(stderr, "Warning: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtCriticalMsg:
        fprintf(stderr, "Critical: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtFatalMsg:
        fprintf(stderr, "Fatal: %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        abort();
    }
}

void setupOrganization(QApplication * app){
    app->setOrganizationName("AnimeRisuto");
    app->setOrganizationDomain("animezensekai.com");
    app->setApplicationVersion("1.0.0");
    app->setApplicationName("AnimeZenSekai - Cross Platform Application");
    qputenv("QT_LOGGING_RULES", "qt.network.ssl.warning=false");
}

void declareQML() {
    EnumEndpoint::declareQML();
}

void loadAds(QQmlApplicationEngine * engine){
    QtAdMobHelper * helper = new QtAdMobHelper(engine);

    helper->loadBannerAd();
    helper->loadInterstitial();
}

void displayDiagnostics(){
    qDebug() << "SslSupport: " << QSslSocket::supportsSsl();
    qDebug() << "SslLibraryBuildVersion: " << QSslSocket::sslLibraryBuildVersionString();
    qDebug() << "SslLibraryRuntimeVersion: " << QSslSocket::sslLibraryVersionString();
}

int main(int argc, char *argv[]) {
    qInstallMessageHandler(messageOutput);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QtQuickControlsApplication app(argc,argv);

    displayDiagnostics();

    setupOrganization(&app);
    declareQML();

    QQmlApplicationEngine engine;
    SingletonNetworkAccessManager singletonAccessManager;

    QQmlComponent component(&engine, "qrc:/main.qml");
    singletonAccessManager.setMainComponent(&component);
    singletonAccessManager.setQmlEngine(&engine);

    UIHelper * uiHelper = new UIHelper(&app);

    engine.rootContext()->setContextProperty("AnimeRisutoApi", &singletonAccessManager );
    engine.rootContext()->setContextProperty("UIHelper", uiHelper);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    loadAds(&engine);

    return app.exec();
}
