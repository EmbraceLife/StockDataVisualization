
String filename = "wfgk.csv";
String[] rawData;
StringList dates = new StringList();
FloatList prices = new FloatList();;
FloatList volumes = new FloatList();;


IntList index2014 = new IntList();
StringList dates2014;
FloatList prices2014;
FloatList volumes2014;

IntList index2015 = new IntList();
StringList dates2015;
FloatList prices2015;
FloatList volumes2015;



//IntList indexJan = new IntList();
//IntList indexFeb = new IntList();
StringList dates2015Jan;
FloatList prices2015Jan;
FloatList volumes2015Jan;

float overallMin;
float overallMax;

float xSpacer; // distance between points
float margin, graphHeight;
PVector[] positionsPrices2014;
PVector[] positionsPrices2015;
PVector[] positionsPrices2015Jan;

boolean toggle2014;
boolean toggle2015;
boolean toggle2015Jan;
float r;

void setup() {
  size(1200, 600);
  toggle2014 = true;
  toggle2015 = false;
  r = 20;
  
  loadData("wfgk.csv");
  
  prices2014 = getYearPrices("2014", prices2014);
  positionsPrices2014 = getPVectorPoints(prices2014);
  dates2014 = getYearDates("2014", dates2014);

  prices2015 = getYearPrices("2015", prices2015);
  positionsPrices2015 = getPVectorPoints(prices2015);
  dates2015 = getYearDates("2015", dates2015);

  prices2015Jan = getMonthPrices("2015-01", prices2015Jan);
  positionsPrices2015Jan = getPVectorPoints(prices2015Jan);
  dates2015Jan = getMonthDates("2015", dates2015Jan);

}


void draw() {

  
  if (toggle2014) {
    drawPointsPositions(positionsPrices2014);
    drawGUI(positionsPrices2014, dates2014);
    smooth();
  }
  
  if (toggle2015) {
    drawPointsPositions(positionsPrices2015);
    drawGUI(positionsPrices2015, dates2015);
    smooth();
  }
  
  if (toggle2015Jan) {
    drawPointsPositions(positionsPrices2015Jan);
    drawGUI(positionsPrices2015Jan, dates2015Jan);
    smooth();
  }
  
  createSwitchButton();
}

void createSwitchButton() {
  
  strokeWeight(5);
  if (toggle2014) {
    fill(#6CA58D);
    stroke(#4663F0);
  } else {
    fill(200);
    stroke(50);
  }
  ellipse(width/3, margin/2, r, r);
  
  if (toggle2015) {
    fill(#6CA58D);
    stroke(#4663F0);
  } else {
    fill(200);
    stroke(50);
  }
  ellipse(width/2, margin/2, r, r);
  
  if (toggle2015Jan) {
    fill(#6CA58D);
    stroke(#4663F0);
  } else {
    fill(200);
    stroke(50);
  }
  ellipse(width*2/3, margin/2, r, r);
}

void mouseReleased() {
  float d1 = dist(mouseX, mouseY, width/3, margin/2);
  float d2 = dist(mouseX, mouseY, width/2, margin/2);
  float d3 = dist(mouseX, mouseY, width*2/3, margin/2);
  if (d1 < r) {
    toggle2014 = true;
    toggle2015 = false;
    toggle2015Jan = false;
  }
  
  if (d2 < r) {
    toggle2015 = true;
    toggle2014 = false;
    toggle2015Jan = false;
  }
  
  if (d3 < r) {
    toggle2015Jan = true;
    toggle2014 = false;
    toggle2015 = false;
  }
}


void drawPointsPositions(PVector[] positions) {
  background(20);
  fill(200);
  for (int i = 0; i < positions.length; i++) {
   ellipse(positions[i].x, positions[i].y, 3, 3);
  }
}

PVector[] getPVectorPoints(FloatList pricesOrVolumes) {   
  overallMin = pricesOrVolumes.min();
  overallMax = pricesOrVolumes.max();
  
  margin = 50;
  graphHeight = (height-margin-margin);
  xSpacer = ((width - margin) - margin)/(pricesOrVolumes.size()-1);

  PVector[] positions = new PVector[pricesOrVolumes.size()];
  for (int i = 0; i < pricesOrVolumes.size(); i++) {
    float adjPrice = map(pricesOrVolumes.get(i), overallMin, overallMax, 0, graphHeight ); 
    float yPos = height - margin - adjPrice;
    float xPos = margin + (xSpacer*i);
    positions[i] = new PVector(xPos, yPos);
  }
  return positions;
}  


void drawGUI(PVector[] positionsPrices, StringList positionsDates) {
  for (int i = 0; i < positionsPrices.length; i++) {
    stroke(200, 100);
    strokeWeight(1);
    // line through point vertically
    line(positionsPrices[i].x, margin, positionsPrices[i].x, height-margin);

    // draw date for each point
    //text(dates[i], positions[i].x-35, height-margin+20);

    // link point with line backward
    if (i > 0) {
      stroke(200);
      strokeWeight(2);
      line(positionsPrices[i].x, positionsPrices[i].y, positionsPrices[i-1].x, positionsPrices[i-1].y);
    }
  }

  // draw date range
  fill(200, 0, 100);
  text(positionsDates.get(0), margin-40, height-margin+20);
  text(positionsDates.get(positionsDates.size()-1), positionsPrices[positionsPrices.length-1].x-40, height-margin+20); //<>//


  // draw data range
  fill(100, 200, 100);
  text(overallMax, 5, margin);
  text(overallMin, 5, height-margin);
}




void loadData(String filename) {

  rawData = loadStrings(filename);
  for (int i = 1; i < rawData.length; i++) {

    String[] thisRow = split(rawData[i], ","); 
    //printArray(thisRow);
    dates.append(thisRow[0]);
    prices.append(float(thisRow[1]));
    volumes.append(float(thisRow[2])*0.000001);
  }
}


StringList getYearDates(String year, StringList datesYear) {
  IntList indexYear = new IntList();
  indexYear = getYearIndex(year);
  datesYear = new StringList();
  for (int i = 0; i < indexYear.size(); i++) {
     datesYear.append(dates.get(indexYear.get(i)));
  }
  //printArray(datesYear);
  return datesYear;
}

FloatList getYearPrices(String year, FloatList pricesYear) {
  IntList indexYear = new IntList();
  indexYear = getYearIndex(year);
  pricesYear = new FloatList();
  for (int i = 0; i < indexYear.size(); i++) {
     pricesYear.append(prices.get(indexYear.get(i)));
  }
  //printArray(pricesYear);
  return pricesYear;
}

FloatList getYearVolumes(String year, FloatList volumesYear) {
  IntList indexYear = new IntList();
  indexYear = getYearIndex(year);
  volumesYear = new FloatList();
  for (int i = 0; i < indexYear.size(); i++) {
     volumesYear.append(volumes.get(indexYear.get(i)));
  }
  //printArray(pricesYear);
  return volumesYear;
}



IntList getYearIndex(String year) {
  IntList indexOfDaysInYear = new IntList();
  for (int i = 0; i < dates.size(); i++) {
    String[] checkYear = match(dates.get(i), year);
    if (checkYear != null) {
      //println("index:",i,"->we are all in ", year); 
      indexOfDaysInYear.append(i);
    } else {
      //println("index:",i,"->now outside of ", year);
    }
  }
  //printArray(indexOct);
  return indexOfDaysInYear;
}

IntList getMonthIndex(String month) {
  IntList indexOfDaysInMonth = new IntList();
  for (int i = 0; i < dates.size(); i++) {
    String[] checkMonth = match(dates.get(i), month);
    if (checkMonth != null) {
      //println("index:",i,"->we are all in ", month); 
      indexOfDaysInMonth.append(i);
    } else {
      //println("index:",i,"->now outside of ", month);
    }
  }
  //printArray(indexOct);
  return indexOfDaysInMonth;
}


StringList getMonthDates(String monthName, StringList datesMonth) {
  IntList indexMonth = new IntList();
  indexMonth = getMonthIndex(monthName);
  datesMonth = new StringList();
  for (int i = 0; i < indexMonth.size(); i++) {
     datesMonth.append(dates.get(indexMonth.get(i)));
  }
  //printArray(datesYear);
  return datesMonth;
}

FloatList getMonthPrices(String monthName, FloatList pricesMonth) {
  IntList indexMonth = new IntList();
  indexMonth = getMonthIndex(monthName);
  pricesMonth = new FloatList();
  for (int i = 0; i < indexMonth.size(); i++) {
     pricesMonth.append(prices.get(indexMonth.get(i)));
  }
  //printArray(pricesYear);
  return pricesMonth;
}

FloatList getMonthVolumes(String monthName, FloatList volumesMonth) {
  IntList indexMonth = new IntList();
  indexMonth = getYearIndex(monthName);
  volumesMonth = new FloatList();
  for (int i = 0; i < indexMonth.size(); i++) {
     volumesMonth.append(volumes.get(indexMonth.get(i)));
  }
  //printArray(pricesYear);
  return volumesMonth;
}