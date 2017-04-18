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
	objCurrPackPar = null; // added by andrew - 03.29.2011
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
<div id="packPolicyItemsDiv" name="packPolicyItemsDiv" style="margin-top : 1px;" changeTagAttr="true">
	<form id="packPolicyItemsInfoForm" name="packPolicyItemsInfoForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/packPar/packCommon/packParPolicyListingTable.jsp"></jsp:include>
		<div id="addDeleteItemDiv">
			<jsp:include page="/pages/underwriting/packPar/packPolicyItems/subPages/packPolicyItems.jsp"></jsp:include>
		</div>
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel"	name="btnCancel"	class="button"	value="Cancel" 	style="width: 100px;" />
			<input type="button" id="btnSave" 	name="btnSave" 		class="button"	value="Save" 	style="width: 100px;" />			
		</div>
	</form>
</div>
<script type="text/javascript">
	setCursor("wait");
	setDocumentTitle("Package Policy Items");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIPIS095");
	objUWGlobal.hidGIPIS095DefualtCurrencyCd = '${defualtCurrencyCd}';
	var objGIPIS095 = {};
	objGIPIS095.exitPage = null;
	objGIPIS095.logoutPage = null;
	objGIPIS095.savePage = null;

	// set pack par information details
	$("lblAcctOf").innerHTML = "In Account Of";
	$("acctOfName").value = unescapeHTML2(objGIPIWPolbas.acctOfName);//added unescape reymon 03052013
	$("acctOfName").show();

	showItemList(objGIPIWItem);	
	showPackagePARPolicyList(objGIPIParList);		
	setMainItemForm(null);

	objItemNoList = [];	
	createItemNoList(objGIPIWItem);	
	
	function loadPackageParPolicyRowObserver(){
		try{
			$$("div#packageParPolicyTable div[name='rowPackPar']").each(function(row){
				setPackParPolicyRowObserver(row);				
			});
		}catch(e){
			showErrorMessage("loadPackageParPolicyRowObserver", e);
		}
	}

	function loadPackagePolicyItemsRowObserver(){
		try{
			$$("div#itemTable div[name='row']").each(function(row){
				//setItemRowObserver(row); changed - irwin 11.14.11
				setPackagePolicyItemRowObserver(row);
			});	
		}catch(e){
			showErrorMessage("loadPackagePolicyItemsRowObserver", e);			
		}
	}
	
	function savePackPolicyItems(){
		try{
			if(checkPendingRecordChanges()) {
				var executeSave = false;
				var objParameters = new Object();

				objParameters.setItemRows 		= getAddedAndModifiedJSONObjects(objGIPIWItem);
				objParameters.delItemRows 		= getDeletedJSONObjects(objGIPIWItem);
				objParameters.delPackInvTax		= getDeletedJSONObjects(objGIPIWPackageInvTax);
				objParameters.delCommInvPerils	= getDeletedJSONObjects(objGIPIWCommInvPerils);
				objParameters.delCommInvoices	= getDeletedJSONObjects(objGIPIWCommInvoices);
				objParameters.delInvoice		= getDeletedJSONObjects(objGIPIWInvoice);
				
				for(attr in objParameters){
					if(objParameters[attr].length > 0){
						executeSave = true;
						break;
					}
				}

				if(executeSave){
					objParameters.setItemRows 		= prepareJsonAsParameter(objParameters.setItemRows);
					objParameters.delItemRows 		= prepareJsonAsParameter(objParameters.delItemRows);
					objParameters.delPackInvTax		= prepareJsonAsParameter(objParameters.delPackInvTax);
					objParameters.delCommInvPerils	= prepareJsonAsParameter(objParameters.delCommInvPerils);
					objParameters.delCommInvoices	= prepareJsonAsParameter(objParameters.delCommInvoices);
					objParameters.delInvoice		= prepareJsonAsParameter(objParameters.delInvoice);

					objParameters.vars = prepareJsonAsParameter(objFormVariables);
					objParameters.pars = prepareJsonAsParameter(objFormParameters);
					objParameters.misc = prepareJsonAsParameter(objFormMiscVariables);

					//objParameters.packParId = $F("globalPackParId"); // andrew - 07.15.2011
					objParameters.packParId = (nvl($F("globalPackParId"), 0) == 0 ? objUWGlobal.packParId : $F("globalPackParId"));  // mark jm 10.12.2011 change null to 0

					new Ajax.Request(contextPath + "/GIPIWItemController?action=savePackagePolicyItems", {
						method : "POST",
						parameters : {
							parameters : JSON.stringify(objParameters)
						},
						onCreate : function(){
							showNotice("Saving Package Policy Items, please wait ...");
						},
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response)){
								if(response.responseText != "SUCCESS"){
									showWaitingMessageBox(response.responseText, imgMessage.ERROR,showPackPolicyItems); //added by steven 2.5.2012; "showPackPolicyItems"
								}else{
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
										if(objGIPIS095.exitPage != null) {
											objGIPIS095.exitPage();
										} else if(objGIPIS095.logoutPage != null){
											showPackPolicyItems();
										}else if(objGIPIS095.savePage != null){
											showPackPolicyItems();
										}else {
											lastAction();
											lastAction = "";
										}
									});
									changeTag = 0;
								}
							}
						}
					});
				}
			}else{
				objGIPIS095.exitPage = null;
			}
		}catch(e){
			showErrorMessage("savePackPolicyItems", e);
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
				objGIPIS095.exitPage = showPackParListing;
				savePackPolicyItems();
			}, showPackParListing, "");
		}else{
			changeTag = 0;
			showPackParListing();
		}	
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 1){ //added by steven 02.05.2013
			objGIPIS095.savePage = "Y";
			savePackPolicyItems();
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}	
	});
	
	$("logout").observe("mousedown", function(){
		if(changeTag == 1){
			objGIPIS095.logoutPage = "Y";
		}else{
			objGIPIS095.logoutPage = null;
		}	
	});

	$("parExit").stopObserving("click"); 
	$("parExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", function(){
							objGIPIS095.exitPage = showPackParListing;
							savePackPolicyItems();
						}, showPackParListing, "");
		}else{
			changeTag = 0;
			showPackParListing();
		}
	});
	

	loadPackageParPolicyRowObserver();
	loadPackagePolicyItemsRowObserver();
	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(savePackPolicyItems);
	initializeChangeAttribute();			
</script>