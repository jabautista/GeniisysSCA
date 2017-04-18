<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div>
	<table align="center" style="margin-top: 10px;">
		<tr>
			<td><label style="float: right; margin: 0 5px 2px 0;">Issuing Source</label></td>
			<td>
				<input type="text" id="txtIssCdHist" readonly="readonly" style="width: 60px;"/>
				<input type="text" id="txtIssNameHist" readonly="readonly" style="width: 190px;"/>
			</td>
			<td><label style="float: right; margin: 0 5px 2px 20px;">Intermediary</label></td>
			<td>
				<input type="text" id="txtIntmNoHist" readonly="readonly" style="width: 60px; text-align: right;"/>
				<input type="text" id="txtIntmNameHist" readonly="readonly" style="width: 190px;"/>
			</td>
		</tr>
		<tr>
			<td><label style="float: right; margin: 0 5px 2px 0;">Line</label></td>
			<td>
				<input type="text" id="txtLineCdHist" readonly="readonly" style="width: 60px;"/>
				<input type="text" id="txtLineNameHist" readonly="readonly" style="width: 190px;"/>
			</td>
			<td><label style="float: right; margin: 0 5px 2px 0;">Subline</label></td>
			<td>
				<input type="text" id="txtSublineCdHist" readonly="readonly" style="width: 60px;"/>
				<input type="text" id="txtSublineNameHist" readonly="readonly" style="width: 190px;"/>
			</td>
		</tr>
	</table>
	<div style="padding-top: 10px;">
		<div id="historyTable" style="height: 181px; margin-left: 11px;"></div>
	</div>
	<div style="float: none; text-align: center;">
		<input type="button" class="button" value="Return" id="btnExitHistory" style="width: 90px; margin-top: 7px;" />
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("txtIssCdHist").value = $F("txtIssCd");
		$("txtIssNameHist").value = $F("txtIssName");
		$("txtIntmNoHist").value = $F("txtIntmNo");
		$("txtIntmNameHist").value = $F("txtIntmName");
		$("txtLineCdHist").value = $F("txtLineCd");
		$("txtLineNameHist").value = $F("txtLineName");
		$("txtSublineCdHist").value = $F("txtSublineCd");
		$("txtSublineNameHist").value = $F("txtSublineName");
		
		var objGiiss202History = {};
		objGiiss202History.histList = JSON.parse('${jsonHistory}');
		
		var historyTable = {};
				
		historyTable = {
			id : "tbgHistory",
			url : contextPath + "/GIISSplOverrideRtController?action=showGiiss202History&refresh=1" +
			"&intmNo="+$F("txtIntmNo")+"&issCd="+$F("txtIssCd")+
			"&lineCd="+$F("txtLineCd")+"&sublineCd="+$F("txtSublineCd"),
			options : {
				width : 778,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
				},toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
						tbgHistory.keys.releaseKeys();
					}
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "effDate",
					title: "Effectivity Date",
					align: "center",
					titleAlign: "center",
					width: 100,
					filterOption: true,
					filterOptionType: "formattedDate"
				},
				{
					id : "expiryDate",
					title: "Expiry Date",
					align: "center",
					titleAlign: "center",
					width: 100,
					filterOption: true,
					filterOptionType: "formattedDate"
				},
				{
					id: "perilName",
					title: "Peril",
					filterOption : true,
					width: 302
				},
				{
					id: "oldCommRate",
					title: "Old Comm Rate",
					width: 130,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer : function(val) {
						return formatToNthDecimal(val, 7);
					}
				},
				{
					id: "newCommRate",
					title: "New Comm Rate",
					width: 130,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer : function(val) {
						return formatToNthDecimal(val, 7);
					}
				}							
			],
			rows : objGiiss202History.histList.rows
		};

		tbgHistory = new MyTableGrid(historyTable);
		tbgHistory.pager = objGiiss202History.histList;
		tbgHistory.render("historyTable");
		
		$("btnExitHistory").observe("click", function(){
			overlayHistory.close();
			delete overlayHistory;
		});
		
	} catch (e) {
		showErrorMessage("History", e);
	}
</script>