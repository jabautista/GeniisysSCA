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

<div id="clmStatHistoryMainDiv" name="clmStatHistoryMainDiv">
	<div id="clmStatHistoryTableGridDiv" align="center">
		<div id="clmStatHistoryGridDiv" style="height: 330px; margin-top: 5px;">
			<div id="clmStatHistoryTableGrid" style="height: 306px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover" value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		objCLM.objClaimListTableGrid = JSON.parse('${claimsListTableGrid}'.replace(/\\/g, '\\\\'));
		objCLM.objClaimList = objCLM.objClaimListTableGrid.rows || [];
		var claimsTableModel = {
				url: contextPath+"/GICLClaimsController?action=getStatHist&claimId=" + objCLMGlobal.claimId+"&refresh=1",
				options:{
					title: '',
					width: '580px',
					onRowDoubleClick: function(y){
						claimsListTableGrid.keys.removeFocus(claimsListTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
						claimsListTableGrid.keys.releaseKeys();	
					},
					onCellFocus: function(element, value, x, y, id){
						claimsListTableGrid.keys.removeFocus(claimsListTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
						claimsListTableGrid.keys.releaseKeys();	
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
						id: 'clmStatCd',
						title: 'Claim Status Code',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'clmStatDesc',
						title: 'Description',
						width: '200px',
						sortable: true,
						align: 'left',
						visible: true
					},	
							
					{
						id: 'userId',
						title: 'User ID',
						width: '96px',
						sortable: true,
						align: 'left',
						visible: true
					},
					
					{
						id: 'dspClmStatDt',
						title: 'Date',
						width: '150px',
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
		claimsListTableGrid.render('clmStatHistoryTableGrid');
			
	} catch(e){
		showErrorMessage("clmStatHistory.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>