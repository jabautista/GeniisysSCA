<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="beneficiaryInformationInfo" class="sectionDiv" style="display: none; width:872px; background-color:white; ">	
	<div style="margin: 10px;" id="bBeneficiaryTable" name="bBeneficiaryTable">	
		<div class="tableHeader" style="margin-top: 5px;">
			<label style="text-align: left; width: 80px; margin-right: 10px; margin-left: 5px;">Ben. No.</label>
			<label style="text-align: left; width: 190px; margin-right: 10px;">Name</label>
			<label style="text-align: left; width: 190px; margin-right: 10px;">Address</label>
			<label style="text-align: left; width: 100px; margin-right: 10px;">Birthday</label>
			<label style="text-align: left; width: 100px; margin-right: 10px;">Age</label>
			<label style="text-align: left; width: 100px; margin-right: 10px;">Relation</label>			
		</div>
		
		<div class="tableContainer" id="bBeneficiaryListing" name="bBeneficiaryListing" style="display: block;">
		</div>
	</div> 
	<table align="center" width="100%" border="0">
		<tr>
			<td class="rightAligned" style="width: 250px;">Beneficiary No. </td>
			<td class="leftAligned" colspan="5">				
				<input id="bBeneficiaryNo" name="bBeneficiaryNo" type="text" style="width: 462px" maxlength="30" class="required"/>				
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Beneficiary Name </td>
			<td class="leftAligned" colspan="5">				
				<input id="bBeneficiaryName" name="bBeneficiaryName" type="text" style="width: 462px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Beneficiary Address </td>
			<td class="leftAligned" colspan="5">
				<input id="bBeneficiaryAddr" name="bBeneficiaryAddr" type="text" style="width: 462px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" style="width: 150px;">
				<div style="float:left; border: solid 1px gray; width: 150px; height: 21px; margin-right:3px;">
			    	<input style="width: 124px; border: none;" id="bDateOfBirth" name="bDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img name="accModalDate" id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>
			<td class="rightAligned" style="width: 70px;">Age </td>
			<td class="leftAligned" style="width: 80px;">
				<input id="bAge" name="bAge" type="text" style="width: 80px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 49px;">Sex </td>
			<td class="lefyAligned">
				<select id="bSex" name="bSex" style="width: 88px;">
						<option value=""></option>
						<option value="F">Female</option>
						<option value="M">Male</option>
					</select>
			</td>					
		</tr>
		<tr>
			<td class="rightAligned">Relation </td>
			<td class="leftAligned">
				<input id="bRelation" name="bRelation" type="text" style="width: 144px;" maxlength="15"/>
			</td>
			<td class="rightAligned">Civil Status </td>
			<td class="leftAligned" colspan="3">
				<select id="bCivilStatus" name="bCivilStatus" style="width: 233px;">
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
				<input type="button" class="button" 		id="btnAddBeneficiary" 	name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiary" 	name="btnDeleteBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
	<!--<jsp:include page="/pages/underwriting/subPages/accidentBeneficiaryPerilListing.jsp"></jsp:include>-->
	<div style="margin:auto; margin-top:0px; width:75%;" id="benPerilTable" name="benPerilTable">	
		<div class="tableHeader" style="margin-top:5px;">
			<label style="text-align: left; width: 300px; margin-right: 10px; margin-left: 5px;">Peril Name</label>
			<label style="text-align: right; width: 300px;">Tsi Amount</label>
		</div>		
		<div class="tableContainer" id="benPerilListing" name="benPerilListing" style="display: block; margin:auto; ">			
		</div>
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
				<input id="bpTsiAmt" name="bpTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="money2" min="-99999999999999.99" max="99999999999999.99" errorMsg="Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99." />
			</td>
		</tr>
		<tr>
			<td>
				<input id="bpGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="bpBeneficiaryNo" 	name="bpBeneficiaryNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="bpLineCd" 			name="bpLineCd" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpRecFlag" 			name="bpRecFlag" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpPremRt" 			name="bpPremRt" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpPremAmt" 			name="bpPremAmt" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpAnnTsiAmt" 		name="bpAnnTsiAmt" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpAnnPremAmt" 		name="bpAnnPremAmt" 	type="hidden" style="width: 215px;" value="" />
				<input id="perilsItemSeqNo"		name="perilsItemSeqNo"  type="hidden" style="width: 215px;" value="" />
				<input id="perilsItemSeqNo2"	name="perilsItemSeqNo2" type="hidden" style="width: 215px;" value="" />
			</td>
		</tr>
	</table>
	<table align="center" border="0" style="margin-bottom:10px;">	
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiaryPerils" 	name="btnAddBeneficiaryPerils" 		value="Add" 		style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiaryPerils" name="btnDeleteBeneficiaryPerils" 	value="Delete" 		style="width: 85px;" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();	
	
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

//start for perils
	function getDefaultsPeril()	{
		$("btnAddBeneficiaryPerils").value = "Update";
		enableButton("btnDeleteBeneficiaryPerils");
	}

	function clearFormPeril()	{
		generateSeqNoForPeril();
		$("bpPerilCd").selectedIndex = 0;
		$("bpTsiAmt").value = "";
		$("bpGroupedItemNo").value = "";
		$("bpBeneficiaryNo").value = "";
		$("bpLineCd").value = "";
		$("bpRecFlag").value = "";
		$("bpPremRt").value = "";
		$("bpPremAmt").value = "";
		$("bpAnnTsiAmt").value = "";
		$("bpAnnPremAmt").value = "";

		$("btnAddBeneficiaryPerils").value = "Add";
		disableButton("btnDeleteBeneficiaryPerils");
		deselectRows("benPerilTable","benPeril");
		checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	function generateSeqNoForPeril(){
		var itemNoSize = $$("div[name='benPeril']").size();
		var getItemNo = 0;
		if (itemNoSize > 0){
			$$("div[name='benPeril']").each(function (a){
					getItemNo = getItemNo+ " " + a.getAttribute("itemSeqNo");
			});	
		}
		$("perilsItemSeqNo2").value = (getItemNo == "" ? "0 ": getItemNo);
		var newItemNo = sortNumbers($("perilsItemSeqNo2").value).last();
		$("perilsItemSeqNo").value = parseInt(newItemNo)+1;
	}
	
	$$("div[name='benPeril']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		beneficiaryNo = newDiv.getAttribute("beneficiaryNo");
		seqNo = newDiv.getAttribute("itemSeqNo"); 
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowBenPeril"+formatNumberDigits(no,7)+beneficiaryNo+seqNo);
	});

	function computeTotalForPeril(){
		var tsiAmtTotal = 0;
		$$("div[name='benPeril']").each(function(row){
			if (row.getAttribute("groupedItemNo") == getSelectedRowAttrValue("grpItem","groupedItemNo") && row.getAttribute("beneficiaryNo") == getSelectedRowAttrValue("benefit","beneficiaryNo")){
				tsiAmtTotal = parseFloat(tsiAmtTotal) + parseFloat(row.down("input",3).value.replace(/,/g, ""));
			}
		});
		$$("div[name='benefit']").each(function(grp){
			if (grp.getAttribute("groupedItemNo") == getSelectedRowAttrValue("grpItem","groupedItemNo") && grp.getAttribute("beneficiaryNo") == getSelectedRowAttrValue("benefit","beneficiaryNo")){
				grp.down("label",5).update(formatCurrency(tsiAmtTotal).truncate(15, "..."));
			}	
		});	
	}	
//end for perils	

	function getDefaults()	{
		$("btnAddBeneficiary").value = "Update";
		enableButton("btnDeleteBeneficiary");
	}

	function clearForm()	{
		generateSequenceItemInfo("benefit","bBeneficiaryNo","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"),"nextItemNoBen2");
		$("bBeneficiaryName").value = "";
		$("bBeneficiaryAddr").value = "";
		$("bDateOfBirth").value = "";
		$("bAge").value = "";
		$("bRelation").value = "";
		$("bCivilStatus").selectedIndex = 0;
		$("bSex").selectedIndex = 0;

		$("btnAddBeneficiary").value = "Add";
		disableButton("btnDeleteBeneficiary");
		deselectRows("bBeneficiaryTable","benefit");
		checkTableItemInfoAdditionalModal("bBeneficiaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
		setRecordListPerItem(false);
	}

	$$("div[name='benefit']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		beneficiaryNo = newDiv.getAttribute("beneficiaryNo");
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowBenInfo"+formatNumberDigits(no,7)+beneficiaryNo);
	});

	function setRecordListPerItem(blnApply){			
		var listTableName 	= ["benPerilTable",];
		var listRowName		= ["benPeril"];
		var listCode 		= ["beneficiaryNo"];

		clearFormPeril();
		
		if(blnApply){
			for(var index = 0, length = listTableName.length; index < length; index++){				
				$$("div[name='"+listRowName[index]+"']").each(
					function(row){						
						if (row.getAttribute("beneficiaryNo") != getSelectedRowAttrValue("benefit","beneficiaryNo") || row.getAttribute("groupedItemNo") != getSelectedRowAttrValue("grpItem","groupedItemNo")){
							$(row.getAttribute("id")).hide();
						} else{
							$(row.getAttribute("id")).show();
						}	
					});
			}			
		} else{			
			for(var index = 0, length = listTableName.length; index < length; index++){				
				$$("div[name='"+listRowName[index]+"']").each(
					function(row){
						row.hide();
					});
			}
		}
		checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}
	
	//computeTotalForPeril();
	//generateSeqNoForPeril();
	//setRecordListPerItem(false);
	//checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	
	/* beneficiary */		

	function setEnrolleeBenificiaryObj(){
		try{
			var newObj = new Object();

			newObj.parId			= objUWParList.parId;
			newObj.itemNo			= $F("itemNo");
			newObj.groupedItemNo	= removeLeadingZero($F("groupedItemNo"));
			newObj.beneficiaryNo	= $F("bBeneficiaryNo");
			newObj.beneficiaryName	= changeSingleAndDoubleQuotes2($F("bBeneficiaryName"));
			newObj.beneficiaryAddr	= changeSingleAndDoubleQuotes2($F("bBeneficiaryAddr"));
			newObj.relation			= changeSingleAndDoubleQuotes2($F("bRelation"));
			newObj.dateOfBirth		= $F("bDateOfBirth").empty() ? null : $F("bDateOfBirth");
			newObj.age				= $F("bAge").empty() ? null : $F("bAge");
			newObj.civilStatus		= $F("bCivilStatus").empty() ? null : $F("bCivilStatus");
			newObj.sex				= $F("bSex").empty() ? null : $F("bSex");
			
			return newObj;
		}catch(e){
			showErrorMessage("setEnrolleeBenificiaryObj", e);
		}
	}

	$("btnDeleteBeneficiary").observe("click", function() {
		//$("popBenDiv").hide();
		
		$$("div#bBeneficiaryTable div[name='rowEnrolleeBen']").each(function(row) {	
			if(row.hasClassName("selectedRow")) {
				var delObj = setEnrolleeBenificiaryObj();
				
				// enrollee beneficiary perils
				if(($$("div#benPerilTable .selectedRow")).length > 0){
					fireEvent(($$("div#benPerilTable .selectedRow"))[0], "click");
				}
				
				var forSplicing = [];
				for (var i = 0, length = objGIPIWItmperlBeneficiary.length; i < length; i++) {
					if (delObj.itemNo == objGIPIWItmperlBeneficiary[i].itemNo &&
							delObj.groupedItemNo == objGIPIWItmperlBeneficiary[i].groupedItemNo &&
							delObj.beneficiaryNo == objGIPIWItmperlBeneficiary[i].beneficiaryNo) {
						var delBenPerilObj = cloneObject(objGIPIWItmperlBeneficiary[i]);
						var delRow = ((("rowBenPeril" + delBenPerilObj.itemNo) + delBenPerilObj.groupedItemNo) + delBenPerilObj.beneficiaryNo) + delBenPerilObj.perilCd;						

						forSplicing.push(delBenPerilObj);						
						$(delRow).remove();
					}
				}

				for(var i=0, length=forSplicing.length; i < length; i++){
					addDelObjByAttr(objGIPIWItmperlBeneficiary, forSplicing[i], "groupedItemNo beneficiaryNo perilCd");
				}					
				resizeTableBasedOnVisibleRows("benPerilTable", "benPerilListing");					
				checkTableIfEmpty("rowBenPeril", "benPerilTable");
				
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function() {						
						addDelObjByAttr(objGIPIWGrpItemsBeneficiary, delObj, "groupedItemNo beneficiaryNo");
						row.remove();
						
						setBBenForm(null);
						//checkIfToResizeTable("bBeneficiaryListing", "rowEnrolleeBen");
						resizeTableBasedOnVisibleRows("bBeneficiaryTable", "bBeneficiaryListing");
						//checkTableIfEmpty("rowEnrolleeBen", "bBeneficiaryTable");
					}
				});
			}
		});
	});

	function addBeneficiary() {	
		try	{
			var newObj = setEnrolleeBenificiaryObj();
			var content = prepareEnrolleeBenificiaryDisplay(newObj);
			var rowId = (("rowEnrolleeBen" + newObj.itemNo) + newObj.groupedItemNo) + newObj.beneficiaryNo;
			
			if($F("btnAddBeneficiary") == "Update"){
				$(rowId).update(content);
				addModifiedJSONObject(objGIPIWGrpItemsBeneficiary, newObj);
				fireEvent($(rowId), "click");
			}else{
				newObj.recordStatus = 0;
				objGIPIWGrpItemsBeneficiary.push(newObj);

				var table = $("bBeneficiaryListing");
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", rowId);
				newDiv.setAttribute("name", "rowEnrolleeBen");
				newDiv.setAttribute("parId", newObj.parId);
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItem", newObj.groupedItemNo);
				newDiv.setAttribute("benNo", newObj.beneficiaryNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				table.insert({bottom : newDiv});
				
				setEnrolleeBeneficiaryRowObserver(newDiv);						
				
				new Effect.Appear(rowId, {
						duration: 0.2
					});
			}
			($$("div#bBeneficiaryListing div:not([grpItem=" + newObj.groupedItemNo + "])")).invoke("hide");
			resizeTableBasedOnVisibleRows("bBeneficiaryTable", "bBeneficiaryListing");
			checkTableIfEmpty("rowEnrolleeBen", "bBeneficiaryTable");	
			
			setBBenForm(null);
			($$("div#beneficiaryInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");			
		} catch (e)	{
			showErrorMessage("addBeneficiary", e);			
		}
	}	

	$("btnAddBeneficiary").observe("click", function() {
		//$("popBenDiv").hide();
		
		if(($$("div#accidentGroupedItemsTable .selectedRow")).length < 1){
			showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.ERROR);
			return false;
		}else{
			if ($F("bBeneficiaryName").empty()) {
				showMessageBox("Beneficiary name must be entered.", imgMessage.ERROR);
				return false;
			}

			var itemNo = $F("itemNo");
			var grpItemNo = parseInt($F("groupedItemNo"));
			var benNo = parseInt($F("bBeneficiaryNo"));		
			

			if($((("rowEnrolleeBen" + itemNo) + grpItemNo) + benNo) != null && $F("btnAddBeneficiaryPerils") == "Add"){
				showMessageBox("Record already exists!", imgMessage.ERROR);
				return false;
			}
			
			addBeneficiary();
		}		
	});
	/* beneficiary ends */
	
	/* beneficiary perils */
	$("btnAddBeneficiaryPerils").observe("click", function() {
		$("popBenDiv").hide();
		
		if(($$("div#bBeneficiaryTable .selectedRow")).length < 1){
			showMessageBox("Please select a Beneficiary Item first.", imgMessage.ERROR);
			return false;
		}else{
			if ($F("bpPerilCd") == "") {
				showMessageBox("Peril Name must be entered.", imgMessage.ERROR);
				return false;
			}
			
			addBeneficiaryPeril();
		}		
	});
	
	function setBeneficiaryPerilObj(){
		try{
			var newObj = new Object();
			
			newObj.parId			= objUWParList.parId;
			newObj.itemNo			= $F("itemNo");
			newObj.groupedItemNo	= removeLeadingZero($F("groupedItemNo"));
			newObj.beneficiaryNo	= $F("bBeneficiaryNo");
			newObj.lineCd			= objUWParList.lineCd;
			newObj.perilCd			= $F("bpPerilCd");
			newObj.recFlag			= ($F("bpRecFlag").empty() ? "C" : $F("bpRecFlag"));
			newObj.premRt			= $F("bpPremAmt");
			newObj.tsiAmt			= $F("bpTsiAmt");
			newObj.premAmt			= $F("bpPremAmt");
			newObj.annTsiAmt		= $F("bpAnnTsiAmt");
			newObj.annPremAmt		= $F("bpAnnPremAmt");
			newObj.perilName 		= changeSingleAndDoubleQuotes2($("bpPerilCd").options[$("bpPerilCd").selectedIndex].text);
			
			return newObj;
		}catch(e){
			showErrorMessage("setBeneficiaryPerilObj", e);
		}
	}

	function prepareBenPerilDisplay(obj){
		try{
			var perilName 	= obj == null ? "---" : unescapeHTML2(obj.perilName);
			var tsiAmt 		= obj == null ? "---" : obj.tsiAmt == null ? "---" : formatCurrency(obj.tsiAmt);

			var content = 
				'<label style="text-align: left; width: 300px; margin-right: 10px; margin-left: 5px;">' + perilName.truncate(20, "...") + '</label>'+
				'<label style="text-align: right; width: 300px;">' + tsiAmt.truncate(20, "...") + '</label>';
				
			return content;
		}catch(e){
			showErrorMessage("prepareBenPerilDisplay", e);
		}
	}

	function setBenPerilForm(obj){
		try{
			$("bpPerilCd").value 	= obj == null ? "" : obj.perilCd;	
			$("bpTsiAmt").value 	= obj == null ? "" : obj.tsiAmt == null ? "" : formatCurrency(obj.tsiAmt);

			if(obj == null){
				$("bpPerilCd").enable();
				$("btnAddBeneficiaryPerils").value = "Add";
				disableButton($("btnDeleteBeneficiaryPerils"));
			}else{
				$("bpPerilCd").disable();
				$("btnAddBeneficiaryPerils").value = "Update";
				enableButton($("btnDeleteBeneficiaryPerils"));
			}
		}catch(e){
			showErrorMessage("setBenPerilForm", e);
		}
	}

	function setBenPerilRowObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){
					($$("div#benPerilTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");

					var objFilteredArr = objGIPIWItmperlBeneficiary.filter(function(obj){
											return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && 
													obj.groupedItemNo == row.getAttribute("grpItem") && obj.beneficiaryNo == row.getAttribute("benNo") &&
													obj.perilCd == row.getAttribute("perilCd");
										});

					for(var i=0, length=objFilteredArr.length; i < length; i++){						
						setBenPerilForm(objFilteredArr[i]);
						break;
					}					
				}else{
					setBenPerilForm(null);
				}
			});
		}catch(e){
			showErrorMessage("setRowObserver", e);
		}
	}

	function addBeneficiaryPeril(){
		try{
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			var newObj 	= setBeneficiaryPerilObj();
			var content = prepareBenPerilDisplay(newObj);
			var rowId 	= newObj.itemNo + "_" + newObj.groupedItemNo + "_" + newObj.beneficiaryNo + "_" + newObj.perilCd;
			var fk 		= newObj.itemNo + "_" + newObj.groupedItemNo + "_" + newObj.beneficiaryNo;
			
			if($F("btnAddBeneficiaryPerils") == "Update"){
				$(rowId).update(content);
				addModifiedJSONObject(objGIPIWItmperlBeneficiary, newObj);
				fireEvent($("rowBenPeril"+rowId), "click");
			}else{
				newObj.recordStatus = 0;
				objGIPIWItmperlBeneficiary.push(newObj);

				var table = $("benPerilListing");
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowBenPeril"+rowId);
				newDiv.setAttribute("name", "rowBenPeril");
				newDiv.setAttribute("fk", fk);
				newDiv.setAttribute("parId", newObj.parId);
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItem", newObj.groupedItemNo);
				newDiv.setAttribute("benNo", newObj.beneficiaryNo);
				newDiv.setAttribute("perilCd", newObj.perilCd);			
				newDiv.addClassName("tableRow");
		
				newDiv.update(content);

				setBenPerilRowObserver(newDiv);

				table.insert({bottom : newDiv});
				
				filterLOV3("bpPerilCd", "rowBenPeril", "perilCd", "benNo", newObj.beneficiaryNo);											
				
				new Effect.Appear("rowBenPeril"+rowId, {
						duration: 0.2
					});
			}
			($$("div#benPerilListing div:not([grpItem=" + newObj.groupedItemNo + "])")).invoke("hide");
			resizeTableBasedOnVisibleRows("benPerilTable", "benPerilListing");
			checkTableIfEmpty("rowBenPeril", "benPerilTable");
			
			setBenPerilForm(null);			
		}catch(e){
			showErrorMessage("addBeneficiaryPeril", e);
		}
	}

	$("btnDeleteBeneficiaryPerils").observe("click", function() {
		$("popBenDiv").hide();
		deleteBenPeril();		
	});

	function deleteBenPeril(){
		try{			
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}

			if(($$("div#benPerilTable .selectedRow")).length > 0){
				var deleteDiv = ($$("div#benPerilTable .selectedRow"))[0];

				Effect.Fade(deleteDiv, {
					duration : .2,
					afterFinish : function(){
						var delObj = setBeneficiaryPerilObj();
						filterLOV3("bpPerilCd", "rowBenPeril", "perilCd", "benNo", delObj.beneficiaryNo);
						addDelObjByAttr(objGIPIWItmperlBeneficiary, delObj, "groupedItemNo beneficiaryNo perilCd");
						deleteDiv.remove();
						setBenPerilForm(null);
						resizeTableBasedOnVisibleRows("benPerilTable", "benPerilListing");					
						//checkTableIfEmpty("rowBenPeril", "benPerilTable");
					}
				});
			}else{
				showMessageBox("Please select peril record to delete.", imgMessage.INFO);
			}
		}catch(e){
			showErrorMessage("deleteBenPeril", e);
		}		
	}
	
	function showBeneficiaryPeril(){
		try{
			for(var i=0, length=objGIPIWItmperlBeneficiary.length; i < length; i++){
				var content = prepareBenPerilDisplay(objGIPIWItmperlBeneficiary[i]);
				var row = new Element("div");
				var rowId = objGIPIWItmperlBeneficiary[i].itemNo + "_" + objGIPIWItmperlBeneficiary[i].groupedItemNo + "_" + objGIPIWItmperlBeneficiary[i].beneficiaryNo + "_" + objGIPIWItmperlBeneficiary[i].perilCd;
				var fk = objGIPIWItmperlBeneficiary[i].itemNo + "_" + objGIPIWItmperlBeneficiary[i].groupedItemNo + "_" + objGIPIWItmperlBeneficiary[i].beneficiaryNo;

				row.setAttribute("id", "rowBenPeril"+rowId);
				row.setAttribute("name", "rowBenPeril");
				row.setAttribute("fk", fk);
				row.setAttribute("parId", objGIPIWItmperlBeneficiary[i].parId);
				row.setAttribute("item", objGIPIWItmperlBeneficiary[i].itemNo);
				row.setAttribute("grpItem", objGIPIWItmperlBeneficiary[i].groupedItemNo);
				row.setAttribute("benNo", objGIPIWItmperlBeneficiary[i].beneficiaryNo);
				row.setAttribute("perilCd", objGIPIWItmperlBeneficiary[i].perilCd);
				row.setStyle("display : none");	
				row.addClassName("tableRow");

				row.update(content);

				setBenPerilRowObserver(row);

				$("benPerilListing").insert({bottom : row});

				filterLOV3("bpPerilCd", "rowBenPeril", "perilCd", "benNo", objGIPIWItmperlBeneficiary[i].beneficiaryNo);			
			}

			resizeTableBasedOnVisibleRows("benPerilTable", "benPerilListing");
			//checkIfToResizeTable("benPerilListing", "rowBenPeril");
			//checkTableIfEmpty("rowBenPeril", "benPerilListing");
			setBenPerilForm(null);
		}catch(e){
			showErrorMessage("showBeneficiaryPeril", e);
		}
	}
	/* end beneficiary peril */

	showEnrolleeBeneficiary(objGIPIWGrpItemsBeneficiary);
	showBeneficiaryPeril();
</script>