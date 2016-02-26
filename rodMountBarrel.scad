include <syringePumpConstants.scad>

space_above_floor = 2.5;

/* === Model-specific Constants === */
plungerDiameter = 26.5;
barrelSlotThickness = 2.5;
barrelSlotHeight = 36; 

//cube containing rods and syringe barrel stop
mountXSize = 15;
mountZSize = syringeCenterHeight;

/* === Model === */

//main cube, holds the two axes
difference(){
	cube(size=[mountXSize,baseSizeY,mountZSize - 5.5]);

	//bore hole for threaded rod
	translate([-floatCorrection,centerY,threadedAxisHeight - 2]){
		rotate(a=[0,90,0]){
			cylinder(h=mountXSize+floatCorrection2, r=smoothRodRadius);
		}
	}

	//hole for smooth rod (needs to fit fairly tight)
	translate([-floatCorrection,centerY,smoothAxisHeight + 0.5]){
		rotate(a=[0,90,0]){
			cylinder(h=mountXSize+floatCorrection2, r=smoothRodRadius);
		}
	}

	//hole for syringe barrel top to go in
    translate([0,0,-5.5]){
        #translate([mountXSize/2,centerY,syringeCenterHeight]){
            translate([0,-baseSizeY/2,-barrelSlotHeight/2]){
                cube(size=[barrelSlotThickness, baseSizeY, barrelSlotHeight]);
            }
        }	
        translate([-floatCorrection,centerY,syringeCenterHeight]){
            rotate(a=[0,90,0]){
                cylinder(h=mountXSize+floatCorrection2, r=barrelDiameter/2);
            }	
            translate([0,-plungerInnerDiameter/2,0]){
                cube(size=[barrelSlotThickness+floatCorrection2,plungerInnerDiameter,mountZSize]);
            }
        }	
    }
}

// 80/20 screw plate
difference(){
	translate([-screwPlateSize,0,0]){
		cube(size=[screwPlateSize,baseSizeY,mountPlateHeight]);
	}

	translate([-screwPlateSize/2,baseSizeY/4,0]){
		cylinder(h=mountPlateHeight, r=screwRadius);
	}
	translate([-screwPlateSize/2,3*baseSizeY/4,0]){
		cylinder(h=mountPlateHeight, r=screwRadius);
	}

}

module bearing608(){
	cylinder(h=bearing608Height, r=bearing608Diameter/2);	
}
