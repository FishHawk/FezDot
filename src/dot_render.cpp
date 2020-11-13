#include "dot_render.hpp"
#include "dot_fbo.hpp"

DotRender::DotRender() {
    initializeOpenGLFunctions();

    program.addCacheableShaderFromSourceFile(QOpenGLShader::Vertex, ":/dot.vert");
    program.addCacheableShaderFromSourceFile(QOpenGLShader::Fragment, ":/dot.frag");
    program.link();
    program.release();

    GenerateVaoLine();
    GenerateVaoFace();

    timer.start();
}

void DotRender::synchronize(QQuickFramebufferObject *item) {
    if (!window)
        window = item->window();

    auto derived = qobject_cast<DotFramebufferObject *>(item);
    m_plane = derived->plane();
    m_angleVelocity1 = derived->velocity1();
    m_angleVelocity2 = derived->velocity2();

    for (int i = 0; i < 8; ++i) {
        auto color = derived->colors()[i];
        m_colors[i].setX(static_cast<float>(color.redF()));
        m_colors[i].setY(static_cast<float>(color.greenF()));
        m_colors[i].setZ(static_cast<float>(color.blueF()));
        m_colors[i].setW(static_cast<float>(color.alphaF()));
    }

    QVector4D face_color[6 * 6 * 8];
    for (int i = 0; i < 8; ++i) {
        for (int j = 0; j < 36; ++j) {
            face_color[i * 36 + j] = m_colors[i];
        }
    }

    vbo_face_color.bind();
    vbo_face_color.setUsagePattern(QOpenGLBuffer::StaticDraw);
    vbo_face_color.allocate(face_color, sizeof(face_color));
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glEnableVertexAttribArray(1);
    vbo_face_color.release();
}

QOpenGLFramebufferObject *DotRender::createFramebufferObject(const QSize &size) {
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
    format.setSamples(1);
    return new QOpenGLFramebufferObject(size, format);
}

void DotRender::render() {
    auto timeInterval = timer.restart();

    m_angle1 += m_angleVelocity1 * 3 * 0.001 * timeInterval;
    m_angle2 += m_angleVelocity2 * 3 * 0.001 * timeInterval;

    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glDisable(GL_DEPTH_TEST);

    glCullFace(GL_BACK);
    glEnable(GL_CULL_FACE);

    glEnable(GL_BLEND);
    glBlendFuncSeparate(GL_ONE, GL_ONE, GL_ONE, GL_ZERO);

    QMatrix4x4 rotate;
    QList<int> index;
    switch (m_plane) {
    case DotFramebufferObject::XY:
        index << 0 << 1 << 2 << 3;
        break;
    case DotFramebufferObject::XZ:
        index << 0 << 2 << 1 << 3;
        break;
    case DotFramebufferObject::XW:
        index << 0 << 3 << 1 << 2;
        break;
    }
    rotate(index[0], index[0]) = static_cast<float>(qCos(m_angle1));
    rotate(index[1], index[1]) = static_cast<float>(qCos(m_angle1));
    rotate(index[0], index[1]) = static_cast<float>(-qSin(m_angle1));
    rotate(index[1], index[0]) = static_cast<float>(qSin(m_angle1));
    rotate(index[2], index[2]) = static_cast<float>(qCos(m_angle2));
    rotate(index[3], index[3]) = static_cast<float>(qCos(m_angle2));
    rotate(index[2], index[3]) = static_cast<float>(-qSin(m_angle2));
    rotate(index[3], index[2]) = static_cast<float>(qSin(m_angle2));

    QMatrix4x4 view;
    view.lookAt(QVector3D(2.0f, 2.5f, 3.0f),
                QVector3D(0.0f, 0.0f, 0.0f),
                QVector3D(0.0f, 1.0f, 0.0f));

    QMatrix4x4 projection;
    projection.ortho(-1.5f, 1.5f, -1.5f, 1.5f, 0.1f, 100.0f);

    program.bind();
    program.setUniformValue("rotate", rotate);
    program.setUniformValue("view", view);
    program.setUniformValue("projection", projection);

    vao_line.bind();
    //        glDrawArrays(GL_LINES, 0, 2 * 32);
    vao_line.release();

    vao_face.bind();
    glDrawArrays(GL_TRIANGLES, 0, 6 * 6 * 8);
    vao_face.release();

    program.release();

    if (window) {
        window->resetOpenGLState();
    } else {
        glDisable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
    }

    update();
}

void DotRender::GenerateVaoLine() {
    QVector4D vertices[16];
    for (int i = 0; i < 16; ++i) {
        for (int j = 0; j < 4; ++j) {
            vertices[i][j] = ((i >> j) & 1) == 0 ? -1.0f : 1.0f;
        }
    }

    QVector4D line_position[2 * 32];
    int index = 0;
    for (int i = 0; i < 16; ++i) {
        for (int j = i; j < 16; ++j) {
            float sum = 0;
            for (int k = 0; k < 4; ++k) {
                sum += abs(vertices[i][k] - vertices[j][k]);
            }
            if (sum == 2) {
                line_position[index++] = vertices[i];
                line_position[index++] = vertices[j];
            }
        }
    }

    QVector4D line_color[2 * 32];
    QVector4D color(0.0f, 0.0f, 0.0f, 1.0f);
    for (auto &c : line_color) {
        c = color;
    }

    vao_line.create();
    vao_line.bind();

    vbo_line_position.create();
    vbo_line_position.bind();
    vbo_line_position.setUsagePattern(QOpenGLBuffer::StaticDraw);
    vbo_line_position.allocate(line_position, sizeof(line_position));
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
    vbo_line_position.release();

    vbo_line_color.create();
    vbo_line_color.bind();
    vbo_line_color.setUsagePattern(QOpenGLBuffer::StaticDraw);
    vbo_line_color.allocate(line_color, sizeof(line_color));
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glEnableVertexAttribArray(1);
    vbo_line_color.release();

    vao_line.release();
}

void DotRender::GenerateVaoFace() {
    QVector3D cube[6 * 6];
    cube[0] = QVector3D(-1, -1, -1);
    cube[1] = QVector3D(-1, -1, +1);
    cube[2] = QVector3D(-1, +1, -1);
    cube[3] = QVector3D(-1, +1, -1);
    cube[4] = QVector3D(-1, -1, +1);
    cube[5] = QVector3D(-1, +1, +1);

    for (int i = 0; i < 2; ++i) {
        for (int j = 0; j < 6; ++j) {
            cube[i * 6 + j + 6].setX(cube[i * 6 + j].y());
            cube[i * 6 + j + 6].setY(cube[i * 6 + j].z());
            cube[i * 6 + j + 6].setZ(cube[i * 6 + j].x());
        }
    }
    cube[18] = QVector3D(+1, -1, -1);
    cube[19] = QVector3D(+1, +1, -1);
    cube[20] = QVector3D(+1, -1, +1);
    cube[21] = QVector3D(+1, -1, +1);
    cube[22] = QVector3D(+1, +1, -1);
    cube[23] = QVector3D(+1, +1, +1);

    for (int i = 3; i < 5; ++i) {
        for (int j = 0; j < 6; ++j) {
            cube[i * 6 + j + 6].setX(cube[i * 6 + j].y());
            cube[i * 6 + j + 6].setY(cube[i * 6 + j].z());
            cube[i * 6 + j + 6].setZ(cube[i * 6 + j].x());
        }
    }

    QVector4D face_position[6 * 6 * 8];
    for (int i = 0; i < 36; ++i) {
        float x = cube[i].x(), y = cube[i].y(), z = cube[i].z();
        face_position[i] = QVector4D(-1.0f, x, y, z);
        face_position[i + 36] = QVector4D(+1.0f, x, y, z);
        face_position[i + 36 * 2] = QVector4D(x, -1.0f, y, z);
        face_position[i + 36 * 3] = QVector4D(x, +1.0f, y, z);
        face_position[i + 36 * 4] = QVector4D(x, y, -1.0f, z);
        face_position[i + 36 * 5] = QVector4D(x, y, +1.0f, z);
        face_position[i + 36 * 6] = QVector4D(x, y, z, -1.0f);
        face_position[i + 36 * 7] = QVector4D(x, y, z, +1.0f);
    }

    QVector4D face_color[6 * 6 * 8];
    for (int i = 0; i < 8; ++i) {
        for (int j = 0; j < 36; ++j) {
            face_color[i * 36 + j] = m_colors[i];
        }
    }

    vao_face.create();
    vao_face.bind();

    vbo_face_position.create();
    vbo_face_position.bind();
    vbo_face_position.setUsagePattern(QOpenGLBuffer::StaticDraw);
    vbo_face_position.allocate(face_position, sizeof(face_position));
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
    vbo_face_position.release();

    vbo_face_color.create();
    vbo_face_color.bind();
    vbo_face_color.setUsagePattern(QOpenGLBuffer::StaticDraw);
    vbo_face_color.allocate(face_color, sizeof(face_color));
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glEnableVertexAttribArray(1);
    vbo_face_color.release();

    vao_face.release();
}