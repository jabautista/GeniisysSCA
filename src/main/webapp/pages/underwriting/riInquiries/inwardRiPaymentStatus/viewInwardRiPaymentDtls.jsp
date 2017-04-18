<div id="inwRiPaytDtls" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 235px; width: 97.6%">
		<div id="inwRiPaytDtlsTG"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
</div>
<script type="text/javascript">
	var jsonInwRiDetails = JSON.parse('${jsonInwRiDetails}');
	
	inwRiDetailsTableModel = {
			url: contextPath+"/GIRIInpolbasController?action=showInwRiDetailsOverlay&refresh=1",
			options: {
				hideColumnChildTitle: true,
				width: '380px',
				height: '210px',
				onCellFocus : function(element, value, x, y, id) {
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgInwRiDetails.keys.removeFocus(tbgInwRiDetails.keys._nCurrentFocus, true);
					tbgInwRiDetails.keys.releaseKeys();
				}
			},
			columnModel : [{
			    id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false
			}, {
				id : "refNo",
				title : "Reference No.",
				width : '120'
			}, {
				id : 'payDate',
				title : 'Date',
				width : '120',
				renderer : function(value){
					return dateFormat(value, 'mm-dd-yyyy');
				}
			}, {
				id : "collectionAmt",
				title : "Amount",
				titleAlign : 'right',
				width : '130',
				geniisysClass: 'money',
				align : 'right',
			}
			], 
			rows: jsonInwRiDetails.rows
	};
	
	tbgInwRiDetails = new MyTableGrid(inwRiDetailsTableModel);
	tbgInwRiDetails.pager = jsonInwRiDetails;
	tbgInwRiDetails.render('inwRiPaytDtlsTG'); 
	
	$("btnReturn").observe("click", function(){
		overlayInwRiDetails.close();
		delete overlayInwRiDetails;
	});
</script>