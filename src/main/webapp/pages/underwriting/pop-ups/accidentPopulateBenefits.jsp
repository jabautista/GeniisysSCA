<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="popBenefitsInfo" class="sectionDiv" style="display:block; width:872px; background-color:white;">
	<div style="margin-left:65px; margin-right:20px; margin-top:5px; margin-bottom:0px; float:left; width:63%;" id="accidentPopBenTable" name="accidentPopBenTable">	
		<div class="tableHeader" style="margin-top:5px; ">
			<label style="text-align: left; width: 19px; margin-right: 6px;">&nbsp;</label>
			<label style="text-align: left; width: 45%; margin-right: 2px;">Enrollee Code</label>
			<label style="text-align: left; width: 45%; margin-right: 2px;">Enrollee Name</label>
		</div>
		<div class="tableContainer" id="accidentPopBenListing" name="accidentPopBenListing" style="display: block; margin:auto; width:100%;">
			<c:forEach var="grpItem" items="${gipiWGroupedItems}">
				<div id="rowPopBens${grpItem.itemNo}${grpItem.groupedItemNo}" item="${grpItem.itemNo}" groupedItemNo="${grpItem.groupedItemNo}" groupedItemTitle="${grpItem.groupedItemTitle }" name="popBens" class="tableRow" style="padding-left:1px;">
					<input type="hidden" id="popParIds" 		     		name="popParIds" 	        	value="${grpItem.parId}" />
		 	  		<input type="hidden" id="popItemNos" 		     		name="popItemNos" 	        	value="${grpItem.itemNo}" /> 
					<input type="hidden" id="popGroupedItemNos"       		name="popGroupedItemNos"     	value="${grpItem.groupedItemNo}" />
					<input type="hidden" id="popGroupedItemTitles"  	 	name="popGroupedItemTitles"  	value="${grpItem.groupedItemTitle}" />
					<input type="hidden" id="popCheckSw"  	 				name="popCheckSw"  				value="Y" />
					
					<label name="textG1" style="text-left: left; margin-right:6px; margin-left:4px;"><input type="checkbox" id="popCheck" name="popCheck" checked="checked"/></label>		
					<label name="textG" id="num" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">${grpItem.groupedItemNo}<c:if test="${empty grpItem.groupedItemNo}">---</c:if></label>
				    <label name="textG" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">${grpItem.groupedItemTitle}<c:if test="${empty grpItem.groupedItemTitle}">---</c:if></label>
				</div>
			</c:forEach>
		</div>
	</div>
	<div id="subButtonDiv" style="display: block; float:left; margin-top:40px;">
		<table border="0" style="margin-left:5px">
			<tr><td>
				<input type="button" class="button" id="btnSelectedGroupedItems" name="btnSelectedGroupedItems" value="Selected Grouped Items" style="width:160px" />
			</td></tr>
			<tr><td>
				<input type="button" class="button" id="btnAllGroupedItems" name="btnAllGroupedItems" value="All Grouped Items" style="width:160px" />
			</td></tr>
		</table>
	</div>
	<div style="width:100%; float:left;">
	<table align="center" style="margin-top:10px; margin-bottom:10px;">
		<tr>
			<td>
				<input type="button" class="button" 		id="btnOkPopBen" 	    name="btnOkPopBen" 		    value="Populate" 	style="width: 65px" />
				<input type="button" class="button" 		id="btnOkCopyBen" 	    name="btnOkCopyBen" 		value="Copy" 		style="width: 60px" />
				<input type="button" class="button" 		id="btnOkDeleteBen" 	name="btnOkDeleteBen" 		value="Delete" 		style="width: 60px" />
				<input type="button" class="button" 		id="btnCancelPopBen" 	name="btnCancelPopBen" 		value="Cancel" 		style="width: 60px" />
			</td>
		</tr>
	</table>
	</div>
</div>	
<script type="text/javascript">
	$$("label[name='textG1']").each(function(label){
			$(label).observe("mouseover",function(){
			label.setAttribute("title","");
		});
	});

	$$("label[name='textG']").each(function (label)    {
   		if ((label.innerHTML).length > 15)    {
        	label.update((label.innerHTML).truncate(15, "..."));
    	}
	});	
	
	$$("label[id='num']").each(function (label)    {
		if (label.innerHTML != "---"){
        	label.update(formatNumberDigits(label.innerHTML,7));
		}
	});
	
	$$("div[name='popBens']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowPopBens"+$F("itemNo")+formatNumberDigits(no,7));
	});

	$$("div[name='popBens']").each(function (newDiv){
		newDiv.observe("mouseover", function ()	{
			newDiv.addClassName("lightblue");
		});
			
		newDiv.observe("mouseout", function ()	{
			newDiv.removeClassName("lightblue");
		});

		newDiv.down("input",5).observe("change", function()	{
			if (newDiv.down("input",5).checked == true){
				newDiv.down("input",4).value = "Y";
			} else{
				newDiv.down("input",4).value = "N";
			}
		});

		newDiv.down("label",1).observe("click", function()	{
			if (newDiv.down("input",5).checked == true){
				newDiv.down("input",5).checked = false;
				newDiv.down("input",4).value = "N";
			} else{
				newDiv.down("input",5).checked = true;
				newDiv.down("input",4).value = "Y";
			}
		});
		newDiv.down("label",2).observe("click", function()	{
			if (newDiv.down("input",5).checked == true){
				newDiv.down("input",5).checked = false;
				newDiv.down("input",4).value = "N";
			} else{
				newDiv.down("input",5).checked = true;
				newDiv.down("input",4).value = "Y";
			}
		});
	});

	$("btnSelectedGroupedItems").observe("click", function(){
		$$("div[name='popBens']").each(function (a){
			a.down("input",5).checked = false;
			a.down("input",4).value = "N";
		});	
	});
	
	$("btnAllGroupedItems").observe("click", function(){
		$$("div[name='popBens']").each(function (a){
			a.down("input",5).checked = true;
			a.down("input",4).value = "Y";
		});
	});

	checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","popBens","item",$F("itemNo"));
</script>		
