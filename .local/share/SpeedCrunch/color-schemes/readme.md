# SpeedCrunch colour schemes

As of writing this, [their documentaion](https://speedcrunch.org/advanced/colorschemeformat.html) tells you to put the colour scheme json files in ``~/.local/SpeedCrunch/color-schemes``. This is wrong however. The actual path can be found in [Qt's official documentation](https://doc.qt.io/qt-5/qstandardpaths.html#StandardLocation-enum) (path type is ``AppDataLocation`` - [source](https://bitbucket.org/heldercorreia/speedcrunch/src/74756f3438149c01e9edc3259b0f411fa319a22f/src/core/settings.cpp#lines-75)).
