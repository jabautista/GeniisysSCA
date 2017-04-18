function checkItemCount(){
	//if ($F("globalPackParId") != null ){
	var itemCount = 0;
	$$("div#parItemTableContainer div[name='row']").each(function(a){
		itemCount++;
	});
	if (parseFloat(itemCount) > 1){
		enableButton("btnCopyPeril");
	}
	//}
}