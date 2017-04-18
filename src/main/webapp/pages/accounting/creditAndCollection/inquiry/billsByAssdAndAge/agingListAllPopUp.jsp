<div id="agingListAllPopUp" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 235px; width: 97.6%">
		<div id="agingListAllPopUpTG"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
	<div>
		<input id="fundCd"     type="hidden"  value="${fundCd}"/>
		<input id="branchCd"   type="hidden"  value="${branchCd}"/>
	</div>
</div>
<script type="text/javascript">
	var jsonShowAgingListAllPopUp = JSON.parse('${jsonShowAgingListAllPopUp}');
	
	agingListAllPopUpTableModel = {
			url: contextPath+"/GIACInquiryController?action=showAgingListAllPopUp&refresh=1&fundCd=" + $F("fundCd") + "&branchCd=" + $F("branchCd"),	
			options: {
				hideColumnChildTitle: true,
				width: '445px',
				height: '220px',
				onCellFocus : function(element, value, x, y, id) {
					tbgAgingListAllPopUp.keys.removeFocus(tbgAgingListAllPopUp.keys._nCurrentFocus, true);
					tbgAgingListAllPopUp.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgAgingListAllPopUp.keys.removeFocus(tbgAgingListAllPopUp.keys._nCurrentFocus, true);
					tbgAgingListAllPopUp.keys.releaseKeys();
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
				id : "gibrGfunFundCd",
				title : "Fund",
				titleAlign : 'left',
				width : '70px',
				filterOption : true,
				align : 'left',
			}, {
				id : "gibrBranchCd",
				title : "Branch",
				titleAlign : 'left',
				width : '70px',
				filterOption : true,
				align : 'left',
			}, {
				id : "columnHeading",
				title : "Age Level",
				titleAlign : 'left',
				width : '130px',
				filterOption : true,
				align : 'left',
			}, {
				id : "balanceAmtDue",
				title : "Total Balance Due",
				titleAlign : 'right',
				width : '143px',
				geniisysClass: 'money',
				align : 'right',
			}
			], 
			rows: jsonShowAgingListAllPopUp.rows
	};
	
	tbgAgingListAllPopUp = new MyTableGrid(agingListAllPopUpTableModel);
	tbgAgingListAllPopUp.pager = jsonShowAgingListAllPopUp;
	tbgAgingListAllPopUp.render('agingListAllPopUpTG'); 

	$("btnReturn").observe("click", function(){
		overlayAgingListAllPopUp.close();
		delete overlayAgingListAllPopUp;
	});
</script>