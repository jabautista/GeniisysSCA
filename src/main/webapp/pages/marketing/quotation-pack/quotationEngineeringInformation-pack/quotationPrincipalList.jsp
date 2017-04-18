<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% 	
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="principalMainDiv${pType}" name="principalMainDiv${pType}">
	<div id="enPrincipalsDiv${pType}" name="enPrincipalsDiv${pType}" style="margin: 10px; width: 430px;" align="center"  changeTagAttr="true">
		<div class="tableHeader" id="principalInfoTable" name="principalInfoTable">
			<label style="width: 140px; text-align: left; margin-left: 5px;">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor</c:when>
					<c:otherwise>Principal</c:otherwise>
				</c:choose>
			</label>
			<label style="width: 240px; text-align: left;">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor Name</c:when>
					<c:otherwise>Principal Name</c:otherwise>
				</c:choose>
			</label>
			<label style="width: 20px; text-align: center; margin-left: 5px;"><c:if test="${pType=='C'}">S</c:if></label>
		</div>
		<div id="enPrincipalTable${pType}" name="enPrincipalTable${pType}" class="tableContainer" style="margin-bottom: 10px;">
		</div>
	</div>
</div>	
<div id="enPrincipalFormDiv" name="enPrincipalFormDiv" style="width: 100%; margin: 10px 0px 5px 0px;" align="center">
	<table align="center" style="width: 420px;">
		<tr>
			<td class="rightAligned" width="20%">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor</c:when>
					<c:otherwise>Principal</c:otherwise>
				</c:choose>
			</td>
			<td class="leftAligned" width="80%">
				<input type="text" id="txtPrincipalDisplay${pType}" id="txtPrincipalDisplay${pType}" style="width: 98%;" readonly="readonly"/>
				<select id="inputPrincipal${pType}" name="inputPrincipal${pType}" style="width: 98%;"></select>
			</td>
		</tr>
		<c:if test="${pType=='C'}">
			<tr>
				<td class="rightAligned" width="20%">Subcon SW</td>
				<td class="leftAligned" width="80%">
					<input type="checkbox" id="chkSubconSw${pType}" name="chkSubconSw${pType}" value="N"/>
				</td>
			</tr>
		</c:if>
	</table>		
</div>

<div style="margin-bottom: 10px;" changeTagAttr="true">
	<input type="button" class="button" style="width: 60px;" id="btnAdd${pType}" name="btnAdd${pType}" value="Add" />
	<input type="button" class="button" style="width: 60px;" id="btnDel${pType}" name="btnDel${pType}" value="Delete" />
</div>

<script type="text/javascript">
	hideNotice();
	var princType = '${pType}';
	var objPrincLOV = JSON.parse('${principalList}'.replace(/\\/g, '\\\\')); 
	objQuotePrincipalList = JSON.parse('${objQuotePrincipalList}'.replace(/\\/g, '\\\\'));

	setQuotePrincipalListing(objQuotePrincipalList);
	setPrincipalLOV(objPrincLOV);
	
	$("btnAdd"+princType).observe("click", function(){
		if($("btnAdd"+princType).value == "Add" && checkBeforeAddingPrincipal()){
			var newObj =  makePrincipalObject();
			newObj.recordStatus = 0;
			objQuotePrincipalList.push(newObj);
			var newDiv = createPrincipalRow(newObj);
			$("enPrincipalTable"+princType).insert({bottom : newDiv});
			setPrincipalRowObserver(newDiv);
			populatePrincipalForm(null);
		}else if($("btnAdd"+princType).value == "Update"){
			var selectedRow = getSelectedRow("princRow"+princType);
			var updatedObj = makePrincipalObject();
			updatedObj.recordStatus = 1;
			for(var i=0; i<objQuotePrincipalList.length; i++){
				if(objQuotePrincipalList[i].quoteId == updatedObj.quoteId &&
				   objQuotePrincipalList[i].principalCd == updatedObj.principalCd){
				   objQuotePrincipalList.splice[i, 1];
				}
			}
			objQuotePrincipalList.push(updatedObj);
			var updatedRow = preparePrincipalRowContent(updatedObj);
			selectedRow.update(updatedRow);
			selectedRow.removeClassName("selectedRow");
			populatePrincipalForm(null);
		}
		filterPrincipalLOV();
		resizeTableBasedOnVisibleRows("enPrincipalsDiv"+princType, "enPrincipalTable"+princType);
	});

	$("btnDel"+princType).observe("click", function(){
		var selectedRow = getSelectedRow("princRow"+princType);
		for(var i=0; i<objQuotePrincipalList.length; i++){
			if(objQuotePrincipalList[i].quoteId == objCurrPackQuote.quoteId &&
			   objQuotePrincipalList[i].principalCd == selectedRow.getAttribute("principalCd")){
			   objQuotePrincipalList[i].recordStatus = -1;
			   selectedRow.removeClassName("selectedRow");
			   selectedRow.remove();
			   resizeTableBasedOnVisibleRows("enPrincipalsDiv"+princType, "enPrincipalTable"+princType);
			   filterPrincipalLOV();
			   populatePrincipalForm(null);
			   break;
			}
		}
	});

	function setPrincipalLOV(objPrincLOV){
		var selPrincipal = $("inputPrincipal" + princType);
		selPrincipal.update('<option value="" principalType="" principalCd="" principalName=""></option>');
		var princObj = null;
		for(var i=0; i<objPrincLOV.length; i++){
			princObj = objPrincLOV[i];
			var princOption = new Element("option");
			princOption.innerHTML = princObj.principalName;
			princOption.setAttribute("value", princObj.principalCd);
			princOption.setAttribute("principalCd", princObj.principalCd);
			princOption.setAttribute("principalName", princObj.principalName);
			princOption.setAttribute("principalType", princObj.principalType);
			selPrincipal.add(princOption, null);						
		}
	}

	function filterPrincipalLOV(){
		if(princType == "P"){
			(($$("select#inputPrincipalP option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
			for(var i=0; i<objQuotePrincipalList.length; i++){
				if(objQuotePrincipalList[i].quoteId == objCurrPackQuote.quoteId &&
				   objQuotePrincipalList[i].principalType == "P" &&
				   objQuotePrincipalList[i].recordStatus != -1){
					(($$("select#inputPrincipalP option[value='" + objQuotePrincipalList[i].principalCd + "']")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
				}
			}
		}else if(princType == "C"){
			(($$("select#inputPrincipalP option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
			for(var i=0; i<objQuotePrincipalList.length; i++){
				if(objQuotePrincipalList[i].quoteId == objCurrPackQuote.quoteId &&
				   objQuotePrincipalList[i].principalType == "C" &&
				   objQuotePrincipalList[i].recordStatus != -1){
					(($$("select#inputPrincipalC option[value='" + objQuotePrincipalList[i].principalCd + "']")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
				}
			}
		}
		$("inputPrincipal" + princType).options[0].show();
		$("inputPrincipal" + princType).options[0].disabled = false;
	}

	function checkIfPrincipalExist(principalCd){
		var exist = false;
		for(var i=0; i<objQuotePrincipalList.length; i++){
			if(objQuotePrincipalList[i].quoteId == objCurrPackQuote.quoteId &&
			   objQuotePrincipalList[i].principalCd == principalCd &&
			   objQuotePrincipalList[i].recordStatus != -1){
			   var exist = true;
			}
		}
		return exist;
	}

	function checkBeforeAddingPrincipal(){
		var principalCd = $F("inputPrincipal" + princType);
		if(principalCd == ""){
			showMessageBox("Select a principal first.", imgMessage.ERROR);
			return false;
		}else if(checkIfPrincipalExist(principalCd)){
			showMessageBox("Principal already exist.", imgMessage.ERROR);
			return false;
		}else{
			return true;
		}
	}

	function createPrincipalRow(princObj){
		var content = preparePrincipalRowContent(princObj);
		var princRow = new Element("div");
		princRow.setAttribute("id", "row"+princObj.quoteId+princObj.principalCd);
		princRow.setAttribute("name", "princRow"+princType);
		princRow.setAttribute("quoteId", princObj.quoteId);
		princRow.setAttribute("principalCd", princObj.principalCd);
		princRow.setAttribute("principalName", princObj.principalName);
		princRow.setAttribute("principalType", princObj.principalType);
		princRow.addClassName("tableRow");

		if(princType == "C"){
			princRow.setAttribute("subConSw", princObj.subconSw);
		}
		
		princRow.update(content);
		return princRow;
	}

	function preparePrincipalRowContent(princObj){
		var content = "";
		if(princType == "C"){
			content = '<label style="width: 140px; text-align: left; margin-left: 5px;">'+princObj.principalCd+'</label>'+
					  '<label style="width: 240px; text-align: left;">'+princObj.principalName+'</label>' +
					  '<label style="width: 20px; text-align: center; margin-left: 5px;">';
					  if (princObj.subconSw == 'Y') {
						 content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 8px;"/></label>';
					  }else{
						 content += '<span style="width: 45px; height: 10px; text-align: left; display: block; margin-left: 3px;"></span></label>';;
					  }
		}else{
			content = '<label style="width: 140px; text-align: left; margin-left: 5px;">'+princObj.principalCd+'</label>'+
			  		  '<label style="width: 240px; text-align: left;">'+princObj.principalName+'</label>';
		}
		return content;
	}

	function setPrincipalRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				if(princType == "P"){
					($$("div#enPrincipalTableP div:not([id='" +row.id+ "'])")).invoke("removeClassName", "selectedRow");
				}else{
					($$("div#enPrincipalTableC div:not([id='" +row.id+ "'])")).invoke("removeClassName", "selectedRow");
				}
				for(var i=0; i<objQuotePrincipalList.length; i++){
					if(objQuotePrincipalList[i].quoteId == row.getAttribute("quoteId") &&
					   objQuotePrincipalList[i].principalCd == row.getAttribute("principalCd") &&
					   objQuotePrincipalList[i].recordStatus != -1){
					   populatePrincipalForm(objQuotePrincipalList[i]);
					}
				}
			}else{
				populatePrincipalForm(null);
			}	
		});
	}

	function setQuotePrincipalListing(objArray){
		try {
			var quotePrincipalTable = $("enPrincipalTable"+princType);
			
			objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1 && obj.principalType == princType;});
			
			for(var i=0; i<objArray.length; i++) {			
				var newDiv = createPrincipalRow(objArray[i]);
				quotePrincipalTable.insert({bottom : newDiv});
				setPrincipalRowObserver(newDiv);
			}
			
			checkIfToResizeTable("enPrincipalTable"+princType, "princRow"+princType);
			checkTableIfEmpty("princRow"+princType, "enPrincipalsDiv"+princType);
			
			if(objMKGlobal.packQuoteId != null){
				if(princType == "P"){
					($$("div#enPrincipalTableP div:not([quoteId='" +objCurrPackQuote.quoteId+ "'])")).invoke("hide");
				}else{
					($$("div#enPrincipalTableC div:not([quoteId='" +objCurrPackQuote.quoteId+ "'])")).invoke("hide");
				}
				resizeTableBasedOnVisibleRows("enPrincipalsDiv"+princType, "enPrincipalTable"+princType);
			}
			
		} catch (e) {
			showErrorMessage("setPrincipalListing", e);
		}
	}

	function makePrincipalObject(){
		var princObj = new Object();
		princObj.quoteId = objCurrPackQuote.quoteId;
		princObj.principalCd = $F("inputPrincipal" + princType);
		princObj.principalName = escapeHTML2($("txtPrincipalDisplay" + princType).value);
		princObj.principalType = princType;
		princObj.enggBasicInfonum = nvl($("enggBasicInfoNum").value, 1);
		princObj.subconSw = princType == "C" ?  ($("chkSubconSw" + princType).checked ? "Y" : "N") : "N";
		return princObj;
	}

	function populatePrincipalForm(princObj){
		$("inputPrincipal" + princType).value = princObj == null ? "" : princObj.principalCd;
		$("txtPrincipalDisplay" + princType).value = princObj == null ? "" : unescapeHTML2(princObj.principalName);
		(princObj == null ? disableButton($("btnDel"+princType)) : enableButton($("btnDel"+princType)));
		
		if(princType == "C"){
			$("btnAdd"+princType).value = princObj == null ? "Add" : "Update";
			$("chkSubconSw" + princType).checked = princObj == null ? false : (princObj.subconSw == "Y" ? true : false);
		}else{
			$("btnAdd"+princType).value = "Add";
			(princObj == null ? enableButton($("btnAdd"+princType)) : disableButton($("btnAdd"+princType)));
		}
		
		if(princObj == null){
			$("inputPrincipal" + princType).show();
			$("txtPrincipalDisplay" + princType).hide();
		}else{
			$("inputPrincipal" + princType).hide();
			$("txtPrincipalDisplay" + princType).show();
		} 
	}

	$("inputPrincipal" + princType).observe("change", function(){
		$("txtPrincipalDisplay" + princType).value = $("inputPrincipal" + princType).options[$("inputPrincipal" + princType).selectedIndex].text;
	});

	$("inputPrincipal" + princType).observe("click", function(){
		filterPrincipalLOV();
	});

	populatePrincipalForm(null);
	initializeChangeTagBehavior(savePackQuoteENInfo);
	
</script>