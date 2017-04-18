//returns rows whose parent row is removed
function returnRows(list1, list2){
	if (trim($(list2).innerHTML) != ''){ //checks if the div is empty
		$$("div#" + list2 + " div[name='row']").each(function (row){
			row.removeClassName("selectedRow");
			row.removeAttribute("userid");
			row.removeAttribute("trancd");
			if (list2 == "lineSelect1"){
				row.removeAttribute("issCd");
			}
			$(list1).insert({bottom : row});
		});
		userSortList(list1);
	}
}