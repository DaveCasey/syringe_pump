include <syringePumpConstants.scad>

/* === Model-specific Constants === */

//add some clearance, we don't want this against the 8020 rails
spaceAboveFloor = 2.5;

// shrinking factor
shrink = 0.3; // this is to be subtracted to all tools beds in order to guarantee a tighter fit

//plunger
plungerDiameter = 27.5;
plungerThickness = 2.2 - shrink;
plungerInnerDiameter = 15;
plungerClipThickness = 3;
plungerWellDepth = plungerThickness + plungerClipThickness;
mink_radius = 1; // this value is used in definind the plunger bed in the cube. It is the amount of which each side of the cube will be increased due to the minkowski sum

//trap nut
nutAcross = 13.2;
nutDepth = 6.2;
nutWellDepth = nutDepth + 0.05 - shrink; //tight so it won't rattle
nutWallThicknessFront = plungerWellDepth+3;
nutWallThicknessBack = 4;

nutSlotSizeX = nutWallThicknessFront;
nutSlotSizeY = nutAcross;
nutSlotSizeZ = nutAcross/2 - 5.5; // 5.5 is a subjective decided amount to compact the design

//linear bearing 
LM8UU_dia = 15.4 - shrink;
LM8UU_length = 24;

//cube containing nut, linear bearing, and plunger
mountXSize = nutWellDepth + nutWallThicknessFront + nutWallThicknessBack;
mountZSize = syringeCenterHeight + plungerDiameter/2 + 3;

//nut
nutEdgeLength = nutAcross / (sqrt(3));
correctionFactor = 0.3;

nutCenterX = (mountXSize - nutWellDepth)/2 -floatCorrection;

finished_base();

/* === Model === */

//U-shaped hole for syringe plunger to go in
module plunger_bed(){
    
	translate([mountXSize-(floatCorrection+plungerWellDepth),centerY + mink_radius -plungerDiameter/2,syringeCenterHeight - plungerDiameter/2 + mink_radius]){
		plungerClip();
        } 	
        translate([mountXSize-(floatCorrection+plungerWellDepth),centerY-(plungerInnerDiameter - 2*mink_radius)/2,syringeCenterHeight - plungerInnerDiameter/2 + mink_radius]){	
        //translate([mountXSize-(floatCorrection+plungerWellDepth),centerY -(plungerInnerDiameter/2),syringeCenterHeight - plungerInnerDiameter/2 + mink_radius]){
		plungerRod();
		}
	}

// syringe plunger clip holder
module plungerClip(){
    
     minkowski(){
			cube(size=[plungerThickness,plungerDiameter - 2*mink_radius,mountZSize]);
			rotate(a=[0,90,0]){cylinder(h=plungerClipThickness, r = mink_radius-1);
		}		
    }   
}

// opening to hold the syringe plunger
module plungerRod(){
    
     #minkowski(){
			cube(size=[plungerClipThickness+floatCorrection2,plungerInnerDiameter - 2*mink_radius ,mountZSize]);
			rotate(a=[0,90,0]){cylinder(h=plungerThickness, r = mink_radius);
		}		
    }   
}

// internal bed for the nut
module nutWell(){
	//compose the outline of the 6-sided nut using 3 cubes. Yay geometry.

   rotate(a=[0,0,-30]){
	translate([-nutEdgeLength/2, -nutAcross/2, 0]){
		cube(size=[nutEdgeLength + correctionFactor,nutAcross + correctionFactor,nutWellDepth+floatCorrection2  + correctionFactor ]);
	}}

		rotate(a=[0,0,90]){
			translate([-nutEdgeLength/2, -nutAcross/2, 0]){
				cube(size=[nutEdgeLength + correctionFactor,nutAcross + correctionFactor,nutWellDepth+floatCorrection2  + correctionFactor ]);
			}
		}
	
		rotate(a=[0,0,-150]){
			translate([-nutEdgeLength/2, -nutAcross/2, 0]){
				cube(size=[nutEdgeLength + correctionFactor,nutAcross + correctionFactor,nutWellDepth+floatCorrection2  + correctionFactor ]);
			}
		}
}

// side opening to slide the nut in place
module nutSideOpening(){
    rotate([]){
        translate([]){
            cube([nutEdgeLength - 3*correctionFactor,nutAcross + 2*correctionFactor,2*nutWellDepth+floatCorrection2  + correctionFactor]);
        }
    }
}

// union of the nut bed and its side opening + the hole for the threaded rod 
module nutSideHole(){
    union(){
    //nut
	translate([nutCenterX,centerY,threadedAxisHeight]){
		rotate(a=[0,90,0]){
			nutWell();
		}
	}
    
    // side opening to slide the nut in position
    	translate([nutCenterX,2*centerY,threadedAxisHeight- (nutWellDepth+floatCorrection2  + 2*correctionFactor) ]){
		rotate(a=[90,0,0]){
			nutSideOpening();
		}
	}

	//bore hole for threaded rod
	translate([-floatCorrection,centerY,threadedAxisHeight]){
		rotate(a=[0,90,0]){
			cylinder(h=mountXSize+floatCorrection2, r=smoothRodRadius);
		}
    }
    
}
}

// ring placed internally in the LM8UU bearing bed to stop it from moving 
module LM8UUstopperRing(){
    
    ringThick = 1.5; // both thickness and difference of the radiuses
    
    difference(){
        cylinder(h=LM8UU_length - floatCorrection, r=LM8UU_dia/2);
        cylinder(h=LM8UU_length , r=(LM8UU_dia/2) - ringThick - floatCorrection);
        cylinder(h=LM8UU_length - ringThick -floatCorrection , r=(LM8UU_dia/2));
        
    }
}

// ring extruding from the LM8UU hole to hold the bearing into position. 
module LM8UUextRing(){
    
    ringThick = 3; //
    
    adj = (LM8UU_length - mountXSize - ringThick); // we want to have the bearing extruding a bit from the ring so that it's easy to remove it from it's bed
    
    difference(){
        cylinder(h=LM8UU_length-adj- floatCorrection, r=(LM8UU_dia/2) + ringThick/2);
        cylinder(h=LM8UU_length - floatCorrection, r=(LM8UU_dia/2));
        cylinder(h=LM8UU_length-adj- ringThick -floatCorrection , r=(LM8UU_dia/2) + ringThick/2);
           
            }
}

// combination of the two rings for the bearings
module bearingLM8UU(){
	difference(){
        union(){
            LM8UUstopperRing();
            translate([0,0,+LM8UU_length]){
            rotate(a=[180,0,0]){LM8UUextRing();}
            }
        }
    }
}

// this custom block is the cut in the main block between the LM8UU bearing and the threaded rod hole and it helps release the stress on the structure when the LM8UU bolt is inserted
module stressRelease(){
    cube(size=[2,7.7,mountXSize + 7]);
}

//main cube, holds the two axes
module main_cube(){
// align the rings with the mount
adj = (LM8UU_length - mountXSize);
    
difference(){
	translate([0,0,spaceAboveFloor]){
		cube(size=[mountXSize,baseSizeY,mountZSize - 5.5]);
	}
    
    // union of the nut bed and its side opening + the hole for the threaded rod 
    translate([0,0, -2.5]){nutSideHole(); }

    // hole for LM8UU
    translate([-adj + floatCorrection,centerY,         smoothAxisHeight ]){
        rotate(a=[0,90,0]){cylinder(h=LM8UU_length - floatCorrection, r=LM8UU_dia/2);}}
    	
	//U-shaped hole for syringe plunger to go in
    translate([0,0, -5.5])plunger_bed();
}
}


// union of the base and the rings to stop and guide the LM8UU in its bed
module main_cube_rings(){

    // align the rings for LM8UU with the mount
    adj = (LM8UU_length - mountXSize);

    union(){
        
        main_cube();

        // hole plus rings for LM8UU
        translate([-adj + floatCorrection,centerY,         smoothAxisHeight]){
            rotate(a=[0,90,0]){
                bearingLM8UU();
            }
        }
    }
}



module finished_base(){
    
    // add the rectangular hole in between the LM8UU and the threaded rod bed
        difference(){
           main_cube_rings();
           
           translate([nutCenterX - 12,centerY-1.0,threadedAxisHeight - 14]){
        rotate(a=[90,0,90]){
            stressRelease();
        }
    }
}
}



