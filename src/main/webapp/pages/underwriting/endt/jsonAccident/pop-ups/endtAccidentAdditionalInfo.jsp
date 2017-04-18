<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="message" style="display:none;">${message}</div>
<div id="accidentModalMainDiv" style="height:525px; overflow-y: auto;">
	<form id="accidentModalForm" name="accidentModalForm">
		<input type="hidden" id="globalParId" 	 			name="globalParId" 				value="${parId}" />
		<input type="hidden" id="parId" 		 			name="parId" 					value="${parId}" />
		<input type="hidden" id="itemNo" 	     			name="itemNo" 					value="${itemNo}" />
		<input type="hidden" id="globalLineCd" 	 			name="globalLineCd" 			value="${lineCd}" />
		<input type="hidden" id="globalIssCd" 	 			name="globalIssCd" 				value="${issCd}" />
		<input type="hidden" id="itemPerilExist" 			name="itemPerilExist"  			value="${itemPerilExist }" />
		<input type="hidden" id="itemPerilGroupedExist" 	name="itemPerilGroupedExist"  	value="${itemPerilGroupedExist }" />
		<input type="hidden" id="tempSave" 		 			name="tempSave"  				value="" />
		<input type="hidden" id="isSaved" 	 	 			name="isSaved"  				value="" />
		<input type="hidden" id="newNoOfPerson"  			name="newNoOfPerson"  			value="" />
		<input type="hidden" id="totalTsiAmtPerItem"   		name="totalTsiAmtPerItem"  		value="${gipiWItem.tsiAmt }" class="money" maxlength="18"/>
		<input type="hidden" id="totalPremAmtPerItem"  		name="totalPremAmtPerItem"  	value="${gipiWItem.premAmt }" class="money" maxlength="14"/>
		<input type="hidden" id="isFromOverwriteBen"   		name="isFromOverwriteBen"    	value="${isFromOverwriteBen }" />
		<input type="hidden" id="doRenumber"     	   		name="doRenumber"  				value="" />
		<input type="hidden" id="popBenefitsSw" 	   		name="popBenefitsSw" 			value="" />
		<input type="hidden" id="popBenefitsGroupedItemNo" 	name="popBenefitsGroupedItemNo" value="" />
		<input type="hidden" id="popBenefitsPackBenCd" 		name="popBenefitsPackBenCd" 	value="" />
		
	<div id="groupedItemsDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Grouped Items/Beneficiary Information</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showGroupedItems" name="gro2" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>	
		<jsp:include page="/pages/underwriting/endt/jsonAccident/subPages/endtAccidentGroupedItems.jsp"></jsp:include>
	</div>
	
	<div id="popBenDiv">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Copy Benefits</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showPopBenefit" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>	
		<jsp:include page="/pages/underwriting/endt/jsonAccident/subPages/endtAccidentPopulateBenefits.jsp"></jsp:include>
	</div>
	
	<div id="coverageDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Enrollee Coverage</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showCoverage" name="gro3" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>			
		<jsp:include page="/pages/underwriting/endt/jsonAccident/subPages/endtAccidentCoverage.jsp"></jsp:include>	
	</div>
	
	<div id="beneficiaryDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Beneficiary Information</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showBeneficiary" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>			
		<jsp:include page="/pages/underwriting/endt/jsonAccident/pop-ups/endtAccidentBeneficiary.jsp"></jsp:include>	
	</div>
	
	<div class="buttonsDiv">
		<input type="button" class="button"  id="btnCancelGrp" name="btnCancelGrp"  value="Cancel" 	style="width: 60px;" />
		<input type="button" class="button"  id="btnSaveGrp1" 	name="btnSaveGrp1" 	  value="Save" 		style="width: 60px;" />
	</div>	
	</form>
</div>
<script type="text/javascript">
try{
	$("accidentModalMainDiv").hide();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();

	function initializeAccordion2()	{
		$$("label[name='gro2']").each(function (label)	{
			label.observe("click", function ()	{
				label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
				var infoDiv = label.up("div", 1).next().readAttribute("id");
				Effect.toggle(infoDiv, "blind", {duration: .3});
				Effect.toggle("groupedItemsInformationInfo2", "blind", {duration: .3});
			});
		});

		$$("label[name='gro3']").each(function (label)	{
			label.observe("click", function ()	{
				if ($F("itemPerilExist") == "Y" && $F("itemPerilGroupedExist") != "Y"){
					showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module");
					return false;
				} else{
					label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
					var infoDiv = label.up("div", 1).next().readAttribute("id");
					Effect.toggle(infoDiv, "blind", {duration: .3});
				}		
			});
		});
	}
	
	initializeAccordion2();

	if($F("accidentPackBenCd") != ""){
		//enableButton("btnPopulateBenefits"); 
	} else{
		//disableButton("btnPopulateBenefits"); 
	}		

	if($F("isFromOverwriteBen") == "Y"){
		$("isSaved").value = "Y";
	} else{
		/*
		$("MB_close").observe("click",function(){
			if ($F("isSaved") == "Y"){
				showItemInfo();
				window.scrollTo(0,0); 
			}
		});	

		$("MB_overlay").observe("click",function(){
			if ($F("isSaved") == "Y"){
				showItemInfo();
				window.scrollTo(0,0); 
			}	
		});
		*/
	}
	
	function saveAccidentGroupedItemsModal(){
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentGroupedItemsModal", {
			method : "POST",
			postBody : Form.serialize("accidentModalForm"),
			asynchronous : false,
			evalScripts : true,
			onCreate : 
				function(){
					$("accidentModalForm").disable();
					showNotice("Saving, please wait...");
				},
			onComplete :
				function(response){
					hideNotice("");
					$("accidentModalForm").enable();
					if (checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							$("isSaved").value = "Y";
							$("tempSave").value = "";
							showMessageBox("SUCCESS.", imgMessage.SUCCESS);
						}
					}				
				}
		});	
	}
	
	$("MB_close").observe("click",function(){
		//if(changeTag == 1){
		//	showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
		//		saveEndtGroupedItems();
		//		changeTag = 0;
		//	}, function(){	Modalbox.hide();	}, "");
		//}else{
		//	changeTag = 0;
		//	Modalbox.hide();
		//	//overlayAccidentGroup.close();
		//}
		//Modalbox.hide({executeOnHideFunc: true});
		$("btnCancelGrp").click();
	});	
	
	$("btnCancelGrp").observe("click",function(){
		/*		
		if ($F("isSaved") == "Y"){
			//Modalbox.hide();
			//showItemInfo();
			//window.scrollTo(0,0); 
			overlayAccidentGroup.close();
		} else{
			//Modalbox.hide();
			overlayAccidentGroup.close();
		}
		*/
		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveEndtGroupedItems();
				changeTag = 0;
			}, function(){	Modalbox.hide();	}, "");
		}else{
			changeTag = 0;
			Modalbox.hide();
			//overlayAccidentGroup.close();
		}		
	});	
	
	$$("img[name='accModalDate']").each( function(a)	{
		a.observe("click", function ()	{
			window.scrollTo(0,0); 
		});
	});

	var countRow = 0;
	$$("div[name='grpItem']").each( function(a)	{
		countRow++;	
	});
	if (countRow > 0){
		//enableButton("btnPopulateBenefits"); 
		enableButton("btnCopyBenefits");
		enableButton("btnDeleteBenefits");
		enableButton("btnSelectedGroupedItems");
		enableButton("btnAllGroupedItems");
		enableButton("btnRenumber"); 
	} else{
		disableButton("btnRenumber"); 
		//disableButton("btnPopulateBenefits"); 
		disableButton("btnCopyBenefits");
		disableButton("btnDeleteBenefits");
		disableButton("btnSelectedGroupedItems");
		disableButton("btnAllGroupedItems");
	}	
	var margin = parseInt(12*(countRow>5?5:countRow));
	$("subButtonDiv").setStyle("margin-top:"+margin+"px");
	
	$("btnRenumber").observe("click",function(){
		$("popBenDiv").hide();
		var renumSum = 0;
		var renumCtr = 0;
		$$("div[name='grpItem']").each( function(a)	{
			renumSum++;	
		});
		for(i=1;i<=renumSum;i++){
			$$("div[name='grpItem']").each( function(row)	{
				if (row.down("input",2).value == parseInt(i)){
					renumCtr++;
				}		
			});
		}	
		if (parseInt(renumSum) == parseInt(renumCtr)){
			showMessageBox("Renumber will only work if group item are not arranged consecutively.", imgMessage.ERROR);
		} else{
			showConfirmBox("Message", "Renumber will automatically reorder your group item number(s) sequentially. Do you want to continue?",  
					"Yes", "No", onOkFuncRenum, onCancelFuncRenum);
		}	
	});
	function onOkFuncRenum(){
		var ctr = 0;
		$$("div[name='grpItem']").each( function(a)	{
			ctr++;	
		});
		if (ctr<2){
			$("newNoOfPerson").value = $("noOfPerson").value;
		} else{
			$("newNoOfPerson").value = ctr;
		}
		$("doRenumber").value = "Y";
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentGroupedItemsModal", {
			method : "POST",
			postBody : Form.serialize("accidentModalForm"),
			asynchronous : false,
			evalScripts : true,
			onCreate : 
				function(){
					$("accidentModalForm").disable();
					showNotice("Saving, please wait...");
				},
			onComplete :
				function(response){
					$("isSaved").value = "Y";
					$("tempSave").value = "";
					$("doRenumber").value = "";
					if (response.responseText == "SUCCESS"){
						hideNotice("SUCCESS, Refreshing page please wait...");	
						showAccidentGroupedItemsModal($F("globalParId"),$F("itemNo"),"Y");
					} else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
		});	
	}	
	function onCancelFuncRenum(){
		null;
	}

	$("btnPopulateBenefits").observe("click",function(){
		if ($F("itemPerilExist")== "Y" && $F("itemPerilGroupedExist") != "Y"){
			showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module.", imgMessage.ERROR);
		} else{	
			if (checkGroupedItemNoExist()){
				if ($F("itemPerilGroupedExist") == "Y"){
					showConfirmBox("Message", "This will insert the default perils for the grouped item and overwrite the existing perils. Would  you like to continue?",  
							"Yes", "No", onOkFuncPopBen, onCancelFuncPopBen);
				} else{
					onOkFuncPopBen();
				}	
			} else{
				return false;
			}	
		}			
	});
	
	function onOkFuncPopBen(){
		$$("div[name='popBens']").each(function (a){
			a.down("input",4).value = "Y";
			a.down("input",5).checked = true;
			a.show();
		});
		checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","popBens","item",$F("itemNo"));
		$("popBenDiv").down("label").update("Populate Benefits");
		$("popBenDiv").show();
		$("btnOkPopBen").show();
		$("btnOkCopyBen").hide();
		$("btnOkDeleteBen").hide();	
	}
	function onCancelFuncPopBen(){
		$("popBenDiv").hide();
		$("btnOkPopBen").show();
		$("btnOkDeleteBen").show();
		$("btnOkCopyBen").show();
	}

	$("btnDeleteBenefits").observe("click",function(){
		$$("div[name='popBens']").each(function (a){
			a.down("input",4).value = "Y";
			a.down("input",5).checked = true;
			a.show();
		});
		checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","popBens","item",$F("itemNo"));
		$("popBenDiv").down("label").update("Delete Benefits");
		$("popBenDiv").show();
		$("btnOkPopBen").hide();
		$("btnOkCopyBen").hide();
		$("btnOkDeleteBen").show();
	});	

	$("btnCopyBenefits").observe("click",function(){
		if (checkGroupedItemNoExist()){
			$("popBenDiv").down("label").update("Copy Benefits");
			$("popBenDiv").show();
			$("btnOkPopBen").hide();
			$("btnOkCopyBen").show();
			$("btnOkDeleteBen").hide();

			$$("div[name='popBens']").each(function (a){
				if (a.getAttribute("id") == "rowPopBens"+$F("itemNo")+""+getSelectedRowAttrValue("grpItem","groupedItemNo")){
					a.down("input",4).value = "N";
					a.down("input",5).checked = false;
					a.hide();
				} else{
					a.down("input",4).value = "Y";
					a.down("input",5).checked = true;
					a.show();
				}		
			});
			var ctr = 0;
			$$("div[name='grpItem']").each( function(a)	{
				ctr++;	
			});
			if (ctr<=5){
				$("accidentPopBenTable").setStyle("height: " + (ctr*31) +"px;"); 
			}
		} else{
			return false;
		}
	});	

	$("btnCancelPopBen").observe("click",function(){
		$("popBenDiv").hide();
		$("popBenefitsSw").value = "";
	});

	$("btnOkPopBen").observe("click",function(){
		$("popBenefitsSw").value = "P";
		$("popBenefitsGroupedItemNo").value = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				$("popBenefitsPackBenCd").value = row.down("input",5).value;	
			}	
		});
		if (checkGroupedItemNoExist()){
			okPopBen();
		}
	});	

	$("btnOkCopyBen").observe("click",function(){
		$("popBenefitsSw").value = "C";
		$("popBenefitsGroupedItemNo").value = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				$("popBenefitsPackBenCd").value = row.down("input",5).value;	
			}	
		});
		if (checkGroupedItemNoExist()){
			okPopBen();
		}
	});	

	$("btnOkDeleteBen").observe("click",function(){
		$("popBenefitsSw").value = "D";
		$("popBenefitsGroupedItemNo").value = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				$("popBenefitsPackBenCd").value = row.down("input",5).value;	
			}	
		});
		okPopBen();
	});	

	function okPopBen(){
		var ctr = 0;
		$$("div[name='grpItem']").each( function(a)	{
			ctr++;	
		});
		if (ctr<2){
			$("newNoOfPerson").value = $("noOfPerson").value;
		} else{
			$("newNoOfPerson").value = ctr;
		}
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentGroupedItemsModal", {
			method : "POST",
			postBody : Form.serialize("accidentModalForm"),
			asynchronous : false,
			evalScripts : true,
			onCreate : 
				function(){
					$("accidentModalForm").disable();
					showNotice("Saving, please wait...");
				},
			onComplete :
				function(response){
					$("isSaved").value = "Y";
					$("tempSave").value = "";
					$("popBenefitsSw").value = "";
					$("popBenefitsGroupedItemNo").value = "";
					if (response.responseText == "SUCCESS"){
						hideNotice("SUCCESS, Refreshing page please wait...");	
						showAccidentGroupedItemsModal($F("globalParId"),$F("itemNo"),"Y");
					} else{
						showMessageBox(response.responseText, imgMessage.ERROR);	
					}			
				}
		});	
	}	

	$("btnUploadEnrollees").observe("click", function(){
		showUploadEnrolleesOverlay($("globalParId").value,$("itemNo").value,"");
	});

	$("popBenDiv").hide();
	hideNotice();
	
	$("btnSaveGrp1").observe("click", function(){		
		var ctr = 0;
		$$("div[name='rowEnrollee']").each(function(row) {
			ctr++;
		});
		
		function onOkChange() {
			$("noOfPerson").value = ctr;
			saveEndtGroupedItems();
		}
		
// 		if (ctr < 2){	remove by steven 9/4/2012 dapat pwede pa rin siyang magsave kasi na-add ung group na yan sa paggawa ng policy,bali i-a-update mo lang siya kaya dapat nakakapag-save siya.
// 			showMessageBox("Minimun no. of Grouped Items is two(2).", imgMessage.ERROR);
// 			return false;
// 		} 
		/* else if ($F("noOfPerson") != ctr){
			showConfirmBox("Message", "Saving the changes will update the No. of Persons, do you want to continue ?",  
					"Yes", "No", onOkChange, "");
		} */  //else{
			saveEndtGroupedItems();
// 		}
		
	});
	
	$("accidentModalMainDiv").show();
	changeTag = 0;
	initializeChangeTagBehavior(saveEndtGroupedItems);
	initializeChangeAttribute();
	//checkIfCancelledEndorsement(); // added by: Nica 07.23.2012 - to check if to disable fields if PAR is a cancelled endt
	
}catch(e){
	showErrorMessage("Endt Accident Item Additional", e);
}
</script>	
	