int app_width = 640;
int app_height = 360;
int fps=30;
boolean cap_mov=false; // capture:T, movie:F
boolean dwd_msa=false; // diewald fluid:T, MSA fluid:F

String my_dir = "C:\\Documents and Settings\\HOH\\My Documents\\Processing\\projects\\body_paint";
String movies_dir = my_dir + "\\movies";
//String movie_file = movies_dir + "\\nc55427.mp4";
String movie_file = movies_dir + "\\one_dance_choreography_2012_640x360.mp4";
String rec_file = my_dir + "\\rec\\bp_####.tif";

void setup() {
  size(app_width, app_height);
  frameRate(fps);
  of_setup();
  if (dwd_msa) {
    dwd_setup();
  }else {
//  size(app_width, app_height, OPENGL);
    msa_setup();
  }
}

void draw() {
  of_draw();
  if (dwd_msa) {
    dwd_draw();
    addVelToDwdFluidOnFlow();
  }else {
    msa_draw();
    addVelToMSAFluidOnFlow();
  }
}

void keyPressed() {
  of_keyPressed();
  dwd_keyPressed();
  //msa_keyPressed();
}

void keyReleased() {
  dwd_keyReleased();
}

void mousePressed() {
  msa_mousePressed();
}

void mouseMoved() {
  msa_mouseMoved();
}

void addVelToDwdFluidOnFlow() {
  for(int ix=0;ix<gw;ix++) {
    int x0=ix*gs+gs2;
    for(int iy=0;iy<gh;iy++) {
      int y0=iy*gs+gs2;
      int ig=iy*gw+ix;

      float u=df*sflowx[ig];
      float v=df*sflowy[ig];

      // draw the line segments for optical flow
      float a=sqrt(u*u+v*v);
      if(a>=30.0) { // add only if the length >=*
        //float r=0.5*(1.0+u/(a+0.1));
        //float g=0.5*(1.0+v/(a+0.1));
        //float b=0.5*(2.0-(r+g));
        
        float vel_fac = 0.001f;
        int size = (int)(((fluid_size_x+fluid_size_y)/2.0) / 50.0);
        size = max(size, 1);
        setVel(fluid, x0, y0, size, size, u*vel_fac, v*vel_fac);
        //if (a>=50.0) setDens(fluid, x0, y0, 4, 4, floor(random(2)), 0, floor(random(2)));
        
        //stroke(255*r,255*g,255*b);
        //line(x0,y0,x0+u,y0+v);
        //fluid.addVelocity(x0, y0, u*0.01, v*0.01);
      }
    }
  }
}

void addVelToMSAFluidOnFlow() {
  for(int ix=0;ix<gw;ix++) {
    int x0=ix*gs+gs2;
    for(int iy=0;iy<gh;iy++) {
      int y0=iy*gs+gs2;
      int ig=iy*gw+ix;

      float u=df*min(pow(10,7),sflowx[ig]);
      float v=df*min(pow(10,7),sflowy[ig]);

      float vel_fac = 0.1f;
      float a=sqrt(u*u+v*v);
      if(a>=80.0) {
        addForce(x0*invWidth, y0*invHeight, u*vel_fac*invWidth, v*vel_fac*invHeight);
      }
    }
  }
}

/*
void addVelToMSAFluidOnFlow() {
  float max_sflow_abs2=0;
  int max_sflow_abs2_ig=0;
  int max_sflow_abs2_x0=0;
  int max_sflow_abs2_y0=0;
  
  for(int ix=0;ix<gw;ix++) {
    int x0=ix*gs+gs2;
    for(int iy=0;iy<gh;iy++) {
      int y0=iy*gs+gs2;
      int ig=iy*gw+ix;
      float sflow_abs2 = pow(sflowx[ig],2) + pow(sflowy[ig],2);
      if (sflow_abs2 > max_sflow_abs2) {
        max_sflow_abs2 = sflow_abs2;
        max_sflow_abs2_ig = ig;
        max_sflow_abs2_x0 = x0;
        max_sflow_abs2_y0 = y0;
      }
    }
  }
  
  float u=df*sflowx[max_sflow_abs2_ig];
  float v=df*sflowy[max_sflow_abs2_ig];
  
  float vel_fac = 1.0f;
  float a=sqrt(u*u+v*v);
  //if(a>=30.0) {
    addForce(max_sflow_abs2_x0*invWidth, max_sflow_abs2_y0*invHeight, u*vel_fac*invWidth, v*vel_fac*invHeight);
  //}
}
*/
