#ifndef ANIMELISITEM_H
#define ANIMELISITEM_H

#include <QObject>

class AnimeListItem : public QObject
{
    /*
        "uniqueId": "string",
        "primaryTitle": "string",
        "type": "string",
        "coverImageUrl": "string",
        "rate": "string"
    */

    Q_OBJECT

    Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)
    Q_PROPERTY(QString primaryTitle READ primaryTitle WRITE setPrimaryTitle NOTIFY primaryTitleChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString coverImageUrl READ coverImageUrl WRITE setCoverImageUrl NOTIFY coverImageUrlChanged)
    Q_PROPERTY(QString rate READ rate WRITE setRate NOTIFY rateChanged)

public:
  //  AnimeListItem(QObject *parent=0);
  //  AnimeListItem(const QString &uniqueId, const QString &primaryTitle, const QString &type, const QString &coverImageUrl, const QString &rateChanged, QObject *parent=0);

    QString uniqueId() const { return mUniqueId; }
    QString primaryTitle() const { return mPrimaryTitle; }
    QString type() const { return mType; }
    QString coverImageUrl() const { return mCoverImageUrl; }
    QString rate() const { return mRate ; }

    void setUniqueId(const QString &str) {
        if (str != mUniqueId){
            mUniqueId = str;
            emit uniqueIdChanged();
        }
    }
    void setPrimaryTitle(const QString &str) {
        if (str != mPrimaryTitle ){
            mPrimaryTitle = str;
            emit primaryTitleChanged();
        }
    }
    void setType(const QString &str) {
        if (str != mType ){
            mType = str;
            emit typeChanged();
        }
    }
    void setCoverImageUrl(const QString &str) {
        if (str != mCoverImageUrl ){
            mCoverImageUrl = str;
            emit coverImageUrlChanged();
        }
    }
    void setRate(const QString &str) {
        if (str != mRate ){
            mRate = str;
            emit rateChanged();
        }
    }

signals:
    void uniqueIdChanged();
    void primaryTitleChanged();
    void typeChanged();
    void coverImageUrlChanged();
    void rateChanged();

private:
    QString mUniqueId;
    QString mPrimaryTitle;
    QString mType;
    QString mCoverImageUrl;
    QString mRate;

};


#endif // ANIMELISITEM_H
