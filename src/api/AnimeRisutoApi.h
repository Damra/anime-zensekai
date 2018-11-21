#ifndef ANIMERISUTOAPI_H
#define ANIMERISUTOAPI_H
#include <QObject>
#include <QtQml>
#include <typeinfo>

#include <QMetaObject>
#include <QJSValue>
#include "src/api/EnumEndpoint.h"
#include "src/utils/singleton.h"

class AnimeRisutoApi : public QObject
{
    Q_OBJECT
    //  Q_PROPERTY(QVariantMap result READ result WRITE setResult NOTIFY resultChanged)

signals:
    void finished();
    void error(QString err);

    void resultChanged();
    void success();
    void badRequest();
    void unAuthorized();

private:
    QNetworkRequest * mNetworkRequest;
    QNetworkAccessManager * mNetworkManager;
    QMap<EnumEndpoint::ApiEndpoint,QString> * mEndpointMap;

    static AnimeRisutoApi* createInstance();
    AnimeRisutoApi();

public:
    static AnimeRisutoApi *instance();
    ~AnimeRisutoApi();

    QString userToken;

    QString BASE_URL = "http://animerisuto-we-ds.azurewebsites.net";
    QJsonObject createPostData(QVariantMap fields);
    QString createGetParam(QVariantMap fields);
    QNetworkRequest createRequest(QUrl url);
    QMap<EnumEndpoint::ApiEndpoint, QString> * loadAndGetEndpoints();
    EnumEndpoint::ApiEndpoint getEndpoint(QString enumEndpoint);
    QString getEndpoint(EnumEndpoint::ApiEndpoint enumApiEndpoint);

    void logQVariantMap(QVariantMap fields){
        QMapIterator<QString, QVariant> i(fields);
        QString logString = "";
        QString dataString = "";
        QList<QString> * list = new QList<QString>();
        while (i.hasNext()) {
            i.next();
            list->append("{"+i.key()+":" +i.value().toString()+ "}");
        }

        logString.append("\nLog: [");
        logString.append(list->join(",\n"));
        logString.append("]\n");

        qDebug() << logString << "\n";

    }

    //Method for other url request
    Q_INVOKABLE QNetworkReply *get(QString url, QVariantMap fields);

    //Method API /api/account/register
    Q_INVOKABLE QNetworkReply *accountRegister(QVariantMap fields);

    //Method API /api/token
    Q_INVOKABLE QNetworkReply *accountLogin(QVariantMap fields);

    //Method API /api/anime/all
    Q_INVOKABLE QNetworkReply *animeListAll(QVariantMap fields);

    //Method API /api/anime/{uniqueId}
    Q_INVOKABLE QNetworkReply *animeDetail(QString uniqueId);

};



#endif // ANIMERISUTOAPI_H
