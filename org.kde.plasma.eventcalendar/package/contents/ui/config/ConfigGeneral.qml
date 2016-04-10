
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.calendar 2.0 as PlasmaCalendar
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: generalPage

    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    property alias cfg_widget_show_spacer: widget_show_spacer.checked
    property alias cfg_widget_show_meteogram: widget_show_meteogram.checked
    property alias cfg_widget_show_timer: widget_show_timer.checked
    property alias cfg_clock_24h: clock_24h.checked
    property alias cfg_clock_show_seconds: clock_show_seconds.checked
    property string cfg_clock_fontfamily: ""
    property alias cfg_clock_timeformat: clock_timeformat.text
    property alias cfg_clock_timeformat_2: clock_timeformat_2.text
    property alias cfg_clock_line_2: clock_line_2.checked
    property alias cfg_clock_line_2_height_ratio: clock_line_2_height_ratio.value
    property alias cfg_clock_line_1_bold: clock_line_1_bold.checked
    property alias cfg_clock_line_2_bold: clock_line_2_bold.checked
    property alias cfg_clock_mousewheel_up: clock_mousewheel_up.text
    property alias cfg_clock_mousewheel_down: clock_mousewheel_down.text
    property alias cfg_timer_repeats: timer_repeats.checked
    property alias cfg_timer_in_taskbar: timer_in_taskbar.checked
    property alias cfg_timer_ends_at: timer_ends_at.text

    property string timeFormat24hour: 'hh:mm'
    property string timeFormat12hour: 'h:mm AP'

    property bool showDebug: false
    property int indentWidth: 24

    SystemPalette {
        id: palette
    }

    Layout.fillWidth: true

    // populate
    onCfg_clock_fontfamilyChanged: {
        // org.kde.plasma.digitalclock
        // HACK by the time we populate our model and/or the ComboBox is finished the value is still undefined
        if (cfg_clock_fontfamily) {
            for (var i = 0, j = clock_fontfamilyComboBox.model.length; i < j; ++i) {
                if (clock_fontfamilyComboBox.model[i].value == cfg_clock_fontfamily) {
                    clock_fontfamilyComboBox.currentIndex = i
                    break
                }
            }
        }
    }

    function onClockFormatChange() {
        var combinedFormat = cfg_clock_timeformat;
        if (cfg_clock_line_2) {
            combinedFormat += '\n' + cfg_clock_timeformat_2;
        }
        var is12hour = combinedFormat.toLowerCase().indexOf('ap') >= 0;
        cfg_clock_24h = !is12hour;
        cfg_clock_show_seconds = combinedFormat.indexOf('s') >= 0
    }

    // Component.onCompleted: {
    //     cfg_clock_timeformat = 'h:mm ap'
    //     cfg_clock_timeformat_2 = 'MMM d, yyyy'
    //     cfg_clock_line_2 = true
    // }



    ColumnLayout {
        id: pageColumn
        Layout.fillWidth: true

        PlasmaExtras.Heading {
            level: 2
            text: i18n("Widgets")
            color: palette.text
        }
        Item {
            width: height
            height: units.gridUnit / 2
        }
        ColumnLayout {
            Text {
                text: "Show/Hide widgets above the calendar."
            }
            CheckBox {
                Layout.fillWidth: true
                id: widget_show_spacer
                text: "Spacer"
            }
            CheckBox {
                Layout.fillWidth: true
                id: widget_show_meteogram
                text: "Meteogram"
            }
            CheckBox {
                Layout.fillWidth: true
                id: widget_show_timer
                text: "Timer"
            }
        }

        
        Item {
            width: height
            height: units.gridUnit / 2
        }
        PlasmaExtras.Heading {
            level: 2
            text: i18n("Clock")
            color: palette.text
        }
        Item {
            width: height
            height: units.gridUnit / 2
        }
        ColumnLayout {
            PlasmaExtras.Heading {
                level: 3
                text: i18n("Time Format")
                color: palette.text
            }

            CheckBox {
                Layout.fillWidth: true
                id: clock_24h
                text: i18n("24 hour clock")

                onClicked: {
                    cfg_clock_timeformat = cfg_clock_24h ? timeFormat24hour : timeFormat12hour
                }
            }
            CheckBox {
                visible: showDebug
                Layout.fillWidth: true
                id: clock_show_seconds
                text: i18n("Show Seconds")
            }

            RowLayout {
                Label {
                    text: "Font:"
                }
                ComboBox {
                    // org.kde.plasma.digitalclock
                    Layout.fillWidth: true
                    id: clock_fontfamilyComboBox
                    textRole: "text" // doesn't autodeduce from model because we manually populate it

                    Component.onCompleted: {
                        // org.kde.plasma.digitalclock
                        var arr = [] // use temp array to avoid constant binding stuff
                        arr.push({text: i18nc("Use default font", "Default"), value: ""})

                        var fonts = Qt.fontFamilies()
                        var foundIndex = 0
                        for (var i = 0, j = fonts.length; i < j; ++i) {
                            arr.push({text: fonts[i], value: fonts[i]})
                        }
                        model = arr
                    }

                    onCurrentIndexChanged: {
                        var current = model[currentIndex]
                        if (current) {
                            generalPage.cfg_clock_fontfamily = current.value
                        }
                    }
                }
            }

            Text {
                text: '<a href="http://doc.qt.io/qt-5/qml-qtqml-qt.html#formatDateTime-method">Time Format Documentation</a>'
                color: "#8a6d3b"
                linkColor: "#369"
                onLinkActivated: Qt.openUrlExternally(link)
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
                    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
            }

            GroupBox {
                Layout.fillWidth: true

                ColumnLayout {
                    RowLayout {
                        Layout.fillWidth: true
                        CheckBox {
                            enabled: false
                            checked: true
                            text: i18n("Line 1:")
                        }
                        TextField {
                            Layout.fillWidth: true
                            id: clock_timeformat
                            onTextChanged: onClockFormatChange()
                        }
                        Label {
                            text: Qt.formatDateTime(new Date(), cfg_clock_timeformat)
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { width: indentWidth } // indent
                        CheckBox {
                            id: clock_line_1_bold
                            text: i18n("Bold")
                        }
                    }
                }
            }

            GroupBox {
                Layout.fillWidth: true

                ColumnLayout {
                    RowLayout {
                        Layout.fillWidth: true
                        CheckBox {
                            id: clock_line_2
                            checked: false
                            onCheckedChanged: onClockFormatChange()
                            text: i18n("Line 2:")
                        }
                        TextField {
                            Layout.fillWidth: true
                            id: clock_timeformat_2
                            onTextChanged: onClockFormatChange()
                        }
                        Label {
                            text: Qt.formatDateTime(new Date(), cfg_clock_timeformat_2)
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { width: indentWidth } // indent
                        Label {
                            text: "Preset:"
                        }
                        Button {
                            property string dateFormat: {
                                // org.kde.plasma.digitalclock
                                // remove "dddd" from the locale format string
                                // /all/ locales in LongFormat have "dddd" either
                                // at the beginning or at the end. so we just
                                // remove it + the delimiter and space
                                var format = Qt.locale().dateFormat(Locale.LongFormat);
                                format = format.replace(/(^dddd.?\s)|(,?\sdddd$)/, "");
                                return;
                            }
                            text: Qt.formatDate(new Date(), dateFormat)
                            onClicked: cfg_clock_timeformat_2 = dateFormat
                        }
                        Button {
                            property string dateFormat: Qt.locale().dateFormat(Locale.ShortFormat);
                            text: Qt.formatDate(new Date(), dateFormat)
                            onClicked: cfg_clock_timeformat_2 = dateFormat
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { width: indentWidth } // indent
                        CheckBox {
                            id: clock_line_2_bold
                            text: i18n("Bold")
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { width: indentWidth } // indent
                        Label {
                            text: "Height:"
                        }
                        Slider {
                            id: clock_line_2_height_ratio
                            minimumValue: 0.3
                            maximumValue: 0.7
                            stepSize: 0.05
                            value: 0.4
                            Layout.fillWidth: true
                            // orientation: Qt.Vertical
                        }
                        Label {
                            text: Math.floor(cfg_clock_line_2_height_ratio * 100) + '%'
                        }
                    }
                }
            }



            Item {
                width: height
                height: units.gridUnit / 2
            }
            PlasmaExtras.Heading {
                level: 3
                text: i18n("Mouse Wheel")
                color: palette.text
            }
            Button {
                text: 'amixer (No UI)'
                onClicked: {
                    cfg_clock_mousewheel_up = 'amixer -q sset Master 10%+'
                    cfg_clock_mousewheel_down = 'amixer -q sset Master 10%-'
                }
            }
            RowLayout {
                Button {
                    text: 'xdotool (UI)'
                    onClicked: {
                        cfg_clock_mousewheel_up = 'xdotool key XF86AudioRaiseVolume'
                        cfg_clock_mousewheel_down = 'xdotool key XF86AudioLowerVolume'
                    }
                }
                Label {
                    text: 'sudo apt-get install xdotool'
                }
            }
            

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: i18n("Mouse Wheel Up:")
                }
                TextField {
                    Layout.fillWidth: true
                    id: clock_mousewheel_up
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: i18n("Mouse Wheel Down:")
                }
                TextField {
                    Layout.fillWidth: true
                    id: clock_mousewheel_down
                }
            }
        }

        PlasmaExtras.Heading {
            visible: showDebug
            level: 2
            text: i18n("Timer")
            color: palette.text
        }
        Item {
            visible: showDebug
            width: height
            height: units.gridUnit / 2
        }
        ColumnLayout {
            RowLayout {
                visible: showDebug
                Layout.fillWidth: true
                Label {
                    text: i18n("timer_repeats:")
                }
                PlasmaComponents.Switch {
                    id: timer_repeats
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                visible: showDebug
                Layout.fillWidth: true
                Label {
                    text: i18n("timer_in_taskbar:")
                }
                PlasmaComponents.Switch {
                    id: timer_in_taskbar
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                visible: showDebug
                Layout.fillWidth: true
                Label {
                    text: i18n("timer_ends_at:")
                }
                TextField {
                    id: timer_ends_at
                    Layout.fillWidth: true
                }
            }
        }
    }
}