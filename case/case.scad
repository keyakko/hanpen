include <BOSL2/std.scad>

PCB_THICKNESS = 1;
PCB_OUTER_WIDTH = 42;
PCB_OUTER_HEIGHT = 56;

WALL_THICKNESS = 2;

ESP_MODULE_PCB_THICKNESS = 1.2;
USB_C_OUTER_WIDTH = 9.5;
USB_C_OUTER_HEIGHT = 3.5;

BOLT_DIAMETER = 3;
INSERT_NUT_DIAMETER = 4;
SCREW_HOLE_MERGIN = 8;

SW_WIDTH = 4;
SW_HEIGHT = 2;
SW_OFFSET_BOTTOM = 1.5;

$fn = 100;

// コーナー準備
module _bottomCorner(height) {
  difference() {
    cuboid(
      [SCREW_HOLE_MERGIN, SCREW_HOLE_MERGIN, height],
      // rounding=SCREW_HOLE_MERGIN / 2,
      chamfer=BOLT_DIAMETER,
      edges=[FRONT+RIGHT, BACK+LEFT],
      anchor=BOTTOM
    );
    #union() {
      cylinder(h=height, d=BOLT_DIAMETER + 0.3);
      // regular_prism(6, r=3, h=3, anchor=BOTTOM);
    }
  }
}

module bottomCase(batteryHeight) {
  // コーナー準備
  translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, 0])
  rotate([0, 0, 90])
    _bottomCorner(batteryHeight);
  translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, 0])
    _bottomCorner(batteryHeight);
  translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), 0])
    _bottomCorner(batteryHeight);
  translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), 0])
  rotate([0, 0, 90])
    _bottomCorner(batteryHeight);

  // usb下部分
  translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS / 2 + 0.2, -2.5, PCB_THICKNESS + batteryHeight])
  difference() {
    cuboid(
      [
        WALL_THICKNESS - 0.2,
        USB_C_OUTER_WIDTH + 8, // 8: offset,
        ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2),
      ],
      anchor=BOTTOM
    );

    union() {
      translate([0, 0, ESP_MODULE_PCB_THICKNESS - 0.1])
      cuboid(
        [
          WALL_THICKNESS + 0.2,
          USB_C_OUTER_WIDTH,
          USB_C_OUTER_HEIGHT,
        ],
        rounding=USB_C_OUTER_HEIGHT / 2,
        edges=[TOP+FRONT, TOP+BACK, BOTTOM+FRONT, BOTTOM+BACK],
        anchor=BOTTOM
      );

      translate([0, - USB_C_OUTER_WIDTH / 2, ESP_MODULE_PCB_THICKNESS - 0.1])
      cuboid(
        [
          WALL_THICKNESS + 0.2,
          10,
          USB_C_OUTER_HEIGHT,
        ],
        anchor=BOTTOM
      );
    }
  }

  // switch
  // translate([0, -PCB_OUTER_WIDTH / 2 + WALL_THICKNESS / 2, PCB_THICKNESS + batteryHeight])
  // difference() {
  //   cuboid(
  //     [
  //       SW_WIDTH + 4, // 4: offset,
  //       WALL_THICKNESS,
  //       SW_OFFSET_BOTTOM + SW_HEIGHT,
  //     ],
  //     anchor=BOTTOM
  //   );

  //   translate([0, -0.1, SW_OFFSET_BOTTOM])
  //   cuboid(
  //     [
  //       SW_WIDTH,
  //       WALL_THICKNESS + 0.2,
  //       SW_HEIGHT,
  //     ],
  //     edges=[TOP+FRONT, TOP+BACK, BOTTOM+FRONT, BOTTOM+BACK],
  //     anchor=BOTTOM
  //   );
  // }
  translate([0, -PCB_OUTER_WIDTH / 2 + WALL_THICKNESS / 2, PCB_THICKNESS + batteryHeight])
  cuboid(
    [
      SW_WIDTH + 4, // 4: offset,
      WALL_THICKNESS,
      SW_OFFSET_BOTTOM,
    ],
    anchor=BOTTOM
  );
}

BOTTOM_THICKNESS = 1;
module bottom(height) {
  MOUNTER_HEIGHT = 3;
  difference() {
    union() {
      translate([0, 0, MOUNTER_HEIGHT])
      prismoid(
        [PCB_OUTER_HEIGHT, PCB_OUTER_WIDTH],
        [PCB_OUTER_HEIGHT, PCB_OUTER_WIDTH],
        rounding=1,
        // rounding2=SCREW_HOLE_MERGIN / 2,
        h=height - MOUNTER_HEIGHT
      );
      cuboid(
        [PCB_OUTER_HEIGHT, PCB_OUTER_WIDTH, MOUNTER_HEIGHT],
        anchor=BOTTOM
      );

      // マウント
      difference() {
        union() {
          cuboid(
            [
              PCB_OUTER_HEIGHT,
              PCB_OUTER_WIDTH + (10 * 2),
              MOUNTER_HEIGHT
            ],
            rounding=1,
            edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
            anchor=BOTTOM
          );

          translate([PCB_OUTER_HEIGHT / 2 - 1, 0, MOUNTER_HEIGHT - 0.05])
          prismoid(
            size1=[
              2,
              PCB_OUTER_WIDTH + (10 * 2),
            ],
            size2=[
              2,
              PCB_OUTER_WIDTH,
            ],
            rounding=1,
            h=height - MOUNTER_HEIGHT + 0.05
          );

          translate([-PCB_OUTER_HEIGHT / 2 + 1, 0, MOUNTER_HEIGHT - 0.05])
          prismoid(
            size1=[
              2,
              PCB_OUTER_WIDTH + (10 * 2),
            ],
            size2=[
              2,
              PCB_OUTER_WIDTH,
            ],
            rounding=1,
            h=height - MOUNTER_HEIGHT + 0.05
          );
        }
        cuboid(
          [
            PCB_OUTER_HEIGHT - (2 * 2),
            PCB_OUTER_WIDTH + (5 * 2),
            height
          ],
          rounding=1,
          edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
          anchor=BOTTOM
        );
      }
    }
    translate([0, 0, BOTTOM_THICKNESS])
    cuboid(
      [
        PCB_OUTER_HEIGHT - (WALL_THICKNESS * 2) + 0.2,
        PCB_OUTER_WIDTH - (WALL_THICKNESS * 2) + 0.2,
        height - BOTTOM_THICKNESS + 0.1,
      ],
      rounding=INSERT_NUT_DIAMETER / 2,
      edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
      anchor=BOTTOM
    );
  }

}
HEIGHT = 8;
// difference() {
//   union() {
//     translate([0, 0, 0])
//       bottomCase(HEIGHT);
//     translate([0, 0, -BOTTOM_THICKNESS])
//       bottom(PCB_THICKNESS + HEIGHT + BOTTOM_THICKNESS);

//   }
//   translate([0, 0, -BOTTOM_THICKNESS])
//   #union() {
//     translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, 0])
//     // rotate([0, 0, 90])
//       zrot(15)
//       regular_prism(6, r=3.4, h=3, anchor=BOTTOM);
//     translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, 0])
//       zrot(45)
//       regular_prism(6, r=3.4, h=3, anchor=BOTTOM);
//     translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), 0])
//       zrot(45)
//       regular_prism(6, r=3.4, h=3, anchor=BOTTOM);
//     translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), 0])
//       zrot(15)
//     // rotate([0, 0, 90])
//       regular_prism(6, r=3.4, h=3, anchor=BOTTOM);
//   }
// }


module topCase(height) {
  difference() {
    union() {
      // 外装
      difference() {
        union() {
          // 1.4 = sqrt(2)
          FILLET_HEIGHT = 0;
          // ケース外装ベース
          prismoid(
            [PCB_OUTER_HEIGHT, PCB_OUTER_WIDTH],
            [PCB_OUTER_HEIGHT, PCB_OUTER_WIDTH],
            rounding1=1,
            rounding2=SCREW_HOLE_MERGIN / 2 + (1.4 * FILLET_HEIGHT),
            h=height - FILLET_HEIGHT,
            anchor=BOTTOM
          );
          // translate([0, 0, height - FILLET_HEIGHT])
          // prismoid(
          //   [PCB_OUTER_HEIGHT, PCB_OUTER_WIDTH],
          //   [PCB_OUTER_HEIGHT - (FILLET_HEIGHT * 2), PCB_OUTER_WIDTH - (FILLET_HEIGHT * 2)],
          //   rounding1=SCREW_HOLE_MERGIN / 2 - 1 + (1.4 * FILLET_HEIGHT),
          //   rounding2=SCREW_HOLE_MERGIN / 2 - 1,
          //   h=FILLET_HEIGHT,
          //   anchor=BOTTOM
          // );
        }
        union() {
          // くり抜き
          difference() {
            cuboid(
              [
                PCB_OUTER_HEIGHT - (WALL_THICKNESS * 2),
                PCB_OUTER_WIDTH - (WALL_THICKNESS * 2),
                height - WALL_THICKNESS,
              ],
              anchor=BOTTOM
            );

          // ネジ周辺
          translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, 0])
          rotate([0, 0, 90])
            cuboid(
              [SCREW_HOLE_MERGIN, SCREW_HOLE_MERGIN, height - 1],
              rounding=SCREW_HOLE_MERGIN / 2,
              edges=[FRONT+RIGHT, BACK+LEFT],
              anchor=BOTTOM
            );
          translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, 0])
            cuboid(
              [SCREW_HOLE_MERGIN, SCREW_HOLE_MERGIN, height - 1],
              rounding=SCREW_HOLE_MERGIN / 2,
              edges=[FRONT+RIGHT, BACK+LEFT],
              anchor=BOTTOM
            );
          translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), 0])
            cuboid(
              [SCREW_HOLE_MERGIN, SCREW_HOLE_MERGIN, height - 1],
              rounding=SCREW_HOLE_MERGIN / 2,
              edges=[FRONT+RIGHT, BACK+LEFT],
              anchor=BOTTOM
            );
          translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), 0])
          rotate([0, 0, 90])
            cuboid(
              [SCREW_HOLE_MERGIN, SCREW_HOLE_MERGIN, height - 1],
              rounding=SCREW_HOLE_MERGIN / 2,
              edges=[FRONT+RIGHT, BACK+LEFT],
              anchor=BOTTOM
            );
          }
          // aux
          translate([-PCB_OUTER_HEIGHT / 2 + WALL_THICKNESS / 2, 0, 0])
          cuboid(
            [WALL_THICKNESS, 15.9 + 0.2, 5.75 + 0.2],
            anchor=BOTTOM
          );
          // usb
          translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS / 2, -2.5, 0])
          color("red")
          union() {
            translate([0, 2, 0])
            cuboid(
              [
                WALL_THICKNESS,
                USB_C_OUTER_WIDTH + 4 + 0.2, // 4: offset,
                ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2),
              ],
              anchor=BOTTOM
            );
            cuboid(
              [
                WALL_THICKNESS,
                USB_C_OUTER_WIDTH + 8 + 0.2, // 8: offset,
                ESP_MODULE_PCB_THICKNESS,
              ],
              anchor=BOTTOM
            );
            translate([0, -2, 0])
            cuboid(
              [
                WALL_THICKNESS,
                USB_C_OUTER_WIDTH,
                ESP_MODULE_PCB_THICKNESS + 2,
              ],
              anchor=BOTTOM
            );
            translate([0, 0, ESP_MODULE_PCB_THICKNESS - 0.1])
            cuboid(
              [
                WALL_THICKNESS + 0.2,
                USB_C_OUTER_WIDTH,
                USB_C_OUTER_HEIGHT,
              ],
              rounding=USB_C_OUTER_HEIGHT / 2,
              edges=[TOP+FRONT, TOP+BACK, BOTTOM+FRONT, BOTTOM+BACK],
              anchor=BOTTOM
            );
          }

          // switch
          translate([0, -PCB_OUTER_WIDTH / 2 + WALL_THICKNESS / 2, 0])
          cuboid(
            [
              SW_WIDTH + 4 + 0.4, // 4: offset,
              WALL_THICKNESS,
              SW_OFFSET_BOTTOM,
            ],
            anchor=BOTTOM
          );
          translate([0, -PCB_OUTER_WIDTH / 2 + WALL_THICKNESS / 2, 0])
          cuboid(
            [
              SW_WIDTH + 0.2, // 4: offset,
              WALL_THICKNESS,
              SW_OFFSET_BOTTOM + 2,
            ],
            anchor=BOTTOM
          );
        }
      }

      // usb
      translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS * 1.5, -2.5 - 1 - 1 - (USB_C_OUTER_WIDTH / 2), ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2)])
      #cuboid([WALL_THICKNESS * 3, 4, height - (ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2)) - 1], anchor=BOTTOM);
      translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS * 1.5, -2.5 - 1 - 2 - (USB_C_OUTER_WIDTH / 2), ESP_MODULE_PCB_THICKNESS])
      #cuboid([WALL_THICKNESS * 3, 2, height - (ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2)) - 1], anchor=BOTTOM);
      translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS * 2.5, -2.5 - 1 - 1 - (USB_C_OUTER_WIDTH / 2), ESP_MODULE_PCB_THICKNESS])
      #cuboid([2, 4, height - (ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2)) - 1], anchor=BOTTOM);
      // translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS * 2, -2.5 - 1 - USB_C_OUTER_WIDTH / 2 , ESP_MODULE_PCB_THICKNESS])
      // #cuboid([WALL_THICKNESS, 2, height - (ESP_MODULE_PCB_THICKNESS + (USB_C_OUTER_HEIGHT / 2)) - 1], anchor=BOTTOM);
      // translate([PCB_OUTER_HEIGHT / 2 - WALL_THICKNESS * 2, -2.5 - 1 - USB_C_OUTER_WIDTH / 2 , ESP_MODULE_PCB_THICKNESS])
      // #prismoid(
      //   size1=[0, 2],
      //   size2=[WALL_THICKNESS * 2, 2],
      //   shift=[WALL_THICKNESS, 0],
      //   h=(USB_C_OUTER_HEIGHT / 2),
      //   anchor=BOTTOM
      // );

      // switch
      // translate([SW_WIDTH * 2.5, - PCB_OUTER_WIDTH / 2 + WALL_THICKNESS * 1.5, 1.5])
      // cuboid([2, WALL_THICKNESS, height - 1.5], anchor=BOTTOM);


    }
    // 削除
    union() {
      // ねじ穴
      // translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, -0.5])
      // rotate([0, 0, 90])
      //   #cyl(h=height, d=BOLT_DIAMETER + 0.1, chamfer2=-1, chamfang=45, anchor=BOTTOM);
      // translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, -0.5])
      //   #cyl(h=height, d=BOLT_DIAMETER + 0.1, chamfer2=-1, chamfang=45, anchor=BOTTOM);
      // translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), -0.5])
      //   #cyl(h=height, d=BOLT_DIAMETER + 0.1, chamfer2=-1, chamfang=45, anchor=BOTTOM);
      // translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), -0.5])
      // rotate([0, 0, 90])
      //   #cyl(l=height, r=BOLT_DIAMETER / 2 + 0.1, chamfer2=-1, chamfang=45, anchor=BOTTOM);
      translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, -0.5])
      rotate([0, 0, 90])
        #cyl(h=height, d=BOLT_DIAMETER + 0.2, anchor=BOTTOM);
      translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, -0.5])
        #cyl(h=height, d=BOLT_DIAMETER + 0.2, anchor=BOTTOM);
      translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), -0.5])
        #cyl(h=height, d=BOLT_DIAMETER + 0.2, anchor=BOTTOM);
      translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), -0.5])
      rotate([0, 0, 90])
        #cyl(l=height, r=BOLT_DIAMETER / 2 + 0.4, anchor=BOTTOM);

      TOP_COVER_BOLT_LENGTH = 15 - (PCB_THICKNESS + HEIGHT + BOTTOM_THICKNESS);
      translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, TOP_COVER_BOLT_LENGTH])
      rotate([0, 0, 90])
        #cyl(h=height - TOP_COVER_BOLT_LENGTH, r=BOLT_DIAMETER + 0.1, anchor=BOTTOM);
      translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, (PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2, TOP_COVER_BOLT_LENGTH])
        #cyl(h=height - TOP_COVER_BOLT_LENGTH, r=BOLT_DIAMETER + 0.1, anchor=BOTTOM);
      translate([(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), TOP_COVER_BOLT_LENGTH])
        #cyl(h=height - TOP_COVER_BOLT_LENGTH, r=BOLT_DIAMETER + 0.1, anchor=BOTTOM);
      translate([-(PCB_OUTER_HEIGHT - SCREW_HOLE_MERGIN) / 2, -((PCB_OUTER_WIDTH - SCREW_HOLE_MERGIN) / 2), TOP_COVER_BOLT_LENGTH])
      rotate([0, 0, 90])
        #cyl(l=height - TOP_COVER_BOLT_LENGTH, r=BOLT_DIAMETER + 0.1, anchor=BOTTOM);

      // translate([SW_WIDTH * 2.5, - PCB_OUTER_WIDTH / 2 + WALL_THICKNESS, 2])
      // #prismoid(
      //   size2=[2, 0],
      //   size1=[2, WALL_THICKNESS * 2],
      //   shift=[0, -WALL_THICKNESS],
      //   h=1.5,
      //   anchor=BOTTOM
      // );
      translate([SW_WIDTH * 2 + 1, - PCB_OUTER_WIDTH / 2 + WALL_THICKNESS / 2, 0])
      #cuboid([10, WALL_THICKNESS, 0.2], anchor=BOTTOM);

      translate([-9, - PCB_OUTER_WIDTH / 2 + 0.3, 1])
      xrot(90)
      #text3d("ON", h=0.4, size=3, anchor=BOTTOM+FRONT+CENTER);

      // ICON_HEIGHT = 1;
      // zrot(90)
      // translate([0, -18, height - ICON_HEIGHT])
      // union() {
      //   CIRCLE = 4;
      //   LINE_WIDTH = 1;
      //   GAP=2;

      //   translate([0, 0, 0])
      //   cyl(d=CIRCLE*1.5, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //   translate([0, CIRCLE * 3, 0])
      //   cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //   translate([0, CIRCLE * 2, 0])
      //   union() {
      //     SPACE=7;
      //     translate([-SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //     translate([SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);
      //   }

      //   translate([0, CIRCLE * 4.5, 0])
      //   cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //   translate([0, CIRCLE * 2, 0])
      //   union() {
      //     SPACE=14;
      //     translate([-SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //     translate([SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);
      //   }

      //   translate([0, CIRCLE * 6, 0])
      //   union() {
      //     SPACE=4;
      //     translate([-SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //     translate([SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);
      //   }

      //   translate([0, CIRCLE * 8, 0])
      //   union() {
      //     SPACE=4;
      //     translate([-SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);

      //     translate([SPACE, 0, 0])
      //     cyl(d=CIRCLE, h=ICON_HEIGHT + 0.1, anchor=BOTTOM+FRONT);
      //   }

      // }
    }
  }



}

// 0.5: fillet
// 5.75: XH CONN height // 0.2: offset
// 1.5: WALL thickness
TOP_HEIGHT = 5.75 + 0.2 + 1.5 + 0.5;
translate([0, 0, TOP_HEIGHT + PCB_THICKNESS + 1])
color("blue")
topCase(TOP_HEIGHT);


// head
// cyl(d=CIRCLE, h=1, anchor=BOTTOM+FRONT);

// // chest
// translate([0, CIRCLE + GAP, 0])
// cyl(d=CIRCLE, h=1, anchor=BOTTOM+FRONT);
// translate([- GAP * 2 - (CIRCLE / 2), CIRCLE + GAP + (CIRCLE - LINE_WIDTH) / 2, 0])
// cuboid(
//   [
//     2,
//     LINE_WIDTH,
//     1,
//   ],
//   rounding=LINE_WIDTH / 2,
//   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
//   anchor=BOTTOM+FRONT+LEFT
// );
// translate([GAP * 2 + (CIRCLE / 2), CIRCLE + GAP + (CIRCLE - LINE_WIDTH) / 2, 0])
// cuboid(
//   [
//     2,
//     LINE_WIDTH,
//     1,
//   ],
//   rounding=LINE_WIDTH / 2,
//   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
//   anchor=BOTTOM+FRONT+RIGHT
// );

// // hip
// translate([0, CIRCLE + GAP + CIRCLE + GAP, 0])
// cuboid(
//   [
//     LINE_WIDTH,
//     4,
//     1,
//   ],
//   rounding=LINE_WIDTH / 2,
//   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
//   anchor=BOTTOM+FRONT
// );
// translate([0, CIRCLE + GAP + CIRCLE + GAP + CIRCLE + GAP, 0])
// cyl(d=CIRCLE, h=1, anchor=BOTTOM+FRONT);
// translate([-(CIRCLE / 2) - GAP, CIRCLE + GAP + CIRCLE + GAP + CIRCLE + GAP + (CIRCLE - LINE_WIDTH) / 2, 0])
// cuboid(
//   [
//     2,
//     LINE_WIDTH,
//     1,
//   ],
//   rounding=LINE_WIDTH / 2,
//   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
//   anchor=BOTTOM+FRONT
// );
// translate([(CIRCLE / 2) + GAP, CIRCLE + GAP + CIRCLE + GAP + CIRCLE + GAP + (CIRCLE - LINE_WIDTH) / 2, 0])
// cuboid(
//   [
//     2,
//     LINE_WIDTH,
//     1,
//   ],
//   rounding=LINE_WIDTH / 2,
//   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
//   anchor=BOTTOM+FRONT
// );
// translate([-(CIRCLE / 2) - GAP - (LINE_WIDTH / 2), CIRCLE + GAP + CIRCLE + GAP + CIRCLE + GAP + (CIRCLE - LINE_WIDTH) / 2, 0])
// cuboid(
//   [
//     LINE_WIDTH,
//     5,
//     1,
//   ],
//   rounding=LINE_WIDTH / 2,
//   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
//   anchor=BOTTOM+FRONT
// );

// // translate([-10 + 2, CIRCLE + 2 + 1.5, 0])
// // cyl(d=3, h=1, anchor=BOTTOM+FRONT);
// // translate([-10 + 2, CIRCLE + 2 + 1.5, 0])
// // cyl(d=3, h=1, anchor=BOTTOM+FRONT);

// translate([-5, 3 + 2 + 10 + 2, 0])
// cyl(d=3, h=1, anchor=BOTTOM+FRONT);
// // cuboid(
// //   [
// //     3,
// //     10,
// //     1,
// //   ],
// //   rounding=1.5,
// //   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
// //   anchor=BOTTOM+FRONT
// // );
// translate([5, 3 + 2 + 10 + 2, 0])
// // cuboid(
// //   [
// //     3,
// //     10,
// //     1,
// //   ],
// //   rounding=1.5,
// //   edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
// //   anchor=BOTTOM+FRONT
// // );
// cyl(d=3, h=1, anchor=BOTTOM+FRONT);