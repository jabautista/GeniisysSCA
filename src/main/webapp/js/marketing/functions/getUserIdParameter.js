function getUserIdParameter(){
	var userId = "";
	var currentContent = "";
	try{
		$$("div#mainContents").each(function (test){
			currentContent = test.down("div", 0).id;
		});
		if (currentContent == 'assuredListingMainDiv'){ //added by angelo 01.28.2011 for assured listing
			$$("div[name='row']").each(function(assured){
				if (assured.hasClassName("selectedRow")){
					userId = assured.down("label", 4).innerHTML;
					$continue;
				}
			});
		} else {
			$$("div[name='row']").each(function(quoteEntry){
				if(quoteEntry.hasClassName("selectedRow")){
					userId = quoteEntry.down("span",5).down("label",0).title;
					$continue;
				}
			});
		}
		
	}catch (e){
		userId = "CPI"; 
	};
	return userId;
}