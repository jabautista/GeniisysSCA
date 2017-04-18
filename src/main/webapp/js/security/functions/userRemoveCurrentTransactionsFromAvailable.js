// remove current transactions from available transaction list
function userRemoveCurrentTransactionsFromAvailable(list1, list2) {
	$$("div[name='"+list1+"'] div[name='row']").invoke("hide");
	
	var list2Array = $$("div[name='"+list2+"'] div[name='row']").pluck("id");
	$$("div[name='"+list1+"'] div[name='row']").each(function (obj) {
		if (!list2Array.include(obj.readAttribute("id"))) {
			obj.show();
		}
	});
}