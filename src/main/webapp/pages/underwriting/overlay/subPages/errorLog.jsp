<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 98%; margin: 5px;">
	<div id="innerDiv" name="innerDiv">
		<label>Error Log</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div style="margin: 38px 5px 5px 5px;">
	<div class="tableHeader">
		<label style="width: 20%; text-align: left; padding-left: 10px;">Upload No</label>
		<label style="width: 28%; text-align: left;">Item</label>
		<label style="width: 15%; text-align: left;">Motor No</label>
		<label style="width: 15%; text-align: left;">Plate No</label>
		<label style="width: 20%; text-align: left;">Serial No</label>
	</div>
	<div id="errorListTable" name="errorListTable" class="tableContainer" style="font-size: 11px;">
		<c:forEach var="error" items="${errors}">
			<div id="row${error.itemNo}" name="row" class="tableRow">
				<label style="width: 20%; text-align: left; padding-left: 10px;">${error.uploadNo}</label>
				<label style="width: 28%; text-align: left;">${error.itemTitle}</label>
				<label style="width: 15%; text-align: left;">${error.motorNo}</label>
				<label style="width: 15%; text-align: left;">${error.plateNo}</label>
				<label style="width: 20%; text-align: left;">${error.serialNo}</label>
				<label style="display: none;">${error.remarks}</label>
				<label style="display: none;">${error.lastUpdate}</label>
				<label style="display: none;">${error.userId}</label>
				<label style="display: none;">${error.dspLastUpdate}</label>
			</div>
		</c:forEach>
	</div>
</div>
<script type="text/JavaScript">
	//initializeTable("tableContainer", "row", "", ""); //marco - replaced with codes below - 02.01.2013
	
	$$("div[name='row']").each(function(row){
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
		
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});
		
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$("errorRemarks").value = row.down("label", 5).innerHTML;
				$("errorUserId").value = row.down("label", 7).innerHTML;
				$("errorLastUpdate").value = row.down("label", 8).innerHTML;
				
				$$("div[name='row']").each(function (r)	{
					if (r.getStyle("display")!= "none")	{
						if (row.readAttribute("id") != r.readAttribute("id")) {
							r.removeClassName("selectedRow");
						}
					}
				});
			}else{
				$("errorRemarks").value = "";
				$("errorUserId").value = "";
				$("errorLastUpdate").value = "";
			}
		});
	});
	
	$("gro").observe("click", function(){
		Effect.Fade("errors", {duration: .3});
		$("errorRemarks").value = "";
		$("errorUserId").value = "";
		$("errorLastUpdate").value = "";
	});
</script>