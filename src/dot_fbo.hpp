#include <utility>

//
// Created by wh on 3/2/19.
//

#ifndef DOT_DOT_FBO_HPP
#define DOT_DOT_FBO_HPP

#include <QtQuick/QQuickFramebufferObject>

class DotFramebufferObject : public QQuickFramebufferObject {
Q_OBJECT
    Q_PROPERTY(RotatePlane plane READ plane WRITE setPlane NOTIFY planeChanged)
    Q_PROPERTY(double velocity1 READ velocity1 WRITE setVelocity1 NOTIFY velocity1Changed)
    Q_PROPERTY(double velocity2 READ velocity2 WRITE setVelocity2 NOTIFY velocity2Changed)

signals:
    void planeChanged();
    void velocity1Changed();
    void velocity2Changed();
public:
    Q_INVOKABLE QColor colors(int index) { return m_colors[index]; }
    Q_INVOKABLE void setColors(int index, QColor color) { m_colors[index] = std::move(color); update();}
    Q_INVOKABLE void saveChange();

    DotFramebufferObject();

    enum RotatePlane { XY, XZ, XW};
    Q_ENUM(RotatePlane)

    Renderer *createRenderer() const override;

    RotatePlane plane() { return m_plane; }
    double velocity1() { return m_velocity1; }
    double velocity2() { return m_velocity2; }

    void setPlane(RotatePlane plane) { m_plane = plane; update(); }
    void setVelocity1(double velocity) { m_velocity1 = velocity; update(); }
    void setVelocity2(double velocity) { m_velocity2 = velocity; update(); }

private:
    RotatePlane m_plane;
    double m_velocity1;
    double m_velocity2;

    QVector<QColor> m_colors;
};

#endif //DOT_DOT_FBO_HPP
