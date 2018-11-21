#include "AnimeRisutoApi.h"

#include <QUrlQuery>
#include <QMetaObject>

#include <QtConcurrent/QtConcurrent>

EnumEndpoint::ApiEndpoint AnimeRisutoApi::getEndpoint(QString path) {

    QString enumName = path.replace("/","_").toUpper();
    enumName.remove(0,1);
    // qDebug() << path << "=>" << enumName << "\n";

    if (!mEndpointMap->isEmpty()) {
        for(auto e : mEndpointMap->keys()) {
            EnumEndpoint::ApiEndpoint enumType(e);
            //qDebug() << mEndpointMap->value(e) << "==" << getEndpoint(e) ;
            if (mEndpointMap->value(e) == getEndpoint(e)) {
                return enumType;
            }
        }
    }

    return EnumEndpoint::ApiEndpoint::API_NOT_DEFIED;
}

QString  AnimeRisutoApi::getEndpoint(EnumEndpoint::ApiEndpoint enumApiEndpoint) {
    static int enumIdx = EnumEndpoint::staticMetaObject.indexOfEnumerator("ApiEndpoint");
    QVariant variant = EnumEndpoint::staticMetaObject.enumerator(enumIdx).valueToKey(enumApiEndpoint);

    QString enumName = variant.toString();
    QString path = "/" + enumName.replace("_","/").toLower();

    return path;
}

QMap<EnumEndpoint::ApiEndpoint, QString> *AnimeRisutoApi::loadAndGetEndpoints() {

    static int enumIdx = EnumEndpoint::staticMetaObject.indexOfEnumerator("ApiEndpoint");

    for ( int enumInt = EnumEndpoint::ApiEndpoint::API_TOKEN ; enumInt != EnumEndpoint::ApiEndpoint::API_NOT_DEFIED; enumInt=1<<enumInt ){
        EnumEndpoint::ApiEndpoint enumType = static_cast<EnumEndpoint::ApiEndpoint>(enumInt);

        QVariant variant = EnumEndpoint::staticMetaObject.enumerator(enumIdx).valueToKey(enumType);

        QString enumName = variant.toString();

        qDebug() << enumType << ", " << enumName << ", " << getEndpoint(enumType) << "\n";

        mEndpointMap->insert(enumType, getEndpoint(enumType));
    }

    return mEndpointMap;
}

//*/

AnimeRisutoApi *AnimeRisutoApi::createInstance() {
    return new AnimeRisutoApi;
}

AnimeRisutoApi::AnimeRisutoApi() {
    mNetworkRequest = new QNetworkRequest ();
    mNetworkManager = new QNetworkAccessManager();
    mEndpointMap = new QMap<EnumEndpoint::ApiEndpoint, QString>();

    userToken = "";

    loadAndGetEndpoints();

    QObject::connect(mNetworkManager, &QNetworkAccessManager::finished, this, [=](QNetworkReply *reply) {


    }
    );
    // */
}

AnimeRisutoApi *AnimeRisutoApi::instance() {
    return Singleton<AnimeRisutoApi>::instance(AnimeRisutoApi::createInstance);
}

AnimeRisutoApi::~AnimeRisutoApi() {
}

QJsonObject AnimeRisutoApi::createPostData(QVariantMap fields) {
    QJsonObject json;

    if (&fields != nullptr && !fields.isEmpty()) {
        QMapIterator<QString, QVariant> i(fields);
        while (i.hasNext()) {
            i.next();
            json.insert(i.key(), i.value().toString());
        }
    }

    return json;
}

QString AnimeRisutoApi::createGetParam(QVariantMap fields) {

    QUrlQuery query;

    if (!fields.isEmpty()) {
        QMapIterator<QString, QVariant> i(fields);
        while (i.hasNext()) {
            i.next();
            query.addQueryItem(i.key(), i.value().toString());
        }
    }

    return query.query();
}

QNetworkRequest AnimeRisutoApi::createRequest(QUrl url) {

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", QString("bearer "+ userToken).toLocal8Bit());

    QSslConfiguration conf = request.sslConfiguration();
    conf.setProtocol(QSsl::AnyProtocol);
    request.setSslConfiguration(conf);

    return request;
}

QNetworkReply *AnimeRisutoApi::accountRegister(QVariantMap fields) {

    qDebug() << "EnumType: "<< EnumEndpoint::API_ACCOUNT_REGISTER;
    qDebug() << "EnumType: "<< EnumEndpoint::ApiEndpoint::API_ACCOUNT_REGISTER;

    QUrl url = QUrl(BASE_URL + getEndpoint(EnumEndpoint::ApiEndpoint::API_ACCOUNT_REGISTER));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    fields.insert("deviceUniqueId", "deviceUniqueId");

    return mNetworkManager->post(request, QJsonDocument(createPostData(fields)).toJson());
}

QNetworkReply *AnimeRisutoApi::accountLogin(QVariantMap fields) {

    qDebug() << "EnumType: "<< EnumEndpoint::API_TOKEN;
    qDebug() << "EnumType: "<< EnumEndpoint::ApiEndpoint::API_TOKEN;

    QUrl url = QUrl(BASE_URL + getEndpoint(EnumEndpoint::ApiEndpoint::API_TOKEN));

    return mNetworkManager->post(createRequest(url), QJsonDocument(createPostData(fields)).toJson());
}

QNetworkReply *AnimeRisutoApi::animeListAll(QVariantMap fields) {
    qDebug() << "EnumType: "<< EnumEndpoint::API_ANIME_ALL;

    QUrl url = QUrl(BASE_URL + getEndpoint(EnumEndpoint::ApiEndpoint::API_ANIME_ALL));

    qDebug() << "URL: => "+ url.url();

    logQVariantMap(fields);


    url.setQuery(createGetParam(fields));

    return mNetworkManager->get(createRequest(url));
}

QNetworkReply *AnimeRisutoApi::animeDetail(QString uniqueId) {
    qDebug() << "EnumType: "<< EnumEndpoint::API_ANIME_DETAIL;

    QUrl url = QUrl(BASE_URL + getEndpoint(EnumEndpoint::API_ANIME_DETAIL).replace("detail", uniqueId));

    qDebug() << "URL => "+ url.toString();

    return mNetworkManager->get(createRequest(url));

}

QNetworkReply *AnimeRisutoApi::get(QString reqUrl, QVariantMap fields) {
    QUrl url = QUrl(reqUrl);

    url.setQuery(createGetParam(fields));

    return mNetworkManager->get(createRequest(url));
}
