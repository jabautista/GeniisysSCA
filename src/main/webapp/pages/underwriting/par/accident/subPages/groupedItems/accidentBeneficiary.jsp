<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="groupedBeneficiaryInfo" class="sectionDiv" style="display: none; width: 872px; background-color: white;">
	<div style="margin: 10px;" id="gBeneficiaryTable" name="gBeneficiaryTable">	
		<div class="tableHeader" style="margin-top: 5px;">
			<label style="text-align: left; width: 20%; margin-right: 10px;">Name</label>
			<label style="text-align: left; width: 17%; margin-right: 10px;">Address</label>
			<label style="text-align: left; width: 10%; margin-right: 10px;">Birthday</label>
			<label style="text-align: left; width: 10%; margin-right: 10px;">Age</label>
			<label style="text-align: left; width: 14%; margin-right: 10px;">Relation</label>
			<label style="text-align: right; width: 20%;">Tsi Amount</label>
		</div>
		<div id="gBeneficiaryListing" name="gBeneficiaryListing"></div>
	</div>
	
	<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned" style="width:100px;">Name </td>
			<td class="leftAligned" colspan="3">
				<input id="bBeneficiaryNo" name="bBeneficiaryNo" type="hidden" style="width: 180px;" maxlength="5" readonly="readonly"/>
				<input id="bBeneficiaryName" name="bBeneficiaryName" type="text" style="width: 462px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Address </td>
			<td class="leftAligned" colspan="3">
				<input id="bBeneficiaryAddr" name="bBeneficiaryAddr" type="text" style="width: 462px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none;" id="bDateOfBirth" name="bDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img name="accModalDate" id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td class="rightAligned" >Age
				<input id="bAge" name="bAge" type="text" style="width: 90px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Sex	
				<select id="bSex" name="bSex" style="width:106px;">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Relation </td>
			<td class="leftAligned">
				<input id="bRelation" name="bRelation" type="text" style="width: 180px;" maxlength="15"/>
			</td>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned">
				<select  id="bCivilStatus" name="bCivilStatus" style="width: 142px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td>
				<input id="bGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="nextItemNoBen2"  name="nextItemNoBen2"   type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center" style="margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddGrpBeneficiary" 	name="btnAddGrpBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteGrpBeneficiary" 	name="btnDeleteGrpBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
	
	
	
	<div style="margin:auto; margin-top:0px; width:75%;" id="benPerilTable" name="benPerilTable">	
		<div class="tableHeader" style="margin-top:5px;">
			<label style="text-align: left; width: 49%; margin-right: 10px;">Peril Name</label>
			<label style="text-align: right; width: 49%;">Tsi Amount</label>
		</div>
		<div id="acBenPerilListing" name="acBenPerilListing"></div>
	</div>
	<table align="center" border="0">
		<tr> 
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >
				<select  id="bpPerilCd" name="bpPerilCd" style="width: 223px" class="required">
					<option value=""></option>
					<c:forEach var="bPerils" items="${beneficiaryPerils}">
						<option value="${bPerils.perilCd}">${bPerils.perilName}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width:105px;">TSI Amt. </td>
			<td class="leftAligned" >
				<input id="bpTsiAmt" name="bpTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="money"/>
			</td>
		</tr>
		<tr>
			<td>
				<input id="bpGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" value="" />
				<input id="bpBeneficiaryNo" 	name="bpBeneficiaryNo" 	type="hidden" value="" />
				<input id="bpLineCd" 			name="bpLineCd" 		type="hidden" value="" />
				<input id="bpRecFlag" 			name="bpRecFlag" 		type="hidden" value="" />
				<input id="bpPremRt" 			name="bpPremRt" 		type="hidden" value="" />
				<input id="bpPremAmt" 			name="bpPremAmt" 		type="hidden" value="" />
				<input id="bpAnnTsiAmt" 		name="bpAnnTsiAmt" 		type="hidden" value="" />
				<input id="bpAnnPremAmt" 		name="bpAnnPremAmt" 	type="hidden" value="" />
				<input id="perilsItemSeqNo"		name="perilsItemSeqNo"  type="hidden" value="" />
				<input id="perilsItemSeqNo2"	name="perilsItemSeqNo2" type="hidden" value="" />
			</td>
		</tr>
	</table>
	<table align="center" border="0" style="margin-bottom:10px;">	
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiaryPerils" 	name="btnAddBeneficiaryPerils" 		value="Add" 		style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiaryPerils" 	name="btnDeleteBeneficiaryPerils" 	value="Delete" 		style="width: 85px;" />
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">

	function getNewBenNo() {
		var benNo = 0;
		if(objWGrpItemBen != null || objWGrpItemBen.length > 0) {
			for(var i=0; i<objWGrpItemBen.length; i++) {
				if(benNo < objWGrpItemBen[i].beneficiaryNo) {
					benNo = objWGrpItemBen[i].beneficiaryNo;
				}
			}
		}
		$("bBeneficiaryNo").value = benNo+1;
	}
	
	$("btnAddGrpBeneficiary").observe("click", function() {
		if($F("groupedItemNo")=="" || $F("groupedItemNo")==null) {
			showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.ERROR);
			return false;
		} else {
			addGrpBeneficiary();
		}
	});	

	function addGrpBeneficiary() {
		try {
			if($F("btnAddGrpBeneficiary") == "Add") {
				getNewBenNo();
			}
			var newObj = setGrpBenObj();
			var newContent = prepareGroupedBen(newObj);
			var tableContainer = $("gBeneficiaryListing");
			
			if($F("btnAddGrpBeneficiary") == "Update") {
				$("gBenRow"+$F("itemNo")+newObj.groupedItemNo+newObj.bBeneficiaryNo).update(newContent);
				addModifiedGroupedJSONObj(objWGrpItemBen, newObj);
			} else {
				newObj.recordStatus = 0;
				objWGrpItemBen.push(newObj);
	
			    var newDiv = new Element("div");
			    newDiv.setAttribute("id", "gBenRow"+newObj.itemNo+newObj.groupedItemNo+newObj.beneficiaryNo);
				newDiv.setAttribute("name", "gBenRow");
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItemNo", newObj.groupedItemNo);
				newDiv.setAttribute("benNo", newObj.beneficiaryNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(newContent);
				tableContainer.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);
				clickGrpBen(newObj, newDiv);
			}
			setGrpBenForm(null);
			checkIfToResizeTable("gBeneficiaryListing", "gBenRow");
			checkTableIfEmpty("gBenRow", "gBeneficiaryTable");
		} catch(e) {
			showErrorMessage("addGrpBeneficiary", e);
		}
	}
	
	function setGrpBenObj() {
		try {
			var benObj = new Object();
			
			benObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			benObj.itemNo			= $F("itemNo");
			benObj.groupedItemNo	= $F("groupedItemNo");
			benObj.beneficiaryNo	= $F("bBeneficiaryNo");
			benObj.beneficiaryName	= $F("bBeneficiaryName");
			benObj.beneficiaryAddr	= $F("bBeneficiaryAddr");
			benObj.relation			= $F("bRelation");
			benObj.dateOfBirth		= $F("bDateOfBirth");
			benObj.age				= $F("bAge");
			benObj.civilStatus		= $F("bCivilStatus");
			benObj.sex				= $F("bSex");
			return benObj;
		} catch(e) {
			showErrorMessage("setGrpBenObj", e);
		}
	}
	
	$("btnDeleteGrpBeneficiary").observe("click", function() {
		try {
			var delObj = setGrpBenObj();
			//$$("div#gBeneficiaryTable div[name='gBenRow' item='"+delObj.itemNo+"' grpItem='"+delObj.groupedItemNo+"' benNo='"+delObj.beneficiaryNo+"']").each(function(row) {
			$$("div#gBeneficiaryTable div[id='gBenRow"+delObj.itemNo+delObj.groupedItemNo+delObj.beneficiaryNo+"' ]").each(function(row) {
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function() {
						addDeletedGroupedJSONObj(objWGrpItemBen, delObj);
						row.remove();
	
						setGrpBenForm(null);
						
						checkIfToResizeTable("gBeneficiaryListing", "gBenRow");
						checkTableIfEmpty("gBenRow", "gBeneficiaryTable");
					}
				});
			});
		} catch(e) {
			showErrorMessage("deleteGrpBeneficiary", e);
		}
	});

	$("btnAddBeneficiaryPerils").observe("click", function() {
		if($F("groupedItemNo")=="" || $F("groupedItemNo")==null) {
			showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.ERROR);
			return false;
		} else if($F("bBeneficiaryNo") == "" || $F("bBeneficiaryNo") == null){
			showMessageBox("Please select a Beneficiary Item first.", imgMessage.ERROR);
			return false;
		} else {
			addGroupedBenPerils();
		}
	});

	function addGroupedBenPerils() {
		try {
			var newObj = setBenPerilObj();
			var newContent = prepareGrpBenPeril(newObj);
			var tableContainer = $("acBenPerilListing");

			if($F("btnAddBeneficiaryPerils") == "Update") {
				$("benPerlRow"+newObj.itemNo+newObj.groupedItemNo+newObj.beneficiaryNo+newObj.perilCd).update(newContent);
				addModifiedGroupedJSONObj(objWGrpItemBen, newObj);
			} else {
				newObj.recordStatus = 0;
				objWItmPerilBen.push(newObj);

				var newDiv = new Element("div");
				newDiv.setAttribute("id", "benPerlRow"+newObj.itemNo+newObj.groupedItemNo+newObj.beneficiaryNo+newObj.perilCd);
				newDiv.setAttribute("name", "benPerlRow");
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItemNo", newObj.groupedItemNo);
				newDiv.setAttribute("benNo", newObj.beneficiaryNo);
				newDiv.setAttribute("perilCd", newObj.perilCd);
				newDiv.addClassName("tableRow");
				
				newDiv.update(newContent);
				tableContainer.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);

				setBenPerilForm(null);
				checkIfToResizeTable("acBenPerilListing", "benPerlRow");
				checkTableIfEmpty("benPerlRow", "benPerilTable");
			}
		} catch(e) {
			showErrorMessage("addGroupedBenPerils", e);
		}
	}

	function setBenPerilObj() {
		try {
			var newObj = new Object();
			
			newObj.parId			=	(objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo			=	$F("itemNo");
			newObj.groupedItemNo	=	$F("groupedItemNo");
			newObj.beneficiaryNo	=   $F("bBeneficiaryNo");
			newObj.lineCd			=   $F("globalLineCd");
			newObj.perilCd			= 	$F("bpPerilCd");
			newObj.recFlag			=	"";
			newObj.premRt			=	"";
			newObj.tsiAmt			=	$F("bpTsiAmt");
			newObj.premAmt			=	"";
			newObj.annTsiAmt		=	"";
			newObj.annPremAmt		=	"";
			newObj.perilName		=	$("bpPerilCd").options[$("bpPerilCd").selectedIndex].text;
			
			return newObj;
		} catch(e) {
			showErrorMessage("setBenPerilObj", e);
		}
	}

	$("btnDeleteBeneficiaryPerils").observe("click", function() {
		try {
			var delObj = setBenPerilObj();
			//$$("div#benPerilTable div[name='benPerlRow' item='"+delObj.itemNo+"' grpItem='"+delObj.groupedItemNo+"' benNo='"+delObj.beneficiaryNo+"' perilCd='"+delObj.perilCd+"']").each(function(row) {
			$$("div#benPerilTable div[id='benPerlRow"+delObj.itemNo+delObj.groupedItemNo+delObj.beneficiaryNo+delObj.perilCd+"' ]").each(function(row) {
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function() {
							addDeletedGroupedJSONObj(objWItmPerilBen, delObj);
							row.remove();
		
							setBenPerilForm(null);
							checkIfToResizeTable("acBenPerilListing", "benPerlRow");
							checkTableIfEmpty("benPerlRow", "benPerilTable");
					}
				});
			});
		} catch(e) {
			showErrorMessage("deleteBeneficiaryPerils", e);
		}
	});
	
/*	$("bAge").observe("blur", function () {
		if (parseInt($F("bAge")) > 999 || parseInt($F("bAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("bAge").value ="";
			return false;
		} else{
			isNumber("bAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("bDateOfBirth").observe("blur", function () {
		$("bAge").value = computeAge($("bDateOfBirth").value);
		checkBday();
	});

	$("bAge").observe("blur", function () {
		if ($("bDateOfBirth").value != ""){
			if ($("bAge").value != ""){
				$("bAge").value = computeAge($("bDateOfBirth").value);
			}
		}
	});
			
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("bDateOfBirth"));
		if (bday>today){
			$("bDateOfBirth").value = "";
			$("bAge").value = "";
			hideNotice("");
		}	
	}

	$("bpTsiAmt").observe("blur", function() {
		if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("bpTsiAmt").focus();
			$("bpTsiAmt").value = "";
		} else if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("bpTsiAmt").focus();
			$("bpTsiAmt").value = "";
		}
	});	*/
	
</script>