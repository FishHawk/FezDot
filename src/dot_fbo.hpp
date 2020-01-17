#ifndef DOT_FBO_HPP
#define DOT_FBO_HPP

#include <utility>

#include <QtQuick/QQuickFramebufferObject>

class DotFramebufferObject : public QQuickFramebufferObject {
    Q_OBJECT
public:
    Q_PROPERTY(QString m_theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(RotatePlane plane READ plane WRITE setPlane NOTIFY planeChanged)
    Q_PROPERTY(double velocity1 READ velocity1 WRITE setVelocity1 NOTIFY velocity1Changed)
    Q_PROPERTY(double velocity2 READ velocity2 WRITE setVelocity2 NOTIFY velocity2Changed)
    Q_PROPERTY(QVector<QColor> colors READ colors NOTIFY colorsChanged)

    enum RotatePlane { XY,
                       XZ,
                       XW };
    Q_ENUM(RotatePlane)

    QString theme() { return m_theme; }
    RotatePlane plane() { return m_plane; }
    double velocity1() { return m_velocity1; }
    double velocity2() { return m_velocity2; }
    QVector<QColor> colors() { return m_colors; }

    void setTheme(QString theme) {
        m_theme = theme;
        update();
    }
    void setPlane(RotatePlane plane) {
        m_plane = plane;
        update();
    }
    void setVelocity1(double velocity) {
        m_velocity1 = velocity;
        update();
    }
    void setVelocity2(double velocity) {
        m_velocity2 = velocity;
        update();
    }

signals:
    void themeChanged();
    void planeChanged();
    void velocity1Changed();
    void velocity2Changed();
    void colorsChanged();

public:
    // Q_INVOKABLE QColor colors(int index) { return m_colors[index]; }
    Q_INVOKABLE void setColors(int index, QColor color) {
        m_colors[index] = std::move(color);
        colorsChanged();
        update();
    }

    DotFramebufferObject();
    Renderer *createRenderer() const override;

private:
    QString m_theme;
    RotatePlane m_plane;
    double m_velocity1;
    double m_velocity2;

    QVector<QColor> m_colors;
};

#endif
