function getItemPerilForPerilDiscount(parId, lineCd, itemNo, param){
	new Ajax.Updater($("itemPeril").up("td", 0), contextPath+"/GIPIParDiscountController", {
		parameters:{
			parId: parId,
			lineCd: lineCd,
			itemNo: itemNo,
			action: "getItemPerils"
			},
		evalScripts: true,
		asynchronous: false,
		onCreate: function () {
			$("itemPeril").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
		onComplete: function ()	{
			if (param != ""){
				var perils = $("itemPeril");
				for(i = 0; i < perils.length; i++) {	
					if(perils.options[i].value == param){
						perils.selectedIndex = i;	
			   		}
				}
			}
		}
	});
}