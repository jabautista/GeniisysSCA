function countItem(recFlag){
	try{
		var count = 0;
		if (recFlag == "" || recFlag == null){
			$$("div[name='row']").each(function(row){					
				count++;					
			});
		} else {
			$$("div[name='row']").each(function(row){					
				if(row.down("input", 10) != null){
					if(row.down("input", 10).value == recFlag){
						count++;
					}
				}					
			});
		}		
		return count;
	} catch (e){
		showErrorMessage("countItem", e);
		//showMessageBox("countItem : " + e.message);
	}
}