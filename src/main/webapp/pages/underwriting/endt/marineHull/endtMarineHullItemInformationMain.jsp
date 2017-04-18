<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="endtItemInformationMainDiv" name="endtItemInformationMainDiv" style="margin-top: 1px;">	
	<form id="itemInformationForm" name="itemInformationForm">
		<!-- module variables -->
		<input type="hidden" 	name="varEndtTaxSw" 	id="varEndtTaxSw" 	value="${endtTaxSw}"/>
		<input type="hidden" 	name="varPackParId" 	id="varPackParId" 	value="${varPackParId}"/>
		<input type="hidden" 	name="varPost" 	 		id="varPost" 	   	value=""/>
		<input type="hidden" 	name="varPost2" 	 	id="varPost2" 	   	value="Y"/>
		<input type="hidden" 	name="varTotalDeductibles"		id="varTotalDeductibles" 		value="" />
		<input type="hidden" 	name="varNewSw2" 	 		id="varNewSw2" 	   	value="Y"/>
		<input type="hidden" 	name="varGroupSw" 	 		id="varGroupSw" 	   	value="N"/>
		<input type="hidden"    name="varCopyItemTag"	id="varCopyItemTag" value="N" />
		<input type="hidden"    name="varNegateItem"	id="varNegateItem"  value="N" />
		<input type="hidden"    name="varCompSw"	id="varCompSw"  value="${wPolBasic.compSw }<c:if test="${empty wPolBasic.compSw}">N</c:if>" />
		<input type="hidden" 	name="varProrateFlag" 	 	id="varProrateFlag" 	   	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="varDeductibleExist" 	id="varDeductibleExist" 	   	value="${pDeductibleExist }"/>
		
		<input type="hidden" 	name="varEffDate" 	 	id="varEffDate" 	   	value="${effDate }"/>
		<input type="hidden" 	name="varEndtExpiryDate" 	 	id="varEndtExpiryDate" 	   	value="${endtExpiryDate }"/>
		<input type="hidden" 	name="varProvPremTag" 	 	id="varProvPremTag" 	   	value="${wPolBasic.provPremTag }"/>
		<input type="hidden" 	name="varProvPremPct" 	 	id="varProvPremPct" 	   	value="${wPolBasic.provPremPct }"/>
		<input type="hidden" 	name="varShortRtPercent" 	 	id="varShortRtPercent" 	   	value="${wPolBasic.shortRtPercent }"/>
		<input type="hidden" 	name="varPackPolFlag" 	 	id="varPackPolFlag" 	   	value="${wPolBasic.packPolFlag }"/>
		<input type="hidden" 	name="varCoInsSw" 	 	id="varCoInsSw" 	   	value="${wPolBasic.coInsuranceSw }"/>
		<input type="hidden"    name="varDiscExist"	    id="varDiscExist" 	value="${discExists }" />
		<input type="hidden"    name="varExpiryDate"	id="varExpiryDate" 	value="${expiryDate }" />
		<input type="hidden"    name="varPhilPeso"		id="varPhilPeso" 	value="${vPhilPeso }" />
		<input type="hidden"    name="varLineCd"		id="varLineCd" 	value="${vMotorCar }" />
		
		<input type="hidden" 	name="varOrigEstValue" 	 		id="varOrigEstValue" 	   	value=""/>
		
		<!-- params -->
		<input type="hidden" name="paramDfltCoverage" id="paramDfltCoverage" value="${paramDfltCoverage}"/>
		<input type="hidden" name="paramPolFlagSw" id="paramPolFlagSw" value="
			<c:choose>
				<c:when test="${wPolBasic.polFlag eq '4'}">Y</c:when>
				<c:otherwise>N</c:otherwise>
			</c:choose>
		"/>
		<input type="hidden" name="paramAddDeleteSw" id="paramAddDeleteSw" value=""/>
		<input type="hidden" name="paramItemCnt" id="paramItemCnt" value="0"/>
		
		<!-- miscellaneous variables -->		
		<input type="hidden" name="vAllowUpdateCurrRate" id="vAllowUpdateCurrRate" value="${pAllowUpdateCurrRate}"/>
		<input type="hidden" name="vPolicyNo"		id="vPolicyNo"	value="${policyNo}"/>
		<input type="hidden" name="isLoaded"		id="isLoaded"	value="0"/>
		<input type="hidden" name="changedFields"	id="changedFields"	value="0"/>
		<input type="hidden" name="gipiWItemExist"	id="gipiWItemExist"	value="N"/>
		<input type="hidden" name="gipiWItemPerilExist"	id="gipiWItemPerilExist"	value="N"/>
		<input type="hidden" name="gipiWInvoiceExist"	id="gipiWInvoiceExist"	value="${gipiWInvoiceExist}"/>
		<input type="hidden" name="gipiWInvTaxExist"	id="gipiWInvTaxExist"	value="${gipiWInvTaxExist}"/>
		<input type="hidden" name="aItem"	id="aItem"	value="N"/>
		<input type="hidden" name="aPeril"	id="aPeril"	value="N"/>
		<input type="hidden" name="cItem"	id="cItem"	value="N"/>
		<input type="hidden" name="cPeril"	id="cPeril"	value="N"/>
		<input type="hidden" name="itemWithPerilCount"	id="itemWithPerilCount"	value="0"/>
		<input type="hidden" name="copyItem" id="copyProcess" value="N"/>
		<input type="hidden" name="copyPeril" id="copyPeril" value="N"/> 
		<input type="hidden" name="vAllowCurrRtUpdate" id="vAllowCurrRtUpdate" value="${vAllowCurrRtUpdate}"/>
		
		<!-- GIPI_PARLIST (b240) -->
		<input type="hidden" id="invoiceSw"				name="invoiceSw"			value="" />
		
		<!-- GIPI_WPOLBAS (b540) -->
		<input type="hidden" 	name="packPolFlag" 	 	id="packPolFlag" 	   	value="${wPolBasic.packPolFlag }"/>
		<input type="hidden" 	name="polProrateFlag" 	id="polProrateFlag"	   	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="polCompSw" 	id="polCompSw" 	   	value="${wPolBasic.compSw }<c:if test="${empty wPolBasic.compSw}">N</c:if>"/>
		<input type="hidden" 	name="polProrateFlag" 	id="polProrateFlag"	   	value="${wPolBasic.prorateFlag }"/>
		<input type="hidden" 	name="polAssdNo" 	id="polAssdNo"	   	value="${wPolBasic.assdNo }"/>
		<input type="hidden" 	name="address1" 	id="address1"	   	value="${wPolBasic.address1 }"/>
		<input type="hidden" 	name="address2" 	id="address2"	   	value="${wPolBasic.address2 }"/>
		<input type="hidden" 	name="address3" 	id="address3"	   	value="${wPolBasic.address3 }"/>
		<input type="hidden"	name="updateGIPIWPolbas" id="updateGIPIWPolbas" value="N"/>
		
		<!-- GIPI_POLBASIC -->
		<input type="hidden" 	name="polbasicAddress1" 	id="polbasicAddress1"	   	value="${polbasicAddress1 }"/>
		<input type="hidden" 	name="polbasicAddress2" 	id="polbasicAddress2"	   	value="${polbasicAddress2 }"/>
		<input type="hidden" 	name="polbasicAddress3" 	id="polbasicAddress3"	   	value="${polbasicAddress3 }"/>
		
		<!-- GIIS_ASSURED -->
		<input type="hidden" 	name="assdAddress1" 	id="assdAddress1"	   	value="${assdMailAddress1 }"/>
		<input type="hidden" 	name="assdAddress2" 	id="assdAddress2"	   	value="${assdMailAddress2 }"/>
		<input type="hidden" 	name="assdAddress3" 	id="assdAddress3"	   	value="${assdMailAddress3 }"/>
		
		<input type="hidden" name="sublineCd" id="sublineCd" value="${sublineCd}"/>
		<input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
		<input type="hidden" name="pageName" id="pageName" value="itemInformation" />
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		
		<!-- For item information -->
		<jsp:include page="/pages/underwriting/endt/marineHull/subPages/endtMarineHullItemInformation.jsp"></jsp:include>
		
		<!-- end of item information-->
		<div id="addDeleteItemSubpageDiv" style="display: none;">
		</div>
		<jsp:include page="/pages/underwriting/endt/marineHull/subPages/endtMarineHullItemInfoAdditional.jsp"></jsp:include>
		<br/>
		<div style="" align="center">
			<input type="button" style="width: 100px; margin-top: 10px; margin-bottom: 10px; " id="btnAddItem" class="button" value="Add" /> 
			<input type="button" style="width: 100px; margin-top: 10px; margin-bottom: 10px; " id="btnDeleteItem" class="disabledButton" value="Delete" disabled="disabled" />
			<input type="button" id="btnShow" class="button" value="View JSON Items" />
		</div>
		<div id="deductibleDetail2">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Item Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible2" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="deductibleDiv2" class="sectionDiv" style="display: none;">
			</div>
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;">
			</div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="2">
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Peril Information</label>
				<span class="refreshers" style="margin-top: 0;"> 
					<label id="showPerilInfoSubPage" name="gro" style="margin-left: 5px;">Show</label> 
				</span>
			</div>
		</div>		
		<div class="sectionDiv" id="perilInformationDiv" name="perilInformationDiv" style="display: none;"></div>
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
				<input type="button" id="btnCancel"	name="btnCancel" 	class="button" value="Cancel" />					
				<input type="button" id="btnSave"	name="btnSave" 		class="button" value="Save" />										
			</div>
	</form>
</div>

<script type="text/javascript" defer="defer">
	setDocumentTitle("Marine Hull Endorsement Item Information");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId(getItemModuleId("E", $F("globalLineCd"))); 

	loadFormVariables();
	loadFormParameters();
	loadFormMiscVariables();

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible2", function(){
		if($("inputDeductible2") == null){			
			showDeductibleModal(2);
			initializeChangeTagBehavior();			
		}
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS097", "showPerilInfoSubPage", function(){
		if($("perilCd") == null){
			showEndtPerilInfoPage();	
			initializeChangeTagBehavior();					
		} 
	});

	observeAccessibleModule(accessType.SUBPAGE, "GIPIS169", "showDeductible3", function(){
		if($("inputDeductible3") == null){
			showDeductibleModal(3);
			initializeChangeTagBehavior();
		}
	});

	$("reloadForm").observe("click", function() {
		if (changeTag == 1){		
			showConfirmBox("Confirmation", "Reloading form will disregard all changes. Proceed?", "Yes", "No", 
				function(){
					showItemInfo();
					changeTag = 0;
				}, stopProcess);
		} else {
			showItemInfo();
			changeTag = 0;
		}
	});

	$("btnSave").observe("click", function(){
		observeBtnSave();		
	});

	function observeBtnSave(){
		var result = true;
		var pExist1 = "N";
		var pExist2 = "N";
		var vExist  = "N";
		var pDistNo = parseInt($F("distNo"));
		var vCounter = 0;
		var itemCount = 0;
		var itemWithPerilCount = 0;
//53	
		objFormMiscVariables[0].miscAPeril = "Y";

		//computes total number of item perils
		for (var i=0; i<objGIPIWItemPeril.length; i++){
			if (objGIPIWItemPeril[i].recordStatus != -1){
				vCounter = vCounter + 1;
			}
		}
		
		for (var i=0; i<objEndtMHItems.length; i++){
			if (objEndtMHItems[i].recordStatus != -1){
				itemCount = itemCount + 1;
				objFormMiscVariables[0].miscGIPIWItemExist = "Y";
				objFormMiscVariables[0].miscAItem = "Y";
				if (objEndtMHItems[i].recFlag == "A"){
					var itemHasPeril = "N";
					for (var j=0; j<objGIPIWItemPeril.length; j++){
						if (objGIPIWItemPeril[j].itemNo == objEndtMHItems[i].itemNo){
							itemHasPeril = "Y";
						}
					}
					if ("Y" == itemHasPeril){
						itemWithPerilCount = itemWithPerilCount + 1;
					} else {
						objFormMiscVariables[0].miscAPeril = "N";
					}
				}
			}
		}

		objFormMiscVariables[0].miscItemWithPerilCount = itemWithPerilCount;

		if (vCounter > 0){
			objFormMiscVariables[0].miscGIPIWItemPerilExist = "Y";
		}

		if (objUWParList.parStatus < 3) {
			showMessageBox("You are not granted access to this form. " +
					"The changes that you have made will not be committed to the database.", imgMessage.ERROR);
			return false;
		} else if ("N" == objFormVariables[0].varPost2){
			return false;
		} else {

			//this portion are procedures in POST-FORMS-COMMIT that cannot be implemented in DAO due to requirement of message box show up
			if ("Y" == objFormMiscVariables[0].miscNbtInvoiceSw 
					&& "" == nvl(objFormVariables[0].varPost, "")){
				//CHECK_ADDTL_INFO
				var noVesselItemNo = "";
				if ("Y" == $F("packPolFlag")){
					for (var i=0; i<objEndtMHItems.length; i++){
						if (nvl(objEndtMHItems[i].vesselCd, "0") == "0"
								&& objEndtMHItems[i].packLineCd == "MH"
								&& nvl(objEndtMHItems[i].annTsiAmt, "0") == "0"
								&& objEndtMHItems[i].recordStatus != -1){
							if ("" != noVesselItemNo){
								noVesselItemNo = noVesselItemNo + ",";
							}
							noVesselItemNo = noVesselItemNo + objEndtMHItems[i].itemNo;
						}
					}
				} else {
					for (var i=0; i<objEndtMHItems.length; i++){
						if (nvl(objEndtMHItems[i].vesselCd, "0") == "0"
								&& nvl(objEndtMHItems[i].recFlag, "A") == "A"
								&& objEndtMHItems[i].recordStatus != -1){
							if ("" != noVesselItemNo){
								noVesselItemNo = noVesselItemNo + ",";
							}
							noVesselItemNo = noVesselItemNo + objEndtMHItems[i].itemNo;
						} 
					}
				}
				if ("" != noVesselItemNo){
					showMessageBox("Item no(s) "+ noVesselItemNo +"  has no corresponding vessel information. " 
							+"Please do the necessary changes.", "info");
					return false;
				}
			}

			new Ajax.Request(contextPath + "/GIPIWItemVesController?action=checkUpdateGipiWPolbasValidity&globalParId="
					+objUWParList.parId,{
				method : "POST",
				asynchronous : false,
				evalScripts : true,
				postBody : Form.serialize("itemInformationForm"),
				onCreate: function() {
					showNotice("Updating. Please wait...");
				},
				onComplete : function(response){
					//hideNotice("Done!");
					if (response.responseText == "") {
						//$("invoiceSw").value = "Y";
						objFormMiscVariables[0].miscUpdateGIPIWPolbas = "Y";
						result = true;
					} else {
						hideNotice("");
						result = false;
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		if (result) {
			if (itemCount == 0){
				saveEndtMHItems();
			} else { 
				observeBtnSave2();
			}
		}
	}

	function observeBtnSave2(){
		var result = true;
		if ("Y" == objFormMiscVariables[0].miscNbtInvoiceSw 
				&& "" == nvl(objFormVariables[0].varPost)){
			new Ajax.Request(contextPath + "/GIPIWItemVesController?action=checkCreateDistributionValidity", {
				method : "GET",
				parameters : {
					globalParId : objUWParList.parId
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						showNotice("Checking validity from dependent tables...");									
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {
							var errorNo = response.responseText;
							if ("0" == errorNo){
								saveEndtMHItems();
							} else if ("1" == errorNo){
								hideNotice("");
								var itemCount = 0;

								/*$$("div#itemTable div[name='row']").each(function (row1){
									itemCount++;
								});*/
								for (var i=0; i<objGIPIWItem.length; i++){
									if (objGIPIWItem[i].recordStatus != -1){
										itemCount++;
									}
								}

								if (0 == itemCount){
									showMessageBox("Pls. be adviced that there are no items for this PAR.", imgMessage.ERROR);
								} else {
									saveEndtMHItems();
								}
							} else if ("2" == errorNo){
								hideNotice("");
								showConfirmBox("", "This PAR has existing records in the posted POLICY tables. Changes will be made.  Would you like to continue?", 
										"OK", "Cancel", observeBtnSave3, "");
							} else if ("3" == errorNo){
								hideNotice("");
								showConfirmBox("", "Changes will be done to the distribution tables. Do you like to proceed?", 
										"OK", "Cancel", checkRIDistValidity, "");
							} else if ("3A" == errorNo){
								hideNotice("");
								checkRIDistValidity();
							} else if ("4" == errorNo){
								hideNotice("");
								showMessageBox("There are too many distribution numbers assigned for this item. Please contact your database" + 
										" administrator to rectify the matter. Check records in the policy table with par_id = "+$F("globalParId") , imgMessage.ERROR);
							} else if ("5" == errorNo){
								hideNotice("");
								showMessageBox("Could not proceed. The effectivity date or expiry date had not been updated.", imgMessage.ERROR);
							} else if ("6" == errorNo){
								hideNotice("");
								showMessageBox("No row in table SYS.DUAL", imgMessage.ERROR);
							} else if ("7" == errorNo){
								hideNotice("");
								showMessageBox("You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.", imgMessage.ERROR);
							} else if ("8" == errorNo){
								hideNotice("");
								showMessageBox("Multiple rows were found to exist in GIPI_WPOLBAS. Please contact your database administrator to" + 
										" rectify the matter. Check record with par_id = "+$F("globalParId")+"." , imgMessage.ERROR);
							} else if ("9" == errorNo){
								hideNotice("");
								showMessageBox("There are too many distribution numbers assigned for this item. "+
				                        "Please call your administrator to rectify the matter. Check "+
				                        "records in the policy table with par_id = "+$F("globalParId")+"." , imgMessage.ERROR);
							}
						} else {
							//result = false;
						}
					}
			});
		} else {
			saveEndtMHItems();
		}
	}

	function checkRIDistValidity(){
		new Ajax.Request(contextPath + "/GIPIWItemVesController?action=checkGiriDistfrpsExist", {
			method : "GET",
			parameters : {
				globalParId : objUWParList.parId
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : 
				function(){
					showNotice("Checking validity from dependent tables...");									
				},
			onComplete :
				function(response){
					if (checkErrorOnResponse(response)) {
						if ("Y" == response.responseText){
							hideNotice("");
							showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);
						} else {
							saveEndtMHItems();
						}
					} else {
						
					}
				}
		 });
	}

	$("btnCancel").observe("click", function(){	
		var objParameters	= new Object();
		objParameters = prepareObjParameters(objParameters);
		if (checkPageChanges(objParameters)){
			showConfirmBox3("Save Changes", objCommonMessage.WITH_CHANGES, "Yes", "No", observeBtnSave, showEndtParListing);
		} else {
			showEndtParListing();	
		}
	});	

	function addToObject(objArray, obj){
		objArray.push(obj);
	}

	function loadFormVariables(){
		objFormVariables = eval('[{' +
				'"varItemNo" :	0,' +
				'"varVPhilPeso" : null,' +
				'"varOldCurrencyCd" : null,' +
				'"varOldCurrencyDesc" : null,' +
				'"varVInterestOnPremises" : null,' +
				'"varVSectionOrHazardInfo" : null,' +
				'"varVConveyanceInfo" : null,' +
				'"varVPropertyNo" : null,' +
				'"varCreatePackItem" : null,' +
				'"varPrevAmtCovered" : null,' +
				'"varPrevDeductibleCd" : null,' +
				'"varPrevDeductibleAmt" : null,' +
				'"varVSublineCd" : null,' +
				'"varDeductibleAmt" : null,' +
				'"varVCount" : 0,' +
				'"varVPackPolFlag" : "${varPackPolFlag}",' +
				'"varVItemTag" : null,' +
				'"varCounter" : null,' +
				'"varSwitchRecFlag" : null,' +
				'"varPost" : null,' + 
				'"varGroupSw" : "N",' +
				'"varVEffDate" : "${varEffDate}",' +
				'"varVEndtExpiryDate" : "${varEndtExpiryDate}",' +
				'"varVShortRtPercent" : "${varShortRtPercent}",' +
				'"varVProvPremTag" : "${varProvPremTag}",' +
				'"varVProvPremPct" : "${varProvPremPct}",' +
				'"varVProrateFlag" : "${varProrateFlag}",' +
				'"varCompSw" : "${compSw}",' +
				'"varCopyItem" : null,' +
				'"varPost2" : "Y",' +
				'"varNewSw" : "Y",' +
				'"varNewSw2" : "Y",' +
				'"varDiscExist" : "${discExists}",' +
				'"varOldGroupCd" : null,' +
				'"varOldGroupDesc" : null,' +
				'"varCoInswSw" : "${varCoInsSw}",' +
				'"varEndtTaxSw" : null,' +
				'"varWithPerilSw" : "N",' +
				'"varVExpiryDate" : null,' +
				'"varVNegateItem" : "N",' +
				'"varVCopyItemTag" : false,' +
				'"varVAllowUpdateCurrRate" : "${pAllowUpdateCurrRate}"' +
				'}]');
	}
	
	function loadFormParameters(){
		objFormParameters = eval('[{' +
				'"paramItemCnt" : null,' +
				'"paramAddDeleteSw" : 1,' + 
				'"paramPostRecordSw" : "N",' +
				'"paramPolFlagSw" : "${parPolFlagSw}",' +
				'"paramPostRecSwitch" : "N"}]');
	}

	function loadFormMiscVariables(){
		objFormMiscVariables = eval('[{' +
				'"miscDeletePolicyDeductibles": "N",' +
				'"miscNbtInvoiceSw" : "N",' +
				'"miscCopyPeril" : "N",' +
				'"miscDeletePerilDiscById" : "N",' +
				'"miscDeleteItemDiscById" : "N",' +
				'"miscDeletePolbasDiscById" : "N",' +
				'"miscLastRateValue" : null,' +
				'"miscGIPIWItemExist" : "N",' +
				'"miscGIPIWItemPerilExist" : "N",' +
				'"miscItemWithPerilCount" : 0,' +
				'"miscAItem" : "N",' +
				'"miscAPeril" : "N",' +
				'"miscGIPIWInvoiceExist" : "${gipiWInvoiceExist}",' +
				'"miscGIPIWInvTaxExist" : "${gipiWInvTaxExist}",' +
				'"miscUpdateGIPIWPolbas" : "N"' +
				'}]');
	}

	function prepareObjParameters(obj){
		obj.setItemRows 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objEndtMHItems));
		obj.delItemRows 	= prepareJsonAsParameter(getDeletedJSONObjects(objEndtMHItems));
		obj.setItemPerils	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItemPeril));
		obj.delItemPerils 	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItemPeril));
		obj.setPerilWCs		= prepareJsonAsParameter(objPerilWCs);
		obj.setDeductRows	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
		obj.delDeductRows	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));
		obj.itemNoList		= prepareJsonAsParameter(objItemNoList);
		obj.vars			= prepareJsonAsParameter(objFormVariables);
		obj.pars			= prepareJsonAsParameter(objFormParameters);
		obj.misc			= prepareJsonAsParameter(objFormMiscVariables);
		
		obj.parId			= objUWParList.parId;
		obj.lineCd			= objUWParList.lineCd;
		obj.issCd			= objUWParList.issCd;
		obj.sublineCd		= $F("globalSublineCd");
		obj.distNo			= nvl($F("distNo"), null);
		obj.negateItem 		= $F("varNegateItem");
		obj.prorateFlag 	= nvl($F("varProrateFlag"), null);
		obj.compSw 			= $F("varCompSw");
		obj.endtExpiryDate 	= $F("varEndtExpiryDate");
		obj.effDate 		= $F("varEffDate");
		obj.shortRtPercent	= $F("varShortRtPercent");
		obj.expiryDate 		= $F("varExpiryDate");
		return obj;
	}

	function checkPageChanges(obj){
		var pageChanged = false;
		if ((JSON.parse(obj.setItemRows)).length > 0
				|| (JSON.parse(obj.delItemRows)).length > 0
				|| (JSON.parse(obj.setItemPerils)).length > 0
				|| (JSON.parse(obj.delItemPerils)).length > 0
				|| (JSON.parse(obj.setPerilWCs)).length > 0
				|| (JSON.parse(obj.setDeductRows)).length > 0
				|| (JSON.parse(obj.delDeductRows)).length > 0){
			pageChanged = true;
		}
		return pageChanged;
	}

	function saveEndtMHItems(){
		var objParameters	= new Object();
		objParameters = prepareObjParameters(objParameters);

		if (!(checkPageChanges(objParameters))){
			showMessageBox("No changes to save.", imgMessage.INFO);
			return false;
		}

		new Ajax.Request(contextPath + "/GIPIWItemVesController?action=saveEndtMHItems", {
			method : "POST",
			parameters : {	globalParId		: objUWParList.parId,							
							parameters		: JSON.stringify(objParameters)},
			onCreate : 
				function(){
					showNotice("Saving Marine Hull Items, please wait...");
				},
			onComplete : 
				function(){	
					hideNotice();
					showWaitingMessageBox("Record Saved.", imgMessage.INFO, showItemInfo);
				}
		});

		objEndtMHItems = null;
		objDeductibles = null;
		objGIPIWItemPeril = null;
		objFormVariables = null;
		objFormParameters = null;
		objFormMiscVariables = null;
		objItemNoList = null;
	}

	showDeductibleModal(2);
	showEndtPerilInfoPage();
	getRates();
	objFormMiscVariables[0].miscLastCurrIndex = $("currency").selectedIndex;
	objFormMiscVariables[0].miscLastRateValue = $F("rate");
	
	//B480.CURRENCY_CD, B480.CURRENCY_DESC, B480.DSP_CURRENCY_DESC - pre_text_item, post_text_item
	$("currency").observe("change", function() {
		var lastIndex = objFormMiscVariables[0].miscLastCurrIndex;//$F("currencyListIndex");
		var itemHasPerils = false;

		for (var i=0; i<objGIPIWItemPeril.length; i++){
			if (objGIPIWItemPeril[i].itemNo == $F("itemNo")){
				itemHasPerils = true;
				break;
			}
		}
		
		if (!$F("itemNo").blank()) {
			if (itemHasPerils) {
				showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
				$("currency").selectedIndex = lastIndex;
				return false;
			}
		} else {
			showMessageBox("Item number is required before changing the currency.", imgMessage.INFO);
			$("currency").selectedIndex = lastIndex;
			return false;
		}

		if ((0 != parseFloat($F("annTsiAmt") == "" ? "0" : $F("annTsiAmt"))) && (null == $F("annTsiAmt"))){ 
			showMessageBox("Currency cannot be updated, item is being endorsed.", imgMessage.INFO);
			$("currency").selectedIndex = lastIndex;
			return false;
		} else {
			objFormVariables[0].varGroupSw = "Y";
			objFormMiscVariables[0].miscLastCurrIndex = $("currency").selectedIndex;
			getRates();
			objFormMiscVariables[0].miscLastRateValue = $F("rate");
		}
	});

	//B480.CURRENCY_RT - pre_text_item, post_text_item
	$("rate").observe("change", function() {
		try {
			lastRate = objFormMiscVariables[0].miscLastRateValue;//$F("lastRateValue");
			var itemHasPerils = false;
	
			for (var i=0; i<objGIPIWItemPeril.length; i++){
				if (objGIPIWItemPeril[i].itemNo == $F("itemNo")){
					itemHasPerils = true;
					break;
				}
			}
	
			if (itemHasPerils){
				showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
				$("rate").value = lastRate;
				$("itemNo").focus();
				return false;
			}
			
			if ($("currency").options[$("currency").selectedIndex].readAttribute("shortName") == $F("varPhilPeso")) {
				if (!(objFormVariables[0].varVAllowUpdateCurrRate == "Y")) {
					showMessageBox("Currency rate for Philippine peso is not updateable.", imgMessage.INFO);
					$("rate").value = lastRate;
					$("rate").focus();
					return false;
				}
			}
			
			if (!$F("annTsiAmt").blank()) {
				if (objFormVariables[0].varVAllowUpdateCurrRate == "Y") {
					showMessageBox("Currency cannot be updated, item is being endorsed.", imgMessage.INFO);
					$("rate").focus();
					$("rate").value = lastRate;
					return false;
				}
			}
	
			if ("" == $F("rate")){
				showWaitingMessageBox("Currency rate is required.", imgMessage.ERROR, function(){$("rate").focus();}); 
				return false;
			} else if (isNaN($F("rate"))){
				showWaitingMessageBox("Must be of form 990.999999999.", imgMessage.ERROR, 
						function(){
					$("rate").value = lastRate;
					$("rate").focus();
				});
				return false;
			} else if (parseInt($F("rate")) == 0
					|| parseFloat($F("rate")) < 0){
				showWaitingMessageBox("Must be of form 990.999999999.", imgMessage.ERROR, 
						function(){
					$("rate").value = lastRate;
					$("rate").focus();
				});
			} else {
				objFormMiscVariables[0].miscLastRateValue = $F("rate");
			}
		} catch (e){
			showErrorMessage("endtMarineHullItemInformationMain.jsp - rate", e);
			//showMessageBox("rate: " + e.message);
		}
	});
</script>