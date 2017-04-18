function deleteParItem(obj){
	try{		
		var itemNo = (obj != null ? obj.itemNo : $F("itemNo"));
		if (objUWParList.binderExist == "Y"){
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
			return false;
		}
		objFormMiscVariables.miscNbtInvoiceSw = "Y"; //added by irwin 11.24.11
		
		$$("div#itemTable div[item='" + itemNo + "']").each(function(row){
			Effect.Fade(row, {
				duration : .2,
				afterFinish : function(){
					//var delObj = (obj != null ? obj : setEndtItemObj()); // andrew - 05.24.2011
					itemNo = $F("itemNo");
					if(nvl(objCurrItem, null) != null){ //marco - 04.14.2014 - added condition and loop
						for(var i = 0; i < objGIPIWItem.length; i++){
							if(objGIPIWItem[i].itemNo == objCurrItem.itemNo){
								objGIPIWItem[i].recordStatus = -1;
							}
						}
						
						//marco - 04.14.2014 - added to filter drop down list
						if($("vesselCd") != null){
							filterAviationVesselLOV("vesselCd", "");
						}
						
						objCurrItem.recordStatus = -1;
						fireEvent(row, "click"); // andrew - 05.23.2011 - unselect row before remove
					}
					//addDeletedJSONObject(objGIPIWItem, obj);
					row.remove();
					
					//setParItemForm(null);
					checkIfToResizeTable("parItemTableContainer", "row");
					checkTableIfEmpty("row", "itemTable");
				}
			});
			if(/*$F("globalParType")*/ objUWParList.parType == "E"){	
				//added by steven 2.28.2013; to delete the div that contains the deleted item no. base on SR 0012187
				//Item Deductible
				$$("div[name='ded2']").each(function (row) {
					if (row.down("input", 0).value == itemNo){
						row.remove();
					}
				});
				//Peril Deductible
				$$("div[name='ded3']").each(function (row) {
					if (row.down("input", 0).value == itemNo){
						row.remove();
					}
				});
				//Peril Information
				$$("div[name='rowEndtPeril']").each(function(row){
						if(row.down("input", 0).value == itemNo){				
							row.remove();
						}
				});	
				for(var i=0; i<objGIPIWItemPeril.length; i++){
					if(nvl(objCurrItem, null) != null && objCurrItem.itemNo == objGIPIWItemPeril[i].itemNo){ //marco - 04.14.2014 - added null condition
						objGIPIWItemPeril[i].recordStatus = null;
					}
				}
				
				deleteTempCAGrpItms(itemNo); //Deo [01.26.2017]: SR-23702
			} else {
				// belle 04282011 added to remove peril 
				$$("div#itemPerilMotherDiv"+itemNo+" div[name='row2']").each(function(row){
					$("perilCd").value = row.getAttribute("peril");
					Effect.Fade(row, {
						duration: .001,
						afterFinish: function (){
							row.remove();
							clearItemPerilFields();
							checkPerilTableIfEmpty("row2", "itemPerilMotherDiv"+$F("itemNo"), "itemPerilMainDiv");
							checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
						}
					});
				});
				
				disableButton("btnDeleteDiscounts"); 
			}
			($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		});
	}catch(e){
		showErrorMessage("deleteParItem", e);
	}
}