class TileGroup {
  int outerCount;
  int outerColour;
  int innerCount;
  int innerColour;
  
  TileGroup(int n) {
    fromInt(n); 
  }
  
  void fromInt(int n) {
    int[] outerCounts = {2, 3, 4};
    outerCount = outerCounts[n % 3];
    n /= 3;
    outerColour = n % 3;
    n /= 3;
    int[] innerCounts = {1, 2, 4};
    innerCount = innerCounts[n % 3];
    n /= 3;
    innerColour = n % 3;
  }

  void draw(int groupSize, int tileSize, color[] colours) {
    drawOuter(groupSize, tileSize, colours);
    drawInner(groupSize, tileSize, colours);
  }
  
  void drawOuter(int groupSize, int tileSize, color[] colours) {
    noStroke();
    fill(colours[outerColour]);
    int spacing = (groupSize - tileSize) / (outerCount - 1);
    for (int x = 0; x < groupSize; x += spacing) {
      rect(x, 0, tileSize, tileSize);
      rect(x, groupSize - tileSize, tileSize, tileSize);
    }
    for (int y = spacing; y < groupSize - spacing; y += spacing) {
      rect(0, y, tileSize, tileSize);
      rect(groupSize - tileSize, y, tileSize, tileSize); 
    }
  }
  
  void drawInner(int groupSize, int tileSize, color[] colours) {
    noStroke();
    int[] rows = {0, 1, 1, 0, 2};
    int[] columns = {0, 1, 2, 0, 2};
    fill(colours[innerColour]);
    int spacing = (groupSize - (tileSize * 4)) / 3;
    int startX = (groupSize - (columns[innerCount] * tileSize) - ((columns[innerCount] - 1) * spacing)) / 2;
    int startY = (groupSize - (rows[innerCount] * tileSize) - ((rows[innerCount] - 1) * spacing)) / 2;
    for (int x = startX, i = 0; i < columns[innerCount]; i++, x += tileSize + spacing) {
      for (int y = startY, j = 0; j < rows[innerCount]; j++, y += tileSize + spacing) {
        rect(x, y, tileSize, tileSize);
      }
    } 
  }
}

void setup() {
  int groupSize = 86;
  int tileSize = 20;
  int spacing = 4;
  int width = height = (9 * groupSize) + (10 * spacing);
  size(width, height);
  background(#ffffff);
  color colours[] = {#d7e0f2, #1d2e70, #69856c};
  TileGroup tileGroup = new TileGroup(42);
  translate(4, 4);
  for (int y = 0; y < height; y += (groupSize + spacing)) {
    for (int x = 0; x < width; x += (groupSize + spacing)) {
      pushMatrix();
      translate(x, y);
      tileGroup.fromInt((int)random(81));
      tileGroup.draw(groupSize, tileSize, colours);
      popMatrix();
    }
  }
}

