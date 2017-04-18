// whofeih
// no applied to all yet
function initializeChangeTagBehavior(func) {
	//changeTag = 0; andrew - 09.23.2010 - ilagay na lang sa pagload ng mga module to, para hindi maging 0 ulit pag tinawag itong function sa pagload ng mga subpage 
	// for change tag
	changeTagFunc = func || ""; //edit Nok changeTagFunc = "";
	$$("div[changeTagAttr='true']").each(function (a) {		
		a.descendants().each(function (obj) {
			if(!obj.hasAttribute("readonly")){
				if (obj.nodeName == "SELECT") {
					obj.observe("change", function () {
						changeTag = 1;
						changeTagFunc = func;
					});
				}
				if (obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA") {
					obj.observe("keyup", function (event) {		
						if(event.keyCode != Event.KEY_TAB // andrew - 02.17.2011 - exceptions keys on keyup event
							   && event.keyCode != Event.KEY_RIGHT
							   && event.keyCode != Event.KEY_LEFT
							   && event.keyCode != Event.KEY_UP
							   && event.keyCode != Event.KEY_DOWN
							   && event.keyCode != Event.KEY_PAGEUP
							   && event.keyCode != Event.KEY_PAGEDOWN
							   && event.keyCode != Event.KEY_ALT
							   && event.keyCode != Event.KEY_CONTROL
							   && event.keyCode != Event.KEY_SHIFT
							   && event.keyCode != Event.KEY_ESCAPE
							   && event.keyCode != Event.KEY_INSERT
							   && event.keyCode != Event.KEY_HOME
							   && event.keyCode != Event.KEY_END){												
							changeTag = 1;
							changeTagFunc = func;				
						}					
					});
				}
				if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "checkbox") {
					obj.observe("change", function () { //edit by Nok changed observe click to change
						changeTag = 1;
						changeTagFunc = func;
					});
				}
				if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "radio") {
					obj.observe("change", function () { //added by: Nica 06.20.2012 to observe changes in radio buttons
						changeTag = 1;
						changeTagFunc = func;
					});
				}
				//added by andrew - 02.08.2011 - to observe buttons within div with changeTagAttr
				if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "button" && obj.readAttribute("id") != "btnSave" && obj.readAttribute("id") != "btnCancel") {
					obj.observe("click", function () {
						if (obj.hasClassName("noChangeTagAttr")) return; //added by Nok 02.11.2011
						changeTag = 1;
						changeTagFunc = func;
					});
				}
			}
		});
	});
	
	/* comment this part - nok 02.11.11
	$$("div:not([changeTagAttr='true'])").each(function (a) {
		a.descendants().each(function (obj) {
			if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "button" && obj.readAttribute("id") != "btnSave" && obj.readAttribute("id") != "btnCancel") {
				obj.observe("click", function () {
					changeTag = 1;
					changeTagFunc = func;
				});
			}
		});
	});
	*/
	// end of for changeTag
}