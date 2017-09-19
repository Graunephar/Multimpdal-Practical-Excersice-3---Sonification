/**
  * This sketch demonstrates how to create synthesized sound with Minim 
  * using an AudioOutput and an Oscil. An Oscil is a UGen object, 
  * one of many different types included with Minim. By using 
  * the numbers 1 thru 5, you can change the waveform being used
  * by the Oscil to make sound. These basic waveforms are the 
  * basis of much audio synthesis. 
  * 
  * For many more examples of UGens included with Minim, 
  * have a look in the Synthesis folder of the Minim examples.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;

//Textstuff
String[] lines;
int index = 0;

//STD Values
final int NO_VALUE = -200; //The value in the set representing no reading 
final int[] DATA_COLUMNS = {6}; ////The columns from the data that we want to play 
final String DATASET = "AirQualityUCI.csv"; // Name of thje csv file

void setup()
{
  size(512, 200, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  wave = new Oscil( 440, 0.5f, Waves.SINE);
  // patch the Oscil to the output
  wave.patch( out );
  
  frameRate(12);
  lines = loadStrings(DATASET);
  
}

void draw()
{
  background(0);
  stroke(255);
  strokeWeight(1);
  
  loadDataAndGeneratePitch();
  generateGraphWindow();

}

void generateGraphWindow() {
  
  // draw the waveform of the output
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50  - out.left.get(i)*50,  i+1, 50  - out.left.get(i+1)*50 );
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
  }

  // draw the waveform we are using in the oscillator
  stroke( 128, 0, 0 );
  strokeWeight(4);
  for( int i = 0; i < width-1; ++i )
  {
    point( i, height/2 - (height*0.49) * wave.getWaveform().value( (float)i / width ) );
  }
  
}

void loadDataAndGeneratePitch() {
  
  if (index < lines.length) {
    
    playSoundFOrAllColumns();
    
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}


void playSoundFOrAllColumns() { 
 
  
    for(int i = 0; i < DATA_COLUMNS.length; i++) {
    
      loadLineAndGenrateSound(DATA_COLUMNS[i]);
      //println(DATA_COLUMNS[i]);
      
    }
}
  
  void loadLineAndGenrateSound(int column) {
   
    String[] pieces = split(lines[index], ';');
    String datapoint = pieces[column];
    
    int datanumber = int(datapoint);
    
    if(datanumber == NO_VALUE) {
    
      //Do stuff with no value
      println("SKIPPED");
    
  } else {
    
      println(datapoint);
      
      float sound =  map(datanumber, 383, 2214, 10, 10000); 
    
      wave.setFrequency(sound);
    
    }
  }

/**void mouseMoved()
{
  // usually when setting the amplitude and frequency of an Oscil
  // you will want to patch something to the amplitude and frequency inputs
  // but this is a quick and easy way to turn the screen into
  // an x-y control for them.
  
  float amp = map( mouseY, 0, height, 1, 0 );
  wave.setAmplitude( amp );
  
  float freq = map( mouseX, 0, width, 110, 880 );
  wave.setFrequency( freq );
}**/

/**void keyPressed()
{ 
  switch( key )
  {
    case '1': 
      wave.setWaveform( Waves.SINE );
      break;
     
    case '2':
      wave.setWaveform( Waves.TRIANGLE );
      break;
     
    case '3':
      wave.setWaveform( Waves.SAW );
      break;
    
    case '4':
      wave.setWaveform( Waves.SQUARE );
      break;
      
    case '5':
      wave.setWaveform( Waves.QUARTERPULSE );
      break;
     
    default: break; 
  }*/