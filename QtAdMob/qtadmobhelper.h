#ifndef QTADMOBHELPER_H
#define QTADMOBHELPER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QScreen>

#include "QtAdMobBanner.h"
#include "QtAdMobInterstitial.h"

const char * ADMOB_APP_ID = "ca-app-pub-1308696798492401~4634739307";
const char * ADMOB_INTERSTITIAL_UNIT_ID = "ca-app-pub-1308696798492401/4705648228";
const char * ADMOB_BANNER_UNIT_ID = "ca-app-pub-1308696798492401/6501412798";
const char * TEST_DEVICE_HASH = "12BF9F8D0CF8B253CD8656125F2F67B2";

class QtAdMobHelper : public QObject {
public:
    QQmlApplicationEngine * engine;

    ~QtAdMobHelper(){ }
    QtAdMobHelper(QQmlApplicationEngine *engine) : QObject() {
        this->engine = engine;
    };

    void loadInterstitial(){
        IQtAdMobInterstitial* interstitial = CreateQtAdMobInterstitial();
        if(interstitial == nullptr){
            return;
        }

        interstitial->SetAppId(QString(ADMOB_APP_ID));
        interstitial->LoadWithUnitId(QString(ADMOB_INTERSTITIAL_UNIT_ID));
        interstitial->AddTestDevice(QString(TEST_DEVICE_HASH));
        interstitial->Show();
    }

    void loadBannerAd() {
        IQtAdMobBanner * banner = CreateQtAdMobBanner();
        if(banner == nullptr){
            return;
        }

        QScreen* screen = QGuiApplication::primaryScreen();
        QObject* topLevel;

        topLevel = engine->rootObjects().value(0);

        QObject* adHolder = topLevel->findChild<QObject*>("adHolder");
        IQtAdMobBanner* m_Banner;


        banner->Initialize();
        banner->SetAppId(QString(ADMOB_APP_ID));
        banner->SetUnitId(QString(ADMOB_BANNER_UNIT_ID));

        if(banner->GetSizeInPixels().height()!=0){
            banner->SetSize(IQtAdMobBanner::Banner);
            int frameY = (screen->availableSize().height() - banner->GetSizeInPixels().height());
            banner->SetPosition(QPoint(0.0f,frameY));

            if(adHolder){
                adHolder->setProperty("height", banner->GetSizeInPixels().height());
            }

        }else{

            if(adHolder){
                // adHolder->setProperty("height",screen->availableSize().height() * .1);
            }

            banner->SetSize(IQtAdMobBanner::SmartBanner);
        }

        banner->Show();
    }

};
#if (defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR))

#endif // PLATFORM
#endif // QTADMOBHELPER_H
