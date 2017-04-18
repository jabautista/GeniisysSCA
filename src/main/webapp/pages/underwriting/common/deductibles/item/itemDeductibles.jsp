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
		<jsp:include page="/pages/underwriting/common/deductibles/item/itemDeductibleTableGridListing.jsp"></jsp:include>
	</c:when>
	<c:otherwise>
		<div id="itemDeductibleTable" name="itemDeductibleTable" style="width : 100%;">
			<div id="itemDeductibleTableGridSectionDiv" class="">
				<div id="itemDeductibleTableGridDiv" style="padding: 10px;">
					<div id="itemDeductibleTableGrid" style="height: 0px; width: 900px;"></div>
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
				<input type="hidden" id="txtDeductibleCd2" name="txtDeductibleCd2" />
				<input class="required" type="text" tabindex="3001" style="float: left; margin-top: 0px; margin-right: 3px; width: 93.5%; border: none;" name="txtDeductibleDesc2" id="txtDeductibleDesc2" readonly="readonly" value="" />
				<img id="hrefDeductible2" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
			</div>				
		</td>
	</tr>
	<tr>
		<td class="rightAligned" width="13%">Rate </td>
		<td class="leftAligned" width="25%"><input tabindex="3002" id="deductibleRate2" name="deductibleRate2" type="text" style="width: 96%; text-align: right;" maxlength="13" readonly="readonly"/></td>		
		<td class="rightAligned" width="13%">Amount </td>
		<td class="leftAligned" width="25%"><input tabindex="3003" id="inputDeductibleAmount2" name="inputDeductibleAmount2" type="text" style="width: 96%; text-align: right;" class="" maxlength="17" readonly="readonly"/></td>
	</tr>
	<tr>
		<td class="rightAligned">Deductible Text </td>
		<td class="leftAligned" colspan="3"><textarea tabindex="3004" id="deductibleText2" name="deductibleText2" style="width: 98.5%; resize: none;" maxlength="2000" rows="2" readonly="readonly"></textarea></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="3">
			<table>
				<tr>
					<td><input tabindex="3005" type="checkbox" id="aggregateSw2" name="aggregateSw2" /></td>
					<td class="rightAligned">Aggregate</td>
					<c:if test="${1 eq dedLevel}">
						<td class="rightAligned" width="20%">
							<input type="checkbox" id="ceilingSw2" name="ceilingSw2" />
						</td>
						<td class="rightAligned">Ceiling Switch</td>
					</c:if>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div style="width: 100%; margin-bottom: 10px;" align="center" id="dedButtonsDiv2">
	<input tabindex="3006" id="btnAddDeductible2" class="button" type="button" value="Add" style="width: 60px; margin: 5px 0px 5px 0px;" />
	<input tabindex="3007" id="btnDeleteDeductible2" class="button" type="button" value="Delete" style="width: 60px;" />
</div>

<script type="text/javascript">
	var dedLevel 		= "2";	// 2 for item deductibles
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
		if(objCurrItem != null){					
			//clickDeductibleLOV();
			clickDeductibleLOVTG(tbgItemDeductible, dedLevel);
		}else{
			showMessageBox("Please select an item first.", imgMessage.INFO);
			return false;
		}		
	});

	function setDeductibleVariables(){
		try {			
			itemNo 			= (1 < dedLevel ? $F("itemNo") : 0);
			perilCd 		= (3 == dedLevel ? $F("perilCd") : 0);
			perilName 		= (3 == dedLevel ? $("perilCd").options[$("perilCd").selectedIndex].text : "");			
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
			var objDeductible = setDeductibleObj(2);			 	
			
			if ($F("btnAddDeductible"+dedLevel) == "Update") {				
				//addModifiedJSONDeductible(objDeductible);				
				//tbgItemDeductible.updateRowAt(objDeductible, tbgItemDeductible.getCurrentPosition()[1]);
				addModedObjByAttr(objDeductibles, objDeductible, "dedDeductibleCd");
				tbgItemDeductible.updateVisibleRowOnly(objDeductible, tbgItemDeductible.getCurrentPosition()[1]);
				
			} else {				
				//addNewJSONDeductible(objDeductible);
				addNewJSONObject(objDeductibles, objDeductible);
				computeTotalAmountInTable(unformatCurrency("inputDeductibleAmount"+dedLevel));  //added by steven 8.17.2012
				tbgItemDeductible.addBottomRow(objDeductible);
			}			
			
			if(getLineCd() == "MC"){
				computeDeductibleAmtByItem(objDeductible.itemNo);
			}
			
			setItemDeductibleForm(null, dedLevel);
			($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgItemDeductible);
			addModifiedJSONObject(objGIPIWItem, setParItemObj());//added by June Mark SR-5806 [12.14.16]
			//saveItemDeductible();
		} catch (e)	{
			showErrorMessage("addDeductibles", e);
		}
	}

	function checkDeductibles() {
		try {
			setDeductibleVariables();
			
			var exists = false;			
			
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
				if($F("itemNo") != "" && objCurrItem != null){					
					checkDeductibles();				
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
			if(dedLevel == 2){				
				if(objCurrItem == null){
					showMessageBox("Please select an item first.", imgMessage.ERROR);					
					return false;	
				}
			}

			var objDeductible = setDeductibleObj(2);
			//addDeletedJSONDeductible(objDeductible);
			addDelObjByAttr(objDeductibles, objDeductible, "dedDeductibleCd perilCd");
			computeTotalAmountInTable(-1*parseFloat(nvl(unformatCurrency("inputDeductibleAmount"+dedLevel),0)));  //added by steven 8.17.2012
			tbgItemDeductible.deleteVisibleRowOnly(tbgItemDeductible.getCurrentPosition()[1]);
			
			if(getLineCd() == "MC"){
				computeDeductibleAmtByItem(objDeductible.itemNo);
			}
			
			tbgItemDeductible.geniisysRows[tbgItemDeductible.getCurrentPosition().toString().split(",")[1]].recordStatus = -1; //marco - 04.11.2013 - change recordStatus of deleted row
			changeTag = 1;
			setItemDeductibleForm(null, dedLevel);
			($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgItemDeductible);
		} catch(e){
			showErrorMessage("deleteDeductibles", e);
		} finally {
			setCursor("default");
		}
	}
	
	function computeTotalAmountInTable(deductibleAmt) { //added by steven 8.17.2012 - to compute the total deductible amount
		try {
			var total=unformatCurrency("itemAmtTotal");
					total =parseFloat(total) + (parseFloat(nvl(deductibleAmt,0)));
			$("itemAmtTotal").value = formatCurrency(total).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}

	$("btnDeleteDeductible"+dedLevel).observe("click", function ()	{
		deleteDeductibles();		
	});
	
	//initializeAll();	
	addStyleToInputs();

	initializeChangeTagBehavior(changeTagFunc);
	initializeChangeAttribute();	
</script>