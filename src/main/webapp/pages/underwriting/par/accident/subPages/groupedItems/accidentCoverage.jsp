<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="coverageInfoDiv" class="sectionDiv" style="display: none; width:872px; background-color:white; ">
	<div style="margin: 10px;" id="coverageTable" name="coverageTable">
		<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 13%; margin-right: 6px;">Enrollee Name</label>
				<label style="text-align: left; width: 13%; margin-right: 6px;">Peril Name</label>
				<label style="text-align: right; width: 10%; margin-right: 5px;">Rate</label>
				<label style="text-align: right; width: 15%; margin-right: 5px;">TSI Amount</label>
				<label style="text-align: right; width: 15%; margin-right: 5px;">Premium Amount</label>
				<label style="text-align: right; width: 10%; margin-right: 5px;">No. Of Days</label>
				<label style="text-align: right; width: 15%; margin-right: 5px;">Base Amount</label>
				<label style="text-align: center; width: 3%;">A</label>
			</div>
			<div id="coverageListing" name="coverageListing"></div>
	</div>
	
	<table align="center" border="0">
		<tr>
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >
				<select  id="cPerilCd" name="cPerilCd" style="width: 223px" class="required">
					<option value="" wcSw="" perilType=""></option>
					<c:forEach var="perils" items="${perils}">
						<option value="${perils.perilCd}" wcSw="${perils.wcSw }" perilType="${perils.perilType }">${perils.perilName}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width:105px;">Peril rate </td>
			<td class="leftAligned" >
				<input id="cPremRt" name="cPremRt" type="text" style="width: 215px;" value="" maxlength="13" class="required moneyRate"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >TSI Amt. </td>
			<td class="leftAligned" >
				<input id="cTsiAmt" name="cTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money"/>
			</td>
			<td class="rightAligned" >Premium Amt. </td>
			<td class="leftAligned" >
				<input id="cPremAmt" name="cPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >No. of Days </td>
			<td class="leftAligned" >
				<input id="cNoOfDays" name="cNoOfDays" type="text" style="width: 215px;" value="" maxlength="6" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered No. of Days is invalid. Valid value is from 0 to 999,999"/>
			</td>
			<td class="rightAligned" >Base Amount </td>
			<td class="leftAligned" >
				<input id="cBaseAmt" name="cBaseAmt" type="text" style="width: 215px;" value=""  maxlength="18" class="money"/>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="leftAligned" colspan="3" ><input type="checkbox" id="cAggregateSw" name="cAggregateSw" checked="checked"/><font class="rightAligned"> Aggregate</font></td>
		</tr>
		<tr>
			<td colspan="4">
				<input id="cAnnPremAmt" 	name="cAnnPremAmt" 		type="hidden" style="width: 215px;" value="" maxlength="14" class="money"/>
				<input id="cAnnTsiAmt"	 	name="cAnnTsiAmt" 		type="hidden" style="width: 215px;" value="" maxlength="18" class="money"/>
				<input id="cGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="cLineCd" 		name="cLineCd" 			type="hidden" style="width: 215px;" value="" />
				<input id="cRecFlag" 		name="cRecFlag"	 		type="hidden" style="width: 215px;" value="" />
				<input id="cRiCommRt" 		name="cRiCommRt" 		type="hidden" style="width: 215px;" value="" maxlength="13" class="moneyRate"/>
				<input id="cRiCommAmt" 		name="cRiCommAmt" 		type="hidden" style="width: 215px;" value="" maxlength="16" class="money"/>
				<input id="cWcSw" 			name="cWcSw"	 		type="hidden" style="width: 215px;" value="" />
				<input id="cPerilType" 		name="cPerilType"	 	type="hidden" style="width: 215px;" value="" />
			</td>
		</tr>		
	</table>
	
	<table align="center" style="margin-bottom: 10px">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnCopyBenefits" 	name="btnCopyBenefits" 		value="Copy Benefits" 		style="width: 95px;" />
				<input type="button" class="button" 		id="btnAddCoverage" 	name="btnAddCoverage" 		value="Add" 		style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteCoverage" 	name="btnDeleteCoverage" 	value="Delete" 		style="width: 85px;" />
			</td>
		</tr>
	</table> 
</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	var fromDateFromItem = "";
	var toDateFromItem = "";
	var packBenCdFromItem = "";
	var prorateFlagFromItem = "";
	var compSwFromItem = "";
	var shortRatePercentFromItem = "";

	$("cPerilCd").observe("change", function() {
		if ($("cPerilCd").options[$("cPerilCd").selectedIndex].getAttribute("wcSw") == "Y"){
			showConfirmBox("Message", "Peril has an attached warranties and clauses, would you like to use these as your default values on warranties and clauses?",  
					"Yes", "No", onOkFunc, onCancelFunc);
		} else{
			$("cWcSw").value = "";
		}	
		$("cPerilType").value = $("cPerilCd").options[$("cPerilCd").selectedIndex].getAttribute("perilType");
	});	

	$("btnAddCoverage").observe("click", function(){
		try {
			var newObj = setGrpCoverageObj();
			var newContent = prepareGrpCoverageInfo(newObj);
			var tableContainer = $("coverageListing");

			if($F("btnAddCoverage") == "Update") {
				$("cvgRow"+$F("itemNo")+$F("groupedItemNo")).update(newContent);
				addModifiedGroupedJSONObj(objWItmperlGrouped, newObj);
			} else {
				newObj.recordStatus = 0;
				objWItmperlGrouped.push(newObj);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "cvgRow"+newObj.itemNo+newObj.groupedItemNo+newObj.perilCd);
				newDiv.setAttribute("name", "cvgRow");
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItem", newObj.groupedItemNo);
				newDiv.setAttribute("peril", newObj.perilCd);
				newDiv.addClassName("tableRow");
				//newDiv.setStyle({fontSize: '10px'});

				newDiv.update(newContent);
				tableContainer.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);
				clickGrpCover(newObj, newDiv);
			}				
			setCoverForm(null);
			checkIfToResizeTable("coverageListing", "cvgRow");
			checkTableIfEmpty("cvgRow", "coverageTable");
		} catch(e) {
			showErrorMessage("addCoverage", e);
		}
	});

	function setGrpCoverageObj() {
		try {
			var newObj = new Object();

			newObj.parId 			= $F("globalParId");
			newObj.itemNo 			= $F("itemNo");
			newObj.groupedItemNo	= $F("groupedItemNo");
			newObj.lineCd			= $F("grpLineCd");
			newObj.perilCd			= $F("cPerilCd");
			newObj.recFlag			= $F("recFlag");
			newObj.noOfDays			= $F("cNoOfDays");
			newObj.premRt			= $F("cPremRt");
			newObj.tsiAmt			= $F("cTsiAmt");
			newObj.premAmt			= $F("cPremAmt");
			newObj.annTsiAmt		= $F("cAnnTsiAmt");
			newObj.annPremAmt		= $F("cAnnPremAmt");
			newObj.aggregateSw		= $F("cAggregateSw");
			newObj.baseAmt			= $F("cBaseAmt");
			newObj.riCommRate		= $F("cRiCommRt");
			newObj.riCommAmt		= $F("cRiCommAmt");
			
			return newObj;
		} catch(e) {
			showErrorMessage("setGrpCoverageObj", e);
		}
	}

	$("btnDeleteCoverage").observe("click", function() {
		try {
			var delObj = setGrpCoverageObj();
			//$$("div#coverageTable div[id='cvgRow"+$F("itemNo")+delObj.groupedItemNo+delObj.perilCd+"']").each(function(row) {
			$$("div#coverageTable div[name='cvgRow']").each(function(row) {	
				if(row.hasClassName("selectedRow")) {
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function() {
							addDeletedGroupedJSONObj(objWItmperlGrouped, delObj);
							row.remove();
							
							setCoverForm(null);
							checkIfToResizeTable("coverageListing", "cvgRow");
							checkTableIfEmpty("cvgRow", "coverageTable");
						}
					});
				}
			});
		} catch(e) {
			showErrorMessage("deleteCoverage", e);
		}
	});
</script>