//
// Created by wh on 3/2/19.
//

#ifndef DOT_DOT_RENDER_HPP
#define DOT_DOT_RENDER_HPP

#include <QtCore/QtMath>

#include <QtGui/QOpenGLFunctions_3_3_Core>
#include <QtGui/QOpenGLFramebufferObject>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLVertexArrayObject>
#include <QtGui/QOpenGLBuffer>
#include <QtGui/QMatrix4x4>

#include <QtQuick/QQuickFramebufferObject>
#include <QtQuick/QQuickWindow>

#include "dot_fbo.hpp"

class DotRender : public QQuickFramebufferObject::Renderer, public QOpenGLFunctions_3_3_Core {
public:
    DotRender();

    void render() override;

    void synchronize(QQuickFramebufferObject* item) override;

    QOpenGLFramebufferObject *createFramebufferObject(const QSize &size) override;

private:

    void GenerateVaoLine();
    void GenerateVaoFace();

    QQuickWindow *window = nullptr;

    QOpenGLShaderProgram program;

    QOpenGLVertexArrayObject vao_line;
    QOpenGLBuffer vbo_line_position, vbo_line_color;

    QOpenGLVertexArrayObject vao_face;
    QOpenGLBuffer vbo_face_position, vbo_face_color;

    QVector4D m_colors[8] {
            QVector4D(0.5f,0.5f,0.0f, 1.6f)/2,
            QVector4D(0.8f,0.2f,0.0f, 1.6f)/2,
            QVector4D(0.8f,0.0f,0.2f, 1.6f)/2,
            QVector4D(0.0f,0.8f,0.2f, 1.6f)/2,
            QVector4D(0.2f,0.8f,0.0f, 1.6f)/2,
            QVector4D(0.2f,0.0f,0.8f, 1.6f)/2,
            QVector4D(0.0f,0.2f,0.8f, 1.6f)/2,
            QVector4D(0.0f,0.5f,0.5f, 1.6f)/2,
    };

    DotFramebufferObject::RotatePlane m_plane = DotFramebufferObject::XY;
    double m_angleVelocity1 = 0.0;
    double m_angleVelocity2 = 0.0;

    double m_angle1 = 30.0;
    double m_angle2 = 0;
};

#endif //DOT_DOT_RENDER_HPP
