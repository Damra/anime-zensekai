#ifndef PAGING_H
#define PAGING_H

#include <QObject>

// template <class T>
class Paging : public QObject
{
//    Q_PROPERTY(T items READ item WRITE setItems NOTIFY itemsChanged)
    Q_PROPERTY(int page READ page WRITE setPage NOTIFY pageChanged)
    Q_PROPERTY(int pageSize READ pageSize WRITE setPageSize NOTIFY pageSizeChanged)
    Q_PROPERTY(int totalPages READ totalPages WRITE setTotalPages NOTIFY totalPagesChanged)
    Q_PROPERTY(bool hasPreviousPage READ hasPreviousPage WRITE setHasPreviousPage NOTIFY hasPreviousPageChanged)
    Q_PROPERTY(bool hasNextPage READ hasNextPage WRITE setHasNextPage NOTIFY hasNextPageChanged)
private:
  //  T mItems;
    int mPage;
    int mPageSize;
    int mTotalPages;
    bool mHasPreviousPage;
    bool mHasNextPage;
signals:
  //  void itemsChanged();
    void pageChanged();
    void pageSizeChanged();
    void totalPagesChanged();
    void hasPreviousPageChanged();
    void hasNextPageChanged();

public:
    Paging() : QObject () {  }

    /* T items() const { return mItems; }
    void setItems(const T &items){
        if (items != mItems){
            mItems = items;
            emit itemsChanged();
        }
    }
*/
    int page() const { return mPage; }
    void setPage(const int &page) {
        if (page != mPage) {
            mPage = page;
            emit pageChanged();
        }
    }

    int pageSize() const { return mPageSize; }
    void setPageSize(const int &pageSize) {
        if(pageSize != mPageSize) {
            mPageSize = pageSize;
            emit pageSizeChanged();
        }
    }

    int totalPages() const { return mTotalPages; }
    void setTotalPages(const int &totalPages) {
        if(totalPages != mTotalPages) {
            mTotalPages = totalPages;
            emit totalPagesChanged();
        }
    }

    bool hasPreviousPage() const { return mHasPreviousPage; }
    void setHasPreviousPage(const bool &hasPreviousPage) {
        if(hasPreviousPage != mHasPreviousPage) {
            mHasPreviousPage = hasPreviousPage;
            emit hasNextPageChanged();
        }
    }

    bool hasNextPage() const { return mHasNextPage; }
    void setHasNextPage(const int &hasNextPage) {
        if(hasNextPage != mHasNextPage) {
            mHasNextPage = hasNextPage;
            emit hasNextPageChanged();
        }
    }
};

#endif // PAGING_H
