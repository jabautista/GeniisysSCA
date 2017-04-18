<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="bondSeqHistMainDiv">
	<div id="bondSeqHistBodyDiv" name="bondSeqHistBodyDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<div id="bondSeqHistTableGrid" style="height: 230px; margin: 10px; margin-bottom: 35px;">tablegrid</div>
	</div>
	
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
try{
	var objBondSeqHist = JSON.parse('${jsonBondSeqHistGrid}');
	var bondSeqHistTableModel = {
			url : contextPath + "/GenerateBondSeqController?action=showBondSeqHistoryOverlay&refresh=1",
			options : {
				onCellFocus: function(element, value, x, y, id){
					bondSeqHistTableGrid.keys.removeFocus(bondSeqHistTableGrid.keys._nCurrentFocus, true);
					bondSeqHistTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	bondSeqHistTableGrid.keys.removeFocus(bondSeqHistTableGrid.keys._nCurrentFocus, true);
	            	bondSeqHistTableGrid.keys.releaseKeys();
	            },
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				}
			},
			columnModel : [
			    {
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'lineCd',
					title : 'Line Code',
					width : '65px',
					titleAlign : 'center',
					filterOption : true
				},
				{
					id : 'sublineCd',
					title : 'Subline Code',
					width : '80px',
					titleAlign: 'center',
					filterOption : true
				},
				{
					id : 'seqNo',
					title : 'Sequence No.',
					width : '79px',
					titleAlign: 'center',
					align : 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer : function(value){
						return formatNumberDigits(value, 7);
					}
				},
				{
					id : 'parId',
					title : 'PAR ID',
					width : '48px',
					titleAlign: 'center',
					align : 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id : 'remarks',
					title : 'Remarks',
					width : '250px',
				},
				{
					id : 'userId',
					title : 'User ID',
					width : '45px'
				},
				{
					id : 'strLastUpdate',
					title : 'Last Update',
					align : 'right',
					width : '70px'
				},
				{
					id : 'lastUpdate',
					title : 'Last Update',
					width : 0,
					visible : false
				}
			],
			rows : objBondSeqHist.rows
	};
	bondSeqHistTableGrid = new MyTableGrid(bondSeqHistTableModel);
	bondSeqHistTableGrid.pager = objBondSeqHist;
	bondSeqHistTableGrid.render('bondSeqHistTableGrid');
	
	$("btnReturn").observe("click", function(){
		overlayBondSeqHistory.close();
		delete overlayBondSeqHistory;
	});
	
} catch (e){
	showErrorMessage("bondSeqHistTableGrid", e);
}
</script>