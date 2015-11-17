String filename = "wfgk.csv";
String[] rawData;
String[] dates;
float[] prices;
float[] volumes;


void setup() {
  size(1200, 600);
  
  loadData("wfgk.csv");
  //println(volumes[0], volumes[0]*0.000001);
    
}

void draw() {
background(225);
  
stroke(255); 
  
for (int i = 0; i < volumes.length; i++) {
  float multiplier = 0.000001;
  float rectWidth = width/(volumes.length);
  float ypos = (height) - (volumes[i]*multiplier);
  int margin = 100;
  fill(0, 100, 0, 200);
  rect(rectWidth*i, ypos-margin, rectWidth, volumes[i]*multiplier
  );
} 

}



void loadData(String filename) {

  rawData = loadStrings(filename);
  
  dates = new String[rawData.length-1];
  prices = new float[rawData.length-1];
  volumes = new float[rawData.length-1];
  
  for (int i = 1; i < rawData.length; i++) {
  
     String[] thisRow = split(rawData[i], ","); 
     //printArray(thisRow);
     dates[i-1] = (thisRow[0]);
     prices[i-1] = float(thisRow[1]);
     volumes[i-1] = int(thisRow[2]);
  }
}