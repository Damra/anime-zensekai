#include "src/api/SingletonNetworkAccessManager.h"
#include <QtConcurrent/QtConcurrent>

void SingletonNetworkAccessManager::replyCallback(QNetworkReply *reply, QJSValue * jsCallback) {

    QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    QVariant statusMessage = reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute);

    QJSValue val = engine->newObject();

    val.setProperty("statusCode", statusCode.toInt());
    val.setProperty("statusMessage", statusMessage.toString());
    val.setProperty("result", QString::fromUtf8(reply->readAll()));
    val.setProperty("path", reply->url().path());

    jsCallback->call(QJSValueList { val });

    qDebug() << "Called JS Callback inside c++";

    qDebug() << "Circular Progres Bar hiding";
    setBusy(false);
}

void SingletonNetworkAccessManager::get(QString url, QVariantMap postData, QJSValue jsCallback)
{

    qDebug() << "URL: " << url;

    QFuture<void> future = QtConcurrent::run([postData, self = this, jsb = &jsCallback](){
        qDebug() << "QtConcurrent::run";
    });

    QEventLoop loop;
    QNetworkReply * reply = AnimeRisutoApi::instance()->get(url, postData);
    connect(reply->manager(), &QNetworkAccessManager::finished, &loop, &QEventLoop::quit);
    loop.exec();
    replyCallback(reply , &jsCallback);
    reply->deleteLater();
}

void SingletonNetworkAccessManager::accountLogin(QVariantMap postData, QJSValue jsCallback ) {
    setBusy(true);
    QFuture<void> future = QtConcurrent::run([postData, self = this, jsb = &jsCallback](){
        qDebug() << "QtConcurrent::run";
    });

    QEventLoop loop;
    QNetworkReply * reply = AnimeRisutoApi::instance()->accountLogin(postData);
    connect(reply->manager(), &QNetworkAccessManager::finished, &loop, &QEventLoop::quit);
    loop.exec();
    replyCallback(reply , &jsCallback);
    reply->deleteLater();

}

void SingletonNetworkAccessManager::accountRegister(QVariantMap postData, QJSValue jsCallback) {
    setBusy(true);
    QFuture<void> future = QtConcurrent::run([postData, self = this, jsb = &jsCallback](){
        qDebug() << "QtConcurrent::run";
    });

    QEventLoop loop;
    QNetworkReply * reply = AnimeRisutoApi::instance()->accountRegister(postData);
    connect(reply->manager(), &QNetworkAccessManager::finished, &loop, &QEventLoop::quit);
    loop.exec();
    replyCallback(reply , &jsCallback);
    reply->deleteLater();

}

void SingletonNetworkAccessManager::animeListAll(QVariantMap postData, QJSValue jsCallback) {

    QFuture<void> future = QtConcurrent::run([postData, self = this, jsb = &jsCallback](){
        qDebug() << "QtConcurrent::run";
        self->setBusy(true);
    });

    QEventLoop loop;
    QNetworkReply * reply = AnimeRisutoApi::instance()->animeListAll(postData);
    connect(reply->manager(), &QNetworkAccessManager::finished, &loop, &QEventLoop::quit);
    loop.exec();
    replyCallback(reply , &jsCallback);
    reply->deleteLater();

}

void SingletonNetworkAccessManager::animeDetail(QString uniqueId, QJSValue jsCallback) {
    setBusy(true);
    QFuture<void> future = QtConcurrent::run([self = this, jsb = &jsCallback](){
        qDebug() << "QtConcurrent::run";
    });

    QEventLoop loop;
    QNetworkReply * reply = AnimeRisutoApi::instance()->animeDetail(uniqueId);

    connect(reply->manager(), &QNetworkAccessManager::finished, &loop, &QEventLoop::quit);
    loop.exec();
    replyCallback(reply , &jsCallback);
    reply->deleteLater();

}
