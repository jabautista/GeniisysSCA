function loadSelectedItemRowOnPerilProcedures(itemNo){
	try {
		getItemPerilDetails();
		getTotalAmounts();
		if (countPerilsForItem(itemNo) > 0){
			if (countItems() > 1){
				enableButton("btnCopyPeril");
			}
		}
		
		if($("itemPerilMotherDiv"+$F("itemNo")) != null){
			if(($("itemPerilMotherDiv"+$F("itemNo")).childElements()).size() > 0){
				showItemPerilMotherDiv($F("itemNo"));
				$("itemPerilMainDiv").show();
				$("itemPerilMotherDiv"+$F("itemNo")).show();
				checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
			}else{
				$("itemPerilMotherDiv"+$F("itemNo")).hide();
				$("itemPerilMainDiv").hide();			
				$("perilTotalTsiAmt").value = formatCurrency(0);
				$("perilTotalPremAmt").value = formatCurrency(0);
			}						
		}else{
			$("itemPerilMainDiv").hide();
		}
		
		if (objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
			for (var i=0; i<objGIPIWItemWGroupedPeril.length; i++){
				if (objGIPIWItemWGroupedPeril[i].itemNo == itemNo){
					if (objGIPIWItemWGroupedPeril[i].itmperlGroupedExists == "Y"){
						//$("chkAggregateSw").disabled = true;
						$("perilGroupExists").value = "Y";
						$("perilPackageCd").disable();
					}
				}
			}
			$("perilPackageCd").value = $("accidentPackBenCd").value;
			$("vOldPlan").value = $("perilPackageCd").value;
		
			new Ajax.Request(contextPath+"/GIPIWItemController?action=getPlanDetails",{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					globalParId:		(objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
					globalPackParId:	(objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalPackParId")),
					packLineCd:			$F("packLineCd"),
					packSublineCd:		$F("packSublineCd")
				},
				onComplete: function (response)	{
					if (checkErrorOnResponse(response)){
						var a = response.responseText;
						var b = a.split(",");
						$("varPackPlanSw").value 	= b[0] == "null" ? "" : b[0];
						$("varPackPlanCd").value 	= b[1] == "null" ? "" : b[1];
						$("varPlanSw").value 		= b[2] == "null" ? "" : b[2];
						$("vOra2010Sw").value 		= b[3] == "null" ? "" : b[3];
		
						$("planSw").value = $F("varPackPlanSw");
						$("planCd").value = $F("varPackPlanCd");
		
						if (("Y" == $F("varPlanSw")) && ("Y" == $("vOra2010Sw")) && (countPerilsForItem($F("itemNo")) == 0)){
							showConfirmBox("Package Plan", 
									"This is a package plan PAR record. Would you like to apply the peril/s maintained? Press YES to apply the peril/s and NO will untag the par record.", 
									"Yes", "No", addMaintainedPerils, clearPlanDetails);
						}
					}
				}
				
			});
		}
	} catch(e){
		showErrorMessage("loadSelectedItemRowOnPerilProcedures", e);
	}
}