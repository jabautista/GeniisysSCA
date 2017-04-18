<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
	<div id="parItemPerilTable" name="parItemPerilTable">
		<div id="itemPerilHeaderDiv" class="tableHeader" style="padding-right: 0px;">
			<label style="width: 8%; text-align: right; margin-right: 5px;">Item</label>
			<label style="width: 20%; text-align: left; margin-left: 5px;">Peril Name</label>
			<label style="width: 12%; text-align: right;">Rate</label>
	   		<label style="width: 15%; text-align: right; margin-left: 5px;">TSI Amount</label>
			<label style="width: 15%; text-align: right; margin-left: 5px;">Premium Amount</label>
			<label style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">Remarks</label>
			<label style="width: 3%; text-align: right;">A</label>
			<label style="width: 3%; text-align: right;">S</label>
			<label style="width: 3%; text-align: right;">D</label>
		</div>
		<div class="tableContainer" id="itemPerilMainDiv">
			<div id="hiddenDiv" name="hiddenDiv" style="display: none;">
				<select id="itemNos" name="itemNos">
					<c:forEach var="itemNum" items="${itemNos}">
						<option value="${itemNum}">${itemNum}</option>
					</c:forEach>
				</select>
				<input type="hidden" id="wItemPeril" name="wItemPeril" value="${wItemPeril}"/>
				<input type="hidden" name="markUpTag" id="markUpTag" value="${markUpTag}"/> 
			</div>
		</div>
	</div>
<script type="text/javaScript">
	objGIISPerilClauses	= JSON.parse('${jsonPerilClauseList}'.replace(/\\/g, '\\\\'));

	//objUWParList			= JSON.parse('${jsonGIPIPARList}'.replace(/\\/g, '\\\\')); // andrew - comment muna
	//objGIPIWItem 			= JSON.parse('${jsonItemList}'.replace(/\\/g, '\\\\'));
	objGIPIWItemPeril 		= JSON.parse('${jsonItemPerilList}'.replace(/\\/g, '\\\\'));
	objGIPIWPolWC			= JSON.parse('${jsonWPolWCList}'.replace(/\\/g, '\\\\'));
	
	setCopyPerilButton();
	createItemPerilMotherDivs();
	//setItemPerilMotherDivs();
	setItemPerilList();
	hideAllItemPerilOptions();
	selectItemPerilOptionsToShow();
	hideExistingItemPerilOptions();
	
	hideAllPerilDivs();
	$$("div[name='itemPerilMotherDiv'").each(function(m){
		m.hide();
	});
	$("itemPerilMainDiv").hide();
	$("perilInformationDiv").hide();

	function createItemPerilMotherDivs(){
		for(var i=0, length=objGIPIWItemPeril.length; i<length; i++){
			setItemPerilMotherDiv(objGIPIWItemPeril[i].itemNo);
		}
	}	
	
	function setItemPerilList(){
		for (var i=0; i<objGIPIWItemPeril.length; i++){
			addObjToPerilTable(objGIPIWItemPeril[i]);	
		}
	}

	$$("label[name='text']").each(function (label)	{
		if ((label.innerHTML).length > 15)    {
            label.update((label.innerHTML).truncate(15, "..."));
        }
	});
	
	$$("label[name='textPeril']").each(function (label)	{
		if ((label.innerHTML).length > 25)    {
            label.update((label.innerHTML).truncate(25, "..."));
        }
	});

</script>