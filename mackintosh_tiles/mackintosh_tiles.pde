// Render an image insipired by Charles Rennie Mackintosh's tile patterns on the staircases
// of the Glasgow School of Art.
//
// Examples of the tile pattens can be seen at http://bit.ly/p10Vm1. Each pattern appears be 
// constructed fromtwo groups of tile - the outer ring, and the inner. The outer ring has 2, 3
// or 4 tiles on each side. The inner has 1, 2 or 4 tiles. The two groups appear to be coloured
// independently, either white, blue or green.
// Handily, this allows each pattern to be represented as a 4 digit number in base 3, using
// digits for the inner and outer tile count, and their reprective colours. The final image is
// built from iterating through all possible permutations.
// It'd be fun to stich the final image from photos of the actual tiles, rather than the flat
// graphics here. That's for another day.
//
// Andrew Eland (andrew@andreweland.org)

class Pattern {
  int outerCount;
  int outerColour;
  int innerCount;
  int innerColour;
  
  Pattern(int n) {
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

  void draw(int patternSize, int tileSize, color[] colours) {
    drawOuter(patternSize, tileSize, colours);
    drawInner(patternSize, tileSize, colours);
  }
  
  void drawOuter(int patternSize, int tileSize, color[] colours) {
    noStroke();
    int spacing = (patternSize - tileSize) / (outerCount - 1);
    for (int x = 0; x < patternSize; x += spacing) {
      drawTile(x, 0, tileSize, outerColour, colours);
      drawTile(x, patternSize - tileSize, tileSize, outerColour, colours);
    }
    for (int y = spacing; y < patternSize - spacing; y += spacing) {
      drawTile(0, y, tileSize, outerColour, colours);
      drawTile(patternSize - tileSize, y, tileSize, outerColour, colours); 
    }
  }
  
  void drawInner(int patternSize, int tileSize, color[] colours) {
    noStroke();
    int[] rows = {0, 1, 1, 0, 2};
    int[] columns = {0, 1, 2, 0, 2};
    int spacing = (patternSize - (tileSize * 4)) / 3;
    int x = (patternSize - (columns[innerCount] * tileSize) - ((columns[innerCount] - 1) * spacing)) / 2;
    int y = (patternSize - (rows[innerCount] * tileSize) - ((rows[innerCount] - 1) * spacing)) / 2;
    for (int i = 0; i < columns[innerCount]; i++) {
      for (int j = 0; j < rows[innerCount]; j++) {
        drawTile(x + ((tileSize + spacing) * i), y + ((tileSize + spacing) * j), tileSize, innerColour, colours);
      }
    } 
  }
  
  void drawTile(int x, int y, int tileSize, int colour, color[] colours) {
    fill(colours[colour]);
    rect(x, y, tileSize, tileSize);
    // Add a slight, random,t highlight pattern to each tile, so the final result
    // isn't so flat.
    fill(colours[colour + 3]);
    for (int dx = x; dx < x + tileSize; dx += 4) {
      for (int dy = y; dy < y + tileSize; dy += 4) {
        float r = random(1.0);
        if(r > 0.7) {
          rect(dx, dy, 2, 2);
        } else if(r > 0.5) {
          rect(dx, dy, 1, 1); 
        }
      }
    }
  }
}

void setup() {
  int patternSize = 86;
  int tileSize = 20;
  int spacing = 2;
  int outputSize = (9 * patternSize) + (10 * spacing);
  size(outputSize, outputSize);
  background(#b3b1c2);
  // Rendering each tile as a single colour makes the output look a little flat and boring -
  // so we use two colours (at index n and n+3) to spice things up somewhat.
  color colours[] = {#ebfdfc, #10408b, #86a094, #dbf3f3, #0a34f5, #7f9a89};
  Pattern pattern = new Pattern(42);
  translate(spacing, spacing);
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      pushMatrix();
      translate((patternSize + spacing) * i, (patternSize + spacing) * j);
      pattern.fromInt((j * 9) + i);
      pattern.draw(patternSize, tileSize, colours);
      popMatrix();
    }
  }
  save("output.png");
}

