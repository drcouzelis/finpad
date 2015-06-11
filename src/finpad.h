#ifndef FINPAD_H
#define FINPAD_H

#include <QtQuick>

class TextFile : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString path READ getPath WRITE setPath)
    Q_PROPERTY(QString fileName READ getFileName)
    Q_PROPERTY(QString baseName READ getBaseName)

public:
    TextFile();
    ~TextFile();

    QString getPath();
    void setPath(const QString& path);
    QString getFileName();
    QString getBaseName();

    Q_INVOKABLE QString load();
    Q_INVOKABLE bool save(const QString& data);

private:
    QString m_path;
};

class FileModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString path READ getPath WRITE setPath)

public:
    enum ItemRole {
        NameRole = Qt::UserRole + 1,
        PathRole,
        IsDirRole,
        SizeRole,
        TimeRole
    };

    FileModel();
    ~FileModel();

    void load();
    void reset_start();
    void reset_end();

    QHash<int, QByteArray> roleNames() const;
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;

    QString getPath();
    void setPath(const QString& path);

    Q_INVOKABLE void cd(const QString& path);
    Q_INVOKABLE void mkdir(const QString& path);
    Q_INVOKABLE QString filePath(const QString& name) const;

private:
    QString m_path;
    QDir m_dir;
    QFileInfoList m_files;

    QString toHumanReadable(qint64 size) const;
};


#endif // FINPAD_H
