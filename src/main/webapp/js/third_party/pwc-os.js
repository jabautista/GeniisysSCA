// Overide WindowUtilities getPageSize to remove dock height (for maximized windows)
WindowUtilities._oldGetPageSize = WindowUtilities.getPageSize;
WindowUtilities.getPageSize = function() {
  var size = WindowUtilities._oldGetPageSize();
  var dockHeight = $('dock').getHeight();
  
  size.pageHeight -= dockHeight;
  size.windowHeight -= dockHeight;
  return size;
};    


// Overide Windows minimize to move window inside dock  
Object.extend(Windows, {
  // Overide minimize function
  minimize: function(id, event) {
    var win = this.getWindow(id)
    if (win && win.visible) {
      // Hide current window
      win.hide();            
    
      // Create a dock element
      var element = document.createElement("span");
      element.className = "dock_icon"; 
      element.style.display = "none";
      element.win = win;
      $('dock').appendChild(element);
      Event.observe(element, "mouseup", Windows.restore);
      $(element).update(win.getTitle().truncate(10));
      $(element).setStyle({font: "10px Verdana", lineHeight: "2em"});
      new Effect.Appear(element, {duration: 0})
    }
    Event.stop(event);
  },                 
  
  // Restore function
  restore: function(event) { 
    var element = Event.element(event);
    // Show window
    element.win.show();
    //Windows.focus(element.win.getId());                    
    element.win.toFront();
    // Fade and destroy icon
    new Effect.Fade(element, {duration: 0, afterFinish: function() {element.remove()}})
  }
})

// blur focused window if click on document
Event.observe(document, "click", function(event) {   
  var e = Event.element(event);
  var win = e.up(".dialog");
  var dock = e == $('dock') || e.up("#dock"); 
  if (!win && !dock && Windows.focusedWindow) {
    Windows.blur(Windows.focusedWindow.getId());                    
  }
})               
/*
// Chnage theme callback
var currentTheme = 0;
function changeTheme(event) {
  var index = Event.element(event).selectedIndex;
  if (index == currentTheme)
    return;

  var theme, blurTheme;
  switch (index) {
    case 0:
      theme = "mac_os_x";
      blurTheme = "blur_os_x";
      break;
    case 1:
      theme = "bluelighting";
      blurTheme = "greylighting";
      break;
    case 2:
      theme = "greenlighting";
      blurTheme = "greylighting";
      break;
  }
  Windows.windows.each(function(win) {
    win.options.focusClassName = theme; 
    win.options.blurClassName = blurTheme;
    win.changeClassName(blurTheme)
  });
  Windows.focusedWindow.changeClassName(theme);
  currentTheme = index;
}*/

// Init webOS, create 3 windows
function initWebOS() {         
  // Create 3 windows
  //$R(1,3).each(function(index) {
    var win = new Window({className: "alphacube", 
    					  blurClassName: "alphacube", 
    					  title: "Client Application Main Menu",
    					  top: 0,
    					  bottom: 0,
    					  left: 0,
    					  right: 0,
    					  width: 1000, 
    					  height: 525, 
    					  parent: $("windowsDiv")}); 
    //win.getContent().update("<h1>Homepage Window</h1>");
    win.setConstraint(true, {top: 0, left: 0, right: 0, bottom: 0});
    win.show();
    win.setAjaxContent("pages/main.jsp", {}, false, false);
    win.maximize();
  //});                 
  //
  /*$$("#theme select").first().selectedIndex = currentTheme;
  Event.observe($$("#theme select").first(), "change", changeTheme);*/  
}
//Event.observe(window, "load", initWebOS);
               
               
