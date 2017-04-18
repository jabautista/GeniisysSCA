<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="hidPerilListDiv">
	<c:forEach var="peril" items="${dedPerilsList}">
		<div id="hidPeril${peril.perilCd}" name="hidPeril">
			<input type="hidden" id="hidItemNo${peril.perilCd}" 	name="hidItemNo" 	value="${peril.itemNo}">
			<input type="hidden" id="hidPerilCd${peril.perilCd}" 	name="hidPerilCd" 	value="${peril.perilCd}">
			<input type="hidden" id="hidTsiAmt${peril.perilCd}" 	name="hidTsiAmt" 	value="${peril.tsiAmt}">
			<input type="hidden" id="hidPerilType${peril.perilCd}"  name="hidPerilType"	value="${peril.perilType}">
		</div>
	</c:forEach>
</div>
<c:choose>
	<c:when test="${fromDeductibleSave eq 'Y'}">
		<jsp:include page="/pages/underwriting/common/deductibles/policy/policyDeductibleTableGridListing.jsp"></jsp:include>
	</c:when>
	<c:otherwise>
		<div id="policyDeductibleTable" name="deductibleTable" style="width : 100%;">
			<div id="policyDeductibleTableGridSectionDiv" class="">
				<div id="policyDeductibleTableGridDiv" style="padding: 10px;">
					<div id="policyDeductibleTableGrid" style="height: 0px; width: 900px;"></div>
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
				<input type="hidden" id="txtDeductibleCd1" name="txtDeductibleCd1" />
				<input class="required" type="text" tabindex="5001" style="float: left; margin-top: 0px; margin-right: 3px; width: 93.5%; border: none;" name="txtDeductibleDesc1" id="txtDeductibleDesc1" readonly="readonly" value="" />
				<img id="hrefDeductible1" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
			</div>				
		</td>
	</tr>
	<tr>
		<td class="rightAligned" width="13%">Rate </td>
		<td class="leftAligned" width="25%"><input tabindex="5002" id="deductibleRate1" name="deductibleRate1" type="text" style="width: 96%; text-align: right;" maxlength="13" readonly="readonly"/></td>		
		<td class="rightAligned" width="13%">Amount </td>
		<td class="leftAligned" width="25%"><input tabindex="5003" id="inputDeductibleAmount1" name="inputDeductibleAmount1" type="text" style="width: 96%; text-align: right;" class="" maxlength="17" readonly="readonly"/></td>
	</tr>
	<tr>
		<td class="rightAligned">Deductible Text </td>
		<td class="leftAligned" colspan="3"><textarea tabindex="5004" id="deductibleText1" name="deductibleText1" style="width: 98.5%; resize: none;" maxlength="2000" rows="2" readonly="readonly"></textarea></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="3">
			<table>
				<tr>
					<td><input tabindex="5005" type="checkbox" id="aggregateSw1" name="aggregateSw1" /></td>
					<td class="rightAligned">Aggregate</td>					
					<td class="rightAligned" width="20%">
						<input tabindex="5006" type="checkbox" id="ceilingSw1" name="ceilingSw1" />
					</td>
					<td class="rightAligned">Ceiling Switch</td>					
				</tr>
			</table>
		</td>
	</tr>
</table>
<div style="width: 100%; margin-bottom: 10px;" align="center" id="dedButtonsDiv1">
	<input tabindex="5007" id="btnAddDeductible1" class="button" type="button" value="Add" style="width: 60px; margin: 5px 0px 5px 0px;" />
	<input tabindex="5008" id="btnDeleteDeductible1" class="button" type="button" value="Delete" style="width: 60px;" />
</div>

<script type="text/javascript">	
	var dedLevel 		= "1";	// 1 for policy deductibles
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
		//clickDeductibleLOV();
		clickDeductibleLOVTG(tbgPolicyDeductible, dedLevel);
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
			
			objParameters.setDeductibles	= tbgPolicyDeductible.getNewRowsAdded().concat(tbgPolicyDeductible.getModifiedRows());
			objParameters.delDeductibles	= tbgPolicyDeductible.getDeletedRows();

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
							tbgPolicyDeductible.clear();
							tbgPolicyDeductible.refresh();
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
			var objDeductible = setDeductibleObj(1);			 	
			
			if ($F("btnAddDeductible"+dedLevel) == "Update") {				
				//addModifiedJSONDeductible(objDeductible);				
				//tbgItemDeductible.updateRowAt(objDeductible, tbgItemDeductible.getCurrentPosition()[1]);
				addModedObjByAttr(objDeductibles, objDeductible, "dedDeductibleCd");
				tbgPolicyDeductible.updateVisibleRowOnly(objDeductible, tbgPolicyDeductible.getCurrentPosition()[1]);
				
			} else {				
				//addNewJSONDeductible(objDeductible);
				addNewJSONObject(objDeductibles, objDeductible);
				computeTotalAmountInTable(unformatCurrency("inputDeductibleAmount"+dedLevel));  //added by steven 8.17.2012
				tbgPolicyDeductible.addBottomRow(objDeductible);
			}			

			setItemDeductibleForm(null, dedLevel);
			($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgPolicyDeductible);
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
				if ((objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "P"){
					//if($F("itemNo")!= "" && ($("row"+$F("itemNo"))== null ? false : $("row"+$F("itemNo")).hasClassName("selectedRow"))){
					if($F("itemNo") != "" && objCurrItem != null){
						if(3 == dedLevel && ($("perilCd") == null || $F("perilCd") == "")){
							showMessageBox("Please select a peril first.");
						} else {
							checkDeductibles();
						}
					}else{
						showMessageBox("Please select an item first.", imgMessage.ERROR);
					}
				} else {
					//if ($F("itemNo") != "" && ($("row"+$F("itemNo"))== null ? false : $("row"+$F("itemNo")).hasClassName("selectedRow"))){
					if($F("itemNo") != "" && objCurrItem != null){
						if(3 == dedLevel && ($("perilCd") == null || $F("perilCd") == "")){
							showMessageBox("Please select a peril first.");
						} else {
							checkDeductibles();
						}
					} else {
						showMessageBox("Please select an item first.");
					}
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
			
			if($$("#policyDeductibleTable .selectedRow").length > 0){				
				var objDeductible = setDeductibleObj(1);
				//addDeletedJSONDeductible(objDeductible);
				addDelObjByAttr(objDeductibles, objDeductible, "dedDeductibleCd");	
				computeTotalAmountInTable(-1*parseFloat(nvl(unformatCurrency("inputDeductibleAmount"+dedLevel),0)));  //added by steven 8.17.2012
				tbgPolicyDeductible.deleteVisibleRowOnly(tbgPolicyDeductible.getCurrentPosition()[1]);
				tbgPolicyDeductible.geniisysRows[tbgPolicyDeductible.getCurrentPosition().toString().split(",")[1]].recordStatus = -1;	//added by Gzelle 09112014
				setItemDeductibleForm(null, dedLevel);
				($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
				updateTGPager(tbgPolicyDeductible);
			}		
		} catch(e){
			showErrorMessage("deleteDeductibles", e);
		} finally {
			setCursor("default");
		}
	}
	
	function computeTotalAmountInTable(deductibleAmt) { //added by steven 8.17.2012 - to compute the total deductible amount
		try {
			var total=unformatCurrency("amtTotal");
					total =parseFloat(total) + (parseFloat(nvl(deductibleAmt,0)));
			$("amtTotal").value = formatCurrency(total).truncate(13, "...");
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