
#include "Tonic.h"

using namespace Tonic;

class WickedSynth :public Synth
{
public:
  WickedSynth(){
    ControlMetro metronome = ControlMetro().bpm(60);
    
    ControlGenerator carrierFreq = ControlValue(220.f);
    Generator control_from_input = addParameter("control",0.0f).smoothed();
    Generator sine = SineWave().freq(140.f + control_from_input * 140.f * SineWave().freq(control_from_input * 280.f) ) + 0.25;
        
    setOutputGen(sine);
  }
  
};

registerSynth(WickedSynth);