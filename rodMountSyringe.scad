include <syringePumpConstants.scad>
use <rodMountPlunger_short.scad>

/* === Model-specific Constants === */
//add some clearance, we don't want this against the 8020 rails
spaceAboveFloor = 2.5;

//cube containing rods and syringe barrel stop
mountXSize = 10;
mountZSize = syringeCenterHeight;

/* === Model === */


module bearing608(){
	cylinder(h=bearing608Height, r=bearing608Diameter/2);	
}

//main cube, holds the two axes
module main_cube(){
    difference(){
        cube(size=[mountXSize,baseSizeY,mountZSize - 5.5]);
        
        //bore hole for threaded rod
        translate([-floatCorrection,centerY,threadedAxisHeight - 5]){
            rotate(a=[0,90,0]){ 
                cylinder(h=mountXSize+floatCorrection2, r=smoothRodRadius);
            }
        }

        //hole for smooth rod (needs to fit fairly tight)
        translate([-floatCorrection + mountXSize +floatCorrection2,centerY,smoothAxisHeight + 0.5]){
            rotate(a=[0,270,0]){
                cylinder(h=(mountXSize+floatCorrection2)/2, r=smoothRodRadius);
            }
        }
        
        //hole for syringe barrel stopper
        translate([-floatCorrection,centerY,syringeCenterHeight - 5.5]){
            rotate(a=[0,90,0]){
                cylinder(h=mountXSize+floatCorrection2, r=5.2);
            }
        }
    }
}

    module horizontal_cube(){
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
}

module finished_base(){
    union(){
        main_cube();
        horizontal_cube();
    }
}

translate([0,0,spaceAboveFloor]){
finished_base();
}

