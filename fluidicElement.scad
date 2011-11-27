// fluidic logic element
// units are in mm
//
// design based off of US Patent 3,825,739
// http://www.google.com/patents?id=tZAzAAAAEBAJ&zoom=4&pg=PA1#v=onepage&q&f=false


// scale of fluidic device
d = .5;

// height of fluidic device
h = 2;

// 80
powerNozzleLength = 6;

// 92 & 93
controlNozzleLength = 10;
controlNozzleWidth = 1.5;

// 98 & 99
bleedChannelLength = 10;
bleedChannelWidth = 1.5;
bleedChannelDistance = 10;


// 86 & 87
outputChannelLength = 35;
outputChannelEndWidth = 4;
outputChannelAngle = 15;


// 84 & 85
chamberDistance = 6.5;
chamberOffset = .5;
chamberRadius = 4;

// 96
feedbackDistance = 10.2;
feedbackRadius = 1.2;

difference() {
%
	union() {
		translate([-10 * d, -11 * d, -1])
		cube([20 * d, 43 * d, 3 * d * h]);	

		// power source
		translate([0 * d, -11 * d, -1])
		inputTube();

		// control
		translate([-10 * d, 1 * d, -1])
		inputTube();

		translate([10 * d, 1 * d, -1])
		inputTube();

		// output
		translate([-9 * d, 33 * d, -1])
		inputTube();

		translate([9 * d, 33 * d, -1])
		inputTube();
	}

	#
	fluidicFlipFlop();
}

module inputTube() {
	difference() {
		cylinder(r=2.5, h=10, $fn=24);

		translate([0, 0, 1])
		cylinder(r=1.5, h=10, $fn=24);
	}
}

module fluidicFlipFlop() {
	difference() {
		union() {
			linear_extrude(height = h * d - 0.25, convexity = 10) {
				// control nozzles (92 & 93)
				rectangle(-controlNozzleLength * d, 0, controlNozzleLength * d, controlNozzleWidth * d);


				// bleed channel (98)
				rectangle(
					-bleedChannelLength * d,  
					(bleedChannelDistance + controlNozzleWidth) * d, 
					-2 * d,	 
					(bleedChannelDistance + bleedChannelWidth + controlNozzleWidth) * d);	

				// bleed channel (99)
				rectangle(
					bleedChannelLength * d,  
					(bleedChannelDistance + controlNozzleWidth) * d, 
					2 * d, 
					(bleedChannelDistance + bleedChannelWidth + controlNozzleWidth) * d);
			}
			
			linear_extrude(height = h * d, convexity = 10) {
				// power nozzle (80)
				difference() {
					rectangle(-1.5, -4 * d, 1.5, -11*d);

					translate([-1.4, -2])
					circle(2 * d, $fn=24);

					translate([1.4, -2])
					circle(2* d, $fn=24);
				}

				rectangle(-d/2 - 0.12, 0, d/2 + 0.12, -powerNozzleLength * d);

				// output channel (86)
				rotate([0, 0, outputChannelAngle])
				trapezoid(outputChannelLength * d, d, outputChannelEndWidth * d);

				// output channel (87)
				rotate([0, 0, -outputChannelAngle])
				trapezoid(outputChannelLength * d, d, outputChannelEndWidth * d);
			}
			

			linear_extrude(height = h * d + 0.25, convexity = 10) {
				// chamber (84)
				translate([-chamberOffset * d, chamberDistance * d, 0])
				circle(chamberRadius * d, $fn = 64);

				// chamber (85)
				translate([chamberOffset * d, chamberDistance * d, 0])
				circle(chamberRadius * d, $fn =64);

				// chamber feedback (96)
				translate([0, feedbackDistance * d, 0])
				circle(feedbackRadius * d, $fn=32);	
			}

		}

		
		/*
		linear_extrude(height = h * d + 0.25, convexity = 10) 
		union() {

			// chamber support
			translate([0, 8, 0])
			circle(radius = .5, $fn=30);

		}*/
	}
}

module rectangle(x1, y1, x2, y2) {
	polygon(points=[[x1, y1], [x1, y2],[x2, y2], [x2, y1]], paths=[[0, 1, 2, 3]]);
}

module trapezoid(length, w1, w2) {
	polygon(points=[[-w1/2, 0], [-w2/2, length],[w2/2, length], [w1/2, 0]], paths=[[0, 1, 2, 3]]);
}
