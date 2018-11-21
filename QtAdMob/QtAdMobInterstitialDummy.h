#ifndef QTADMOBINTERSTITIALDUMMY_H
#define QTADMOBINTERSTITIALDUMMY_H

#include "IQtAdMobInterstitial.h"

class QtAdMobInterstitialDummy : public IQtAdMobInterstitial
{
public:
    QtAdMobInterstitialDummy();
    virtual ~QtAdMobInterstitialDummy();

    // Initalize MobileAds
    virtual void setAppId(const QString& appId);

    /*
     * Setup unit id and start caching interstitial for that id
     */
    virtual void setUnitId(const QString& unitId);

    /*
     * Retrive interstitial id
     */
    virtual const QString& unitId() const;

    /*
     * If interstitial has already loaded it will be presented, another
     * case it will be showed after loading finished
     */
    virtual void setVisible(bool isVisible);

    /*
     * Is interstitial visible
     */
    virtual bool visible();

    /*
     * Check if interstitial loaded
     */
    virtual bool isLoaded();

    /*
     * Add test device identifier. Device identifier you can find in output log, on Android
     * it will looks like 'Ads : Use AdRequest.Builder.addTestDevice("device id") to get test ads on this device.'
     * iOS: // TODO:
     */
    virtual void addTestDevice(const QString& hashedDeviceId);

private:
    QString m_UnitId;
    QString m_AppId;
};

#endif // QTADMOBINTERSTITIALDUMMY_H
