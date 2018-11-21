#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class Utils
{
public:
    Utils();
    static QString getMacAddress();
    static QString osName();
};

#endif // UTILS_H
