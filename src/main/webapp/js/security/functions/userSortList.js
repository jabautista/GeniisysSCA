// sort

function userSortList(listId) {
	var arrayText = new Array();
	var arrayCd = new Object();
	var i = 0;
	$$("div#" + listId + " div[name='row']").each(function(o) {
		if (o.getStyle("display") != "none") {
			//arrayText[i] = o.down("label", 0).innerHTML;
			//arrayCd[o.down("label", 0).innerHTML] = o.down("input", 0).value;
			arrayText[i] = o.childNodes[1].innerHTML; //changed to prevent illegal string error
			arrayCd[o.childNodes[1].innerHTML] = o.childNodes[0].value;
			i++;
		}
	});

	arrayText.sort();

	var j = 0;
	$$("div#" + listId + " div[name='row']").each(function(o) {
		if (o.getStyle("display") != "none") {
			o.writeAttribute("id", "row" + arrayCd[arrayText[j]]);
			//o.down("input", 0).value = arrayCd[arrayText[j]];
			//o.down("label", 0).innerHTML = arrayText[j];
			//o.down("label", 0).writeAttribute("title", arrayText[j]);
			o.childNodes[0].value = arrayCd[arrayText[j]];
			o.childNodes[1].innerHTML = arrayText[j];
			o.childNodes[1].writeAttribute("title", arrayText[j]);
			j++;
		}
	});
}

// end of sort