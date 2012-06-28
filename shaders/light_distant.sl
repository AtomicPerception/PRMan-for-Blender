// light_area.sl

#include "util.h"

class
light_distant(
        uniform float intensity = 1;
        uniform color lightcolor = 1;
        uniform float samples = 16;
        uniform float angle = 1.0;
        uniform float shadowtype = 0;
        uniform string shadowmap = "";
       )
       
{
    public constant float isdelta = 1;
    public constant float stype=shadowtype;
    public constant string smap=shadowmap;

    constant point center = point "shader" (0,0,0); // center
    constant vector udir = vector "shader" (1,0,0); // axis of rectangle
    constant vector vdir = vector "shader" (0,1,0); // axis of rectangle
    constant vector zdir = vector "shader" (0,0,1);   // direction of light
    
    constant float angle_rad = radians(angle);

    public void construct() {
        
        //if (shape == 0)         area = width*height;
        //else if (shape == 1)    area = PI*width*0.5*height*0.5;
    }
    
    color Le(point P; vector L;) {

        color Le = lightcolor*intensity;
        
        return Le;
    }
    
    float pdf(point P; vector V; output vector L;)
    {
        float pdf=0;
        return pdf;
    }
    
    public void eval_light(point P; vector wi[];
                                uniform float nsamp;
                                output vector _L[];
                                output color _Li[];
                                output float _pdf[];
                                )
    {
        float i;
        resize(_L, nsamp);
        resize(_Li, nsamp);
        resize(_pdf, nsamp);
        
        for (i = 0; i < nsamp; i += 1) {
            _pdf[i] = pdf(P, wi[i], _L[i]);
            
            if (_pdf[i] > 0)
                _Li[i] = Le(P, _L[i]);
        }
    }
    
    public void light( output vector L;         // unused
                       output color Cl;         // unused
                       varying normal Ns;
                       output color _Li[];
                       output vector _L[];
                       output float _pdf[];
                       output uniform float nsamp = 0;
                       )
    {
       vector rnd;
       varying point samplepos;
       varying float su, sv;
       uniform float s;
       uniform float nsamples;
       
       if (nsamp <= 0)
            nsamples = 32;
       else
            nsamples = nsamp;

       resize(_Li, nsamples);   // note use of resizable arrays
       resize(_L, nsamples);
       resize(_pdf, nsamples);

       color Le;
       color black=0;
       
       for (s = 0; s < nsamples; s += 1) {
          if (angle > 0) {
            su = random();
            sv = random();

            float cosangle = cos(angle_rad);
            _L[s] = warp_cone(su, sv, cosangle, udir, vdir, zdir) * SCENE_BOUNDS;
          } else {
            _L[s] = SCENE_BOUNDS * zdir;
          }

          _pdf[s] = 1.0;
          _Li[s] = Le(P, _L[s]);           
       }
       nsamp = nsamples;
       

       L = (0,0,0);
       Cl = (0,0,0);
    }
}