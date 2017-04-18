<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="dedMainContainerDiv${dedLevel}" name="dedMainContainerDiv" changeTagAttr="true">	
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
	<div style="margin: 10px 10px 0px 10px;" id="deductiblesTable${dedLevel}" name="deductiblesTable${dedLevel}">	
		<div class="tableHeader" style="margin-top: 5px;" id="deductibleHeader${dedLevel}">
			<label style="width: 33px; text-align: center; ">A</label>
			<c:if test="${1 eq dedLevel}">
				<label style="width: 45px; text-align: center;">C</label>
			</c:if>
			<c:if test="${1 lt dedLevel}">
				<label style="width: 70px; text-align: right; margin-right: 10px;">Item No.</label>
			</c:if>
			<c:if test="${3 eq dedLevel}">
				<label style="width: 110px; text-align: left;">Peril Name</label>
			</c:if>
			<label style="width: 213px; text-align: left; margin-left: 5px;">Deductible Title</label>
			<label style="width: 155px; text-align: left; margin-left: 20px; ">Deductible Text</label>
			<label style="width: 119px; text-align: right; ">Rate</label>
			<label style="width: 130px; text-align: right; ">Amount</label>
			
		</div>
		<div id="dedForDeleteDiv${dedLevel}" name="dedForDeleteDiv${dedLevel}" style="visibility: hidden;">
		</div>
		<div id="dedForInsertDiv${dedLevel}" name="dedForInsertDiv${dedLevel}" style="visibility: hidden;">
		</div>
		<div class="tableContainer" id="wdeductibleListing${dedLevel}" name="wdeductibleListing${dedLevel}" style="display: block;">
			<c:forEach var="wdeductible" items="${wdeductibles}">
				<div id="ded${dedLevel}${wdeductible.itemNo}${wdeductible.perilCd}${wdeductible.dedDeductibleCd}" name="ded${dedLevel}" item="${wdeductible.itemNo}" dedCd="${wdeductible.dedDeductibleCd}" perilCd="${wdeductible.perilCd}" dedType="${wdeductible.deductibleType}" class="tableRow" style="display : none;">
					<input type="hidden" 	id="dedItemNo${dedLevel}" 			name="dedItemNo${dedLevel}" 		value="${wdeductible.itemNo}" />					
					<input type="hidden" 	id="dedPerilName${dedLevel}" 		name="dedPerilName${dedLevel}"		value="${wdeductible.perilName}" />
					<input type="hidden" 	id="dedPerilCd${dedLevel}"  		name="dedPerilCd${dedLevel}" 		value="${wdeductible.perilCd}" />
					<input type="hidden" 	id="dedTitle${dedLevel}"			name="dedTitle${dedLevel}"			value="${wdeductible.deductibleTitle}" />
					<input type="hidden" 	id="dedDeductibleCd${dedLevel}"		name="dedDeductibleCd${dedLevel}"	value="${wdeductible.dedDeductibleCd}" />
					<input type="hidden" 	id="dedAmount${dedLevel}" 			name="dedAmount${dedLevel}" 		value="${wdeductible.deductibleAmount}" />
					<input type="hidden" 	id="dedRate${dedLevel}"  			name="dedRate${dedLevel}" 			value="${wdeductible.deductibleRate}"/>
					<input type="hidden" 	id="dedText${dedLevel}"				name="dedText${dedLevel}"			value="${wdeductible.deductibleText}" />		
					<input type="hidden" 	id="dedAggregateSw${dedLevel}"		name="dedAggregateSw${dedLevel}"	value="${wdeductible.aggregateSw}" />
					<input type="hidden" 	id="dedCeilingSw${dedLevel}"		name="dedCeilingSw${dedLevel}"		value="${wdeductible.ceilingSw}" />
					<input type="hidden" 	id="dedDeductibleType${dedLevel}"	name="dedDeductibleType${dedLevel}"	value="${wdeductible.deductibleType}" />
					<input type="hidden"	id="dedLineCd${dedLevel}"			name="dedLineCd${dedLevel}"			value="${wdeductible.dedLineCd}" />
					<input type="hidden"	id="dedSublineCd${dedLevel}"		name="dedSublineCd${dedLevel}"		value="${wdeductible.dedSublineCd}" />
					<input type="hidden"	id="dedType${dedLevel}"				name="dedType${dedLevel}"			value="${wdeductible.deductibleType}" />
					<input type="hidden"	id="minAmt${dedLevel}"				name="minAmt${dedLevel}"			value="${wdeductible.minimumAmount}">
					<input type="hidden"	id="maxAmt${dedLevel}"				name="maxAmt${dedLevel}"			value="${wdeductible.maximumAmount}" />
					<input type="hidden"	id="rangeSw${dedLevel}"				name="rangeSw${dedLevel}"			value="${wdeductible.rangeSw}" />
					
					<label style="width: 33px; text-align: center; ">
						<c:if test="${'N' eq wdeductible.aggregateSw or empty wdeductible.aggregateSw}">
							<span style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;"></span>
						</c:if>
						<c:if test="${'Y' eq wdeductible.aggregateSw}">
							<img name="checkedImg" class="printCheck" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;" />
						</c:if>
					</label>
					<c:if test="${1 eq dedLevel}">
						<label style="width: 45px; text-align: center;">
							<c:if test="${'N' eq wdeductible.ceilingSw or empty wdeductible.ceilingSw}">
								<span style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;"></span>
							</c:if>
							<c:if test="${'Y' eq wdeductible.ceilingSw}">
								<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 16px;" />
							</c:if>
						</label>
					</c:if>
					<c:if test="${1 lt dedLevel}">
						<label style="width: 70px; text-align: right; margin-right: 10px;">${wdeductible.itemNo}</label>
					</c:if>
					<c:if test="${3 eq dedLevel}">
						<label style="width: 110px; text-align: left;" id="peril${dedLevel}${wdeductible.itemNo}${wdeductible.perilCd}${wdeductible.dedDeductibleCd}" name="peril${dedLevel}">
							${wdeductible.perilName}
						</label>
					</c:if>	
					<label style="width: 213px; text-align: left; margin-left: 5px;" id="dedTitle${dedLevel}${wdeductible.itemNo}${wdeductible.perilCd}${wdeductible.dedDeductibleCd}" name="dedTitle${dedLevel}">${wdeductible.deductibleTitle}</label>
					<label style="width: 155px; text-align: left; margin-left: 20px; " id="dedText${dedLevel}${wdeductible.itemNo}${wdeductible.perilCd}${wdeductible.dedDeductibleCd}" name="dedText${dedLevel}" title="Click to view complete text.">
						<c:if test="${empty wdeductible.deductibleText}">
							-
						</c:if>
						${wdeductible.deductibleText}
					</label>
					<label style="width: 119px; text-align: right;">
						${wdeductible.deductibleRate}
					</label>
					<label style="width: 130px; text-align: right;">
						${wdeductible.deductibleAmount}
					</label>
					
				</div>
			</c:forEach>		
		</div>
		<div class="tableHeader" id="totalDedAmountDiv${dedLevel}" style="display: none;">
			<label style="margin-left: 5px;">Total Deductible Amount</label>
			<label id="totalDedAmount${dedLevel}" style="float: right; margin-right: 5px;"></label>
		</div>
	</div>

<!-- 	<c:if test="${lineCd eq EN}">
		<div id="hidItemLoc" style="display: none;">
			<c:forEach var="itemLoc" items="${itemLoc}">
				<input type="hidden" id="itemLoc${itemLoc.itemNo}" name="itemLoc" />
			</c:forEach>
		</div>
		<div id="insertLocations" name="insertLocations" style="visibility: hidden;"></div>
		<div id="deleteLocations" name="deleteLocations" style="visibility: hidden;"></div>
	</c:if>  -->
	
	<table align="center" width="60%" style="margin-top: 10px;">
	 	<tr>
			<td class="rightAligned">Deductible Title </td>
			<td class="leftAligned" colspan="3">
				<div style="float: left; border: solid 1px gray; width: 100%; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="txtDeductibleCd${dedLevel}" name="txtDeductibleCd${dedLevel}" />
					<input class="required" type="text" tabindex="23" style="float: left; margin-top: 0px; margin-right: 3px; width: 93.5%; border: none;" name="txtDeductibleDesc${dedLevel}" id="txtDeductibleDesc${dedLevel}" readonly="readonly" value="" />
					<img id="hrefDeductible${dedLevel}" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>
				<%-- <input type="text" id="inputDeductDisplay${dedLevel}" readonly="readonly" class="required" style="width: 450px; display: none;" deductibleCd="" /> --%>
				<%-- <select  id="inputDeductible${dedLevel}" name="inputDeductible${dedLevel}" style="width: 100%;" class="required"> --%>
<%-- 					<option value="" dText="" dAmt="" dRate="" dType=""></option>
					<c:forEach var="deductible" items="${deductiblesList}">
						<option value="${deductible.deductibleCd}" rangeSw="${deductible.rangeSw}" minAmt="${deductible.minimumAmount}" maxAmt="${deductible.maximumAmount}" dText="${deductible.deductibleText}" dAmt="${deductible.deductibleAmt}" dRate="${deductible.deductibleRate}" dType="${deductible.deductibleType}">${deductible.deductibleTitle}</option>
					</c:forEach> --%>
				<!-- </select> -->
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="13%">Rate </td>
			<td class="leftAligned" width="25%"><input id="deductibleRate${dedLevel}" name="deductibleRate${dedLevel}" type="text" style="width: 96%; text-align: right;" maxlength="13" readonly="readonly"/></td>		
			<td class="rightAligned" width="13%">Amount </td>
			<td class="leftAligned" width="25%"><input id="inputDeductibleAmount${dedLevel}" name="inputDeductibleAmount${dedLevel}" type="text" style="width: 96%; text-align: right;" class="" maxlength="17" readonly="readonly"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Deductible Text </td>
			<td class="leftAligned" colspan="3"><textarea id="deductibleText${dedLevel}" name="deductibleText${dedLevel}" style="width: 98.5%;" maxlength="2000" rows="2" readonly="readonly"></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td colspan="3">
				<table>
					<tr>
						<td><input type="checkbox" id="aggregateSw${dedLevel}" name="aggregateSw${dedLevel}" /></td>
						<td class="rightAligned">Aggregate</td>
						<c:if test="${1 eq dedLevel}">
							<td class="rightAligned" width="20%">
								<input type="checkbox" id="ceilingSw${dedLevel}" name="ceilingSw${dedLevel}" />
							</td>
							<td class="rightAligned">Ceiling Switch</td>
						</c:if>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div style="width: 100%; margin-bottom: 10px;" align="center" id="dedButtonsDiv${dedLevel}">
		<input id="btnAddDeductible${dedLevel}" class="button" type="button" value="Add" style="width: 60px; margin: 5px 0px 5px 0px;" />
		<input id="btnDeleteDeductible${dedLevel}" class="button" type="button" value="Delete" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript" defer="defer">
	//objDeductibleListing = JSON.parse('${objDeductibleListing}');
	var dedLevel 		= '${dedLevel}';//$("dedMainContainerDiv${dedLevel}").up("div").next("input", 0).value;
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
	//added by: nica
	var minimumAmount	= null;
	var maximumAmount	= null;
	var	rangeSw			= null;

	var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));

	if (objDeductibles == null){
		objDeductibles = new Array();
	}
	
	objCurrDeductible = null;
	
	/*	Added by	: mark jm 10.20.2010
	 *	Description	: evaluates deductible listing
	 */
	if (dedLevel == 1){		
		var objPolDeductibles = JSON.parse('${objDeductibles}'.replace(/\\/g, '\\\\'));
		objDeductibles = objDeductibles.concat(objPolDeductibles);
	} else if (dedLevel == 2){
		var objItemDeductibles = JSON.parse('${objDeductibles}'.replace(/\\/g, '\\\\'));
		objDeductibles = objDeductibles.concat(objItemDeductibles); 
	} else if (dedLevel == 3) {
		var objItemPerilDeductibles = JSON.parse('${objDeductibles}'.replace(/\\/g, '\\\\'));
		objDeductibles = objDeductibles.concat(objItemPerilDeductibles);
	}
	
	function clickDeductibleLOV(){
		try {
			var notIn = "";
			var withPrevious = false;
			var itemNo = (1 < dedLevel ? $F("itemNo") : 0);
			var perilCd = (3 == dedLevel ? $F("perilCd") : 0);
			$$("div#wdeductibleListing"+dedLevel+" div[name='ded"+dedLevel+"']").each(function(row){
				if(itemNo == row.getAttribute("item") && perilCd == row.getAttribute("perilCd")) {
					if(withPrevious) notIn += ",";
					notIn += "'"+row.getAttribute("dedCd")+"'";
					withPrevious = true;
				}
			});
			//notIn = (notIn != "" ? "("+notIn+")" : null); // mark jm 06.20.2011 me problem kapag walang pinili sa list tapos nag next page
			notIn = (notIn != "" ? "("+notIn+")" : "");
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
			var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));
			showDeductibleLOV(lineCd, sublineCd, dedLevel, notIn);
		} catch (e){
			showErrorMessage("clickDeductibleLOV", e);
		}
	}
	
	$("hrefDeductible"+dedLevel).observe("click", function(){
		if($("hrefDeductible"+dedLevel).src.indexOf("disabledSearchIcon.png") == -1){ //added by jdiago 08.05.2014
			clickDeductibleLOV();	
		}
	});
	
	$("txtDeductibleDesc"+dedLevel).observe("keyup", function(event){
		if(event.keyCode == 46){
			setDeductibleForm(null, dedLevel);
		}
	});
	
	//objDeductibles = objDeductibles.concat(objItemPerilDeductibles);
	setDeductibleForm(null, dedLevel);
	checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
	checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
	initializeAll();
	//initializeAllMoneyFields();
	initializeTable("tableContainer", "ded"+dedLevel, "", "");
	addStyleToInputs();	
	
/* 	function setDeductibleListing(obj) {
		try {
			$("inputDeductible"+dedLevel).update('<option value="" dText="" dAmt="" dRate="" dType=""></option>');
			for(var i=0; i<obj.length; i++) {
				var exist = false;
				// added by: nica 10.13.2010 to replace null value of deductible attributes
				var minAmt = obj[i].minimumAmount == null ? "" : obj[i].minimumAmount;
				var maxAmt = obj[i].maximumAmount == null ? "" : obj[i].maximumAmount;
				var rangeSw = obj[i].rangeSw == null ? "" : obj[i].rangeSw;
				var rate = obj[i].deductibleRate == null ? "" : obj[i].deductibleRate;
				itemNo = (1 < dedLevel ? $F("itemNo") : 0);
				perilCd = (3 == dedLevel ? $F("perilCd") : 0);
				
				$$("div#wdeductibleListing"+dedLevel+ " div[name='ded"+dedLevel+"']").each(function(ded){
					//if(ded.getStyle("display") != "none") { commented by: nica 10.13.2010
					// modified by: nica 10.14.2010 to handle sorting of deductibles per deductible Level
					// andrew - 11.18.2010 modified the condition to handle all deductible levels, the commented block of code below can be deleted
					if(obj[i].deductibleCd == ded.getAttribute("dedCd") 
							&& itemNo == ded.getAttribute("item") 
							&& perilCd == ded.getAttribute("perilCd")) {
						exist = true;
					} */
					
					/*
					if(dedLevel == 1){
						// Policy Deductibles
						if(obj[i].deductibleCd == ded.down("input", 4).value) {
							exist = true;
						}
					}if(dedLevel == 2){
						// Item Deductibles
						if(obj[i].deductibleCd == ded.down("input", 4).value && itemNo == ded.down("input", 0).value) {
							exist = true;
						}
					}if(dedLevel == 3){
						// Peril Deductibles
						if(obj[i].deductibleCd == ded.down("input", 4).value && itemNo == ded.down("input", 0).value && perilCd == ded.down("input", 2).value) {
							exist = true;
						}
					}*/
/* 				});
				if (!exist){
					var opt = '<option value="'+obj[i].deductibleCd +'" rangeSw="'+rangeSw  
								+'" minAmt="'+minAmt+ '" maxAmt="'+maxAmt  
								+'" dText="'+ obj[i].deductibleText + '" dAmt="'+ obj[i].deductibleAmt 
								+ '" dRate="'+rate+'" dType="'+ obj[i].deductibleType 
								+ '">'+ obj[i].deductibleTitle +'</option>';
					$("inputDeductible"+dedLevel).insert({bottom: opt});
				}
			}
			$("inputDeductible"+dedLevel).selectedIndex = 0;
		} catch (e) {
			showErrorMessage("setDeductibleListing" , e);
		}
	} */
	
/* 	$("inputDeductible"+dedLevel).observe("change", function() {
		synchDetailsOfDeductible($("inputDeductible"+dedLevel).selectedIndex);
	}); */
	
	$("btnAddDeductible"+dedLevel).observe("click", function ()	{
		try {
			if(dedLevel > 1){
				if ((objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "P"){
					if($F("itemNo")!= "" && ($("row"+$F("itemNo"))== null ? false : $("row"+$F("itemNo")).hasClassName("selectedRow"))){
						if(3 == dedLevel && ($("perilCd") == null || $F("perilCd") == "")){
							showMessageBox("Please select a peril first.");
						} else {
							checkDeductibles();
						}
					}else{
						showMessageBox("Please select an item first.", imgMessage.ERROR);
					}
				} else {
					if ($F("itemNo") != "" && ($("row"+$F("itemNo"))== null ? false : $("row"+$F("itemNo")).hasClassName("selectedRow"))){
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
	
	$("btnDeleteDeductible"+dedLevel).observe("click", function ()	{
		deleteDeductibles();		
	});
	
	$$("label[name='dedText"+dedLevel+"']").each(function (txt)	{
		var id = txt.getAttribute("id");
		$(id).update($(id).innerHTML.trim().truncate(25, "..."));
	});
	
	$$("label[name='dedTitle"+dedLevel+"']").each(function (txt)	{
		var id = txt.getAttribute("id");
		$(id).update($(id).innerHTML.trim().truncate(20, "..."));
	});
	
	$$("label[name='peril"+dedLevel+"']").each(function (txt)	{
		var id = txt.getAttribute("id");
		$(id).update($(id).innerHTML.trim().truncate(15, "..."));
	});

	// added by: nica 02.21.2011 - to set lay-out for deductibles per level
	var margin = (1== dedLevel ? 38 : (2 == dedLevel ? 25 : 0));
	
	$("deductibleHeader"+dedLevel).setStyle("margin-left: "+margin+"px; margin-right: "+margin+"px;");
	$("totalDedAmountDiv"+dedLevel).setStyle("margin-left:"+margin+"px; margin-right: "+margin+"px;");
	
	$$("div[name='wdeductibleListing"+dedLevel+"']").each(function(div){
		var id = div.getAttribute("id");
		$(id).setStyle("margin-left: "+margin+"px; margin-right: "+margin+"px;");
	});
	
	$$("div[name='ded"+dedLevel+"']").each(function (row)	{
		row.observe("click", function () {			
			clickDeductibleRow(row, dedLevel);
			
			/* 			if (row.hasClassName("selectedRow")){				
				setDeductibleForm(row, dedLevel);
 				var s = $("inputDeductible"+dedLevel);
				for (var i=0; i<s.length; i++)	{
					if (s.options[i].value==row.down("input", 0).value)	{
						s.selectedIndex = i;
					}
				} 

				// added to hide deductible title dropdown and make it readonly field
				s.hide();
 				$("inputDeductDisplay"+dedLevel).value = row.down("input", 3).value;
				$("inputDeductDisplay"+dedLevel).setAttribute("deductibleCd", row.down("input", 4).value );
				$("inputDeductDisplay"+dedLevel).show(); 
			} else {
				setDeductibleForm(null, dedLevel);
 				$("inputDeductible"+dedLevel).show();
				$("inputDeductDisplay"+dedLevel).clear();
				$("inputDeductDisplay"+dedLevel).hide();
			} */
		});
		
		var index 	   = parseInt(dedLevel == 1 ? 4 : (dedLevel == 2 ? 4 : 5));
		var tempRate   = parseFloat(row.down("label", index).innerHTML);
		var tempAmount = parseFloat(row.down("label", index+1).innerHTML);
		row.down("label", index).update(isNaN(tempRate) ? "-" : formatToNineDecimal(tempRate));
		row.down("label", index+1).update(tempAmount == "" ? "-" : formatCurrency(tempAmount));
	});	
	
	function setDeductibleVariables(){
		try {
			//var inputDeductible = $("inputDeductible"+dedLevel).options[$("inputDeductible"+dedLevel).selectedIndex];
			
			itemNo 			= (1 < dedLevel ? $F("itemNo") : 0);
			perilCd 		= (3 == dedLevel ? $F("perilCd") : 0);
			perilName 		= (3 == dedLevel ? $("txtPerilName").value : "");
			//perilName 	= (3 == dedLevel ? $("perilCd").options[$("perilCd").selectedIndex].text : "");
			/* deductibleTitle = $("inputDeductible"+dedLevel).options[$("inputDeductible"+dedLevel).selectedIndex].text == "" ? $("inputDeductDisplay"+dedLevel).value : $("inputDeductible"+dedLevel).options[$("inputDeductible"+dedLevel).selectedIndex].text;
			deductibleCd 	= $("inputDeductible"+dedLevel).getStyle("display") == "none" ? $("inputDeductDisplay"+dedLevel).getAttribute("deductibleCd") : $F("inputDeductible"+dedLevel); // modified by: nica 10.14.2010
			deductibleType	= $("inputDeductible"+dedLevel).options[$("inputDeductible"+dedLevel).selectedIndex].getAttribute("dType"); */
			deductibleCd 	= $F("txtDeductibleCd"+dedLevel);
			deductibleTitle = $F("txtDeductibleDesc"+dedLevel);			
			deductibleType	= $("txtDeductibleCd"+dedLevel).getAttribute("deductibleType");
			deductibleAmt 	= $F("inputDeductibleAmount"+dedLevel);
			deductibleRate 	= $F("deductibleRate"+dedLevel);
			deductibleText 	= $F("deductibleText"+dedLevel);
			aggregateSw 	= $("aggregateSw"+dedLevel).checked ? "Y" : "N";
			ceilingSw	 	= (1 == dedLevel ? ($("ceilingSw"+dedLevel).checked ? "Y" : "N") : "N");
			/* minimumAmount	= (inputDeductible.getAttribute("dType")== "L" || inputDeductible.getAttribute("dType")== "I" ) ? inputDeductible.getAttribute("minAmt"): "";
			maximumAmount	= (inputDeductible.getAttribute("dType")== "L" || inputDeductible.getAttribute("dType")== "I" ) ? inputDeductible.getAttribute("maxAmt"): "";
			rangeSw			= (inputDeductible.getAttribute("dType")== "L" || inputDeductible.getAttribute("dType")== "I" ) ? inputDeductible.getAttribute("rangeSw"): ""; */
			minimumAmount	= (deductibleType == "L" || deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("minAmt"): "";
			maximumAmount	= (deductibleType == "L" || deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("maxAmt"): "";
			rangeSw			= (deductibleType == "L" || deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("rangeSw"): "";
		} catch (e){
			showErrorMessage("setDeductibleVariables", e);
		}
	}
	
	function synchDetailsOfDeductible(index) {
		var amount  = $("inputDeductible"+dedLevel).options[index].getAttribute("dAmt");
		var rate 	= $("inputDeductible"+dedLevel).options[index].getAttribute("dRate");

		$("inputDeductibleAmount"+dedLevel).value = (amount == null  || amount == "" ? "" : formatCurrency(amount));
		$("deductibleRate"+dedLevel).value   = (rate == null || rate == "" ? "" : formatToNineDecimal(rate));
		$("deductibleText"+dedLevel).value   = $("inputDeductible"+dedLevel).options[index].getAttribute("dText");

		checkDeductibleAmount(index);
	}
	
	function deleteDeductibles(){
		try {
			setCursor("wait");
			if(dedLevel == 2){
				//if(!checkIfItemExists($F("itemNo"))){
				//	return false;
				//}
				var id = "row" + parseInt($F("itemNo").trim());
				
				if($(id) == null){
					showMessageBox("Please select an item first.", imgMessage.ERROR);					
					return false;	
				}
			}
			
			$$("div[name='ded"+dedLevel+"']").each(function (deduct) {
				if (deduct.hasClassName("selectedRow")){
					var delId = dedLevel + deduct.down("input", 0).value + deduct.down("input", 2).value + deduct.down("input", 4).value;
					var delDedCd = deduct.down("input", 4).value;
					var dedForDeleteDiv = $("dedForDeleteDiv"+dedLevel);
					var deleteContent  = '<input type="hidden" id="delDedItemNo'+ delId +'"			name="delDedItemNo'+dedLevel+'" 		value="'+ deduct.down("input", 0).value +'" />'+
										 '<input type="hidden" id="delDedPerilCd'+ delId +'"		name="delDedPerilCd'+dedLevel+'" 		value="'+ deduct.down("input", 2).value +'" />'+
										 '<input type="hidden" id="delDedDeductibleCd'+ delId +'"	name="delDedDeductibleCd'+dedLevel+'" 	value="'+ deduct.down("input", 4).value +'" />';

					var delDiv = new Element("div");
					delDiv.setAttribute("name", "delDed"+dedLevel);
					delDiv.setAttribute("id", "delDed"+delId);
					delDiv.setStyle("display: none;");
					delDiv.update(deleteContent);
					dedForDeleteDiv.insert({bottom : delDiv});

					$$("div[name='insDed"+dedLevel+"']").each(function(div){
						var id = div.getAttribute("id");
						if(id == "insDed"+delId){
							div.remove();
						}
					});

					//setDeductibleVariables();
					//var objDed = setJSONDeductible();
					//addDeletedJSONDeductible(objDed);
					objCurrDeductible.recordStatus = -1;
					
					Effect.Fade(deduct, {
						duration: .5,
						afterFinish: function () {
							//if(1 < dedLevel) {
							//	updateTempDeductibleItemNos();
							//}
							setDeductibleForm(null, dedLevel);							
							deduct.remove();
							//checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
							//checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
							checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
							setTotalAmount(dedLevel, deduct.down("input", 0).value, deduct.down("input", 2).value);
							//setDeductibleListing(objDeductibleListing, dedLevel);
						}
					});
					
					//$("inputDeductible"+dedLevel).show();
					//$("inputDeductDisplay"+dedLevel).clear();
					//$("inputDeductDisplay"+dedLevel).hide();
				}
			});
		} catch(e){
			showErrorMessage("deleteDeductibles", e);
		} finally {
			setCursor("default");
		}
	}	

	function checkDeductibles() {
		try {
			setDeductibleVariables();
			
			var exists = false;
			if (3 == dedLevel && (perilCd == 0 /*|| $("rowPeril" + itemNo + perilCd) == null*/)) {
				showMessageBox("Please select peril.", imgMessage.ERROR);
				//$("inputPeril"+$F("itemNo")).focus();
				exists = true;
				return false;
			}
			
			if (deductibleTitle == ""){
				showWaitingMessageBox("Please select a deductible.", imgMessage.ERROR, function(){
					$("hrefDeductible"+dedLevel).focus();
					exists = true;
				});
				//$("inputDeductible"+dedLevel).focus();
				return false;
			}
			
			var id = "ded" + dedLevel + itemNo + perilCd + deductibleCd;
			$$("div[name='ded"+dedLevel+"']").each( function(d)	{
				if (d.getAttribute("id") == id && $F("btnAddDeductible"+dedLevel) != "Update")	{
					showMessageBox("Record already exists!", imgMessage.ERROR);
					exists = true;
					return false;
				}
			});
	
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
									//$("inputDeductible"+dedLevel).disable();
								},
							onComplete: function (response) {
								setCursor("default");
								$("btnAddDeductible"+dedLevel).enable();
								//$("inputDeductible"+dedLevel).enable();
								if(checkErrorOnResponse(response)){
									if ("SUCCESS" == response.responseText) {
										addDeductibles();
										return;
									} else {
										showMessageBox(response.responseText, imgMessage.ERROR);
										setDeductibleForm(null, dedLevel);
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
	
	function addDeductibles() {
		try	{
			var id = dedLevel + itemNo + perilCd + deductibleCd;
			var objDeductible = setJSONDeductible();
			var insContent = '<input type="hidden" id="insDedItemNo'+id+'" 			name="insDedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
							 '<input type="hidden" id="insDedPerilName'+id+'" 		name="insDedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
							 '<input type="hidden" id="insDedPerilCd'+id+'" 		name="insDedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
							 '<input type="hidden" id="insDedTitle'+id+'" 			name="insDedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
							 '<input type="hidden" id="insDedDeductibleCd'+id+'"	name="insDedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
							 '<input type="hidden" id="insDedAmount'+id+'" 			name="insDedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
							 '<input type="hidden" id="insDedRate'+id+'"			name="insDedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
							 '<input type="hidden" id="insDedText'+id+'"			name="insDedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
							 '<input type="hidden" id="insDedAggregateSw'+id+'"		name="insDedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
					 		 '<input type="hidden" id="insDedCeilingSw'+id+'"		name="insDedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
					 		 '<input type="hidden" id="insDedDeductibleType'+id+'" 	name="insDedDeductibleType'+dedLevel+'"	value="'+deductibleType+'" />'+
					 		 '<input type="hidden" id="insDedMinimumAmount'+id+'" 	name="insDedMinimumAmount'+dedLevel+'"	value="'+minimumAmount+'" />' +
					 		 '<input type="hidden" id="insDedMaximumAmount'+id+'" 	name="insDedMaximumAmount'+dedLevel+'"	value="'+maximumAmount+'" />'+
					 		 '<input type="hidden" id="insDedRangeSw'+id+'" 		name="insDedRangeSw'+dedLevel+'"		value="'+rangeSw+'" />';
					 		 
			var content = '<input type="hidden" name="dedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
						 '<input type="hidden" name="dedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
						 '<input type="hidden" name="dedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
						 '<input type="hidden" name="dedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
						 '<input type="hidden" name="dedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
						 '<input type="hidden" name="dedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
						 '<input type="hidden" name="dedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
						 '<input type="hidden" name="dedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
						 '<input type="hidden" name="dedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
				 		 '<input type="hidden" name="dedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' +
				 		 '<input type="hidden" name="dedDeductibleType'+dedLevel+'"	value="'+deductibleType+'" />' +
				 		 '<input type="hidden" name="dedMinimumAmount'+dedLevel+'"	value="'+minimumAmount+'" />' +
				 		 '<input type="hidden"  name="dedMaximumAmount'+dedLevel+'"	value="'+maximumAmount+'" />' +
				 		 '<input type="hidden" name="dedRangeSw'+dedLevel+'"		value="'+rangeSw+'" />' +
				 		 '<label style="width: 33px; text-align: center;">';
							if (aggregateSw == 'Y') {
								content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;  " /></label>';
							} else {
								content += '<span style="width: 33px; height: 10px; text-align: left; display: block; margin-left: 3px;"></span></label>';
							}
							if (1 == dedLevel){
								content += '<label style="width: 45px; text-align: center;">';
								if (ceilingSw == 'Y') {
									content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 16px;" /></label>';
								}else{
									content += '<span style="width: 45px; height: 10px; text-align: left; display: block; margin-left: 3px;"></span></label>';;
								}
							}
				 		 
				content+=(1 < dedLevel ? '<label style="width: 70px; text-align: right; margin-right: 10px;">'+itemNo.trim()+'</label>' : "") +
						 (3 == dedLevel ? '<label style="width: 110px; text-align: left; " title="'+perilName+'">'+perilName.truncate(15, "...")+'</label>' : "") +	
						 '<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'" id="dedTitle'+dedLevel+itemNo+perilCd+deductibleCd+'" name="dedTitle'+dedLevel+'">'+deductibleTitle.truncate(25, "...")+'</label>'+  // added id="...." name="...." - dencal25 2010-09-24
						 '<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
						 '<label style="width: 119px; text-align: right;">'+(deductibleRate == "" ? "-" : formatToNineDecimal(deductibleRate))+'</label>'+
						 '<label style="width: 130px; text-align: right;">'+(deductibleAmt == "" ? "-" : formatCurrency(deductibleAmt))+'</label>';
						 /*
						 (1 < dedLevel ? '<label style="width: 4%; text-align: right; margin-right: 10px;">'+itemNo.trim()+'</label>' : "") +								  
						 (3 == dedLevel ? '<label style="width: 18%; text-align: left; " title="'+perilName+'">'+perilName.truncate(20, "...")+'</label>' : "") +	
						 '<label style="width: 24%; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'">'+deductibleTitle.truncate(25, "...")+'</label>'+		
						 '<label style="width: 13%; text-align: right; ">'+deductibleRate+'</label>'+
						 '<label style="width: 13%; text-align: right; ">'+formatCurrency(deductibleAmt)+'</label>'+							 
						 '<label style="width: 18%; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
						 '<label style="width: 3%; text-align: center;">';*/
					 	
			
			if ($F("btnAddDeductible"+dedLevel) == "Update") {
				$("ded"+id).update(content);
				//if(1 < dedLevel){
				//	updateTempDeductibleItemNos();
				//}
				// succeeding block added by nica 12.09.2010 
				// to unselect the record after update
				$("ded"+id).removeClassName("selectedRow");
				//$("inputDeductible"+dedLevel).show();
				//$("inputDeductDisplay"+dedLevel).clear();
				//$("inputDeductDisplay"+dedLevel).hide();
				setDeductibleForm(null, dedLevel);
				addModifiedJSONDeductible(objDeductible);
				
			} else {
				var newTaxDiv = new Element('div');
				newTaxDiv.setAttribute("name", "ded"+dedLevel);
				newTaxDiv.setAttribute("id", "ded"+id);
				newTaxDiv.setAttribute("item", itemNo);
				newTaxDiv.setAttribute("dedCd", deductibleCd);
				newTaxDiv.setAttribute("perilCd", perilCd);
				newTaxDiv.addClassName("tableRow");
				newTaxDiv.setStyle("display: none;");
				
				newTaxDiv.update(content);
				$("wdeductibleListing"+dedLevel).insert({bottom: newTaxDiv});
				
				newTaxDiv.observe("mouseover", function ()	{
					newTaxDiv.addClassName("lightblue");
				});
				
				newTaxDiv.observe("mouseout", function ()	{
					newTaxDiv.removeClassName("lightblue");
				});
				
				newTaxDiv.observe("click", function ()	{
					newTaxDiv.toggleClassName("selectedRow");
					clickDeductibleRow(newTaxDiv, dedLevel);
					
/* 					newTaxDiv.toggleClassName("selectedRow");
					
					if (newTaxDiv.hasClassName("selectedRow"))	{
						$$("div[name='ded"+dedLevel+"']").each(function (li)	{
							if (newTaxDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}
						});

						// change combobox to textbox when row select - dencal25 2010-09-23
						
						// modified by: nica 10.14.2010
						for( var i=0; i<objDeductibleListing.length; i++){
							if (objDeductibleListing[i].deductibleCd ==newTaxDiv.down("input", 4).value){
								$("inputDeductDisplay"+dedLevel).value = objDeductibleListing[i].deductibleTitle;
								$("inputDeductDisplay"+dedLevel).setAttribute("deductibleCd", objDeductibleListing[i].deductibleCd);
							}
						}
						$("inputDeductible"+dedLevel).hide();
						//$("inputDeductDisplay"+dedLevel).value = s.options[s.selectedIndex].text;
						$("inputDeductDisplay"+dedLevel).show();
						
						setDeductibleForm(newTaxDiv, dedLevel);
					} else {
						$("inputDeductible"+dedLevel).show();
						$("inputDeductDisplay"+dedLevel).clear();
						$("inputDeductDisplay"+dedLevel).hide();
						setDeductibleForm(null, dedLevel);
					} */
				});
				
				Effect.Appear(newTaxDiv, {
					duration: .5,
					afterFinish: function ()	{
						setDeductibleVariables();
						//checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
						//checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
						checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);						
						setTotalAmount(dedLevel, itemNo, perilCd);
					}
				});
				
				//hideOptionDeducTitles();
				//setDeductibleListing(objDeductibleListing, dedLevel);
				
				//if (1 < dedLevel) {
				//	updateTempDeductibleItemNos();
				//}
				addNewJSONDeductible(objDeductible);
			}
			var forInsertDiv = $("dedForInsertDiv"+dedLevel);
			var newInsDiv = new Element('div');
			newInsDiv.setAttribute("name", "insDed"+dedLevel);
			newInsDiv.setAttribute("id", "insDed"+id);
			newInsDiv.setStyle("display: none;");
			newInsDiv.update(insContent);
			forInsertDiv.insert({bottom: newInsDiv});

			setDeductibleForm(null, dedLevel);
			($$("div#dedMainContainerDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
		} catch (e)	{
			showErrorMessage("addDeductibles", e);
		}
	}
	
	function updateTempDeductibleItemNos(){
		var temp = $F("tempDeductibleItemNos").blank() ? "" : $F("tempDeductibleItemNos");
		$("tempDeductibleItemNos").value = temp + $F("inputDeductible"+dedLevel) + " ";
	}

	function checkDeductibleAmount(index){
		try {
			var tempType = $("inputDeductible"+dedLevel).options[index].getAttribute("dType");
			
			if (tempType == "T"){
				var itemNum = 1 < dedLevel ? $F("itemNo") : 0;
				var rate	= $("inputDeductible"+dedLevel).options[index].getAttribute("dRate");
				var minAmt  = $("inputDeductible"+dedLevel).options[index].getAttribute("minAmt");
				var maxAmt  = $("inputDeductible"+dedLevel).options[index].getAttribute("maxAmt");
				var rangeSw = $("inputDeductible"+dedLevel).options[index].getAttribute("rangeSw");
				var amount  = parseFloat(getAmount(dedLevel, itemNum)) * (parseFloat(rate)/100);
				if(rate != ""){
					if (minAmt != "" && maxAmt != ""){
						if (rangeSw == "H"){
							$("inputDeductibleAmount"+dedLevel).value = formatCurrency(Math.min(Math.max(amount, minAmt), maxAmt));
						} else if (rangeSw == "L"){
							$("inputDeductibleAmount"+dedLevel).value = formatCurrency(Math.min(Math.max(amount, minAmt), maxAmt));
						} else {
							$("inputDeductibleAmount"+dedLevel).value = formatCurrency(maxAmt);
						}
					} else if (minAmt != ""){
						$("inputDeductibleAmount"+dedLevel).value = formatCurrency(Math.max(amount, minAmt));	
					} else if (maxAmt != ""){
						$("inputDeductibleAmount"+dedLevel).value = formatCurrency(Math.min(amount, maxAmt));
					} else{
						$("inputDeductibleAmount"+dedLevel).value = formatCurrency(amount);
					}
				}else{
					if (minAmt != ""){
						$("inputDeductibleAmount"+dedLevel).value = formatCurrency(minAmt);
					} else if (maxAmt != ""){
						$("inputDeductibleAmount"+dedLevel).value = formatCurrency(maxAmt);
					}
				}
			}
		} catch (e) {
			showErrorMessage("getDeductibleAmount", e);
		}
	}

	changeCheckImageColor();
	/*	Modified by		: mark jm 09.17.2010
	*	Modification	: Show records related to selected item.
	*					: Used in item information page 
	*/

	if($("pageName") != null && $F("pageName") == "itemInformation"){
		var selectedItem = "";
		var rowName = ((objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "E" ? "row" : "row");
		$$("div[name='"+rowName+"']").each(
			function(row){
				row.observe("click", function(){
					if(row.hasClassName("selectedRow")){
						itemNo = $("itemNo").value;
						hidePerilDeductibles();
						//hideOptionDeducTitles();
						resetItemAndPerilDeductiblesIfItemChange();
						//setDeductibleListing(objDeductibleListing, dedLevel);
						checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
						setTotalAmount(dedLevel, (1 < dedLevel ? $F("itemNo") : 0), (3 == dedLevel && $("perilCd") != null && $F("perilCd") != "" ? $F("perilCd") : 0));
					}else{
						//showAllDeductibleOptions();
						hideAllItemDeductibles();
						hidePerilDeductibles();
						resetItemAndPerilDeductiblesIfItemChange();
						//setDeductibleListing(objDeductibleListing, dedLevel);
					}
				});// modified by: nica 02/23/2011
				
				if(row.hasClassName("selectedRow")){
					selectedItem = $("itemNo").value;
				}
			});
		if(selectedItem.blank()){
			initializeSubPagesTableListing("deductiblesTable" + dedLevel, "ded" + dedLevel);
			hidePerilDeductibles();
		}else{
			//loadRecordsBasedOnSelectedItem("deductiblesTable" + dedLevel, "ded" + dedLevel, "item", selectedItem, "inputDeductible" + dedLevel);
			resetItemAndPerilDeductiblesIfItemChange();
			hidePerilDeductibles();
			checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
			setTotalAmount(dedLevel, (1 < dedLevel ? $F("itemNo") : 0), (3 == dedLevel && $("perilCd") != null && $F("perilCd") != "" ? $F("perilCd") : 0));
		}
	}else if($F("pageName") != null && $F("pageName") == "basicInformation"){		
		//loadRecordsBasedOnSelectedItem("deductiblesTable" + dedLevel, "ded" + dedLevel, "item", 0, "inputDeductible" + dedLevel);
		checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
		setTotalAmount(dedLevel, (1 < dedLevel ? $F("itemNo") : 0), (3 == dedLevel && $("perilCd") != null && $F("perilCd") != "" ? $F("perilCd") : 0));
		//setDeductibleListing(objDeductibleListing, dedLevel);
	}
	//checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
	//setTotalAmount(dedLevel, (1 < dedLevel ? $F("itemNo") : 0), (3 == dedLevel && $("perilCd") != null && $F("perilCd") != "" ? $F("perilCd") : 0));
	// hides the loaded & added deductible title from the options
	// shows deductible title after deletion
	//hideOptionDeducTitles();
	//setDeductibleListing(objDeductibleListing);
	
	//assign value to perilCd whenever a peril is selected -- nica 09.30.10	
	if(dedLevel == 3){ // andrew - 10.06.2010 - modified this block
		var rowPeril = (objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "E" ? "row2": "row2";
	
		$$("div[name='"+rowPeril+"']").each(function(peril){
			peril.observe("click", function(){
				if(peril.hasClassName("selectedRow")){
					perilCd = $F("perilCd");
					//$("inputDeductible"+dedLevel).show();
					//$("inputDeductDisplay"+dedLevel).hide();
					//$("inputDeductibleAmount"+dedLevel).value = formatCurrency(0);
					//$("deductibleRate"+dedLevel).value   = formatCurrency(0);
					//$("deductibleText"+dedLevel).value   = "";
					setDeductibleForm(null, dedLevel);
					resetDeductibleForm(dedLevel);
					//setDeductibleListing(objDeductibleListing, dedLevel);
					toggleDeductibles(dedLevel, $F("itemNo"), perilCd);
					//checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
					setTotalAmount(dedLevel, (1 < dedLevel ? $F("itemNo") : 0), (3 == dedLevel && $("perilCd") != null && $F("perilCd") != "" ? $F("perilCd") : 0));
				}else{
					setDeductibleForm(null, dedLevel);
					resetDeductibleForm(dedLevel);
					toggleDeductibles(dedLevel, $F("itemNo"), 0);
					//checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);
					//$("inputDeductible"+dedLevel).show();
					//$("inputDeductDisplay"+dedLevel).hide();
					//$("inputDeductible"+dedLevel).value = "";
					//$("inputDeductDisplay"+dedLevel).value = "";
					//$("inputDeductibleAmount"+dedLevel).value = formatCurrency(0);
					//$("deductibleRate"+dedLevel).value   = formatCurrency(0);
					//$("deductibleText"+dedLevel).value   = ""; // added by: nica 10.14.2010 to clear deductible field if no peril is selected
				}
				// added by: nica 02.23.2011 - to unselect peril records when a peril is click
				$$("div[name=ded3]").each(function(perilDed){
					perilDed.removeClassName("selectedRow");
				})
			});
		});
	}
	
	/* //andrew - 10.06.2010 - commented this block 
	function hideOptionDeducTitles(){
		var wcSelOpts = $("inputDeductible"+dedLevel).options;

		setDeductibleVariables();
		showAllDeductibleOptions();
		
		$$("div[name='ded"+dedLevel+"']").each(function(d)	{
			if(dedLevel == 1){
				for (var i=0; i<wcSelOpts.length; i++) {
					if (d.getAttribute("dedCd") == wcSelOpts[i].value)	{
						wcSelOpts[i].hide();
					}
				}
			}else if(dedLevel == 2){
				for (var i=0; i<wcSelOpts.length; i++) {
					if (d.getAttribute("dedCd") == wcSelOpts[i].value && d.down("input", 0).value == itemNo){
						wcSelOpts[i].hide();
					}
				}
			}else if(dedLevel == 3){

				for (var i=0; i<wcSelOpts.length; i++) {
					if (d.getAttribute("dedCd") == wcSelOpts[i].value && d.down("input", 0).value == itemNo && perilCd == d.down("input",2).value){
						wcSelOpts[i].hide();
					}
				}
			}
		});
	}	
	
	function showOptionDeducTitles(id){
		var wcSelOpts = $("inputDeductible"+dedLevel).options;
		for (var i=0; i<wcSelOpts.length; i++) {
			if (wcSelOpts[i].value == id)	{
				wcSelOpts[i].show();
			}
		}
	}
	//reload the deductible listing - nica 09.29.2010
	function showAllDeductibleOptions(){
		var wcSelOpts = $("inputDeductible"+dedLevel).options;
		for (var i=0; i<wcSelOpts.length; i++) {
			wcSelOpts[i].show();
		}
	}*/

	
	/*
	* Created by	: andrew
	* Date			: October 18, 2010
	* Description	: Creates a new deductible object and assign values to it
	*/
	function setJSONDeductible(){
		var objDeductible = new Object();
		objDeductible.parId				= (objUWGlobal.packParId != null ? objCurrPackPar.parId :  $F("globalParId"));
		objDeductible.dedLineCd			= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
		objDeductible.dedSublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
		objDeductible.userId			= "${PARAMETERS['userId']}";
		objDeductible.itemNo 			= itemNo;
		objDeductible.perilCd 			= perilCd;
		objDeductible.dedDeductibleCd 	= deductibleCd;
		objDeductible.deductibleTitle 	= deductibleTitle;
		objDeductible.deductibleAmount 	= deductibleAmt == "" ? null : deductibleAmt;
		objDeductible.deductibleRate 	= deductibleRate == "" ? null : deductibleRate;
		objDeductible.deductibleText	= deductibleText;
		objDeductible.aggregateSw		= aggregateSw;
		objDeductible.ceilingSw		 	= ceilingSw;
		objDeductible.deductibleType 	= deductibleType;
		objDeductible.minimumAmount  	= minimumAmount;
		objDeductible.maximumAmount	 	= maximumAmount;
		objDeductible.rangeSw		 	= rangeSw;
		return objDeductible;
	}

	/*
	* Created By 	: andrew
	* Date			: October 18, 2010
	* Description	: Adds new deductible object to deductibles array of objects;
	*/
	function addNewJSONDeductible(newObj) {
		newObj.recordStatus = 0;
		objDeductibles.push(newObj);		
	}

	/*
	* Created By 	: andrew
	* Date			: October 18, 2010
	* Description	: Adds modified deductible object to deductibles array of objects;
	*/
	function addModifiedJSONDeductible(editedObj) {
		editedObj.recordStatus = 1;
		for (var i=0; i<objDeductibles.length; i++) {
			if(objDeductibles[i].itemNo == editedObj.itemNo && objDeductibles[i].perilCd == editedObj.perilCd && objDeductibles[i].dedDeductibleCd == editedObj.dedDeductibleCd){
				objDeductibles.splice(i, 1); // removes the object from the array of objects if existing
			}			
		}
		objDeductibles.push(editedObj); // adds the modified object to the array;
	}

	/*
	* Created By 	: andrew
	* Date			: October 20, 2010
	* Description	: Adds deleted deductible object to deductibles array of objects;
	*/
	function addDeletedJSONDeductible(deletedObj) {
		deletedObj.recordStatus = -1;		
		var existIndex = 0;
		for (var i=0; i<objDeductibles.length; i++) {
			if(objDeductibles[i].itemNo == deletedObj.itemNo && objDeductibles[i].perilCd == deletedObj.perilCd && objDeductibles[i].dedDeductibleCd == deletedObj.dedDeductibleCd){
				existIndex = i;
				break;
				//objDeductibles.splice(i, 1); 
			}
		}
		
		if (existIndex > 0) {
			objDeductibles.splice(existIndex, 1); // removes the object from the array of objects if existing
			objDeductibles.push(deletedObj); // added by mark jm 11.26.2010 push the object to be deleted
		} else {
			objDeductibles.push(deletedObj); // adds the deleted object to the array;
		}
	}

   	/* 
	* Created by	: Veronica V. Raymundo	
	* Date			: February 23, 2011
	* Description	: Hides all item deductibles
	*/

	function hideAllItemDeductibles(){
		$$("div[name=ded2]").each(function(itemDed){
			itemDed.setStyle("display: none;");
		});
	}

	/* 
	* Created by	: Veronica V. Raymundo	
	* Date			: February 23, 2011
	* Description	: Hides all peril deductibles
	*/
	
	function hidePerilDeductibles(){
		$$("div[name=ded3]").each(function(perilDed){
			perilDed.setStyle("display: none;");
		});
	}

	/* 
	* Created by	: Veronica V. Raymundo	
	* Date			: February 23, 2011
	* Description	: Reset deductibles form to be able to insert new deductible record
	*/

	function resetDeductibleForm(dedLvl){
		if($("inputDeductible"+dedLvl) != null){
			$("inputDeductible"+dedLvl).show();
			$("inputDeductible"+dedLvl).enable();
			$("inputDeductDisplay"+dedLvl).hide();
			$("inputDeductibleAmount"+dedLvl).value = formatCurrency(0);
			$("deductibleRate"+dedLvl).value   = formatCurrency(0);
			$("deductibleText"+dedLvl).value   = "";
			$("inputDeductible"+dedLvl).value = "";
		}
	}

	/* 
	* Created by	: Veronica V. Raymundo	
	* Date			: February 23, 2011
	* Description	: Used in item information to reset both item and  
	*				  peril deductible forms whenever another item is selected
	*/
	function resetItemAndPerilDeductiblesIfItemChange(){
		if($("inputDeductible"+dedLevel) != null){
			$$("div[name=ded2]").each(function(itemDed){
				itemDed.removeClassName("selectedRow");
			});
			
			$$("div[name=ded3]").each(function(perilDed){
				perilDed.removeClassName("selectedRow");
			});
			setDeductibleForm(null, 3);
			resetDeductibleForm(3);
			setDeductibleForm(null, 2);
			resetDeductibleForm(2);
			checkPopupsTable("deductiblesTable2", "wdeductibleListing2", "ded2");
			checkPopupsTable("deductiblesTable3", "wdeductibleListing3", "ded3");
		}
	}
	
	initializeChangeTagBehavior(changeTagFunc);
	initializeChangeAttribute();
	//setDeductibleListing(objDeductibleListing, dedLevel);
</script>