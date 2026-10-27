#ifndef CALENDAREXPORTER_H
#define CALENDAREXPORTER_H

#include <QObject>
#include <QVariantList>

class CalendarExporter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString lastFilePath READ lastFilePath NOTIFY lastFilePathChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit CalendarExporter(QObject *parent = nullptr);

    QString lastFilePath() const;
    QString lastError() const;

    Q_INVOKABLE bool exportEvents(const QString &fileName, const QVariantList &events);
    Q_INVOKABLE bool openExportedFile();
    Q_INVOKABLE QString downloadsPath() const;

signals:
    void lastFilePathChanged();
    void lastErrorChanged();
    void exportFinished(bool success, const QString &filePath);

private:
    QString escapeIcsText(const QString &text) const;
    QString foldIcsLine(const QString &line) const;
    QString normalizedFileName(const QString &fileName) const;
    void setLastFilePath(const QString &filePath);
    void setLastError(const QString &error);

    QString m_lastFilePath;
    QString m_lastError;
};

#endif
