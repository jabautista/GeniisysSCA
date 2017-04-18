function updateNegated() { //moved codes : edgar 01/23/2015
	var objMap = objMapNegate;
	var objPerilList = objMap.gipiWItmPerl;
	var objItemList = getItemObjects();
	var recordStatus;
	var bool = false; // andrew - 11.24.2010 - used to check if a peril has been negated or deleted

	for(var x=0, y=objItemList.length; x < y; x++){
		recordStatus = nvl(objItemList[x].recordStatus, 0);
		if((recordStatus > -1) && objItemList[x].itemNo == $F("itemNo")){
			objItemList[x].tsiAmt		= objMap.tsiAmt;
			objItemList[x].premAmt 		= objMap.premAmt;
			objItemList[x].annTsiAmt	= objMap.annTsiAmt;
			objItemList[x].annPremAmt 	= objMap.annPremAmt;																		
			objItemList[x].recordStatus	= 1;
			
			$("itemTsiAmt").value 		 = formatCurrency(objMap.tsiAmt);
			$("itemPremiumAmt").value 	 = formatCurrency(objMap.premAmt);
			$("itemAnnPremiumAmt").value = formatCurrency(objMap.annPremAmt);
			$("itemAnnTsiAmt").value 	 = formatCurrency(objMap.annTsiAmt);
		}
	}
	
	if(objPerilList.length > 0){
		for(var i=0; i<objPerilList.length; i++){
			//if(objPerilList[i].itemNo == $F("itemNo")){ //commented out edgar 10/29/2014
			    objGIPIWItemPeril[i].itemNo			= objPerilList[i].itemNo; //added edgar 10/29/2014
			    objGIPIWItemPeril[i].lineCd			= objPerilList[i].lineCd;
				objGIPIWItemPeril[i].perilCd		= objPerilList[i].perilCd;
				objGIPIWItemPeril[i].discountSw		= objPerilList[i].discountSw;
				objGIPIWItemPeril[i].premRt			= objPerilList[i].premRt;
				objGIPIWItemPeril[i].tsiAmt			= objPerilList[i].tsiAmt;
				objGIPIWItemPeril[i].premAmt		= objPerilList[i].premAmt;
				objGIPIWItemPeril[i].annTsiAmt		= objPerilList[i].annTsiAmt;
				objGIPIWItemPeril[i].annPremAmt		= objPerilList[i].annPremAmt;
				objGIPIWItemPeril[i].prtFlat		= objPerilList[i].prtFlag;
				objGIPIWItemPeril[i].recFlag		= objPerilList[i].recFlag;
				objGIPIWItemPeril[i].riCommRate		= objPerilList[i].riCommRate; //edgar 10/21/2014
				if(objPerilList[i].riCommRate == null || objPerilList[i].riCommRate == ""){
					objGIPIWItemPeril[i].riCommAmt		= null;
				}else{
					objGIPIWItemPeril[i].riCommAmt		= formatCurrency(objPerilList[i].premAmt*(objGIPIWItemPeril[i].riCommRate/100)); // edgar 10/01/2014 for recomputation of ri_comm_amt
				}
				objGIPIWItemPeril[i].recordStatus	= 0;															
				updateNegatedPerilRow(objGIPIWItemPeril[i]); // andrew - 11.23.2010 - added this line to update the peril html row
				bool = true;															
		}
	}else{
		for(var i=0, length=objGIPIWItemPeril.length; i < length; i++){
			if(objGIPIWItemPeril[i].itemNo == $F("itemNo")){														
				var rowEndtPeril;
				addDeletedJSONObject(objGIPIWItemPeril, objGIPIWItemPeril[i]);
				rowEndtPeril = $("rowEndtPeril" + objGIPIWItemPeril[i].itemNo + objGIPIWItemPeril[i].perilCd);
				Effect.Fade(rowEndtPeril, {
					duration: .5,
					afterFinish: function () {
						rowEndtPeril.remove();
						checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
						checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");																
						setEndtPerilForm(null);
						setEndtPerilFields(null);
					}
				});		
				bool = true;
			}													
		}
	}																											
	
	
	delete objMap, objPerilList;														

	$("itemTsiAmt").scrollTo();
}