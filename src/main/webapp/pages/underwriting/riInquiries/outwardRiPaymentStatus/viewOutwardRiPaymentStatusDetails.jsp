<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="detailsDiv" style="width: 475px; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px;">
		<div id="detailsTable" style="height: 240px; margin-left: auto;"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
</div>
<script type="text/javascript">
	try {
		
		var jsonGIRIS012Details = JSON.parse('${jsonGIRIS012Details}');
		detailsTableModel = {
				id: "detailsTableGrid",
				url : contextPath+"/GIRIInpolbasController?action=showGIRIS012Details&refresh=1&fnlBinderId=" + objGIRIS012.fnlBinderId,
				options: {
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					width: '475px',
					height: '215px',
					onCellFocus : function(element, value, x, y, id) {
						tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
						tbgDetails.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
						tbgDetails.keys.releaseKeys();
					},
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "refNo",
						title: "Reference No.",
						width: 155
					},
					{
						id : "payDate",
						title: "Date",
						width: 133,
						align: "center",
						titleAlign: "center",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{
						id : "disbursementAmt",
						title: "Amount",
						width: 155,
						align: "right",
						titleAlign: "right",
						geniisysClass: "money"
					}
				],
				rows: jsonGIRIS012Details.rows
			};
		
		tbgDetails = new MyTableGrid(detailsTableModel);
		tbgDetails.pager = jsonGIRIS012Details;
		tbgDetails.render('detailsTable');
		tbgDetails.afterRender = function() {
			
		};
		
		$("btnReturn").observe("click", function(){
			overlayDetails.close();
			delete overlayDetails;
		});
		
	} catch (e) {
		showErrorMessage("Error" , e);
	}
</script>