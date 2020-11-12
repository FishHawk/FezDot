#ifndef BACKEND_HPP
#define BACKEND_HPP

#include <QObject>
#include <QSettings>

#include "dot_fbo.hpp"

class Backend : public QObject {
    Q_OBJECT
public:
    Q_PROPERTY(QStringList themes MEMBER m_themes NOTIFY themesChanged)

    Q_PROPERTY(DotFramebufferObject *dot READ dot CONSTANT)
    DotFramebufferObject *dot() { return m_dot; }

signals:
    void themesChanged();

public:
    Q_INVOKABLE void saveTheme(QString theme);
    Q_INVOKABLE void loadTheme(QString theme);
    Q_INVOKABLE void deleteTheme(QString theme);

    Backend();

    Q_INVOKABLE QVariant loadSetting(const QString &key, const QVariant &defaultValue = QVariant()) {
        return m_settings.value(key, defaultValue);
    }
    Q_INVOKABLE void saveSetting(const QString &key, const QVariant &value = QVariant()) {
        m_settings.setValue(key, value);
    }

private:
    QSettings m_settings{"settings"};

    QStringList m_themes;

    DotFramebufferObject *m_dot;

    void loadThemeList();
};

#endif