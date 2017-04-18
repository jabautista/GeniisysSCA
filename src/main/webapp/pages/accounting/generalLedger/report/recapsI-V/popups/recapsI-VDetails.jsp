<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="sectionDiv" style="height: 425px; width: 835px; margin: 10px 0 12px 0;">
	<div id="recapsIToVDetailsMainDiv" name="recapsIToVDetailsMainDiv" style="height: 415px; width: 815px; margin: 0 0 10px 10px; overflow: auto;">
		<div id="headerLabelDiv" name="headerLabelDiv" style="float: left;">
			<table style="margin: 10px 0 0 370px;">
				<tr>
					<td><label id="cededLbl" style="width: 100%; text-align: center;"></label></td>
					<td style="padding-right: 120px;"></td>
					<td><label id="inwLbl" style="width: 100%; text-align: center;"></label></td>
					<td><label id="retLbl" style="width: 100%; text-align: center;"></label></td>
				</tr>
				<tr>
					<td>--------------------------------------------------------------------------</td>
					<td style="padding-right: 120px;"></td>
					<td>-------------------------------------------------------------------------</td>
					<td style="padding-left: 8px;">------------------------------------------------------------------------</td>
				</tr>
				<tr>
					<td><label style="font-size: 10px; padding-left: 190px;">Unauthorized Companies</label></td>
					<td style="padding-right: 120px;"></td>
					<td><label style="font-size: 10px; padding-left: 190px;"">Unauthorized Companies</label></td>
					<td><label style="font-size: 10px; padding-left: 198px;"">Unauthorized Companies</label></td>
				</tr>
			</table>
		</div>
		<div id="recapDetailTGDiv" name="recapDetailTGDiv" style="padding: 5px 0 0 0; margin-right: 15px; float: left;">
		
		</div>
	</div>
</div>
<div align="center">
	<input id="btnViewLineDetails" name="btnViewLineDetails" type="button" class="button" value="Line Details" style="width: 85px;" tabindex="201"/>
	<input id="btnReturn" name="btnReturn" type="button" class="button" value="Return" style="width: 85px;" tabindex="202"/>
</div>

<script type="text/javascript">
	objRecaps.detailsTableGrid = JSON.parse('${recapDetailsJSON}');
	objRecaps.detailsRows = objRecaps.detailsTableGrid.rows || [];
	objRecaps.selectedRow = "";
	
	try{
		detailsTableModel = {
			url: contextPath+"/GIACRecapDtlExtController?action=showRecapDetails&refresh=1&type="+objRecaps.type,
			id: "125",
			options: {
				id: 125,
	          	height: '306px',
	          	width: '1732px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objRecaps.selectedRow = detailsTableGrid.geniisysRows[y].rowTitle;
	          		detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
	          		detailsTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objRecaps.selectedRow = "";
	            	detailsTableGrid.keys.removeFocus(detailsTableGrid.keys._nCurrentFocus, true);
	          		detailsTableGrid.keys.releaseKeys();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'rowTitle',
							title: 'Line of Business',
							width: '248px',
							filterOption: true
						},
						{	id: 'directAmt',
							title: objRecaps.directAmtLbl,
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directAuth',
							title: 'Authorized',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directAsean',
							title: 'Asean',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directOth',
							title: 'Others',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'directNet',
							title: objRecaps.directNetLbl,
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'inwAuth',
							title: 'Authorized',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'inwAsean',
							title: 'Asean',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'inwOth',
							title: 'Others',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'retAuth',
							title: 'Authorized',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'retAsean',
							title: 'Asean',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'retOth',
							title: 'Others',
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'netWritten',
							title: objRecaps.netWrittenLbl,
							width: '121px',
							align: 'right',
							geniisysClass: 'money'
						}
						],
			rows: objRecaps.detailsRows
		};
		detailsTableGrid = new MyTableGrid(detailsTableModel);
		detailsTableGrid.pager = objRecaps.detailsTableGrid;
		detailsTableGrid.render('recapDetailTGDiv');
		detailsTableGrid.afterRender = function(){
			detailsTableGrid.onRemoveRowFocus();
		};
	}catch(e){
		showMessageBox("Error in Recap Details Table Grid: " + e, imgMessage.ERROR);
	}
	
	function setHeaderLabels(){
		$("cededLbl").innerHTML = objRecaps.cededLbl;
		$("inwLbl").innerHTML = objRecaps.inwLbl;
		$("retLbl").innerHTML = objRecaps.retLbl;
	}
	
	function showLineDetails(){
		var title = objRecaps.title + " - Details for " + objRecaps.selectedRow;
		
		lineDetailsOverlay = Overlay.show(contextPath+"/GIACRecapDtlExtController", {
			urlParameters: {
				action: "showLineDetails",
				type: objRecaps.type,
				line: objRecaps.selectedRow
			},
			title: title,
		    height: 530,
		    width: 840,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}
	
	$("btnViewLineDetails").observe("click", function(){
		if(objRecaps.selectedRow == ""){
			showMessageBox("Please select a record first.", "I");
		}else{
			showLineDetails();
		}
	});
	
	$("btnReturn").observe("click", function(){
		recapDetailsOverlay.close();
		delete recapDetailsOverlay;
	});
	
	setHeaderLabels();
	$("recapsIToVDetailsMainDiv").up("div", 1).setStyle("overflow: hidden;");
</script>