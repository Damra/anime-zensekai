#ifndef ENUM_ENDPOINT_H
#define ENUM_ENDPOINT_H

#include <QObject>
#include <QtQml>

// Required derivation from QObject
class EnumEndpoint : public QObject
{
    Q_OBJECT

public:
    // Default constructor, required for classes you expose to QML.
    EnumEndpoint() : QObject() {}
    enum ApiEndpoint {
        API_TOKEN               = 1<<0,
        API_ACCOUNT_REGISTER    = 1<<1,
        API_ACCOUNT_UPDATE      = 1<<2,
        API_ANIME_ALL           = 1<<3,
        API_ANIME_DETAIL        = 1<<4,
        API_NOT_DEFIED          = 1<<16
    };
    Q_ENUMS(ApiEndpoint)

    // Do not forget to declare your class to the QML system.
    static void declareQML() {
        qmlRegisterType<EnumEndpoint>("EnumEndpoint", 1, 0, "EnumEndpoint");
    }
};

#endif // ENUM_ENDPOINT_H
