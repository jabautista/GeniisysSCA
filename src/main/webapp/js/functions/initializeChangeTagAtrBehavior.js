function initializeChangeTagAtrBehavior(func) {	 
	changeTagFunc = "";
	
	$$("div[changeTagAttr='true']").each(function (a) {
		a.descendants().each(function (obj) {
			if (obj.nodeName == "SELECT") {
				obj.observe("change", function () {
					a.setAttribute("changeTagAttr", "changed");
					changeTagFunc = func;
				});
			} else if (obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA") {
				obj.observe("keyup", function () {
					a.setAttribute("changeTagAttr", "changed");
					changeTagFunc = func;
				});
			} else if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "checkbox") {
				obj.observe("click", function () {
					a.setAttribute("changeTagAttr", "changed");
					changeTagFunc = func;
				});
			}
		});
	});
	
	$$("div:not([changeTagAttr='true'])").each(function (a) {
		a.descendants().each(function (obj) {
			if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "button" && obj.readAttribute("id") != "btnSave" && obj.readAttribute("id") != "btnCancel") {
				obj.observe("click", function () {
					a.setAttribute("changeTagAttr", "changed");
					changeTagFunc = func;
				});
			}
		});
	});	
}