include <openscad-common/PanelMountUsbConnectors.scad>

DEFAULT_PANEL_SIZE = [500, 60, 3];
DEFAULT_NUM_CONN_GROUP = 2;
DEFAULT_CONN_PER_GROUP = 10;
DEFAULT_SUPPORT_WIDTH = 18;
DEFAULT_SCREW_HOLE_RADIUS = 3.2; // Hole for M3 screw

function calc_xPerGroup(size, supportWidth, numConnGroups)
    = (size[0] - supportWidth * 2) / numConnGroups;

module UsbHangerPanel2D(
    size = DEFAULT_PANEL_SIZE,
    numConnGroups = DEFAULT_NUM_CONN_GROUP,
    connPerGroup = DEFAULT_CONN_PER_GROUP,
    supportWidth = DEFAULT_SUPPORT_WIDTH,
    showBodyPreview = true)
{
    yPos = size[1] / 2;

    xPerGroup = calc_xPerGroup(size, supportWidth, numConnGroups);
    xUsbSpacing = xPerGroup / (connPerGroup + 1);

    difference()
    {
        // Main panel body
        square([size[0], size[1]]);

        for (x1 = [0 : numConnGroups - 1])
        for (x2 = [1 : connPerGroup])
        {
            // Holes for panel mount USB connectors
            xPos = supportWidth
                + x1 * xPerGroup
                + x2 * xUsbSpacing;
            translate([xPos, yPos])
            PanelMountSingleUsbCutout(showBodyPreview = showBodyPreview);

            // Notches for loop cables back over the top of the panel
            cableNotchSize = 7;
            if (x2 != connPerGroup)
            {
                xPos = supportWidth
                    + x1 * xPerGroup
                    + (x2 + 0.5) * xUsbSpacing
                    - cableNotchSize / 2;
                translate([xPos, size[1] - cableNotchSize])
                square([cableNotchSize, cableNotchSize]);
            }
        }

        // Notches for holders
        for (x1 = [0 : numConnGroups])
        {
            translate([x1 * xPerGroup + supportWidth / 2, 0])
            square([supportWidth, size[1] / 2]);
        }
    }
}

module UsbHangerPanel3D(
    size = DEFAULT_PANEL_SIZE,
    numConnGroups = DEFAULT_NUM_CONN_GROUP,
    connPerGroup = DEFAULT_CONN_PER_GROUP,
    supportWidth = DEFAULT_SUPPORT_WIDTH)
{
    linear_extrude(size[2])
    UsbHangerPanel2D(size, numConnGroups, connPerGroup, supportWidth, showBodyPreview = false);

    // USB connector bodies (a lot of this code is similar to UsbHangerPanel2D)
    yPos = size[1] / 2 - USB_BODY_SIZE[1] / 2;
    zPos = -USB_BODY_SIZE[2] - size[2];
    xPerGroup = calc_xPerGroup(size, supportWidth, numConnGroups);
    xUsbSpacing = xPerGroup / (connPerGroup + 1);
    for (x1 = [0 : numConnGroups - 1])
    for (x2 = [1 : connPerGroup])
    {
        xPos = supportWidth
            + x1 * xPerGroup
            + x2 * xUsbSpacing
            - USB_BODY_SIZE[0] / 2;
        translate([xPos, yPos, zPos])
        cube(USB_BODY_SIZE);
    }
}

module QuarterCircle(radius)
{
    difference()
    {
        circle(r = radius);

        translate([-radius, -radius])
        {
            square([radius, radius * 2]);
            square([radius * 2, radius]);
        }
    }
}

module UsbHangerHolder2D(
    panelSize = DEFAULT_PANEL_SIZE,
    supportWidth = DEFAULT_SUPPORT_WIDTH,
    screwHoleRadius = DEFAULT_SCREW_HOLE_RADIUS)
{
    difference()
    {
        QuarterCircle(panelSize[1] * 1.5);

        // Slot for panel
        rotate([0, 0, 45])
        translate([panelSize[1] * 1, 0])
        square([panelSize[1], panelSize[2]]);

        // Screw holes
        translate([panelSize[1] * 1.25, panelSize[1] * 0.25]) circle(screwHoleRadius, $fn = 60);
        translate([panelSize[1] * 0.25, panelSize[1] * 1.25]) circle(screwHoleRadius, $fn = 60);
        translate([panelSize[1] * 0.25, panelSize[1] * 0.25]) circle(screwHoleRadius, $fn = 60);
    }
}

module UsbHangerHolder3D(
    panelSize = DEFAULT_PANEL_SIZE,
    supportWidth = DEFAULT_SUPPORT_WIDTH)
{
    linear_extrude(supportWidth)
    UsbHangerHolder2D(panelSize, supportWidth);
}

module UsbHangerAssembly3D(
    size = DEFAULT_PANEL_SIZE,
    numConnGroups = DEFAULT_NUM_CONN_GROUP,
    connPerGroup = DEFAULT_CONN_PER_GROUP,
    supportWidth = DEFAULT_SUPPORT_WIDTH)
{
    // Supports
    xPerGroup = calc_xPerGroup(size, supportWidth, numConnGroups);
    for (x1 = [0 : numConnGroups])
    {
        translate([x1 * xPerGroup + supportWidth / 2, 0])
        rotate([0, 270, 180])
        UsbHangerHolder3D();
    }

    // Panel
    rotate([180 - 45, 0, 0])
    translate([0, size[1] / 2])
    #UsbHangerPanel3D(size, numConnGroups, connPerGroup, supportWidth);

    // Wall
    color("yellow")
    translate([-100, 0, -100])
    cube([size[0] + 200, 20, 300]);
}

//UsbHangerPanel2D();
//UsbHangerPanel3D();

//UsbHangerHolder2D();
//UsbHangerHolder3D();

//UsbHangerAssembly3D();
