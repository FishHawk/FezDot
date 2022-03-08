#pragma once

#include <utility>

#include <QtCore/QSettings>
#include <QtQuick/QQuickFramebufferObject>

class DotFramebufferObject : public QQuickFramebufferObject {
    Q_OBJECT
  public:
    Q_PROPERTY(RotatePlane plane MEMBER m_plane NOTIFY planeChanged)
    Q_PROPERTY(double velocity1 MEMBER m_velocity1 NOTIFY velocity1Changed)
    Q_PROPERTY(double velocity2 MEMBER m_velocity2  NOTIFY velocity2Changed)
    Q_PROPERTY(double opacity MEMBER m_opacity NOTIFY opacityChanged)
    Q_PROPERTY(QVector<QColor> colors MEMBER m_colors NOTIFY colorsChanged)

    enum RotatePlane { XY,
                       XZ,
                       XW };
    Q_ENUM(RotatePlane)

    Q_INVOKABLE void setColors(int index, QColor color) {
        m_colors[index] = std::move(color);
        colorsChanged();
    }

  signals:
    void planeChanged();
    void velocity1Changed();
    void velocity2Changed();
    void opacityChanged();
    void colorsChanged();

  public:
    DotFramebufferObject();

    void loadTheme(const QSettings &theme);
    void saveTheme(QSettings &theme);

    Renderer *createRenderer() const override;

  private:
    friend class DotRender;

    RotatePlane m_plane;
    double m_velocity1;
    double m_velocity2;

    double m_opacity;
    QVector<QColor> m_colors;
};