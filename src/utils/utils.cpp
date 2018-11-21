#include "utils.h"

#include <QNetworkInterface>
#include <QFile>
#include <QCryptographicHash>


Utils::Utils()
{

}

QString Utils::getMacAddress()
{

    // Trying to get MAC Address
    Q_FOREACH(QNetworkInterface netInterface, QNetworkInterface::allInterfaces())
    {
        // Return only the first non-loopback MAC Address
        if (!(netInterface.flags() & QNetworkInterface::IsLoopBack))
        {
            QString macAddress = netInterface.hardwareAddress();

            // On Android 6 you cannot retrieve MAC address with regular way, this is a workaround for getting it.
            if(macAddress.isEmpty()){

                qDebug()<< Q_FUNC_INFO <<"MAC address cannot be retrieved with regular way, trying to obtain it from: /sys/class/net/"+netInterface.name()+"/address";

                QFile macFile("/sys/class/net/"+netInterface.name()+"/address");

                if (macFile.open(QFile::ReadOnly)){
                    QTextStream textStream(&macFile);
                    macAddress= QString(textStream.readLine());
                    macFile.close();
                }
            }

            if(!macAddress.isEmpty()&&!macAddress.endsWith("02:00:00:00:00:00")){
                qDebug()<< Q_FUNC_INFO <<"Using MAC address"<< macAddress;

                return QString(QCryptographicHash::hash((macAddress.toLocal8Bit()),QCryptographicHash::Md5).toHex());
            }

            qDebug()<< Q_FUNC_INFO <<"MAC Address is:"<<macAddress;


        }
    }

    return "";

    /*
        // Trying to get ANDROID_ID from system
        QAndroidJniObject myID = QAndroidJniObject::fromString("android_id");
        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
        QAndroidJniObject appctx = activity.callObjectMethod("getApplicationContext","()Landroid/content/Context;");
        QAndroidJniObject contentR = appctx.callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");

        QAndroidJniObject androidId = QAndroidJniObject::callStaticObjectMethod("android/provider/Settings$Secure","getString",
                                                                             "(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;",
                                                                             contentR.object<jobject>(),
                                                                             myID.object<jstring>());
        if(!_isJvmException()){
            if(androidId.isValid() && !androidId.toString().isEmpty()){
                if(androidId.toString().endsWith("9774d56d682e549c")){
                    qWarning()<< Q_FUNC_INFO <<"This device has the bug with unique id"; //https://code.google.com/p/android/issues/detail?id=10603
                }else{
                    qDebug()<< Q_FUNC_INFO <<"Using androidId"<<androidId.toString();
                    return _getSha1Hash(androidId.toString());
                }
            }
        }

        qDebug()<< Q_FUNC_INFO <<"Using randomUuid";
        return _getSha1Hash(QUuid::createUuid().toString());
//*/
}

QString Utils::osName()
{
    #if defined(Q_OS_ANDROID)
        return QLatin1String("android");

    #elif defined(Q_OS_BLACKBERRY)
        return QLatin1String("blackberry");

    #elif defined(Q_OS_IOS)
        return QLatin1String("ios");

    #elif defined(Q_OS_MAC)
        return QLatin1String("osx");

    #elif defined(Q_OS_WINCE)
        return QLatin1String("wince");

    #elif defined(Q_OS_WIN)
        return QLatin1String("windows");

    #elif defined(Q_OS_LINUX)
        return QLatin1String("linux");

    #elif defined(Q_OS_UNIX)
        return QLatin1String("unix");

    #else
        return QLatin1String("unknown");
    #endif
}
