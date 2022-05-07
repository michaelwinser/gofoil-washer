/*
MIT License

Copyright (c) 2022 Michael Winser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/ 


$fa = 1;
$fs = 0.4;

gofoil_washer();


//
// The defaults are measured (by hand) from an actual Go Foil plate washer
//
module gofoil_washer(base_height = 3.1, 
    bevel_height = 3.1, 
    outer_radius = 31.4/2, 
    bevel_radius = 24.3 / 2, 
    shaft_radius = 8.1 / 2, 
    countersink_outer_radius = 16.1 / 2, 
    countersink_inset_height = 1) {
        
        full_height = base_height + bevel_height;
        countersink_bevel_height = full_height - countersink_inset_height * 2;
        
        // This offset ensures that the negative space of the countersink extends
        // past the top and bottom of the main washer
        // The preview rendering doesn't look right but the final rendering and
        // print are fine.
        
        buffer_offset = 1; 
    difference() {
        
        base_washer(outer_radius, bevel_radius, base_height, bevel_height);
        translate([0, 0, full_height + buffer_offset]) {
            countersink(
                r_outer = countersink_outer_radius, 
                r_shaft = shaft_radius,
                h_bevel = countersink_bevel_height,
                h_inset = countersink_inset_height + buffer_offset,
                h_shaft = countersink_inset_height + buffer_offset);
         }
    }
}


module base_washer(r_outer, r_bevel, h_base, h_bevel) {
    bevel_with_shaft(r_outer, r_bevel, h_base, h_bevel, 0);
}

module countersink(r_outer, r_shaft, h_bevel, h_inset, h_shaft) {
    
    rotate([180, 0, 0]) {
        bevel_with_shaft(r_outer, r_shaft, h_inset, h_bevel, h_shaft);
    }
}


// This is the module that does all the work. 
module bevel_with_shaft(r_outer, r_inner, h_base, h_bevel, h_shaft) {
    
    union() {
        cylinder(h_base, r_outer, r_outer);
        translate([0, 0, h_base]) {
            cylinder(h_bevel, r_outer, r_inner);
            translate([0, 0, h_bevel]) {
                cylinder(h_shaft, r_inner, r_inner);
            }
        }
    }
}


