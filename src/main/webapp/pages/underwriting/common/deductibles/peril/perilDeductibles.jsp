<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<c:choose>
	<c:when test="${fromDeductibleSave eq 'Y'}">
		<jsp:include page="/pages/underwriting/common/deductibles/peril/perilDeductibleTableGridListing.jsp"></jsp:include>
	</c:when>
	<c:otherwise>
		<div id="perilDeductibleTable" name="perilDeductibleTable" style="width: 100%;">
			<div id="perilDeductibleTableGridSectionDiv" class="">
				<div id="perilDeductibleTableGridDiv" style="padding: 10px;">
					<div id="perilDeductibleTableGrid" style="height: 0px; width: 900px;"></div>
				</div>
			</div>	
		</div>	
	</c:otherwise>
</c:choose>

<table align="center" width="60%" style="margin-top: 10px;">
 	<tr>
		<td class="rightAligned">Deductible Title </td>
		<td class="leftAligned" colspan="3">
			<div style="float: left; border: solid 1px gray; width: 100%; height: 21px; margin-right: 3px;" class="required">
				<input type="hidden" id="txtDeductibleCd3" name="txtDeductibleCd3" />
				<input class="required" type="text" tabindex="7001" style="float: left; margin-top: 0px; margin-right: 3px; width: 93.5%; border: none;" name="txtDeductibleDesc3" id="txtDeductibleDesc3" readonly="readonly" value="" />
				<img id="hrefDeductible3" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
			</div>				
		</td>
	</tr>
	<tr>
		<td class="rightAligned" width="13%">Rate </td>
		<td class="leftAligned" width="25%"><input tabindex="7002" id="deductibleRate3" name="deductibleRate3" type="text" style="width: 96%; text-align: right;" maxlength="13" readonly="readonly"/></td>		
		<td class="rightAligned" width="13%">Amount </td>
		<td class="leftAligned" width="25%"><input tabindex="7003" id="inputDeductibleAmount3" name="inputDeductibleAmount3" type="text" style="width: 96%; text-align: right;" class="" maxlength="17" readonly="readonly"/></td>
	</tr>
	<tr>
		<td class="rightAligned">Deductible Text </td>
		<td class="leftAligned" colspan="3"><textarea tabindex="7004" id="deductibleText3" name="deductibleText3" style="width: 98.5%; resize: none;" maxlength="2000" rows="2" readonly="readonly"></textarea></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="3">
			<table>
				<tr>
					<td><input tabindex="7005" type="checkbox" id="aggregateSw3" name="aggregateSw3" /></td>
					<td class="rightAligned">Aggregate</td>					
				</tr>
			</table>
		</td>
	</tr>
</table>
<div style="width: 100%; margin-bottom: 10px;" align="center" id="dedButtonsDiv3">
	<input tabindex="7006" id="btnAddDeductible3" class="button" type="button" value="Add" style="width: 60px; margin: 5px 0px 5px 0px;" />
	<input tabindex="7007" id="btnDeleteDeductible3" class="button" type="button" value="Delete" style="width: 60px;" />
</div>

<script type="text/javascript">
	var dedLevel 		= "3";	// 3 for peril deductibles
	var itemNo 			= null;
	var perilCd 		= null;
	var perilName 		= null;	
	var deductibleTitle = null;
	var deductibleCd 	= null;
	var	deductibleType	= null;
	var deductibleAmt 	= null;
	var deductibleRate 	= null;
	var deductibleText 	= null;
	var aggregateSw 	= null;
	var ceilingSw		= null;	
	var minimumAmount	= null;
	var maximumAmount	= null;
	var	rangeSw			= null;
	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));	

	$("hrefDeductible"+dedLevel).observe("click", function(){
		if(objCurrItem != null && objCurrItemPeril != null){					
			//clickDeductibleLOV();
			clickDeductibleLOVTG(tbgPerilDeductible, dedLevel);
		}else{
			showMessageBox("Please select peril first.", imgMessage.INFO);
			return false;
		}		
	});

	function setDeductibleVariables(){
		try {			
			itemNo 			= (1 < dedLevel ? $F("itemNo") : 0);
			perilCd 		= (3 == dedLevel ? $F("perilCd") : 0);
			perilName 		= (3 == dedLevel ? escapeHTML2($F("txtPerilName")) : "");	//$("perilCd").options[$("perilCd").selectedIndex].text : "");			
			deductibleCd 	= $F("txtDeductibleCd"+dedLevel);
			deductibleTitle = $F("txtDeductibleDesc"+dedLevel);			
			deductibleType	= $("txtDeductibleCd"+dedLevel).getAttribute("deductibleType");
			deductibleAmt 	= $F("inputDeductibleAmount"+dedLevel);
			deductibleRate 	= $F("deductibleRate"+dedLevel);
			deductibleText 	= $F("deductibleText"+dedLevel);
			aggregateSw 	= $("aggregateSw"+dedLevel).checked ? "Y" : "N";
			ceilingSw	 	= (1 == dedLevel ? ($("ceilingSw"+dedLevel).checked ? "Y" : "N") : "N");			
			minimumAmount	= (deductibleType == "L" || deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("minAmt"): "";
			maximumAmount	= (deductibleType == "L" || deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("maxAmt"): "";
			rangeSw			= (deductibleType == "L" || deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("rangeSw"): "";
		} catch (e){
			showErrorMessage("setDeductibleVariables", e);
		}
	}

	function saveItemDeductible(){
		try{
			var executeSave = false;
			var objParameters = new Object();
			
			objParameters.setDeductibles	= tbgItemDeductible.getNewRowsAdded().concat(tbgItemDeductible.getModifiedRows());
			objParameters.delDeductibles	= tbgItemDeductible.getDeletedRows();

			for(attr in objParameters){
				if(objParameters[attr].length > 0){											
					executeSave = true;
					break;
				}
			}

			if(executeSave){
				new Ajax.Request(contextPath + "/GIPIWDeductibleController?action=saveDeductibles", {				
					method : "POST",
					parameters : {	
						parameters : JSON.stringify(objParameters),
						parId : objUWParList.parId,
						itemNo : objCurrItem.itemNo	},
					asynchronous : true,
					evalScripts : true,
					onCreate : function(){
						//showNotice("Saving, please wait...");
					},
					onComplete : function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.INFO);
							tbgItemDeductible.clear();
							tbgItemDeductible.refresh();
						}
					}
				});
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}
		}catch(e){
			showErrorMessage("saveItemDeductible", e);
		}
	}

	function addDeductibles() {
		try	{			
			var objDeductible = setDeductibleObj(3);			 	
			
			if ($F("btnAddDeductible"+dedLevel) == "Update") {				
				//addModifiedJSONDeductible(objDeductible);				
				//tbgItemDeductible.updateRowAt(objDeductible, tbgItemDeductible.getCurrentPosition()[1]);
				addModedObjByAttr(objDeductibles, objDeductible, "dedDeductibleCd");
				tbgPerilDeductible.updateVisibleRowOnly(objDeductible, tbgPerilDeductible.getCurrentPosition()[1]);
				
			} else {				
				//addNewJSONDeductible(objDeductible);
				addNewJSONObject(objDeductibles, objDeductible);	
				computeTotalAmountInTable(unformatCurrency("inputDeductibleAmount"+dedLevel));  //added by steven 8.17.2012
				tbgPerilDeductible.addBottomRow(objDeductible);
			}			
			
			if(getLineCd() == "MC"){				
				computeDeductibleAmtByItem(objDeductible.itemNo);
			}
			
			setItemDeductibleForm(null, dedLevel);
			objUW.hidObjGIPIS010.perilChangeTag = 1; //added by steve 10/24/2012
			($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgPerilDeductible);
			//saveItemDeductible();
		} catch (e)	{
			showErrorMessage("addDeductibles", e);
		}
	}

	function checkDeductibles() {
		try {
			setDeductibleVariables();
			
			var exists = false;
			
			if (objCurrItem == null && objCurrItemPeril == null) {
				showMessageBox("Please select peril.", imgMessage.ERROR);				
				exists = true;
				return false;
			}
			
			if (deductibleTitle == ""){
				showWaitingMessageBox("Please select a deductible.", imgMessage.ERROR, function(){
					$("hrefDeductible"+dedLevel).focus();
					exists = true;
				});				
				return false;
			}			
	
			if (parseFloat($F("inputDeductibleAmount"+dedLevel)) == 0 && parseFloat($F("deductibleRate"+dedLevel)) == 0) {
				showMessageBox("Please input amount or rate.", imgMessage.ERROR);
				return false;
			}

			if(!exists) {
				if($F("btnAddDeductible"+dedLevel) == "Add"){
					if(3 > dedLevel) {
						new Ajax.Request(contextPath+"/GIPIWDeductibleController", {
							method: "POST",
							parameters: {action: 		  "checkDeductibles",
										 deductibleType:  deductibleType,
										 dedLevel: 		  dedLevel,
										 globalParId:	  (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
										 itemNo: 		  itemNo
										 },
							onCreate: function() {
									setCursor("wait");
									$("btnAddDeductible"+dedLevel).disable();									
								},
							onComplete: function (response) {
								setCursor("default");
								$("btnAddDeductible"+dedLevel).enable();
								
								if(checkErrorOnResponse(response)){
									if ("SUCCESS" == response.responseText) {
										addDeductibles();
										return;
									} else {
										showMessageBox(response.responseText, imgMessage.ERROR);										
										setItemDeductibleForm(null, dedLevel);
										return false;
									}
								}
							}
						});
					} else {
						addDeductibles();
					}
				} else {
					addDeductibles();
				}
			}
		} catch (e){
			showErrorMessage("checkDeductibles", e);
		}
	}

	$("btnAddDeductible"+dedLevel).observe("click", function ()	{
		try {			
			if(dedLevel > 1){
				if($F("itemNo") != "" && objCurrItem != null ){
					if(objCurrItemPeril != null){
						checkDeductibles();							
					} else {						
						showMessageBox("Please select peril first.", imgMessage.ERROR);
						return false;
					}
				}else{
					showMessageBox("Please select an item first.", imgMessage.ERROR);
					return false;
				}
			} else {
				checkDeductibles();
			}
		} catch (e) {
			showErrorMessage("btnAddDeductible" , e);
		}
	});

	function deleteDeductibles(){
		try {
			setCursor("wait");
			if(dedLevel == 3){				
				if(objCurrItem == null){
					showMessageBox("Please select an item first.", imgMessage.ERROR);					
					return false;	
				}else{
					if(objCurrItemPeril == null){
						showMessageBox("Please select peril first.", imgMessage.ERROR);					
						return false;
					}
				}
			}

			var objDeductible = setDeductibleObj(3);
			//addDeletedJSONDeductible(objDeductible);
			addDelObjByAttr(objDeductibles, objDeductible, "dedDeductibleCd perilCd");		
			computeTotalAmountInTable(-1*parseFloat(nvl(unformatCurrency("inputDeductibleAmount"+dedLevel),0))); //added by steven 8.17.2012
			tbgPerilDeductible.deleteVisibleRowOnly(tbgPerilDeductible.getCurrentPosition()[1]);
			
			if(getLineCd() == "MC"){
				computeDeductibleAmtByItem(objDeductible.itemNo);	
			}
			
			tbgPerilDeductible.geniisysRows[tbgPerilDeductible.getCurrentPosition().toString().split(",")[1]].recordStatus = -1; //marco - 04.29.2013 - change recordStatus of deleted row
			setItemDeductibleForm(null, dedLevel);
			objUW.hidObjGIPIS010.perilChangeTag = 1; //added by steve 10/24/2012
			($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgItemDeductible);
		} catch(e){
			showErrorMessage("deleteDeductibles", e);
		} finally {
			setCursor("default");
		}
	}

	$("btnDeleteDeductible"+dedLevel).observe("click", function ()	{
		deleteDeductibles();		
	});
	
	function computeTotalAmountInTable(deductibleAmt) { //added by steven 8.17.2012 - to compute the total deductible amount
		try {
			var total=unformatCurrency("perilAmtTotal");
					total =parseFloat(total) + (parseFloat(nvl(deductibleAmt,0)));
			$("perilAmtTotal").value = formatCurrency(total).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}

	
	//initializeAll();	
	addStyleToInputs();

	initializeChangeTagBehavior(changeTagFunc);
	initializeChangeAttribute();	
</script>