function initializeItemInfoTagBehavior(attName) {	
	$$("div[" + attName + "='true']").each(function (a) {
		a.descendants().each(function (obj) {
			if (obj.nodeName == "SELECT") {
				obj.observe("change", function () {
					masterDetail = true;
				});
			} else if (obj.nodeName == "INPUT" || obj.nodeName == "TEXTAREA") {
				obj.observe("keyup", function () {					
					masterDetail = true;
				});
			} else if (obj.nodeName == "INPUT" && obj.readAttribute("type") == "checkbox") {
				obj.observe("click", function () {
					masterDetail = true;
				});
			}
		});
	});
	/*
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
}