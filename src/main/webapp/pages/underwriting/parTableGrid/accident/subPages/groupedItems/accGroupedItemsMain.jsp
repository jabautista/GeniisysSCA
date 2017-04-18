<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="accidentModalMainDiv" style="height: 525px; width: 900px; overflow: auto;">
	<form id="accidentModalForm" name="accidentModalForm">
		<input type="hidden" id="isFromOverWriteBen" value="${isFromOverwriteBen}" />
		<input type="hidden" id="itemPerilExist" name="itemPerilExist" value="" />
		<input type="hidden" id="itemPerilGroupedExist" name="itemPerilGroupedExist" value="" />
	
		<div id="groupedItemsDetail">
			<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGroupedItems.jsp"></jsp:include>			
		</div>
		
		<div id="coverageDetail">
			<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
				<div id="innerDiv" name="innerDiv">
					<label>Enrollee Coverage</label>
						<span class="refreshers" style="margin-top: 0;">
						<label id="showCoverage" name="groItem" tableGrid="tbgItmperlGrouped" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>	
			<div id="accCoverageInfo" class="sectionDiv" style="display: none; width:872px; background-color:white;">
				<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accCoverage.jsp"></jsp:include>
			</div> 				 
		</div>
		
		<div id="accBeneficiaryDetail">
			<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;">
				<div id="innerDiv" name="innerDiv">
			   		<label>Beneficiary Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showAccBeneficiary" name="groItem" tableGrid="tbgGrpItemsBeneficiary" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>					
			<div id="accBeneficiaryInfo" class="sectionDiv" style="display: none; width:872px; background-color:white;">	
				<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGrpItemsBen.jsp"></jsp:include>
			</div>	
		</div>
		
		<div class="buttonsDiv">
			<input type="button" class="button"  id="btnCancelGrp" name="btnCancel"  value="Cancel" 	style="width: 60px;" />
			<input type="button" class="button"  id="btnSaveGrp" 	name="btnSave" 	  value="Save" 		style="width: 60px;" />
		</div>	
	</form>
</div>
<script type="text/javascript">
try{

	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeItemAccordion();
	
	function validateBeforeSave(refresh){
		try{
			//if(getAddedAndModifiedJSONObjects(objGIPIWGroupedItems).length < 2){
			var cntEnrollee = ((tbgGroupedItems.bodyTable.down('tbody').childElements()).filter(function(row){ return row.style.display != "none"; })).length;
			//if(((tbgGroupedItems.bodyTable.down('tbody').childElements()).filter(function(row){ return row.style.display != "none"; })).length < 2){ 
			//	if(cntEnrollee != 0 && cntEnrollee < 2  ){ //belle 09132012 comment out by bonok :: 12.13.2012
			if(tbgGroupedItems.pager.total != 0 && tbgGroupedItems.pager.total < 2){ // temp solution bonok :: 12.13.2012
				showMessageBox("Minimum no. of Grouped Items is two(2).", imgMessage.INFO);
				return false;
			}else if(objCurrItem.gipiWAccidentItem.noOfPersons != objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	}).length){
				showConfirmBox("Message", "Saving the changes will update the No. of Persons, do you want to continue ?", "Yes", "No", 
						function(){
							//$("noOfPerson").value = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	}).length; 
							var noOfPerson = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	}).length; //belle 09132012
							$("noOfPerson").value = noOfPerson == 0 ? 1 : noOfPerson;							
							addModifiedJSONObject(objGIPIWItem, setParItemObj());
							saveAccidentGroupedItemsModal(refresh);	
						}, ""
				);
			}else{
				saveAccidentGroupedItemsModal(refresh);
			}
		}catch(e){
			showErrorMessage("validateBeforeSave", e);
		}
	}
	
	function saveAccidentGroupedItemsModal(refresh){
		try{
			var executeSave = false;
			var objParameters = new Object();
			
			objParameters.setItemRows			= getAddedAndModifiedJSONObjects(objGIPIWItem);
			objParameters.setGroupedItems 		= getAddedAndModifiedJSONObjects(objGIPIWGroupedItems);
			objParameters.delGroupedItems 		= getDeletedJSONObjects(objGIPIWGroupedItems);
			objParameters.setWItmperlGrouped	= getAddedAndModifiedJSONObjects(objGIPIWItmperlGrouped);
			objParameters.delWItmperlGrouped	= getDeletedJSONObjects(objGIPIWItmperlGrouped);
			objParameters.setGrpItemsBens		= getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary);
			objParameters.delGrpItemsBens		= getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary);
			objParameters.setWItmperlBens		= getAddedAndModifiedJSONObjects(objGIPIWItmperlBeneficiary);
			objParameters.detWItmperlBens		= getDeletedJSONObjects(objGIPIWItmperlBeneficiary);
			for(attr in objParameters){
				if(objParameters[attr].length > 0){
					executeSave = true;
					break;
				}
			}

			if(executeSave){
				objParameters.misc	= prepareJsonAsParameter(objFormMiscVariables);
				
				objParameters.setItemRows		= prepareJsonAsParameter(objParameters.setItemRows);
				objParameters.setGroupedItems	= prepareJsonAsParameter(objParameters.setGroupedItems);
				objParameters.delGroupedItems	= prepareJsonAsParameter(objParameters.delGroupedItems);
				objParameters.setCoverages		= prepareJsonAsParameter(objParameters.setWItmperlGrouped);
				objParameters.delCoverages		= prepareJsonAsParameter(objParameters.delWItmperlGrouped);
				objParameters.setBeneficiaries	= prepareJsonAsParameter(objParameters.setGrpItemsBens);
				objParameters.delBeneficiaries	= prepareJsonAsParameter(objParameters.delGrpItemsBens);
				objParameters.setBenPerils		= prepareJsonAsParameter(objParameters.setWItmperlBens);
				objParameters.delBenPerils		= prepareJsonAsParameter(objParameters.detWItmperlBens);
				
				new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentGroupedItemsModalTG", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters),
						parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId),
						lineCd : (objUWGlobal.lineCd != null ? objUWGlobal.lineCd: objUWParList.lineCd),
						issCd : (objUWGlobal.issCd != null  ? objUWGlobal.issCd: objUWParList.issCd)
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function(){
						showNotice("Saving grouped items, please wait ...");
					},
					onComplete : function(response){
						hideNotice();						
						if(checkErrorOnResponse(response)){
							if(response.responseText != "SUCCESS"){
								showMessageBox(response.responseText, imgMessage.ERROR);
							}else{
								/*
								clearObjectRecordStatus2(objGIPIWGroupedItems);
								clearObjectRecordStatus2(objGIPIWItmperlGrouped);
								clearObjectRecordStatus2(objGIPIWGrpItemsBeneficiary);
								clearObjectRecordStatus2(objGIPIWItmperlBeneficiary);							
								*/
								changeTag = 0;
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
									if(refresh) {
										reloadAccGroupedModal();
									} else {
										showItemInfo();
										Modalbox.hide();
									}
								});
							}
						}
					}
				});
			}
			
			
		}catch(e){
			showErrorMessage("saveAccidentGroupedItemsModal", e);
		}
	}
	
	$("MB_close").observe("click", function(){
		showItemInfo();
	});
	
	function reloadAccGroupedModal() {
		new Ajax.Updater("MB_content", contextPath+"/GIPIWAccidentItemController?action=showACGroupedItemsTableGrid&parId="+
				(objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId)+"&itemNo="+$F("itemNo"), {
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response) {
				hideNotice();
			}
		});
	}
	
	observeCancelForm("btnCancelGrp", function(){	validateBeforeSave(false);	Modalbox.hide();	}, function(){	Modalbox.hide(); showItemInfo(); });
	observeSaveForm("btnSaveGrp", function(){	validateBeforeSave(true);	});
	
}catch(e){
	showErrorMessage("Accident Grouped Items Main Page", e);
}
</script>