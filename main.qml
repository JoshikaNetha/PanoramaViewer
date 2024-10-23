
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick3D

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Dynamic Hotspots VR Tour")
    property var house:["qrc:/images/shot-panoramic-composition-bedroom.jpg",
                        "qrc:/images/shot-panoramic-composition-living-room.jpg",
                        "qrc:/images/shot-panoramic-composition-living-room(1).jpg",
                        "qrc:/images/pexels-borja-lopez-1059078.jpg"]
    // Define a property to manage the current texture or scene
    property string currentTexture: house[0]
    property bool doorVisible: false // Property to control door visibility

    View3D {
        anchors.fill: parent

        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 0, 0) // Set the camera position
            eulerRotation: Qt.vector3d(0, 0, 0) // Adjust these values to change the view direction
        }

        DirectionalLight {
            ambientColor: "white"  //changing whole screen color
        }



        // Model representing a door or some condition to show hotspots
        Model {
            id: doorModel
            source: "#Door" // Replace with actual door model source
            scale: Qt.vector3d(1, 1, 1) // Adjust scale as needed
            position: Qt.vector3d(0, 0, 0) // Position of the door

            // Use this to set visibility based on condition
            visible: doorVisible
        }

        // Sphere representing the room
        Model {
            id: sphere
            source: "#Sphere"
            scale: Qt.vector3d(-5, 5, 5) // Scale to invert sphere so texture is visible inside
            materials: [
                DefaultMaterial {
                    id: material
                    diffuseMap: Texture {
                        id: texture
                        source: currentTexture // Use the current texture
                    }
                }
            ]
        }

        // MouseArea for rotating and zooming
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            property real lastX: 0
            property real lastY: 0
            property bool dragging: false

            onPressed: function(mouse) {
                lastX = mouse.x
                lastY = mouse.y
                dragging = true
            }

            onReleased: function() {
                dragging = false
            }

            onPositionChanged: function(mouse) {
                if (dragging) {
                    let dx = mouse.x - lastX
                    let dy = mouse.y - lastY
                    lastX = mouse.x
                    lastY = mouse.y

                    // Rotate the camera based on mouse movement
                    camera.eulerRotation.y -= dx * 0.1 // Rotate around Y axis
                    camera.eulerRotation.x -= dy * 0.1 // Rotate around X axis
                }
            }

            onWheel: function(wheel) {
                // Zoom in and out based on the wheel delta
                camera.position.z += wheel.angleDelta.y * 0.05
            }
        }

        // Dynamic hotspot for navigating to another room
        Rectangle {
            id:                 hotspot
            width:              parent.width * 0.1
            height:             parent.height
            color:              "transparent"
            radius:             25
            anchors.left:       parent.left
            anchors.top:        parent.top

            Column{
                spacing:   5
                Repeater{
                    model: ["Hall","Living Room","BedRoom" ,"Kitchen"]
                    delegate:Rectangle{
                        width:     100
                        height:    50
                        opacity:   0.8
                        color:     "transparent"
                        border.color: "white"
                        radius:       height / 10
                        Text {
                            anchors.centerIn: parent
                            text:             modelData
                            color:            "black"
                            font.pixelSize:   12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: function() {
                                // Change the texture to navigate to another room
                                console.log("[ModelData] ",modelData)
                                currentTexture = house[index]
                            }
                        }
                    }
                }
            }

            // Show or hide the hotspot based on the visibility of the door
            // visible: doorVisible
        }

        // Example function to update door visibility
        Timer {
            interval: 3000 // Update every 3 seconds for demonstration
            running: true
            repeat: true
            onTriggered: {
                // Example condition: Toggle door visibility
                doorVisible = !doorVisible
            }
        }
    }
}






























// below code to working fine
// import QtQuick 2.15
// import QtQuick.Window 2.15
// import QtQuick3D
// Window {
//     width: Screen.width
//     height: Screen.height
//     visible: true
//     title: qsTr("Hello World")
//     // Define a property to manage the current texture or scene
//           property string currentTexture: "file:///home/joshikanamani/Downloads/istockphoto-1321116143-1024x1024.jpg"



//     View3D {
//         anchors.fill: parent

//         PerspectiveCamera {
//             id: camera
//             position: Qt.vector3d(0, 0, 10) // Set the camera position
//             eulerRotation: Qt.vector3d(0, 0, 0) // Adjust these values to change the view direction
//         }

//         DirectionalLight {
//             ambientColor: "white"
//             // intensity: 0.8
//         }

//         Model {
//             id: sphere
//             source: "#Sphere"
//             scale: Qt.vector3d(-5, 5, 5) // Scale to invert sphere so texture is visible inside
//             materials: [
//                 DefaultMaterial {
//                     id: material
//                     diffuseMap: Texture {
//                         source: currentTexture
//                     }
//                 }
//             ]
//         }
//         MouseArea {
//             id: mouseArea
//             anchors.fill: parent
//             property real lastX: 0
//             property real lastY: 0
//             property bool dragging: false

//             onPressed: {
//                 lastX = mouse.x
//                 lastY = mouse.y
//                 dragging = true
//             }

//             onReleased: {
//                 dragging = false
//             }

//             onPositionChanged: {
//                 if (dragging) {
//                     let dx = mouse.x - lastX
//                     let dy = mouse.y - lastY
//                     lastX = mouse.x
//                     lastY = mouse.y

//                     // Rotate the camera based on mouse movement
//                     camera.eulerRotation.y -= dx * 0.1 // Rotate around Y axis
//                     camera.eulerRotation.x -= dy * 0.1 // Rotate around X axis
//                 }
//             }
//             onWheel: {
//                 // Zoom in and out based on the wheel delta
//                 camera.position.z += wheel.angleDelta.y * 0.01
//             }
//         }

//         // Hotspot for navigating to another room
//         Rectangle {
//             width: 50
//             height: 50
//             color: "red"
//             radius: 25
//             anchors.centerIn: parent
//             anchors.bottom: parent.bottom
//             anchors.right: parent.right
//             anchors.bottomMargin: 20
//             anchors.rightMargin: 20

//             Text {
//                 anchors.centerIn: parent
//                 text: "Room 2"
//                 color: "white"
//                 font.pixelSize: 12
//             }

//             MouseArea {
//                 anchors.fill: parent
//                 onClicked: function() {
//                     // Change the texture to navigate to another room
//                     currentTexture = "file:///home/joshikanamani/Downloads/istockphoto-1705035753-1024x1024.jpg"
//                 }
//             }
//         }

//     }
// }
