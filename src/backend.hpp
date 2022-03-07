#ifndef BACKEND_HPP
#define BACKEND_HPP

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

  public:
    Q_INVOKABLE void saveTheme(QString theme);
    Q_INVOKABLE void loadTheme(QString theme);
    Q_INVOKABLE void deleteTheme(QString theme);

    Backend(int size, int x, int y);

    Q_INVOKABLE QVariant loadSetting(const QString &key, const QVariant &defaultValue = QVariant()) {
        return m_settings.value(key, defaultValue);
    }
    Q_INVOKABLE void saveSetting(const QString &key, const QVariant &value = QVariant()) {
        m_settings.setValue(key, value);
    }

  private:
    int m_size, m_x, m_y;

    WindowLayer m_layer{WindowLayer::AboveOthers};

    QSettings m_settings{"settings"};

    QStringList m_themes;

    DotFramebufferObject *m_dot;

    void loadThemeList();
};

#endif