//------------------------------------------------------------------------------
//
// author: thomas diewald
// date: 27.07.2011
//
// basic example to show how to initialize a CPU-based fluidsolver
//
// interaction:
//    LMB: set density white
//    MMB: set density red
//    RMB: set velocity
//
//    key 'y' + LMB: add obstacle
//    key 'y' + MMB: remove obstacle
//
//    key 's': to visualize the difference in smoothing
//
//------------------------------------------------------------------------------

import diewald_fluid.Fluid2D;
import diewald_fluid.Fluid2D_CPU;
import diewald_fluid.Fluid2D_GPU;

int  CPU_GPU        = 1; // 0 is GPU, 1 is CPU;
//int  fluid_size_x = 150; 
//int  fluid_size_y = 150;
int window_size_x = app_width;
int window_size_y = app_height;

int  cell_size    = 4;
//int  window_size_x = fluid_size_x  * cell_size + (cell_size * 2);
//int  window_size_y = fluid_size_y  * cell_size + (cell_size * 2);
int  fluid_size_x = round((window_size_x - cell_size * 2) / cell_size); 
int  fluid_size_y = round((window_size_y - cell_size * 2) / cell_size); 

Fluid2D fluid;
PImage output_densityMap;
boolean edit_quader = false;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void dwd_setup() {
  //size(window_size_x, window_size_y, JAVA2D);
  fluid = createFluidSolver(CPU_GPU);
  //frameRate(60);
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void dwd_draw() {
  //background(0);
  if ( mousePressed ) 
    fluidInfluence(fluid);
    
  //float speed = .25f;
  float speed = .25f;
  int off = 15;
  
  setVel (fluid,       off,        off, 2, 2, speed, speed);
  setDens(fluid,       off,        off, 6, 6, 1, 0, 0);
  
  setVel (fluid, width-off,        off, 2, 2, -speed, speed);
  setDens(fluid, width-off,        off, 6, 6, 1, 1, 1);
  
  setVel (fluid, width-off, height-off, 2, 2, -speed, -speed);
  setDens(fluid, width-off, height-off, 6, 6, 0, 0, 1);
  
  setVel (fluid,       off, height-off, 2, 2, speed, -speed);
  setDens(fluid,       off, height-off, 6, 6, 0, 1, 0);
  
  
  fluid.smoothDensityMap(( keyPressed && key == 's'));
  fluid.update();

  // render
  fluid.setTextureBackground((cap_mov) ? video_cap.get() : video_mov.get());
  tint(255, 32);
  image(fluid.getDensityMap(), 0, 0, width, height);
  
  // render in another way
  //PImage imgVideo = (cap_mov) ? video_cap.get() : video_mov.get();
  //PImage imgFluid = fluid.getDensityMap();
  //imgVideo.blend(imgFluid, 0, 0, imgFluid.width, imgFluid.height, 0, 0, imgVideo.width, imgVideo.height, ADD);
  //image(imgVideo, 0, 0, width, height);
  
  //println(frameRate);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// createFluidSolver();
//
Fluid2D createFluidSolver(int type) {
  Fluid2D fluid_tmp = null;
  
  if ( type == 0) fluid_tmp = new Fluid2D_GPU(this, fluid_size_x, fluid_size_y);
  if ( type == 1) fluid_tmp = new Fluid2D_CPU(this, fluid_size_x, fluid_size_y);

  fluid_tmp.setParam_Timestep  ( 0.10f );
  fluid_tmp.setParam_Iterations( 8 );
  fluid_tmp.setParam_IterationsDiffuse(1);
  fluid_tmp.setParam_Viscosity ( 0.00000000f );
  fluid_tmp.setParam_Diffusion ( 0.000001f );
  fluid_tmp.setParam_Vorticity ( 2.0f );
  fluid_tmp.processDensityMap  ( true );
  fluid_tmp.processDiffusion   ( true );
  fluid_tmp.processViscosity   ( !true );
  fluid_tmp.processVorticity   ( true );
  fluid_tmp.setObjectsColor    (1, 1, 1, 1); 
  
  output_densityMap    = createImage(window_size_x, window_size_y, RGB);
  fluid_tmp.setDensityMap(output_densityMap);
  return fluid_tmp;
}

