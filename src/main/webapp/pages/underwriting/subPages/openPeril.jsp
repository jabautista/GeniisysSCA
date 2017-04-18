<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="float: left; width: 90%;">
	<div id="openPerilDiv" name="perilDiv" style="width: 97%; margin: 10px;">
		<div class="tableHeader" id="perilTable" name="perilTable">
			<label class="sortable" index="1" type="string" id="lblPerilName" name="lblPerilName" style="width: 200px; text-align: left; margin-left: 5px;">Peril</label>
			<label class="sortable" index="2" type="number" id="lblPremiumRate" name="lblPremiumRate" style="width: 120px; text-align: right; margin-right: 15px;">Premium Rate</label>
			<label class="sortable" index="3" type="date" id="lblRemarks" name="lblRemarks" style="width: 450px; text-align: left;">Remarks</label>
		</div>
		<div id="perilForDeleteDiv" name="perilForDeleteDiv" style="visibility: hidden;">
		</div>
		<div id="perilForInsertDiv" name="perilForInsertDiv" style="visibility: hidden;">
		</div>
		<div class="tableContainer" id="openPerilList" name="openPerilList">
			<input type="hidden" id="perilRateTotal" name="perilRateTotal" value="" />
			<c:forEach var="operil" items="${openLiab.openPerils}">
				<div id="operil${operil.perilCd}" name="rowPeril" class="tableRow">
					<input type="hidden" id="perilCd${operil.perilCd}"   	name="perilCd"     	value="${operil.perilCd}" />
					<input type="hidden" id="perilName${operil.perilCd}" 	name="perilName" 	value="${fn:replace(operil.perilName,'"','&quot;')}"/>
					<input type="hidden" id="premiumRate${operil.perilCd}"  name="premiumRate"	value="${operil.premiumRate}" />
					<input type="hidden" id="remarks${operil.perilCd}" 		name="remarks" 		value="${fn:replace(operil.remarks,'"','&quot;')}" />
					<input type="hidden" id="perilType${operil.perilCd}"	name="perilType" 	value="${operil.perilType}" />
					<input type="hidden" id="basicPerilCd${operil.perilCd}"	name="basicPerilCd" value="${operil.basicPerilCd}" />
					
					<label style="width: 200px; text-align: left; margin-left: 5px;" title="${operil.perilName}" name="perilName" id="perilName${operil.perilCd}">${operil.perilName}</label>
					<label style="width: 120px; text-align: right; margin-right: 15px;" id="premiumRate${operil.perilCd}" name="premiumRate">${operil.premiumRate}</label>
					<label style="width: 350px; text-align: left;" name="perilRemarksDisp" title="${operil.remarks}">${operil.remarks}</label>
			 	</div>
			</c:forEach>
		</div>
	</div>
	<div id="perilFormDiv" name="perilFormDiv" style="width: 100%; margin: 10px 10px 5px 10px;">
		<table width="47%">
			<tr>
				<td class="rightAligned" width="22%">Peril</td>
				<td class="leftAligned" width="78%">
					<span class="required lovSpan" style="width: 100%;">
						<input id="txtPerilName" name="txtPerilName" class="required" type="text" style="border: none; float: left; width: 265px; height: 13px; margin: 0px;" readonly="readonly" tabindex="403">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOpenPeril" name="searchOpenPeril" alt="Go" style="float: right;" tabindex="404"/>
					</span>
					<select id="inputOpenPeril" name="inputOpenPeril" style="width: 100%;" class="required" hidden="hidden">
						<option value=""></option>
						<optgroup label="Basic">
							<c:forEach var="peril" items="${perils}">
								<c:if test="${'B' eq peril.perilType}">
									<option value="${peril.perilCd}" perilType="${peril.perilType}" basicPerilCd="${peril.bascPerlCd}" perilName="${peril.perilName}">${peril.perilSname} - ${peril.perilName}</option>
								</c:if>							
							</c:forEach>														
						</optgroup>
						<optgroup label="Allied">
							<c:forEach var="peril" items="${perils}">
								<c:if test="${'A' eq peril.perilType}">
									<option value="${peril.perilCd}" perilType="${peril.perilType}" basicPerilCd="${peril.bascPerlCd}" perilName="${peril.perilName}">${peril.perilSname} - ${peril.perilName}</option>
								</c:if>
							</c:forEach>
						</optgroup>						
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Premium Rate</td>
				<td class="leftAligned"><input type="text" id="inputPremiumRate" name="inputPremiumRate" style="width: 97.5%; text-align: right;" maxlength="13" lastValidValue=""/></td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 99.5%;">
						<textarea id="inputOpenPerilRemarks" name="inputOpenPerilRemarks" style="width: 91%; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editOpenPerilText" />
					</div>
				</td>
			</tr>				
		</table>
	</div>
</div>
<div style="margin: 10px 10px 10px 0px; float: left; border: 1px solid #E0E0E0; width: 77px; display: block;" align="center">
	<table align="center" width="20px" style="margin: 5px 0px 5px 0px">
		<tr>
			<td width="90%" align="center" style="font-size: 11px;"><input type="checkbox" id="withInvoice" name="withInvoice" disabled="disabled" style="background-color: green;"><br/>With Invoice</td>
		</tr>
	</table>
</div>
<div style="float: left; width: 100%; margin-bottom: 10px;" align="center" >
	<input type="button" class="button" style="width: 60px;" id="btnAddOpenPeril" name="btnAddOpenPeril" value="Add" />
	<input type="button" class="disabledButton" style="width: 60px;" id="btnDeleteOpenPeril" name="btnDeleteOpenPeril" value="Delete" disabled="disabled" />
</div>
<script type="text/javascript" defer="defer">
/*	var sortMode 	= 0; // 0=Ascending : 1=Descending
	var columnIndex = 0;
	var list 		= null;
	var rowArray 	= new Array();
/*	
	function Peril(perilRow){
		this.Row = perilRow;
	}

	function sortString(a, b){
	    var x = a.Row.down("input", columnIndex).value.toLowerCase();
	    var y = b.Row.down("input", columnIndex).value.toLowerCase();
	    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
	}

	function sortNumber(a, b){
		return (parseFloat(a.Row.down("input", columnIndex).value) - parseFloat(b.Row.down("input", columnIndex).value));
	}

	function sortDate(a, b){
		var x = Date.parse(a.Row.down("input", columnIndex).value);
	    var y = Date.parse(b.Row.down("input", columnIndex).value);
	    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
	}
	
	function sortList(list, sortMode, type){
		if(sortMode == 1){
			rowArray.reverse();
		} else {
			rowArray.sort((type == "string" ? sortString : (type == "number" ? sortNumber : (type == "date" ? sortDate : null))));
		} 

		list.update("");
		for(var i=0; i<rowArray.length;i++){
			list.insert({bottom : rowArray[i].Row});
		}
	}

	$$("label[class='sortable']").each(function(col){
		var sortMode = null;
		col.observe("click", function() {
			var img  = col.down("img", 0);
			var type = col.getAttribute("type");
			
			if (col.hasClassName("sortedAsc") && parseInt(col.getAttribute("index")) == columnIndex){
				img.setAttribute("src", "${pageContext.request.contextPath}/images/menu/right.gif");
				col.removeClassName("sortedAsc");
				col.addClassName("sortedDesc");
				sortMode = 1;
			} else {
				img.setAttribute("src", "${pageContext.request.contextPath}/images/menu/down.gif");
				col.removeClassName("sortedDesc");
				col.addClassName("sortedAsc");
				sortMode = 0;
			}

			columnIndex = parseInt(col.getAttribute("index"));
						
			if (list == col.up("div").next("div[class='tableContainer']")){
				var colArr = list.previous("div", 0).getElementsByTagName("label");
				
				for(var i = 0; i < colArr.length; i++){
					if (parseInt(colArr[i].getAttribute("index")) != columnIndex){
						var img2 = colArr[i].down("img", 0);
						img2.setAttribute("src", "");
					}
				}	
			} 

			list = col.up("div").next("div[class='tableContainer']");
			sortList(list, sortMode, type);
		});
	});
	*/	
	var perilCd     = null;
	var perilName   = null;
	var premiumRate = null;
	var remarks	    = null;
	var checkPremRate = false;
	var selectedPremRate = 0;
	//hideAddedPeril();
	truncateDisp();
	
	//setOpenPerilForm(null);
	populateInputOpenTextFields(null);
	initializeTable("tableContainer", "rowPeril", "", "");
	checkIfToResizeTable("openPerilList", "rowPeril");
	checkTableIfEmpty("rowPeril", "openPerilDiv");
	$("perilRateTotal").value = getTotalPremiumRate();
	
	//$("btnAddOpenPeril").observe("click", checkOpenPeril);
	$("btnAddOpenPeril").observe("click", checkOpenPeril2);
	$("btnDeleteOpenPeril").observe("click", deleteOpenPeril);

	$$("div[name='rowPeril']").each(function(rowPeril){	
		//rowArray[rowArray.length++] = new Peril(rowPeril); 
		rowPeril.observe("click", function(){
			if (rowPeril.hasClassName("selectedRow"))	{
				//setOpenPerilForm(rowPeril);
				populateInputOpenTextFields(rowPeril);
			} else {
				//setOpenPerilForm(null);
				populateInputOpenTextFields(null);
			} 
		});
		
		var tempPremRate = rowPeril.down("label", 1).innerHTML;		
		rowPeril.down("label", 1).update(tempPremRate.trim() == "" ? "&nbsp;" : formatToNineDecimal(tempPremRate));
		rowPeril.down("label", 2).update(rowPeril.down("label", 2).innerHTML.truncate(60, "..."));		
	});
	
	function populateInputOpenTextFields(row){
		$("txtPerilName").value = (row == null ? "" : row.down("input", 1).value);
		$("inputPremiumRate").value = (row == null ? "" : (isNaN(row.down("input", 2).value) ? "" : formatToNineDecimal(row.down("input", 2).value)));
		$("inputPremiumRate").setAttribute("lastValidValue", (row == null ? "" : (isNaN(row.down("input", 2).value) ? "" : row.down("input", 2).value)));
		$("inputOpenPerilRemarks").value = (row == null ? "" : row.down("input", 3).value);
		
		perilCd = (row == null ? "" : row.down("input", 0).value);
		perilName = (row == null ? "" : row.down("input", 1).value);
		perilType = (row == null ? "" : row.down("input", 4).value);
		basicPerilCd = (row == null ? "" : row.down("input", 5).value);
		premiumRate = (row == null ? "" : (isNaN(parseFloat(row.down("input", 2).value)) ? "" : formatToNineDecimal(row.down("input", 2).value)));
		remarks = (row == null ? "" : row.down("input", 3).value);
		
		$("btnAddOpenPeril").value = (row == null ? "Add" : "Update");
		row == null ? enableSearch("searchOpenPeril") : disableSearch("searchOpenPeril");
		row == null ? disableButton("btnDeleteOpenPeril") : enableButton("btnDeleteOpenPeril");
		
		selectedPremRate = (row == null ? 0 : parseFloat($("inputPremiumRate").value));
	}
	
	$("inputPremiumRate").observe("change", function(){
		if (!isNaN(parseFloat($F("inputPremiumRate"))) && $F("inputPremiumRate") != ""){
			if(parseFloat($F("inputPremiumRate")) > 100){
				showWaitingMessageBox("Invalid Premium Rate. Valid value should be from 0.000000001 to 100.000000000.", "I", function(){
					$("inputPremiumRate").value = ($("inputPremiumRate").readAttribute("lastValidValue").trim() == "" ? "" : formatToNineDecimal($("inputPremiumRate").readAttribute("lastValidValue")));
					$("inputPremiumRate").focus();
				});
			} else {
				$("inputPremiumRate").setAttribute("lastValidValue", $F("inputPremiumRate"));
				$("inputPremiumRate").value = formatToNineDecimal($F("inputPremiumRate"));	
			}
		}
	});

	$("inputPremiumRate").observe("keyup", function(){
		if(isNaN($F("inputPremiumRate"))){
			$("inputPremiumRate").value = ($("inputPremiumRate").readAttribute("lastValidValue").trim() == "" ? "" : formatToNineDecimal($("inputPremiumRate").readAttribute("lastValidValue")));
		}
	});
	
	if ($F("withInvoiceTag") == 'Y'){
		$("withInvoice").checked = true;
	}

	if ($$("div[name='rowPeril']").size() == 0){
		$("openPerilList").setStyle("height: 0px;");
	}

	function truncateDisp() {
		$$("label[name='perilRemarksDisp']").each(function (label) {
			if((label.innerHTML).length > 60) {
				label.update((label.innerHTML).truncate(60, "..."));
			}
		});
	}
	
	//testing
	function setVariables(){
		var index	= $("inputOpenPeril").selectedIndex;
		perilCd     = $F("inputOpenPeril");
		perilName   = $("inputOpenPeril").options[index].getAttribute("perilName");//$("inputOpenPeril").options[index].text;
		premiumRate = $F("inputPremiumRate");
		//remarks	    = $F("inputOpenPerilRemarks");
		remarks 	= changeSingleAndDoubleQuotes($F("inputOpenPerilRemarks")).escapeHTML();
		//remarks = changeSingleAndDoubleQuotes($F("inputRemarks")).escapeHTML();
		perilType	= $("inputOpenPeril").options[index].getAttribute("perilType");
		basicPerilCd= $("inputOpenPeril").options[index].getAttribute("basicPerilCd");
	}
	
	function checkOpenPeril(){		
		setVariables();
		var exists = false;
		$$("input[name='perilCd']").each(function (c){
			if (c.value == perilCd){
				exists = true;
			}
		});
		//var tempPremRate = getTotalPremiumRate() + parseFloat(!$F("inputPremiumRate").blank() || !isNaN($F("inputPremiumRate")) ? $F("inputPremiumRate") : 0);
		var tempPremRate = 0;
		if(!(isNaN(parseFloat($F("inputPremiumRate"))))){
			tempPremRate = parseFloat($F("inputPremiumRate"));
		}
		tempPremRate += getTotalPremiumRate();
		$("perilRateTotal").value = tempPremRate;
		if($F("btnAddOpenPeril") == "Update" &&
			!isNaN(selectedPremRate) && !(selectedPremRate == null)){
			tempPremRate = tempPremRate - selectedPremRate;
		} 
		
		if (perilCd == "") {
			showMessageBox("Peril is required.");
			$("inputOpenPeril").focus();
			return false;
		} else if (exists == true && $F("btnAddOpenPeril") != "Update"){
			showMessageBox("Peril already exists in the list.");
			$("inputOpenPeril").focus();
			return false;
		} else if( (isNaN(parseFloat($F("inputPremiumRate"))) && $F("inputPremiumRate") != "") ||
					parseFloat($F("inputPremiumRate").replace(/,/g, "")) <= 0 || 
					parseFloat($F("inputPremiumRate").replace(/,/g, "")) > 100){
			showMessageBox("Invalid Premium Rate. Value should be from 0.000000001 to 100.000000000");
			$("inputPremiumRate").value = "";
			$("inputPremiumRate").focus();
			return false;			
/*		} else if (parseFloat(premiumRate) == 0){
			showMessageBox("Premium rate must not be 0.");
			$("inputPremiumRate").value = "";
			$("inputPremiumRate").focus();
			return false;*/
		} else if (tempPremRate > 100){
			showMessageBox("Total premium rate must not be greater than 100.");
			$("inputPremiumRate").value = "";
			$("inputPremiumRate").focus();
			return false;
		} else if (!validateAllied()){
			return false;
		} else {
			addOpenPeril();
		}
		
/*
		new Ajax.Request("GIPIWOpenPerilController", {
			action: "GET",
			parameters: {action:  	   "checkWOpenPeril",
						 globalParId:  $F("globalParId"),
						 globalLineCd: $F("globalLineCd"),
						 geogCd: 	   $F("geogCd"),
						 perilCd: 	   perilCd},
			onComplete: function(response) {
				if(response.responseText == "SUCCESS"){
					addOpenPeril();
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});*/
	}
	
	function checkOpenPeril2(){		
		premiumRate = $F("inputPremiumRate");
		remarks = changeSingleAndDoubleQuotes($F("inputOpenPerilRemarks")).escapeHTML();
		
		var exists = false;
		$$("input[name='perilCd']").each(function (c){
			if (c.value == perilCd){
				exists = true;
			}
		});
		var tempPremRate = 0;
		if(!(isNaN(parseFloat($F("inputPremiumRate"))))){
			tempPremRate = parseFloat($F("inputPremiumRate"));
		}
		tempPremRate += getTotalPremiumRate();
		$("perilRateTotal").value = tempPremRate;
		if($F("btnAddOpenPeril") == "Update" &&
			!isNaN(selectedPremRate) && !(selectedPremRate == null)){
			tempPremRate = tempPremRate - selectedPremRate;
		} 
		if (perilCd == "") {
			showMessageBox("Peril is required.");
			$("txtPerilName").focus();
			return false;
		} else if (exists == true && $F("btnAddOpenPeril") != "Update"){
			showMessageBox("Peril already exists in the list.");
			$("txtPerilName").focus();
			return false;
		} else if( (isNaN(parseFloat($F("inputPremiumRate"))) && $F("inputPremiumRate") != "") ||
					parseFloat($F("inputPremiumRate").replace(/,/g, "")) <= 0 || 
					parseFloat($F("inputPremiumRate").replace(/,/g, "")) > 100){
			showMessageBox("Invalid Premium Rate. Value should be from 0.000000001 to 100.000000000");
			$("inputPremiumRate").value = "";
			$("inputPremiumRate").focus();
			return false;			
		} else if (tempPremRate > 100){
			showMessageBox("Total premium rate must not be greater than 100.");
			$("inputPremiumRate").value = "";
			$("inputPremiumRate").focus();
			return false;
		} else if (!validateAllied2()){
			return false;
		} else {
			addOpenPeril();
		}
	}

	function addOpenPeril(){
		var openPerilDiv  = $("openPerilList");
		var perilForInsertDiv = $("perilForInsertDiv");
		var insertContent  = '<input type="hidden" id="insPerilCd'+perilCd+'" 	   name="insPerilCd"  		value="'+perilCd+'" />'+
							 '<input type="hidden" id="insPerilName'+perilCd+'"    name="insPerilName" 		value="'+perilName+'" />'+
							 '<input type="hidden" id="insPremiumRate'+perilCd+'"  name="insPremiumRate"	value="'+premiumRate+'" />'+
							 '<input type="hidden" id="insRemarks'+perilCd+'" 	   name="insRemarks" 		value="'+remarks.replace(/"/g, "&quot;")+'" />';
							 
		var content	   = '<input type="hidden" id="perilCd'+perilCd+'"   	name="perilCd"     	value="'+perilCd+'" />'+
						 '<input type="hidden" id="perilName'+perilCd+'" 	name="perilName" 	value="'+perilName.replace(/"/g, "&quot;")+'" />'+
						 '<input type="hidden" id="premiumRate'+perilCd+'"  name="premiumRate"	value="'+premiumRate+'" />'+
						 '<input type="hidden" id="remarks'+perilCd+'" 		name="remarks" 		title="'+changeSingleAndDoubleQuotes2(fixTildeProblem(remarks))+'" value="'+changeSingleAndDoubleQuotes2(fixTildeProblem(remarks))+'" />'+
						 '<input type="hidden" id="perilType'+perilCd+'"	name="perilType" 	value="'+perilType+'" />'+
						 '<input type="hidden" id="basicPerilCd'+perilCd+'"	name="basicPerilCd" value="'+basicPerilCd+'" />'+
						 '<label style="width: 200px; text-align: left; margin-left: 5px;" title="'+perilName+'" name="perilName" id="perilName'+perilCd+'">'+perilName+'</label>'+
						 '<label style="width: 120px; text-align: right; margin-right: 15px;" id="premiumRate'+perilCd+'" name="premiumRate">'+(trim(premiumRate) == "" ? "&nbsp;" : formatToNineDecimal(premiumRate))+'</label>'+
						 '<label style="width: 350px; text-align: left;" name="perilRemarksDisp" title="'+remarks+'">'+remarks.truncate(60, "...")+'</label>';
		
		if($F("btnAddOpenPeril") == "Update"){
			var updatePerilCd = "";
			$$("div[name='rowPeril']").each(function(row){
				if(row.hasClassName("selectedRow")){
					updatePerilCd = row.down("input", 0).value;
				}
			});
			$("operil"+updatePerilCd).update(content);			
			//$("operil"+perilCd).update(content);
			//deselectRows("tableContainer","operil"+perilCd);
			$("operil"+updatePerilCd).removeClassName("selectedRow");
			$$("div[name='rowPeril']").each(function(x){x.removeClassName("selectedRow");});
		} else {				
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "operil"+perilCd);
			newDiv.setAttribute("name", "rowPeril");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			newDiv.update(content);
	
			openPerilDiv.insert({bottom : newDiv});
			//rowArray[rowArray.length++] = new Peril(newDiv);
			
			newDiv.observe("mouseover", function ()	{
				newDiv.addClassName("lightblue");
			});
			
			newDiv.observe("mouseout", function ()	{
				newDiv.removeClassName("lightblue");
			});
	
			newDiv.observe("click", function(){
				
				/* Apollo 5.16.2014
				to unselect other rows */
				$$("div[name='rowPeril']").each(function(x){
					if(x.readAttribute("id") != newDiv.readAttribute("id"))
						x.removeClassName("selectedRow");
				});
				
				newDiv.toggleClassName("selectedRow");
				if (newDiv.hasClassName("selectedRow"))	{
					//setOpenPerilForm(newDiv);
					populateInputOpenTextFields(newDiv);
				} else {
					//setOpenPerilForm(null);
					populateInputOpenTextFields(null);
				} 
				
				$$("div[name='rowPeril']").each(function(row){
					if(row.id != newDiv.id){
						row.removeClassName("selectedRow");
					}
				});
			});
			
			Effect.Appear(newDiv, {
				duration: .5
			});

			checkIfToResizeTable("openPerilList", "rowPeril");
			checkTableIfEmpty("rowPeril", "openPerilDiv");			
		}
		//hideAddedPeril();
		//setOpenPerilForm(null);
		populateInputOpenTextFields(null);
		perilForInsertDiv.insert({bottom : insertContent});
		truncateDisp();
		
		if (0 < getTotalPremiumRate()) {
			$("withInvoiceTag").value = "Y";
		} else {
			$("withInvoiceTag").value = "N";
		}
		changeTag = 1;
		changeTagFunc = objLimitsOfLiability.saveLimitOfLiability;		
	}

	function ifHasAllied(){
		try {
			var result = true;
			$$("div[name='rowPeril']").each(function(row){
				if (row.hasClassName("selectedRow")) {
					var tempPerilType = row.down("input", 4).value;
					var tempPerilCd   = row.down("input", 0).value;
					var alliedPerilName = null;
					var basicAlliedPerilName = null;
					
					if (tempPerilType == "B"){
						$$("div[name='rowPeril']").each(function(r) { // to check if there is an existing allied for the basic peril
							if(tempPerilCd != r.down("input", 0).value 
									&& tempPerilCd == r.down("input", 5).value) {
								basicAlliedPerilName = r.down("input", 1).value;
							}
						
							if(tempPerilCd != r.down("input", 0).value 
									&& "A" == r.down("input", 4).value
									&& ("" == r.down("input", 5).value||"null" == r.down("input", 5).value)) {
								alliedPerilName = r.down("input", 1).value;
							}
						});			
						
						if (basicAlliedPerilName != null) {
							showMessageBox("Cannot delete this record while its subsequent ally (" + basicAlliedPerilName + ") exists.");
							result = false;
						} else if(alliedPerilName != null){
							var basicPerilsCount = 0;
							
							$$("div[name='rowPeril']").each(function(r) {
								if("B" == r.down("input", 4).value 
										&& tempPerilCd != r.down("input", 0).value) {
									basicPerilsCount++;
								}
							});

							if(basicPerilsCount == 0){
								showMessageBox("Cannot delete this record while its subsequent ally (" + alliedPerilName + ") exists.");
								result = false;
							}
						}
					} 
				}
			});
			
			return result;			
		} catch (e) {
			showErrorMessage("ifHasAllied", e);
		}
	}	
	
	function deleteOpenPeril(){
		$("btnDeleteOpenPeril").disable();
		$$("div[name='rowPeril']").each(function(row){
			if (row.hasClassName("selectedRow")) {
				
				
				if(!ifHasAllied()) {
					return false;
				}
				
				var perilCd   = row.down("input", 0).value;
				var perilForDeleteDiv = $("perilForDeleteDiv");
				var deleteContent  = '<input type="hidden" id="delPerilCd'+ perilCd +'"	name="delPerilCd" value="'+ perilCd +'" />';
						
				perilForDeleteDiv.insert({bottom : deleteContent});

				$$("input[name='insPerilCd']").each(function(input){
					var id = input.getAttribute("id");
					if(id == "insPerilCd"+perilCd){
						input.remove();
					}
				});
				
				Effect.Fade(row, {
					duration: .5,
					afterFinish: function () {
						row.remove();
						//setOpenPerilForm(null);
						populateInputOpenTextFields(null);
						checkIfToResizeTable("openPerilList", "rowPeril");
						checkTableIfEmpty("rowPeril", "openPerilDiv");
						//showDeletedPeril(row);
						if (0 < getTotalPremiumRate()) {
							$("withInvoiceTag").value = "Y";
						} else {
							$("withInvoiceTag").value = "N";
						}
					}
				});
			}
		});
		$("btnDeleteOpenPeril").enable();
		changeTag = 1;
		changeTagFunc = objLimitsOfLiability.saveLimitOfLiability;
	}

	function setOpenPerilForm(row){
		if(row == null){
			$("inputOpenPeril").selectedIndex = 0;	
		} else {
			var s = $("inputOpenPeril");
			for (var i=0; i < s.length; i++)	{
				if (s.options[i].value == row.down("input", 0).value)	{
					s.selectedIndex = i;
				}
			}
		}
		
		$("inputPremiumRate").value = (row == null ? "" : (isNaN(parseFloat(row.down("input", 2).value)) ? "" : formatToNineDecimal(row.down("input", 2).value)));		
		$("inputOpenPerilRemarks").value 	= (row == null ? "" : row.down("input", 3).value);
		$("btnAddOpenPeril").value  = (row == null ? "Add" : "Update");
		selectedPremRate = (row == null ? 0 : parseFloat($("inputPremiumRate").value));
		
		(row == null ? $("inputOpenPeril").enable() : $("inputOpenPeril").disable());
		(row == null ? disableButton("btnDeleteOpenPeril") : enableButton("btnDeleteOpenPeril"));
	}

	function getTotalPremiumRate(){
		var total = 0;
		
		$$("div[name='rowPeril']").each(function(rowPeril){
			if(rowPeril.hasClassName("tableRow")){
				if (!isNaN(rowPeril.down("input", 2).value) && !rowPeril.down("input", 2).value.blank()){
					total += parseFloat(rowPeril.down("input", 2).value);
				} else if(rowPeril.down("input", 2).value.blank()) {
					total += 0;
				}
			}
		});	
		return total;
	}	
	
	function validateAllied(){
		try {
			var index 			 = $("inputOpenPeril").selectedIndex;
			var tempPerilType    = $("inputOpenPeril").options[index].getAttribute("perilType");
			var tempBasicPerilCd = $("inputOpenPeril").options[index].getAttribute("basicPerilCd");
	
			if (tempPerilType == "A"){
				if (tempBasicPerilCd != "" && tempBasicPerilCd != null) {
					var exist = false;
					var tempBasicPerilName 	= null;				
					var perils 				= $("inputOpenPeril");											
					
					$$("div[name='rowPeril']").each(function(row){
						if (row.down("input", 0).value == tempBasicPerilCd){
							exist = true;
							$break;
						} 
					});
	
					if (!exist){
						for (var k=0; k < perils.length; k++) {
							if (perils.options[k].value == tempBasicPerilCd) {
								tempBasicPerilName = perils.options[k].text;
							}
						}
						
						showMessageBox("Basic peril (" + tempBasicPerilName + ") should be added first before this peril.");
						return false;
					} 
				} else if ($$("div[name='rowPeril']").size() == 0) {
					showMessageBox("A basic peril should be added first before this allied peril.");	
					return false;
				} 
			}
			return true;
		} catch (e) {
			showErrorMessage("validateAllied", e);
		}
	}
	
	function validateAllied2(){
		try {
			if (perilType == "A"){
				if (basicPerilCd != "" && basicPerilCd != null) {
					var exist = false;
					var tempBasicPerilName = null;				
					var perils = $("inputOpenPeril");											
					
					$$("div[name='rowPeril']").each(function(row){
						if (row.down("input", 0).value == basicPerilCd){
							exist = true;
							$break;
						} 
					});
	
					if (!exist){
						for (var k=0; k < perils.length; k++) {
							if (perils.options[k].value == basicPerilCd) {
								tempBasicPerilName = perils.options[k].text;
							}
						}
						
						showMessageBox("Basic peril (" + tempBasicPerilName + ") should be added first before this peril.");
						return false;
					} 
				} else if ($$("div[name='rowPeril']").size() == 0) {
					showMessageBox("A basic peril should be added first before this allied peril.");	
					return false;
				} 
			}
			return true;
		} catch (e) {
			showErrorMessage("validateAllied2", e);
		}
	}

	function hideAddedPeril() {
		var perilOpt = $("inputOpenPeril").options;
		$$("div[name='rowPeril']").pluck("id").findAll(function(row) {
			for(var i=0; i<perilOpt.length; i++) {
				if(row.substring(6) == perilOpt[i].value) {
					perilOpt[i].hide();
					perilOpt[i].disabled = true;
				}
			}
		});
	}

	function showDeletedPeril(row) {
		var perilOpt = $("inputOpenPeril").options;
		for(var i=0; i<perilOpt.length; i++) {
			if(row.id.substring(6) == perilOpt[i].value) {
				perilOpt[i].show();
				perilOpt[i].disabled = false;
			}
		}
	}

	$("editOpenPerilText").observe("click", function () {
		//showEditor("inputOpenPerilRemarks", 4000); removed by jdiago 07.08.2014
		showOverlayEditor("inputOpenPerilRemarks", 4000, $("inputOpenPerilRemarks").hasAttribute("readonly")); // added by jdiago 07.08.2014
	});

	$("inputOpenPerilRemarks").observe("keyup", function () {
		limitText(this, 4000);
	});
	
	var perilType = "";
	var basicPerilCd = "";
	$("searchOpenPeril").observe("click", function(){
		try{
			var notIn = "";
			var withPrevious = false;
			
			$$("div[name='rowPeril']").each(function(r) {
				notIn += withPrevious ? "," : "";
				notIn += r.down("input", 0).value;
				withPrevious = true;
			});
			perilType = notIn == "" ? "B" : "";
		
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action 	      : "getWOpenPerilLOV",
								lineCd 	      : $F("globalLineCd"),
								sublineCd     : $F("globalSublineCd"),
								perilType	  : perilType,
								notIn		  : notIn != "" ? "("+notIn+")" : "0",
								page		  : 1
							    },
				title: "Valid values for Peril",
				width: 421,
				height: 386,
				columnModel:[
				             	{	id : "perilName",
									title: "Peril",
									width: '225px'
								},
								{	id : "perilSname",
									title: "Peril Short Name",
									width: '110px'
								},
								{	id : "perilType",
									title: "Peril Type",
									width: '65px'
								},
								{	id : "perilCd",
									width: '0px',
									visible: false
								},
								{	id : "bascPerlCd",
									width: '0px',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("txtPerilName").value = unescapeHTML2(row.perilName);
						perilCd = row.perilCd;
						perilName = row.perilName;
						perilType = row.perilType;
						basicPerilCd = row.bascPerlCd;
					}
				}
			});
		}catch(e){
			showErrorMessage("searchOpenPeril",e);
		}
	});
	
	changeTag=0;
	//initializeChangeTagBehavior();
</script>
