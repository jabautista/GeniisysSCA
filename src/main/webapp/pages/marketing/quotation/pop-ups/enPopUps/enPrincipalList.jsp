<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% 	
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="principalMainDiv" name="principalMainDiv">
	<div id="enPrincipalsDiv${pType}" name="enPrincipalsDiv${pType}" style="margin: 10px; width: 430px; margin-left: 255px; display: none;"  changeTagAttr="true">
		<div class="tableHeader" id="carrierInfoTable" name="carrierInfoTable">
			<label style="width: 140px; text-align: left; margin-left: 5px;">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor</c:when>
					<c:otherwise>Principal</c:otherwise>
				</c:choose>
			</label>
			<label style="width: 230px; text-align: left; margin-left: 5px;">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor Name</c:when>
					<c:otherwise>Principal Name</c:otherwise>
				</c:choose>
			</label>
			<c:choose>	
				<c:when test="${pType=='C'}">
					<label style="width: 20px; text-align: left; margin-left: 0px;">S</label>
				</c:when>
			</c:choose>
			
		</div>
		<div id="enPrincipalTable${pType}" name="enPrincipalTable${pType}" class="tableContainer" style="margin-bottom: 10px; max-height: 160px; overflow: auto;">
		</div>
	</div>
</div>	
<div class="sectionDiv" style="border: none;">
	<div id="enPrincipalFormFiv" name="enPrincipalFormDiv" style="width: 100%; margin: 10px 0px 5px 0px; ">
		<table align="center" style="width: 420px;">
			<tr>
				<td class="rightAligned" width="20%">
					<c:choose>	
						<c:when test="${pType=='C'}">Contractor</c:when>
						<c:otherwise>Principal</c:otherwise>
					</c:choose>
				</td>
				<td class="leftAligned" width="80%">
					<select id="inputPrincipal${pType}" name="inputPrincipal${pType}" style="width: 98%;" class="required"></select>
				</td>
			</tr>
			<tr id="SubconSwRow${pType}">
				<td class="rightAligned" width="20%">Subcon SW</td>
				<td class="leftAligned" width="80%">
					<input type="checkbox" id="chkSubconSw${pType}" name="chkSubconSw${pType}" value="N"/>
				</td>
			</tr>
			
		</table>		
	</div>

	<div style="margin-bottom: 10px;" changeTagAttr="true">
		<input type="button" class="button" style="width: 60px;" id="btnAdd${pType}" name="btnAdd${pType}" value="Add" />
		<input type="button" class="disabledButton" style="width: 60px;" disabled="disabled" id="btnDel${pType}" name="btnDel${pType}" value="Delete" />
	</div>
</div>	


<script type="text/javascript">
	var paramType = '${pType}';
	var objArray = JSON.parse('${principalList}'.replace(/\\/g, '\\\\'));	
	var selRowNum = 0;
	var subConSw = "";
	if (paramType == "C") {
		$("SubconSwRow"+paramType).show();
	} else {
		$("SubconSwRow"+paramType).hide();
	}
	populatePrincipalDtls(objArray, paramType);
	if (paramType == 'C'){
		objGIPIQuote.objPrincipalArrayC = JSON.parse('${principalListingJSON}'.replace(/\\/g, '\\\\'));
		populatePrincipalListing(objGIPIQuote.objPrincipalArrayC);
	}else {
		objGIPIQuote.objPrincipalArrayP = JSON.parse('${principalListingJSON}'.replace(/\\/g, '\\\\'));
		populatePrincipalListing(objGIPIQuote.objPrincipalArrayP);
	}
	
	function populatePrincipalListing(objArray){
		try {
			var itemTable = $("enPrincipalTable" + paramType);
			
			for(var i=0; i<objArray.length; i++) {														
				var newDiv = new Element("div");
				var subconSw = objArray[i].subconSw;
				var content;

				newDiv.setAttribute("id", paramType + ($$("div[name='principalRow' + "+paramType+" ]").size()+ 1));
				newDiv.setAttribute("name", "principalRow" + paramType);
				newDiv.setAttribute("recNum", ($$("div[name='principalRow' + "+paramType+" ]").size()+ 1));
				newDiv.setAttribute("principalCd", objArray[i].principalCd);
				newDiv.setAttribute("subConSw", subconSw);
				newDiv.addClassName("tableRow");

				objArray[i].recNum = $$("div[name='principalRow' + "+paramType+" ]").size()+ 1;
				content = preparePrincipalListInfo(objArray[i], newDiv);
			
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});
				checkTableIfEmpty("principalRow" + paramType, "enPrincipalTable" + paramType);
				divEvents(newDiv);
					
			}
		} catch (e) {
			showErrorMessage("populatePrincipalListing", e);
		}
	}

	function preparePrincipalListInfo(obj, newDiv){
		try {	
			var content = "";
			if (paramType == 'C') {
				content = '<label style="width: 25px; text-align: right; margin-left: 25px;" id="lblPrincipalCd'+paramType+newDiv.getAttribute("recNum")+'">'+ obj.principalCd +'</label>'+
				  '<label style="width: 240px; text-align: left; margin-left: 80px;" id="lblPrincipalName'+paramType+newDiv.getAttribute("recNum")+'">'+obj.principalName+'</label>'+
				  //'<label style="width: 20px; text-align: left; margin-left: 22px;" id="lblSubConSw'+paramType+newDiv.getAttribute("recNum")+'">'+obj.subconSw+'</label>'; replaced by agazarraga 4/20/2012, so that subcon appearance will not be affected even of scrollbar appears 
				  '<label style="width: 20px; text-align: left; margin-left: 10px;" id="lblSubConSw'+paramType+newDiv.getAttribute("recNum")+'">'+obj.subconSw+'</label>'; 
			}else {
				content = '<label style="width: 35px; text-align: right; margin-left: 25px;" id="lblPrincipalCd'+paramType+newDiv.getAttribute("recNum")+'">'+ obj.principalCd +'</label>'+
				  '<label style="width: 230px; text-align: left; margin-left: 90px;" id="lblPrincipalName'+paramType+newDiv.getAttribute("recNum")+'">'+obj.principalName+'</label>';
			}
			return content;
		} catch (e) {
			showErrorMessage("preparePrincipalListInfo", e);
		}
	}

	function populatePrincipalDtls(obj, value){
		$("inputPrincipal" + paramType).update('<option name="optPrincipal" value="" principalType="" principalCd="" principalName=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option name="optPrincipal" value="'+obj[i].principalCd+'" principalCd="'+obj[i].principalCd+'" principalName="'+obj[i].principalName+'" principalType="'+obj[i].principalType+'">'+obj[i].principalName+'</option>';
		}
		$("inputPrincipal" + paramType).insert({bottom: options}); 
		$("inputPrincipal" + paramType).selectedIndex = 0;
	}

	function divEvents(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='principalRow' + "+paramType+"]").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{
						$("btnAdd" + paramType).value = "Update";
						enableButton("btnDel" + paramType);
						enableButton("btnAdd" + paramType);
						selRowNum = r.getAttribute("recNum");
						subConSw = r.getAttribute("subConSw");
						$("inputPrincipal" + paramType).value =  r.getAttribute("principalCd");
						if (paramType == 'C') {
							if ($("lblSubConSw" + paramType + selRowNum).innerHTML == 'Y') {
								$("chkSubconSw" + paramType).checked = true;
							}else {
								$("chkSubconSw" + paramType).checked = false;
							}
						} 
					}
			    });	
			}else {
				resetValues();
			}
		});
	}

	function updateSelectedValues(){
		$("lblPrincipalCd" + paramType + selRowNum).innerHTML = $("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalCd");
		$("lblPrincipalName" + paramType + selRowNum).innerHTML = $("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalName");
		if (paramType == 'C'){
			if ($("chkSubconSw" + paramType) != null) {
				$("lblSubConSw" + paramType + selRowNum).innerHTML = $("chkSubconSw" + paramType).checked == true ? "Y" : "N";
			}
		}
		if (paramType == 'C'){
			for(var i=0; i<objGIPIQuote.objPrincipalArrayC.length; i++) {
				if (objGIPIQuote.objPrincipalArrayC[i].recNum == selRowNum){
					objGIPIQuote.objPrincipalArrayC[i].origPrincipalCd = objGIPIQuote.objPrincipalArrayC[i].principalCd;
					objGIPIQuote.objPrincipalArrayC[i].principalCd = $("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalCd");
					objGIPIQuote.objPrincipalArrayC[i].principalName = escapeHTML2($("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalName"));
					//if ($("chkSubconSw" + paramType) != null) {
						objGIPIQuote.objPrincipalArrayC[i].subconSw = $("chkSubconSw" + paramType).checked == true ? "Y" : "N";
					//}else{
					//	objGIPIQuote.objPrincipalArrayC[i].subconSw = 'N';
					//}
					objGIPIQuote.objPrincipalArrayC[i].recordStatus = 1;
				}
			}
		}else {
			for(var i=0; i<objGIPIQuote.objPrincipalArrayP.length; i++) {
				if (objGIPIQuote.objPrincipalArrayP[i].recNum == selRowNum){
					objGIPIQuote.objPrincipalArrayP[i].origPrincipalCd = objGIPIQuote.objPrincipalArrayP[i].principalCd;
					objGIPIQuote.objPrincipalArrayP[i].principalCd = $("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalCd");
					objGIPIQuote.objPrincipalArrayP[i].principalName = escapeHTML2($("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalName"));
					//if ($("chkSubconSw" + paramType) != null) {
					//	objGIPIQuote.objPrincipalArrayP[i].subconSw = $("chkSubconSw" + paramType).checked == true ? "Y" : "N";
					//}else{
						objGIPIQuote.objPrincipalArrayP[i].subconSw = 'N';
					//}
					objGIPIQuote.objPrincipalArrayP[i].recordStatus = 1;
				}
			}
		}
		$$("div[name='principalRow' + "+paramType+"]").each(function (r){
			if(r.getAttribute("recNum") == selRowNum){
				if (paramType == 'C'){
					if ($("chkSubconSw" + paramType) != null) {
						r.setAttribute("subConSw",  $("chkSubconSw" + paramType).checked == true ? "Y" : "N");
					}
					else{
						r.setAttribute("subConSw", 'N');
					}
				}
				r.setAttribute("principalCd", $("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalCd"));
			}
		});
		resetValues();
	}

	function resetValues(){
		$$("div[name='principalRow' + "+paramType+"]").each(function (r)	{
			r.removeClassName("selectedRow");
		});
		$("btnAdd" + paramType).value = "Add";
		disableButton("btnDel" + paramType);
		$("inputPrincipal" + paramType).selectedIndex = 0;
		if ($("chkSubconSw" + paramType) != null) {
			$("chkSubconSw" + paramType).checked = false;
		}
	}

	function checkIfRowExist2(principal){
		var exists = false;
		$$("div[name='principalRow' + "+paramType+"]").each(function (r)	{
			if (r.getAttribute("principalCd") == principal){
				exists = true;
				return;
			}
		});
		return exists;
	}
	
	function notInSelectOption() {
		$$("option[name='optPrincipal']").each(function(o){
			if(checkIfRowExist2(o.value)){
				hideOption(o);
			} else {
				showOption(o);
			}
		});
	}
	
	$("inputPrincipal" + paramType).observe("mousedown", notInSelectOption); //added by steven 10.02.2013
	
	$("btnAdd" + paramType).observe("click", function () {
		if ($("inputPrincipal" + paramType).selectedIndex != 0) {
			if ($("btnAdd" + paramType).value == "Add") {
				var itemTable = $("enPrincipalTable" + paramType);
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", paramType + ($$("div[name='principalRow' + "+paramType+" ]").size()+ 1));
				newDiv.setAttribute("name", "principalRow" + paramType);
				newDiv.setAttribute("recNum", ($$("div[name='principalRow' + "+paramType+" ]").size()+ 1));
				newDiv.setAttribute("principalCd", $F("inputPrincipal" + paramType));
				newDiv.addClassName("tableRow");
				var content = "";
				if (paramType == "C"){
					var subconSw = $("chkSubconSw" + paramType).checked == true ? "Y" : "N";
					newDiv.setAttribute("subConSw", subconSw);
					content = '<label style="width: 25px; text-align: right; margin-left: 25px;" id="lblPrincipalCd'+paramType+newDiv.getAttribute("recNum")+'">'+ $F("inputPrincipal" + paramType) +'</label>'+
					  '<label style="width: 240px; text-align: left; margin-left: 80px;" id="lblPrincipalName'+paramType+newDiv.getAttribute("recNum")+'">'+$("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalName")+'</label>'+
					  //'<label style="width: 20px; text-align: left; margin-left: 22px;" id="lblSubConSw'+paramType+newDiv.getAttribute("recNum")+'">'+subconSw+'</label>';
					  '<label style="width: 20px; text-align: left; margin-left: 10px;" id="lblSubConSw'+paramType+newDiv.getAttribute("recNum")+'">'+subconSw+'</label>'; 
				}else {
					content = '<label style="width: 35px; text-align: right; margin-left: 25px;" id="lblPrincipalCd'+paramType+newDiv.getAttribute("recNum")+'">'+ $F("inputPrincipal" + paramType) +'</label>'+
					  '<label style="width: 230px; text-align: left; margin-left: 90px;" id="lblPrincipalName'+paramType+newDiv.getAttribute("recNum")+'">'+$("inputPrincipal" + paramType).options[$("inputPrincipal" + paramType).selectedIndex].getAttribute("principalName")+'</label>';  
				}
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});  	
				divEvents(newDiv);
				setAddedGIPIQuotePrincipal();
				if (getSizeOfRecord() > 0){ $("enPrincipalsDiv" + paramType).show();}else{$("enPrincipalsDiv" + paramType).hide();}
				resetValues();
				changeTag = 1;
			}else {
				updateSelectedValues(); 
				changeTag = 1;
			}
		}else {
			showMessageBox("Required fields must be entered.");
		}
	});

	$("btnDel" + paramType).observe("click", deletePrincipal);
	
	function setAddedGIPIQuotePrincipal(){
		var newObj = new Object();

		try{
			newObj.quoteId  	= 	$F("quoteId");
			newObj.principalCd  = escapeHTML2($F("inputPrincipal" + paramType));
			newObj.enggBasicInfonum  = 1;
			newObj.selRowNum = selRowNum;
			newObj.recNum = $$("div[name='principalRow' + "+paramType+" ]").size();
			if (paramType == 'C') {
				newObj.subconSw  = $("chkSubconSw" + paramType).checked == true ? "Y" : "N";
			}else {
				newObj.subconSw = 'N';
			}
			newObj.recordStatus = 0;
			if (paramType == 'C') {
				objGIPIQuote.objPrincipalArrayC.push(newObj);
			}else {
				objGIPIQuote.objPrincipalArrayP.push(newObj);
			}		    			
		}catch(e){
			showErrorMessage("setAddedGIPIQuotePrincipal", e);
		}
	}

	function deletePrincipal(){
		$$("div[name='principalRow' + "+paramType+"]").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				markRecordAsDeleted($F("inputPrincipal" + paramType));
				row.remove();	
				changeTag = 1;
				if (getSizeOfRecord() > 0){ $("enPrincipalsDiv" + paramType).show();}else{$("enPrincipalsDiv" + paramType).hide();}		
				resetValues();	
				checkTableIfEmpty("principalRow" + paramType, "enPrincipalTable" + paramType);
			}
		});
	}

	function markRecordAsDeleted(principalCd){
		if (paramType == 'C'){
			for(var i=0; i<objGIPIQuote.objPrincipalArrayC.length; i++) {		
				if (parseInt(principalCd) == parseInt(objGIPIQuote.objPrincipalArrayC[i].principalCd)){
					objGIPIQuote.objPrincipalArrayC[i].recordStatus = -1;
				}
			}
		}else {
			for(var i=0; i<objGIPIQuote.objPrincipalArrayP.length; i++) {		
				if (parseInt(principalCd) == parseInt(objGIPIQuote.objPrincipalArrayP[i].principalCd)){
					objGIPIQuote.objPrincipalArrayP[i].recordStatus = -1;
				}
			}
		}
	}

	function getSizeOfRecord(){
		var count = 0;
		if (paramType == 'C'){
			for (var i=0; i<objGIPIQuote.objPrincipalArrayC.length; i++) {
				if (objGIPIQuote.objPrincipalArrayC[i].recordStatus != -1) {
					count = count + 1;
				}
			}
		}else {
			for (var i=0; i<objGIPIQuote.objPrincipalArrayP.length; i++) {
				if (objGIPIQuote.objPrincipalArrayP[i].recordStatus != -1) {
					count = count + 1;
				}
			}
		}
		return count;
	}
	if (getSizeOfRecord() > 0){ $("enPrincipalsDiv" + paramType).show();}else{$("enPrincipalsDiv" + paramType).hide();}
</script>