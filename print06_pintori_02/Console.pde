class Console{
  String name;
  String [] buttons;
  color [] colors;
  PImage img;
  
  Console(String _name, String _imagename, String [] _buttons, color [] _colors){
    name = _name;
    buttons = _buttons;
    colors = _colors;
    img = loadImage(_imagename);
  }
}
