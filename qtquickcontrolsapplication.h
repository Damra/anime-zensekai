#ifndef QTQUICKCONTROLSAPPLICATION_H
#define QTQUICKCONTROLSAPPLICATION_H

#ifdef QT_WIDGETS_LIB
#include <QtWidgets/QApplication>
#else
#include <QtGui/QGuiApplication>
#endif

QT_BEGIN_NAMESPACE

#ifdef QT_WIDGETS_LIB
#define QtQuickControlsApplication QApplication
#else
#define QtQuickControlsApplication QGuiApplication
#endif

QT_END_NAMESPACE

#endif // QTQUICKCONTROLSAPPLICATION_H
