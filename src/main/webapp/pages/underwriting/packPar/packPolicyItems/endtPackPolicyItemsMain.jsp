<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<script type="text/javascript">
	objCurrPackPar = null;
	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	objGIPIParList = JSON.parse(Object.toJSON(formMap.packParList));
	objGIPIWItem = JSON.parse(Object.toJSON(formMap.packPolicyItems));	
	objGIPIWPackageInvTax = [];
	objGIPIWCommInvPerils = [];
	objGIPIWCommInvoices = [];
	objGIPIWInvoice = [];
	
	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
</script>
<div id="endtPackPolicyItemsDiv" name="endtPackPolicyItemsDiv" style="margin-top : 1px;" changeTagAttr="true">
	<form id="endtPackPolicyItemsInfoForm" name="endtPackPolicyItemsInfoForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
		<div id="endtPackAddDeleteItemDiv">
			<jsp:include page="/pages/underwriting/packPar/packPolicyItems/subPages/endtPackPolicyItems.jsp"></jsp:include>
		</div>
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel"	class="button"	value="Cancel" 	style="width: 100px;" toEnable="true"/>
			<input type="button" id="btnSave" 	name="btnSave" 		class="button"	value="Save" 	style="width: 100px;" />			
		</div>
	</form>
</div>
<script type="text/javascript">
	setCursor("wait");
	updatePackParParameters(); // added this line to ensure that global parameters have values.
	setDocumentTitle("Package Policy Items");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIPIS096");
	
	// set pack par information details
	$("lblAcctOf").innerHTML = "In Account Of";
	$("acctOfName").value = objGIPIWPolbas.acctOfName;
	$("acctOfName").show();
	populatePackPolicyNo("policyNo");
	$("policyNo").show();
		
	showItemList(objGIPIWItem);	
	//showPackagePARPolicyList(objGIPIParList.filter(function(par){return par.parStatus != 99 && par.parStatus != 98;}));		
	showPackagePARPolicyList(objGIPIParList);
	setMainItemForm(null);

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);	
	
	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setEndtPackPolicyRowObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}

	function loadPackagePolicyItemsRowObserver(){
		try{
			$$("div#itemTable div[name='row']").each(function(row){
				row.setAttribute("updateable", "N");
				setEndtPackPolicyItemRowObserver(row);
			});	
		}catch(e){
			showErrorMessage("loadPackagePolicyItemsRowObserver", e);			
		}
	}

	function saveEndtPackPolicyItems(){
		try{
			var executeSave = false;
			var objParameters = new Object();

			objParameters.setItemRows 		= getAddedAndModifiedJSONObjects(objGIPIWItem);
			objParameters.delItemRows 		= getDeletedJSONObjects(objGIPIWItem);
			
			for(attr in objParameters){
				if(objParameters[attr].length > 0){
					executeSave = true;
					break;
				}
			}

			if(executeSave){
				objParameters.setItemRows 		= prepareJsonAsParameter(objParameters.setItemRows);
				objParameters.delItemRows 		= prepareJsonAsParameter(objParameters.delItemRows);

				objParameters.vars = prepareJsonAsParameter(objFormVariables);
				objParameters.pars = prepareJsonAsParameter(objFormParameters);
				objParameters.misc = prepareJsonAsParameter(objFormMiscVariables);

				objParameters.packParId = (nvl($F("globalPackParId"), null) == null ? objUWGlobal.packParId : $F("globalPackParId"));
				objParameters.lineCd    = nvl(objUWGlobal.lineCd, "");
				objParameters.sublineCd = nvl(objUWGlobal.sublineCd, "");
				objParameters.issCd     = nvl(objUWGlobal.issCd, "");
				objParameters.issueYy   = nvl(objUWGlobal.issueYy, 0);
				objParameters.polSeqNo  = nvl(objUWGlobal.polSeqNo, 0);
				objParameters.renewNo   = nvl(objUWGlobal.renewNo, 0); 

				new Ajax.Request(contextPath + "/GIPIWItemController?action=saveEndtPackPolicyItems", {
					method : "POST",
					parameters : {
						parameters : JSON.stringify(objParameters)
					},
					onCreate : function(){
						showNotice("Saving Endorsement Package Policy Items, please wait ...");
					},
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							if(response.responseText != "SUCCESS"){
								showMessageBox(response.responseText, imgMessage.ERROR);
							}else{
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showPackPolicyItems);
								changeTag = 0;
							}
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("saveEndtPackPolicyItems", e);
		}
	}

	$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
				function(){
					showPackPolicyItems();
					changeTag = 0;
				}, stopProcess);
		} else {
			changeTag = 0;
			showPackPolicyItems();			
		}
	});	
	
	$("btnCancel").observe("click", function(){		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveEndtPackPolicyItems();
				changeTag = 0;
			}, showEndtPackParListing, "");
		}else{
			changeTag = 0;
			showEndtPackParListing();
		}	
	});

	$("btnSave").observe("click", saveEndtPackPolicyItems);
	
	loadPackageParPolicyRowObserver();
	loadPackagePolicyItemsRowObserver();
	hideNotice();
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveEndtPackPolicyItems);
	initializeChangeAttribute();	
	
	var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"):$F("globalPackPolFlag");
	
	var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
 	if(parTypeCond == "E" && "4" == polFlag){ 
		showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.WARNING);
		checkIfCancelledEndorsement(); // added by: steven 10/08/2012 - to check if to disable fields if PAR is a cancelled endt	
	} 
</script>