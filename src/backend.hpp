#pragma once

#include <QObject>
#include <QSettings>

#include "dot_fbo.hpp"

class Backend : public QObject {
    Q_OBJECT
  public:
    Q_PROPERTY(int size MEMBER m_size NOTIFY sizeChanged)
    Q_PROPERTY(int x MEMBER m_x NOTIFY xChanged)
    Q_PROPERTY(int y MEMBER m_y NOTIFY yChanged)
    Q_PROPERTY(WindowLayer layer MEMBER m_layer NOTIFY layerChanged)
    enum WindowLayer { AboveOthers,
                       BelowOthers,
                       Normal };
    Q_ENUM(WindowLayer)

    Q_PROPERTY(QStringList themes MEMBER m_themes NOTIFY themesChanged)

    Q_PROPERTY(DotFramebufferObject *dot READ dot CONSTANT)
    DotFramebufferObject *dot() { return m_dot; }

  signals:
    void xChanged();
    void yChanged();
    void sizeChanged();
    void layerChanged();
    void themesChanged();

  private slots:
    void onXChanged() { m_settings.setValue("x", m_x); }
    void onYChanged() { m_settings.setValue("y", m_y); }
    void onSizeChanged() { m_settings.setValue("size", m_size); }
    void onLayerChanged() { m_settings.setValue("layer", m_layer); }

  public:
    Backend(int size, int x, int y);

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
    int m_size, m_x, m_y;

    QSettings m_settings{"settings"};
    WindowLayer m_layer{static_cast<WindowLayer>(m_settings.value("layer", 0).toUInt())};

    QStringList m_themes;

    DotFramebufferObject *m_dot;

    void loadThemeList();
};