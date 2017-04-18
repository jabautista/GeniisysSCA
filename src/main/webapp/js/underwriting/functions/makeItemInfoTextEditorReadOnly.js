/**
 * Change the 'click' observe for calling the text editors
 * in the UW item information to make them readOnly fields
 * and disallow editing of information
 * @author Veronica V. Raymundo - 7/23/2012
 * @param editBtnId - id of the edit button
 */

function makeItemInfoTextEditorReadOnly(editBtnId){
	function showItemInfoTextEditor(btnId, textField, charLimit){
		if(nvl($(btnId), null) != null && nvl($(btnId), null) != null){
			$(btnId).stopObserving("click");
			$(btnId).observe("click", function(){
				showEditor(textField, charLimit, "true");
			});
		}
	}
	
	if(editBtnId == "editDesc"){
		showItemInfoTextEditor(editBtnId, "itemDesc", 2000);
	}else if(editBtnId == "editDesc2"){
		showItemInfoTextEditor(editBtnId, "itemDesc2", 2000);
	}else if(editBtnId == "editMortgRemarks"){
		showItemInfoTextEditor(editBtnId, "mortgageeRemarks", 2000);
	}
	
	var lineCd = getLineCd();
	
	if(lineCd == "FI"){
		if(editBtnId == "hrefConstructionRemarks"){
			showItemInfoTextEditor(editBtnId, "constructionRemarks", 2000);
		}else if(editBtnId == "hrefOccupancyRemarks"){
			showItemInfoTextEditor(editBtnId, "occupancyRemarks", 2000);
		}else if(editBtnId == "hrefFront"){
			showItemInfoTextEditor(editBtnId, "front", 2000);
		}else if(editBtnId == "hrefRight"){
			showItemInfoTextEditor(editBtnId, "right", 2000);
		}else if(editBtnId == "hrefLeft"){
			showItemInfoTextEditor(editBtnId, "left", 2000);
		}else if(editBtnId == "hrefRear"){
			showItemInfoTextEditor(editBtnId, "rear", 2000);
		}
	}else if(lineCd == "MC"){
		// no edit buttons
	}else if(lineCd == "AV"){
		if(editBtnId == "editPurpose"){
			showItemInfoTextEditor(editBtnId, "purpose", 200);
		}else if(editBtnId == "editDeductText"){
			showItemInfoTextEditor(editBtnId, "deductText", 200);
		}else if(editBtnId == "editQualification"){
			showItemInfoTextEditor(editBtnId, "qualification", 200);
		}else if(editBtnId == "editGeogLimit"){
			showItemInfoTextEditor(editBtnId, "geogLimit", 200);
		}
	}else if(lineCd == "MH"){
		if(editBtnId == "editDryPlace"){
			showItemInfoTextEditor(editBtnId, "dryPlace", 30);
		}else if(editBtnId == "editGeogLimit"){
			showItemInfoTextEditor(editBtnId, "geogLimit", 200);
		}
	}else if(lineCd == "MN"){
		// no edit buttons
	}else if(lineCd == "PA" || lineCd == "AC"){ //added "AC" by jdiago 08.06.2014
		if(editBtnId == "editBenRemarks"){ //added by jdiago 08.06.2014 : for beneficiary
			showItemInfoTextEditor(editBtnId, "beneficiaryRemarks", 4000);
		}
	}else if(lineCd == "CA"){
		if(editBtnId == "editRemarks"){ //added by steven 10/08/2012
			showItemInfoTextEditor(editBtnId, "txtRemarks", 4000); //modified by jdiago 08.06.2014 : from remarks to txtRemarks
		} else if(editBtnId == "editRemarksP"){ //added by jdiago 08.06.2014 for personnel remarks.
			showItemInfoTextEditor(editBtnId, "txtRemarksP", 4000);
		}
	}else if(lineCd == "EN"){
		// no edit buttons
	}else if(lineCd == "SU"){
		// no edit buttons
	}
}