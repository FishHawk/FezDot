#ifndef BACKEND_HPP
#define BACKEND_HPP

#include <QObject>

#include "dot_fbo.hpp"

class Backend : public QObject {
    Q_OBJECT
public:
    Q_PROPERTY(QStringList themes MEMBER m_themes NOTIFY themesChanged)
    Q_PROPERTY(DotFramebufferObject *dot READ dot CONSTANT)

    DotFramebufferObject *dot() { return m_dot; }

signals:
    void themesChanged();

private:
    QStringList m_themes;
    DotFramebufferObject *m_dot;

public:
    Backend();
};

#endif