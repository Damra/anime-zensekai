#ifndef SINGLETONNETWORKACCESSMANAGER_H
#define SINGLETONNETWORKACCESSMANAGER_H

#include <QObject>
#include <QNetworkReply>
#include <QQmlComponent>
#include <QQmlApplicationEngine>
#include "AnimeRisutoApi.h"

class SingletonNetworkAccessManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool busy READ busy WRITE setBusy NOTIFY busyChanged)
public slots:
    void slotError(QNetworkReply::NetworkError error) {
        qDebug("SLOT ERROR");
    }
signals:
    void busyChanged();
private:
    bool mBusy;
    QQmlComponent * mainComponent;
    QQmlApplicationEngine * engine;
    void replyCallback( QNetworkReply * reply, QJSValue * jsCallback );

    QString getUserTokenFromQML() {
        QVariant returnedValue;
        QObject *object = mainComponent->create();

        QMetaObject::invokeMethod(object, "getUserToken", Q_RETURN_ARG(QVariant, returnedValue));
        return returnedValue.toString();
    }

public:

    void setQmlEngine(QQmlApplicationEngine * engine){
        this->engine = engine;
    }

    void setMainComponent(QQmlComponent * mainComponent) {
        this->mainComponent = mainComponent;
    }

    bool busy() const {
        return mBusy;
    }

    void setBusy(const bool &busy) {
        if (busy != mBusy) {
            mBusy = busy;
            emit busyChanged();
        }
    }

    // methods for singleton instance of animerisuto qml callback
    Q_INVOKABLE void setUserTokenFromQML(QVariant userToken){
        AnimeRisutoApi::instance()->userToken = userToken.toString();
    }

    Q_INVOKABLE QVariant  getEndpointPathByType(EnumEndpoint::ApiEndpoint enumEndpoint){
        const QString path = AnimeRisutoApi::instance()->getEndpoint(enumEndpoint);
        return QVariant(path);
    }

    Q_INVOKABLE int getEndpointTypeByPath(QString enumEndpoint){
        return AnimeRisutoApi::instance()->getEndpoint(enumEndpoint);
    }

    Q_INVOKABLE int getEndpointTypeByPath(QString enumEndpoint, QString param){
        return AnimeRisutoApi::instance()->getEndpoint(enumEndpoint.replace(param, "detail"));
    }

    Q_INVOKABLE QVariantMap loadAndGetEndpoints(){
        return  QVariantMap();
    }

    Q_INVOKABLE void get(QString url, QVariantMap postData, QJSValue jsCallback) ;

    Q_INVOKABLE void accountLogin(QVariantMap postData, QJSValue  jsCallback) ;

    Q_INVOKABLE void accountRegister(QVariantMap postData, QJSValue jsCallback) ;

    Q_INVOKABLE void animeListAll(QVariantMap postData, QJSValue jsCallback) ;

    Q_INVOKABLE void animeDetail(QString uniqueId, QJSValue jsCallback) ;



};

#endif // SINGLETONNETWORKACCESSMANAGER_H
