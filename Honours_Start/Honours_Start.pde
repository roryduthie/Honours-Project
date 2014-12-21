JSONObject json;
String text;
String firstText;
String secText;
PFont f;
char[] someText = new char[5];
float textX = 10;
float textY = 100;
boolean flag = false;
String type;
String typeString;
String ID;
int screenX = 1000;
int screenY = 900;
StringList info;
int id;
StringList edgeInfo;
StringList nodeWithCoords;
String fromCoord1;
String fromCoord2;
String toCoord1;
String toCoord2;
float a;
float b;
float c;
float d;
StringList allNodeInfo;
StringList checkList;
FloatList allLineInfo;
StringList coordsFinal;


void setup()
{
  info = new StringList();
  edgeInfo = new StringList();
  nodeWithCoords = new StringList();
  allNodeInfo = new StringList();
  allLineInfo = new FloatList();
  checkList = new StringList();
  coordsFinal = new StringList();

  size(screenX, screenY);
  f = loadFont("ArialMT-20.vlw");


  json = loadJSONObject("http://www.arg.dundee.ac.uk/AIFdb/json/1364");
  JSONArray values = json.getJSONArray("nodes");
  JSONArray edges = json.getJSONArray("edges");

  for (int i = 0; i < values.size (); i++)
  {
    JSONObject node = values.getJSONObject(i);

    id = node.getInt("nodeID");
    text = node.getString("text");
    type = node.getString("type");

    ID = str(id);

    if (type.equals("I") || type.equals("RA"))
    {
      info.append(ID);
      info.append(text);

      //println(info);
    }
  }

  for (int z = 0; z < edges.size (); z++)
  {
    JSONObject edge = edges.getJSONObject(z);

    int edgeID = edge.getInt("edgeID");
    int edgeFrom = edge.getInt("fromID");
    int edgeTo = edge.getInt("toID");


    //println("Edge Info: " + edgeID + ", " + edgeFrom + ", " + edgeTo);

    for (int y = 0; y < info.size (); y++)
    {
      if (str(edgeFrom).equals(info.get(y)))
      {
        edgeInfo.append(str(edgeFrom));
        edgeInfo.append(str(edgeTo));
        //println("Edge From " + edgeFrom + " Has Been Found To " + edgeTo);
      }
    }
  }

  String lines[] = loadStrings("http://www.arg-tech.org/AIFdb/dot/layout/1364");



  for (int i=5; i < lines.length; i++)
  {
    String[] list = split(lines[i], " ");
    //println(lines[i]);

    for (int q = 0; q < list.length; q++)
    {

      String[] sList = split(list[q], " ");

      for (int z = 0; z < sList.length; z++)
      {
        sList[z] = trim(sList[z]);
        
        if (flag == false)
        {
          for (int n = 0; n < info.size (); n++)
          {
            if (sList[z].equals(info.get(n)))
            {
              if(!checkList.hasValue(sList[z]))
              {
              //println("ID: " + sList[z]);
              flag = true;
              checkList.append(sList[z]);
              break;
              //println(sList[z]);
              }
            }
          }
        }

        if (flag==true)
        {
          if (sList[z].length() > 3)
          {
            String sub = sList[z].substring(0, 4);
            if (sub.equals("pos="))
            {
              String coords = sList[z].trim();
              coords = coords.substring(5, sList[z].length()-2);
              String[] coordsL = split(coords, ",");
              //println(coordsL[0] + " bjdfsjkdhfkjasd");
              coordsFinal.append(coordsL[0]);
              coordsFinal.append(coordsL[1]);
              
              flag = false;
            }
          }
        }
      }
    }
  }
  
  
  /*
  /////////////////////////////////////////////////////////DIVIDE COORDS//////////////////////////////////////////////////////////////////////////////////////////////
  */
  
}

void draw()
{
  background(255);
  textFont(f, 12);
  fill(0);

  /////////////////////////////////////////////////////////////COORD List Size == INFO list size //////////////////////////////////////////////////////////////////
  println(coordsFinal.size());
  println(info.size());
  
  for (int i = 0; i < info.size(); i++)
  {
    nodeWithCoords.append(info.get(i));
    i++;

    String xCoord;
    String yCoord;
    String id = info.get(i-1);


    //draws the text
    //text(info.get(i), textX, textY, 100, 150);
    allNodeInfo.append(id);
    allNodeInfo.append(info.get(i));
    allNodeInfo.append(str(textX));
    allNodeInfo.append(str(textY));
    allNodeInfo.append("100");
    allNodeInfo.append("150");

    noFill();



    //gets rectangle boundaries
    if (info.get(i).equals("RA"))
    {

      pushMatrix();
      translate(textX + 10, textY - 25);

      rotate(radians(45));

      //rect(0, 0, 50, 50);
      popMatrix();
      xCoord = str((textX + 10));
      yCoord = str((textY - 25));
      nodeWithCoords.append(xCoord);
      nodeWithCoords.append(yCoord);

      allNodeInfo.append(xCoord);
      allNodeInfo.append(yCoord);
      allNodeInfo.append("50");
      allNodeInfo.append("50");
    } else
    {
      //rect(textX - 5, textY - 20, 110, 150);
      xCoord = str((textX -5));
      yCoord = str((textY - 20));
      nodeWithCoords.append(xCoord);
      nodeWithCoords.append(yCoord);

      allNodeInfo.append(xCoord);
      allNodeInfo.append(yCoord);
      allNodeInfo.append("110");
      //allNodeInfo.append("150");
      allNodeInfo.append(str(calculateTextHeight(info.get(i), 150, 10, 18 )));
    }
    //println(allNodeInfo);
    //adjusts Y value for text
    textY = textY + 200;

    if (textY + 150 > screenY)
    {
      textY = 100;

      textX = textX + 250;
    }

    //println(info.get(i) + info.get(i-1));
    //println(nodeWithCoords);
  }



  for (int x=0; x < edgeInfo.size (); x++)
  {

    for (int g = 0; g < info.size (); g++)
    {
      g++;
      if (info.get(g-1).equals(edgeInfo.get(x)))
      {
        //println("Got An Edge From " + edgeInfo.get(x) + " To: " + edgeInfo.get(x + 1));

        //get coords of first node and second node 
        for (int z = 0; z < nodeWithCoords.size (); z++)
        {
          if (nodeWithCoords.get(z).equals(edgeInfo.get(x)))
          {
            fromCoord1 = nodeWithCoords.get(z+1);
            fromCoord2 = nodeWithCoords.get(z+2);

            //println("coords 1: " + fromCoord1 + " coords 2: " + fromCoord2);
            a = Float.valueOf(fromCoord1).floatValue();
            b = Float.valueOf(fromCoord2).floatValue();
          }

          if (nodeWithCoords.get(z).equals(edgeInfo.get(x+1)))
          {
            toCoord1 = nodeWithCoords.get(z+1);
            toCoord2 = nodeWithCoords.get(z+2);
            //println("coords 1: " + toCoord1 + " coords 2: " + toCoord2); 
            c = Float.valueOf(toCoord1).floatValue();
            d = Float.valueOf(toCoord2).floatValue();
          }

          z= z+2;
        }

        if (info.get(g).equals("RA"))
        {

          if (b+70 > d)
          {
            //println("FROM is LESS than To FOR NODE: " + info.get(g-1) + " With Text: " + info.get(g));
          }
          //line(a, b+70, c, d);
          allLineInfo.append(Float.parseFloat(info.get(g-1)));
          allLineInfo.append(a);
          allLineInfo.append(b + 70); //+70
          allLineInfo.append(c);
          allLineInfo.append(d);
        } else
        {
          //line(a, b+150, c, d);
          if (b+150 > d)
          {
            //println("FROM is LESS than To FOR NODE: " + info.get(g-1) + " With Text: " + info.get(g));
          }
          allLineInfo.append(Float.parseFloat(info.get(g-1)));
          allLineInfo.append(a);
          allLineInfo.append(b + calculateTextHeight(info.get(g), 150, 10, 18 )); //+150
          allLineInfo.append(c);
          allLineInfo.append(d);
        }



        //println("line: " + a, b, c, d);
      }
    }
    x++;
  }

  //println(allLineInfo);
  for (int z = 0; z < allNodeInfo.size (); z++)
  {

    text(allNodeInfo.get(z+1), Float.parseFloat(allNodeInfo.get(z+2)), Float.parseFloat(allNodeInfo.get(z+3)), 150, 2000);
    noFill();

    if (allNodeInfo.get(z+1).equals("RA"))
    {
      pushMatrix();
      translate(Float.parseFloat(allNodeInfo.get(z+6)), Float.parseFloat(allNodeInfo.get(z+7)));

      rotate(radians(45));

      rect(0, 0, Float.parseFloat(allNodeInfo.get(z+8)), Float.parseFloat(allNodeInfo.get(z+9)));
      popMatrix();
    } else
    {
      // rect(Float.parseFloat(allNodeInfo.get(z+6)), Float.parseFloat(allNodeInfo.get(z+7)), Float.parseFloat(allNodeInfo.get(z+8)), Float.parseFloat(allNodeInfo.get(z+9)));
      //rect(Float.parseFloat(allNodeInfo.get(z+6)), Float.parseFloat(allNodeInfo.get(z+7)), 150, calculateTextHeight(allNodeInfo.get(z+1), 150, 10, 18 ));
      rect(Float.parseFloat(allNodeInfo.get(z+6)), Float.parseFloat(allNodeInfo.get(z+7)), 150, Float.parseFloat(allNodeInfo.get(z+9)));
    }

    z = z + 9;
  }

  for (int i = 0; i < allLineInfo.size (); i++)
  {
    i++;
    line(allLineInfo.get(i), allLineInfo.get(i+1), allLineInfo.get(i+2), allLineInfo.get(i+3));
    i = i + 3;
  }

  //println(allLineInfo);
  noLoop();
}


int calculateTextHeight(String string, int specificWidth, int fontSize, int lineSpacing) {
  String[] wordsArray;
  String tempString = "";
  int numLines = 0;
  float textHeight;

  wordsArray = split(string, " ");

  for (int i=0; i < wordsArray.length; i++) {
    if (textWidth(tempString + wordsArray[i]) < specificWidth) {
      tempString += wordsArray[i] + " ";
    } else {
      tempString = wordsArray[i] + " ";
      numLines++;
    }
  }

  numLines++; //adds the last line

  textHeight = numLines * (textDescent() + textAscent() + lineSpacing);
  return(round(textHeight));
} 

