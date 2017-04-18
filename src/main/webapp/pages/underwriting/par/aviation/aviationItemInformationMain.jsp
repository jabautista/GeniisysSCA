<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemInformationDiv" name="parItemInformationDiv" style="margin-top: 1px;" changeTagAttr="true">
	<form id="itemInformationForm" name="itemInformationForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/par/aviation/subPages/aviationItemInformation.jsp"></jsp:include>
		</div>	
		
		<div id="deductibleDetail2" divName="Item Deductible">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Item Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>					
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;"></div>
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="2" />
		</div>
		
		<jsp:include page="/pages/underwriting/subPages/parPerilInformation.jsp"></jsp:include>
		<div id="deductibleDetail3">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Peril Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible3" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="deductibleDiv3" class="sectionDiv" style="display: none;">
			</div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="3">
		</div>
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel"	class="button"	value="Cancel" 	style="width: 100px;" />
			<input type="button" id="btnSave" 	name="btnSave" 		class="button"	value="Save" 	style="width: 100px;" />			
		</div>
	</form>
</div>
<script type="text/javascript">
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd() /*$F("globalLineCd")*/);
	var sublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
	setCursor("wait");
	if(objUWGlobal.packParId == null) setDocumentTitle("Item Information - Aviation");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("P", getLineCd()));	

	showItemList(objGIPIWItem);
	
	setDefaultItemForm();	

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", "");
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS038", "showPeril", "");
		
	if (checkUserModule("GIPIS038")) {
		observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function() {
			if($("inputDeductible3") == null){
				showDeductibleModal(3);
			}
		});
	}else{
		disableSubpage("showDeductible3");
	}

	/* comment out by andrew - transferred in underwriting-item-save-functions.js - can be removed later
	function saveAviationItems(refresh){	
		//validation if items have peril(s)
		var perilExists;
		var itemCount = 0;
		var withPerilCount = 0;
		var itemWithoutPeril = new Array();
		for(var i=0; i<objGIPIWItem.length; i++){
			if(objGIPIWItem[i].recordStatus != -1) {
				perilExists = false;
				itemCount++;
				for (var j=0; j<objGIPIWItemPeril.length; j++) {
					if (objGIPIWItemPeril[j].itemNo == objGIPIWItem[i].itemNo && objGIPIWItemPeril[j].recordStatus != -1) {
						withPerilCount++;
						perilExists = true;
						break;							
					}
				}	
											
				if (!perilExists){
					itemWithoutPeril.push(objGIPIWItem[i].itemNo);
				}
			}
		}
		
		if(!(itemCount == withPerilCount || itemCount == itemWithoutPeril.length)) {
			showConfirmBox("Confirmation", "Do you want to go to the next item without peril(s)?", "Yes", "No", 
					function(){
						itemWithoutPeril.sort();
						if(!$("row"+itemWithoutPeril[0]).hasClassName("selectedRow")){
							fireEvent($("row"+itemWithoutPeril[0]), "click");
						}
						$("row"+itemWithoutPeril[0]).scrollTo();
					}, "");
			return false;			
		}
		
		//validation if all default perils have TSI Amount
		for(var i=0; i<objGIPIWItemPeril.length; i++){
			if ("0" == objGIPIWItemPeril[i].tsiAmt) {
				showMessageBox("Peril " +objGIPIWItemPeril[i].perilName + " has no TSI Amount.", imgMessage.Info);
				if(!$("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd).hasClassName("selectedRow")){
					fireEvent($("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd), "click");
				}
			return false;
			}
		}
		
		if(checkPendingRecordChanges()){
			if($$("div#itemInformationDiv [changed=changed]").length > 0){
				fireEvent($("btnAddItem"), "click");
				return false;			
			}
			
			var executeSave = false;
			var objParameters = new Object();
			
			objParameters.setItemRows 	= getAddedAndModifiedJSONObjects(objGIPIWItem);
			objParameters.delItemRows 	= getDeletedJSONObjects(objGIPIWItem);
			objParameters.setDeductRows	= getAddedAndModifiedJSONObjects(objDeductibles);
			objParameters.delDeductRows	= getDeletedJSONObjects(objDeductibles);
			objParameters.setPerils 	= getAddedAndModifiedJSONObjects(objGIPIWItemPeril);		
			objParameters.delPerils 	= getDeletedJSONObjects(objGIPIWItemPeril);	
			objParameters.setWCs 		= getAddedAndModifiedJSONObjects(objGIPIWPolWC);
			
			for(attr in objParameters){
				if(objParameters[attr].length > 0){								
					executeSave = true;
					break;
				}
			}

			if(executeSave){
				objParameters.setItemRows 	= prepareJsonAsParameter(objParameters.setItemRows);
				objParameters.delItemRows 	= prepareJsonAsParameter(objParameters.delItemRows);
				objParameters.setDeductRows	= prepareJsonAsParameter(objParameters.setDeductRows);
				objParameters.delDeductRows	= prepareJsonAsParameter(objParameters.delDeductRows);
				objParameters.setPerils 	= prepareJsonAsParameter(objParameters.setPerils);		
				objParameters.delPerils 	= prepareJsonAsParameter(objParameters.delPerils);	
				objParameters.setWCs 		= prepareJsonAsParameter(objParameters.setWCs);

				objParameters.vars			= prepareJsonAsParameter(objFormVariables);
				objParameters.pars			= prepareJsonAsParameter(objFormParameters);
				objParameters.misc			= prepareJsonAsParameter(objFormMiscVariables);		
				
				objParameters.gipiWPolbas	= prepareJsonAsParameter(objGIPIWPolbas);

				objParameters.parId			= parId;
				objParameters.lineCd		= lineCd;
				objParameters.sublineCd		= sublineCd;
				
				//to include Peril Miscellaneous Fields
				objParameters = includePerilParamsForSaving(objParameters);	

				new Ajax.Request(contextPath + "/GIPIWAviationItemController?action=saveParAVItems", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters),
						globalParId: objParameters.parId
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
						showNotice("Saving Aviation Items, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							if(response.responseText != "SUCCESS"){
								showMessageBox(response.responseText, imgMessage.ERROR);
							}else{
								clearObjectRecordStatus2(objGIPIWItem);
								clearObjectRecordStatus2(objDeductibles);
								clearObjectRecordStatus2(objGIPIWItemPeril);
								clearObjectRecordStatus2(objGIPIWPolWC);
								changeTag = 0;
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, refresh ? showItemInfo :null);
								updateParParameters();	
							}
						}
					}
				});
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}	
		}	
	}*/

	/*$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
				function(){
					showItemInfo();
					changeTag = 0;
				}, stopProcess);
		} else {
			changeTag = 0;
			showItemInfo();			
		}
	});
	$("btnCancel").observe("click", function(){		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveAviationItems();
				changeTag = 0;
			}, showParListing, "");
		}else{
			changeTag = 0;
			showParListing();
		}	
	});
	$("btnSave").observe("click", saveAviationItems);*/

	observeReloadForm("reloadForm", showItemInfo);
	//observeCancelForm("btnCancel", function(){saveAviationItems(false);}, showParListing); //belle 09082011
	//observeSaveForm("btnSave", function(){saveAviationItems(true); }); //belle 07282011 
	observeCancelForm("btnCancel", function(){ validateSaving(false);}, showParListing);
	observeSaveForm("btnSave", function(){ validateSaving(true);});
	
	loadItemRowObserver();	

	showDeductibleModal(1);
	showDeductibleModal(2);	
		
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveAviationItems);
	initializeChangeAttribute();
	hideNotice("");	
</script>
