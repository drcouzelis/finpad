# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = finpad

CONFIG += sailfishapp

SOURCES += \
    src/finpad.cpp

OTHER_FILES += qml/finpad.qml \
    qml/cover/CoverPage.qml \
    rpm/finpad.spec \
    rpm/finpad.yaml \
    finpad.desktop \
    qml/pages/EditPage.qml \
    qml/pages/OpenPage.qml \
    qml/pages/SavePage.qml

HEADERS += \
    src/finpad.h

