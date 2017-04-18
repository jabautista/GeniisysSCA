<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<div id="zoneDetailMainDiv" style="width: 860px; height: 407px; ">
	<div class="sectionDiv" style="width: 860px; height: 407px; margin: 5px;">
		<table style="margin: 10px 0 5px 15px;">
			<tr><!-- added row for line name : edgar 03/20/2015 -->
				<td style="padding-left: 43px;">Line Name</td>
				<td><input id="txtLine" type="text" readonly="readonly" style="width: 250px;" tabindex="101"/></td>
			</tr>
			<tr>
				<td style="padding-right: 10px;">Distribution Share</td>
				<td><input id="txtShare" type="text" readonly="readonly" style="width: 250px;" tabindex="101"/></td>
			</tr>
		</table>
		
		<div id="zoneDetailDiv" style="width: 700px; height: 310px; margin: 5px 5px 5px 10px;"></div>
				
		<div id="totalsDiv" style="width: 835px; height: 30px; margin-top: 15px;">
			<label style="padding: 6px 10px 0 460px;">Totals</label><!-- change padding : edgar 03/20/2015 -->
			<input id="txtTotalTsiAmt" type="text" class="money rightAligned" readonly="readonly" style="width: 163px; margin-left: 5px;"><!-- changed width : edgar 03/20/2015 -->
			<input id="txtTotalPremAmt" type="text" class="money rightAligned" readonly="readonly"  style="width: 140px;"><!-- changed width : edgar 03/20/2015 -->
		</div>
	
	</div>
	
	<div class="buttonsDiv">
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 90px;" tabindex="102">
	</div>
</div>

<script type="text/javascript">
try{
	$("btnReturn").focus();
	$("txtShare").value = unescapeHTML2(objGIPIS901.fireSelectedRow.shareName);
	$("txtLine").value = unescapeHTML2(objGIPIS901.fireSelectedRow.lineName);//edgar 03/20/2015
	$("txtTotalTsiAmt").value = formatCurrency('${sumShareTsiAmt}');
	$("txtTotalPremAmt").value = formatCurrency('${sumSharePremAmt}');
	
	$("btnReturn").observe("click", function(){
		zoneDetailTG.onRemoveRowFocus();
		overlayZoneDetailDialog.close();
	});
	
	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	var objZoneDetail = new Object();
	objZoneDetail.tableGrid = JSON.parse('${zoneDetailTG}'.replace(/\\/g, '\\\\'));
	objZoneDetail.objRows = objZoneDetail.tableGrid.rows || [];
	objZoneDetail.objList = [];	// holds all the geniisys rows
	
	try{
		var zoneDetailTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireZoneDetail&refresh=1&asOfSw="+objGIPIS901.asOfSw+
				 "&lineCdFi="+objGIPIS901.lineCdFi+"&shareCd="+objGIPIS901.fireSelectedRow.shareCd+"&zoneType="+$F("hidZoneType"), //edgar 03/20/2015
			options: {
				width: '840px',
				height: '295px',
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = zoneDetailTG.geniisysRows[y];
				},
				onRemoveRowFocus: function(){
					zoneDetailTG.keys.releaseKeys();
					selectedRowInfo = null;
				},
				onRefresh: function(){
					zoneDetailTG.onRemoveRowFocus();
				},
				onSort: function(){
					zoneDetailTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						zoneDetailTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},    
				{
					id: 'shareCd',
					width: '0px',
					visible: false
				},      
				{
					id: 'shareName',
					width: '0px',
					visible: false
				},   
				{
					id: 'asOfSw',
					width: '0px',
					visible: false
				},      
				{
					id: 'userId',
					width: '0px',
					visible: false
				},   
				{
					id: 'policyNo',
					title: 'Policy No',
					width: '165px', //changed width : edgar 03/20/2015
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},  
				{
					id: 'assdName',
					title: 'Assured Name',
					width: '320px', //changed width : edgar 03/20/2015
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'shareTsiAmt',
					title: 'TSI Amount',
					width: '170px', //changed width : edgar 03/20/2015
					titleAlign: 'right',
					align:	'right',
					visible: true,
					sortable: true,
					geniisysClass: 'money'
				},
				{
					id: 'sharePremAmt',
					title: 'Premium Amount',
					width: '145px', //changed width : edgar 03/20/2015
					titleAlign: 'right',
					align:	'right',
					visible: true,
					sortable: true,
					geniisysClass: 'money'
				}
			],
			rows: objZoneDetail.objRows
		};
		
		zoneDetailTG = new MyTableGrid(zoneDetailTableModel);
		zoneDetailTG.pager = objZoneDetail.tableGrid;
		zoneDetailTG.render('zoneDetailDiv');
	}catch(e){
		showErrorMessage("Zone Master table grid error", e);
	}
	
}catch(e){
	showErrorMessage("popup page error", e);
}
</script>