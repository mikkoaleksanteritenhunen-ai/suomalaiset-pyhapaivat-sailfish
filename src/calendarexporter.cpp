#include "calendarexporter.h"

#include <QDate>
#include <QDateTime>
#include <QDesktopServices>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>
#include <QTextStream>
#include <QUrl>
#include <QUuid>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>

CalendarExporter::CalendarExporter(QObject *parent)
    : QObject(parent)
{
}

QString CalendarExporter::lastFilePath() const
{
    return m_lastFilePath;
}

QString CalendarExporter::lastError() const
{
    return m_lastError;
}

QString CalendarExporter::downloadsPath() const
{
    QString path =
            QStandardPaths::writableLocation(
                QStandardPaths::DownloadLocation);

    if (path.isEmpty()) {
        path = QDir::homePath() +
                QStringLiteral("/Downloads");
    }

    return path;
}

QString CalendarExporter::normalizedFileName(
        const QString &fileName) const
{
    QString result = fileName.trimmed();

    if (result.isEmpty()) {
        result =
                QStringLiteral(
                    "suomalaiset-pyhapaivat");
    }

    result.replace(
                QStringLiteral("/"),
                QStringLiteral("-"));

    result.replace(
                QStringLiteral("\\"),
                QStringLiteral("-"));

    result.replace(
                QStringLiteral(".."),
                QStringLiteral("-"));

    if (!result.endsWith(
                QStringLiteral(".ics"),
                Qt::CaseInsensitive)) {
        result.append(
                    QStringLiteral(".ics"));
    }

    return result;
}

QString CalendarExporter::escapeIcsText(
        const QString &text) const
{
    QString result = text;

    result.replace(
                QStringLiteral("\\"),
                QStringLiteral("\\\\"));

    result.replace(
                QStringLiteral(";"),
                QStringLiteral("\\;"));

    result.replace(
                QStringLiteral(","),
                QStringLiteral("\\,"));

    result.replace(
                QStringLiteral("\r\n"),
                QStringLiteral("\\n"));

    result.replace(
                QStringLiteral("\n"),
                QStringLiteral("\\n"));

    result.replace(
                QStringLiteral("\r"),
                QStringLiteral("\\n"));

    return result;
}

QString CalendarExporter::foldIcsLine(
        const QString &line) const
{
    const int maximumCharacters = 70;

    if (line.length() <= maximumCharacters) {
        return line;
    }

    QString result;
    int position = 0;

    while (position < line.length()) {
        if (!result.isEmpty()) {
            result.append(
                        QStringLiteral("\r\n "));
        }

        result.append(
                    line.mid(
                        position,
                        maximumCharacters));

        position += maximumCharacters;
    }

    return result;
}

void CalendarExporter::setLastFilePath(
        const QString &filePath)
{
    if (m_lastFilePath == filePath) {
        return;
    }

    m_lastFilePath = filePath;
    emit lastFilePathChanged();
}

void CalendarExporter::setLastError(
        const QString &error)
{
    if (m_lastError == error) {
        return;
    }

    m_lastError = error;
    emit lastErrorChanged();
}

bool CalendarExporter::exportEvents(
        const QString &fileName,
        const QVariantList &events)
{
    setLastError(QString());

    if (events.isEmpty()) {
        setLastError(
                    tr("Vietäviä tapahtumia ei ole."));

        emit exportFinished(
                    false,
                    QString());

        return false;
    }

    const QString directoryPath =
            downloadsPath();

    QDir directory(directoryPath);

    if (!directory.exists()) {
        if (!directory.mkpath(
                    QStringLiteral("."))) {
            setLastError(
                        tr("Downloads-hakemistoa "
                           "ei voitu luoda."));

            emit exportFinished(
                        false,
                        QString());

            return false;
        }
    }

    const QString outputPath =
            directory.filePath(
                normalizedFileName(fileName));

    QFile file(outputPath);

    if (!file.open(
                QIODevice::WriteOnly |
                QIODevice::Text |
                QIODevice::Truncate)) {
        setLastError(
                    tr("Tiedostoa ei voitu avata: %1")
                    .arg(file.errorString()));

        emit exportFinished(
                    false,
                    QString());

        return false;
    }

    QTextStream stream(&file);
    stream.setCodec("UTF-8");

    stream << "BEGIN:VCALENDAR\r\n";
    stream << "VERSION:2.0\r\n";
    stream << "PRODID:-//Mikko Tenhunen//"
              "Suomalaiset Pyhapaivat//FI\r\n";
    stream << "CALSCALE:GREGORIAN\r\n";
    stream << "METHOD:PUBLISH\r\n";

    stream << foldIcsLine(
                  QStringLiteral(
                      "X-WR-CALNAME:"
                      "Suomalaiset pyhä- ja "
                      "liputuspäivät"))
           << "\r\n";

    const QString timeStamp =
            QDateTime::currentDateTimeUtc()
            .toString(
                QStringLiteral(
                    "yyyyMMdd'T'HHmmss'Z'"));

    int writtenEventCount = 0;

    for (int index = 0;
         index < events.count();
         ++index) {
        const QVariant eventValue =
                events.at(index);

        const QVariantMap event =
                eventValue.toMap();

        const QString dateString =
                event.value(
                    QStringLiteral("date"))
                .toString();

        const QDate startDate =
                QDate::fromString(
                    dateString,
                    Qt::ISODate);

        if (!startDate.isValid()) {
            continue;
        }

        const QDate endDate =
                startDate.addDays(1);

        const QString name =
                event.value(
                    QStringLiteral("name"))
                .toString();

        if (name.trimmed().isEmpty()) {
            continue;
        }

        const QString description =
                event.value(
                    QStringLiteral("description"))
                .toString();

        const QString category =
                event.value(
                    QStringLiteral("category"))
                .toString();

        QString uid =
                event.value(
                    QStringLiteral("uid"))
                .toString();

        if (uid.isEmpty()) {
            uid =
                    QUuid::createUuid()
                    .toString()
                    .remove(
                        QLatin1Char('{'))
                    .remove(
                        QLatin1Char('}'));

            uid.append(
                        QStringLiteral(
                            "@suomalaisetpyhapaivat"));
        }

        stream << "BEGIN:VEVENT\r\n";

        stream << foldIcsLine(
                      QStringLiteral("UID:") +
                      uid)
               << "\r\n";

        stream << "DTSTAMP:"
               << timeStamp
               << "\r\n";

        stream << "DTSTART;VALUE=DATE:"
               << startDate.toString(
                      QStringLiteral("yyyyMMdd"))
               << "\r\n";

        stream << "DTEND;VALUE=DATE:"
               << endDate.toString(
                      QStringLiteral("yyyyMMdd"))
               << "\r\n";

        stream << foldIcsLine(
                      QStringLiteral("SUMMARY:") +
                      escapeIcsText(name))
               << "\r\n";

        if (!description.isEmpty()) {
            stream << foldIcsLine(
                          QStringLiteral(
                              "DESCRIPTION:") +
                          escapeIcsText(
                              description))
                   << "\r\n";
        }

        if (!category.isEmpty()) {
            stream << foldIcsLine(
                          QStringLiteral(
                              "CATEGORIES:") +
                          escapeIcsText(
                              category))
                   << "\r\n";
        }

        stream << "TRANSP:TRANSPARENT\r\n";
        stream << "STATUS:CONFIRMED\r\n";
        stream << "END:VEVENT\r\n";

        ++writtenEventCount;
    }

    stream << "END:VCALENDAR\r\n";
    stream.flush();

    const QFile::FileError fileError =
            file.error();

    file.close();

    if (fileError != QFile::NoError) {
        setLastError(
                    tr("Tiedoston kirjoittaminen "
                       "epäonnistui."));

        QFile::remove(outputPath);

        emit exportFinished(
                    false,
                    QString());

        return false;
    }

    if (writtenEventCount == 0) {
        setLastError(
                    tr("Yhtään kelvollista tapahtumaa "
                       "ei voitu kirjoittaa."));

        QFile::remove(outputPath);

        emit exportFinished(
                    false,
                    QString());

        return false;
    }

    setLastFilePath(outputPath);

    emit exportFinished(
                true,
                outputPath);

    return true;
}

bool CalendarExporter::openExportedFile()
{
    setLastError(QString());

    if (m_lastFilePath.isEmpty()) {
        setLastError(
                    tr("Vietyä tiedostoa ei ole."));

        return false;
    }

    QFileInfo fileInfo(m_lastFilePath);

    if (!fileInfo.exists() ||
            !fileInfo.isFile()) {
        setLastError(
                    tr("Vietyä tiedostoa ei löydy."));

        return false;
    }

    const QUrl fileUrl =
            QUrl::fromLocalFile(
                m_lastFilePath);

    const bool opened =
            QDesktopServices::openUrl(
                fileUrl);

    if (!opened) {
        setLastError(
                    tr("Tiedostoa ei voitu avata."));
    }

    return opened;
}
