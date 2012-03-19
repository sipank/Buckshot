#import('../../core/Buckshot.dart');
#import('../DemoStyles/DemoStyles.dart');
#import('dart:html');
#source('UpperCaseConverter.dart');

// To compile:
// minfrog --out=ValueConversion.dart.app.js --compile-only ValueConversion.dart

class ValueConversion {
StyleResources resources;

  void run() {
    //init LUCA UI
    new BuckshotSystem();
    
    //instantiate style resources
    resources = new StyleResources();
    
    //bind BuckshotSystem.visualRoot to window dimensions
    new Binding(BuckshotSystem.windowWidthProperty, BuckshotSystem.visualRoot.widthProperty);
    new Binding(BuckshotSystem.windowHeightProperty, BuckshotSystem.visualRoot.heightProperty);
    
    //make the mainGrid and set it's style
    Grid mainGrid = new Grid();
    mainGrid.style = resources.mainGridStyle;

    Border outerContentBorder = new Border();
    outerContentBorder.style = resources.contentBorderStyle;
    Grid.setRow(outerContentBorder, 2);
    mainGrid.children.add(outerContentBorder);
    
    Border innerContentBorder = new Border();
    innerContentBorder.style = resources.innerBorderStyle;
    outerContentBorder.content = innerContentBorder;
    
    TextBlock title = new TextBlock();
    title.style = resources.titleTextBlockStyle;
    title.text = "Value Conversion and Data Binding";
    mainGrid.children.add(title);
    
    TextBlock subTitle = new TextBlock();
    subTitle.style = resources.subTitleTextBlockStyle;
    subTitle.text = "The value of the TextBox is bound to the TextBlock and converted on-the-fly to upper case.";
    Grid.setRow(subTitle, 1);
    mainGrid.children.add(subTitle);
    
    Grid contentGrid = buildContentGrid(); 
    innerContentBorder.content = contentGrid;
    
    generateContent(contentGrid);
    
    BuckshotSystem.renderRaw(mainGrid);
  }
  
  void generateContent(Grid contentGrid){
    TextBlock info = new TextBlock();
    info.style = resources.centeredStyle;
    info.text = "Enter text into the text box below.  The text property of it is bound to a text block below it that has a value converter attached.  As you type, the text will appear in all caps as it passes through the converter.";
    info.width = 500;
    contentGrid.children.add(info);
    
    TextBox enter = new TextBox();
    enter.style = resources.centeredStyle;
    enter.width = 300;
    enter.placeholder = "Enter some lowercase text here...";
    Grid.setRow(enter, 1);
    contentGrid.children.add(enter);
    
    TextBlock output = new TextBlock();
    output.style = resources.centeredStyle;
    output.fontSize = 24;
    output.text = "hello";
    Grid.setRow(output, 2);
    contentGrid.children.add(output);
    
    
    // this binding handles all the work for us as the user types into the text box
    new Binding(enter.textProperty, output.textProperty, BindingMode.OneWay, new UpperCaseConverter());
  }

  Grid buildContentGrid(){
    Grid g = new Grid();
    g.background = new SolidColorBrush(new Color.predefined(Colors.WhiteSmoke));
    g.style = resources.stretchedStyle;
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(.3)));
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(.3)));
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
    
    return g;
  } 
}

void main() {
  new ValueConversion().run();
}
