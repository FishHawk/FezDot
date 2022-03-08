#pragma once

#include <QtCore/QCommandLineParser>
#include <QtCore/QSettings>

#include "dot_fbo.hpp"

class Backend : public QObject {
    Q_OBJECT
  public:
    Q_PROPERTY(DotFramebufferObject *dot MEMBER m_dot CONSTANT)

    Q_PROPERTY(int size MEMBER m_size NOTIFY sizeChanged)
    Q_PROPERTY(int x MEMBER m_x NOTIFY xChanged)
    Q_PROPERTY(int y MEMBER m_y NOTIFY yChanged)
    Q_PROPERTY(WindowLayer layer MEMBER m_layer NOTIFY layerChanged)
    Q_PROPERTY(QString theme MEMBER m_theme NOTIFY themeChanged)
    Q_PROPERTY(QStringList themes MEMBER m_themes NOTIFY themesChanged)

    enum WindowLayer { AboveOthers,
                       BelowOthers,
                       Normal };
    Q_ENUM(WindowLayer)

  signals:
    void xChanged();
    void yChanged();
    void sizeChanged();
    void layerChanged();
    void themeChanged();
    void themesChanged();

  private slots:
    void onXChanged() { m_settings.setValue("x", m_x); }
    void onYChanged() { m_settings.setValue("y", m_y); }
    void onSizeChanged() { m_settings.setValue("size", m_size); }
    void onLayerChanged() { m_settings.setValue("layer", m_layer); }
    void onThemeChanged() { m_settings.setValue("theme", m_theme); }

  public:
    Backend(const QCommandLineParser &parser);

    Q_INVOKABLE void saveTheme(QString theme);
    Q_INVOKABLE void loadTheme(QString theme);
    Q_INVOKABLE void deleteTheme(QString theme);

    Q_INVOKABLE QVariant loadSetting(const QString &key, const QVariant &defaultValue = QVariant()) {
        return m_settings.value(key, defaultValue);
    }
    Q_INVOKABLE void saveSetting(const QString &key, const QVariant &value = QVariant()) {
        m_settings.setValue(key, value);
    }

  private:
    QSettings m_settings{"settings"};

    DotFramebufferObject *m_dot{new DotFramebufferObject()};

    int m_size, m_x, m_y;
    WindowLayer m_layer;

    QString m_theme;
    QStringList m_themes;

    void loadThemeList();
};