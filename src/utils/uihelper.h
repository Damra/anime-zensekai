#ifndef UIHELPER_H
#define UIHELPER_H
#include <QObject>
#include <QScreen>
#include <QApplication>

class UIHelper : public QObject {
    Q_OBJECT
public:
    QScreen * screen;
    qreal mRatio;
    qreal mRatioFont;
    UIHelper(QApplication * app) {
       screen = app->primaryScreen();
       calculateRatios(app);
    }

    Q_INVOKABLE float dp(float px){
        return px / mRatio;
    }

    Q_INVOKABLE float px(float dp) {
        return dp * mRatio;
    }

    Q_INVOKABLE void calculateRatios(QApplication * app){
        qreal refDpi = 216.;
        qreal refHeight = 1776.;
        qreal refWidth = 1080.;
        QRect rect = app->primaryScreen()->geometry();
        qreal height = qMax(rect.width(), rect.height());
        qreal width = qMin(rect.width(), rect.height());
        qreal dpi = app->primaryScreen()->logicalDotsPerInch();
        mRatio = qMin(height/refHeight, width/refWidth);
        mRatioFont = qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth));

    }
};

#endif // UIHELPER_H
