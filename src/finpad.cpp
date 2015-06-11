#include "finpad.h"

#include <sailfishapp.h>

TextFile::TextFile()
{
}

TextFile::~TextFile()
{
}

QString TextFile::getPath()
{
    return m_path;
}

void TextFile::setPath(const QString& path)
{
    m_path = path;
}

QString TextFile::getFileName()
{
    return QFileInfo(m_path).fileName();
}

QString TextFile::getBaseName()
{
    return QFileInfo(m_path).baseName();
}

QString TextFile::load()
{
    QFile f(m_path);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString();
    }
    QString data(QString::fromLocal8Bit(f.readAll()));
    f.close();
    return data;
}

bool TextFile::save(const QString& data)
{
    QFile f(m_path);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        return false;
    }
    f.write(data.toLocal8Bit());
    f.close();
    return true;
}

FileModel::FileModel() :
    m_dir(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation),
          QString(),
          QDir::Name |
          QDir::DirsFirst |
          QDir::IgnoreCase |
          QDir::LocaleAware,
          QDir::AllDirs |
          QDir::Files |
          QDir::NoDot)
{
    load();
}

FileModel::~FileModel()
{
}

void FileModel::load()
{
    m_files = m_dir.entryInfoList();
}

void FileModel::reset_start()
{
    beginResetModel();
}

void FileModel::reset_end()
{
    load();
    endResetModel();
}

QHash<int, QByteArray> FileModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[PathRole] = "path";
    roles[IsDirRole] = "isDir";
    roles[SizeRole] = "size";
    roles[TimeRole] = "time";
    return roles;
}

int FileModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
    {
        return 0;
    }

    return m_files.size();
}

QVariant FileModel::data(const QModelIndex& index, int role) const
{
    const QFileInfo& info = m_files[index.row()];
    switch (role)
    {
    case NameRole:
        return info.fileName();
    case PathRole:
        return info.filePath();
    case IsDirRole:
        return info.isDir();
    case SizeRole:
        return toHumanReadable(info.size());
    case TimeRole:
        return info.lastModified().toString(Qt::DefaultLocaleShortDate);
    default:
        return QVariant();
    }
}

QString FileModel::getPath()
{
    return m_dir.path();
}

void FileModel::setPath(const QString& path)
{
    reset_start();
    m_dir.setPath(path);
    reset_end();
}

void FileModel::cd(const QString& path)
{
    reset_start();
    m_dir.cd(path);
    reset_end();
}

void FileModel::mkdir(const QString& path)
{
    reset_start();
    m_dir.mkdir(path);
    reset_end();
}

QString FileModel::filePath(const QString& name) const
{
    return m_dir.filePath(name);
}

QString FileModel::toHumanReadable(qint64 size) const
{
    if (size < 1024)
    {
        return QString::number(size) + " bytes";
    }
    double sz = size / 1024.0;
    if (sz < 1024.0)
    {
        return QString::number(sz, 'f', 1) + " KiB";
    }
    sz /= 1024.0;
    if (sz < 1024.0)
    {
        return QString::number(sz, 'f', 1) + " MiB";
    }
    sz /= 1024.0;
    return QString::number(sz, 'g', 1) + " GiB";
}

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    qmlRegisterType<TextFile>("finpad", 1, 0, "TextFile");
    qmlRegisterType<FileModel>("finpad", 1, 0, "FileModel");

    return SailfishApp::main(argc, argv);
}
