<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="processorHistoryMainDiv" name="processorHistoryMainDiv">
	<div id="processorHistoryTableGridDiv" align="center">
		<div id="processorHistoryGridDiv" style="height: 330px; margin-top: 5px;">
			<div id="processorHistoryTableGrid" style="height: 306px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		objCLM.objClaimListTableGrid = JSON.parse('${claimsListTableGrid}'.replace(/\\/g, '\\\\'));
		objCLM.objClaimList = objCLM.objClaimListTableGrid.rows || [];
		var claimsTableModel = {
				url: contextPath+"/GICLClaimsController?action=getProcessorHistory&claimId=" + objCLMGlobal.claimId+"&refresh=1",
				options:{
					title: '',
					width: '580px',
					onRowDoubleClick: function(y){
						var row = claimsListTableGrid.geniisysRows[y];
						claimsListTableGrid.keys.removeFocus(claimsListTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
						claimsListTableGrid.keys.releaseKeys();	
					},
					onCellFocus: function(element, value, x, y, id){
						var mtgId = claimsListTableGrid._mtgId;
						claimsListTableGrid.keys.removeFocus(claimsListTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
						claimsListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {

					}
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
						id: 'inHouAdj',
						title: 'Claim Processor',
						width: '200px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'userId',
						title: 'User ID',
						width: '200px',
						sortable: true,
						align: 'left',
						visible: true
					},	
							
					{
						id: 'dspLastUpdate',
						title: 'Last Update',
						width: '168px',
						sortable: true,
						align: 'left',
						visible: true
					},
				],
				resetChangeTag: true,
				rows: objCLM.objClaimList
		};
	
		claimsListTableGrid = new MyTableGrid(claimsTableModel);
		claimsListTableGrid.pager = objCLM.objClaimListTableGrid;
		claimsListTableGrid.render('processorHistoryTableGrid');
			
	} catch(e){
		showErrorMessage("processorHistory.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>