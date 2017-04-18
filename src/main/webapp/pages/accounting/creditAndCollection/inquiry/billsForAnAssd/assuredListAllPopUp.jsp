<div id="assuredListAllPopUp" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 320px; width: 97.6%">
		<div id="assuredListAllPopUpTG"></div>
	</div>
	<center>
		<input type="button" class="button" value="Sort" id="btnSort" style="margin-top: 5px; width: 100px;" />
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	</center>
	<div>
		<input id="assdNo"     type="hidden"  value="${assdNo}"/>
	</div>
</div>
<script type="text/javascript">
	var jsonShowAssuredListAllPopUp = JSON.parse('${jsonShowAssuredListAllPopUp}');
	
	assuredListAllPopUpTableModel = {
			url: contextPath+"/GIACInquiryController?action=showAssuredListAllPopUp&refresh=1&assdNo=" + $F("assdNo"),
			options: {
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function() {
						tbgAssuredListAllPopUp.keys.removeFocus(tbgAssuredListAllPopUp.keys._nCurrentFocus, true);
						tbgAssuredListAllPopUp.keys.releaseKeys();
					}
				},
				hideColumnChildTitle: true,
				width: '525px',
				height: '295px',
				onCellFocus : function(element, value, x, y, id) {
					tbgAssuredListAllPopUp.keys.removeFocus(tbgAssuredListAllPopUp.keys._nCurrentFocus, true);
					tbgAssuredListAllPopUp.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgAssuredListAllPopUp.keys.removeFocus(tbgAssuredListAllPopUp.keys._nCurrentFocus, true);
					tbgAssuredListAllPopUp.keys.releaseKeys();
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
			},{
				id : "assdNo",
				title : "Assured No.",
				titleAlign : 'center',
				width : '100px',
				filterOption : true,
				filterOptionType : 'integerNoNegative',
				align : 'right',
			},{
				id : "assdName",
				title : "Assured Name",
				titleAlign : 'center',
				width : '280px',
				filterOption : true,
				align : 'left',
			},{
				id : "balanceAmtDue",
				title : "Balance Due",
				titleAlign : 'right',
				width : '112px',
				geniisysClass: 'money',
				filterOption : true,
				filterOptionType : 'number',
				align : 'right',
			}], 
			rows: jsonShowAssuredListAllPopUp.rows	
	};
	tbgAssuredListAllPopUp = new MyTableGrid(assuredListAllPopUpTableModel);
	tbgAssuredListAllPopUp.pager = jsonShowAssuredListAllPopUp;
	tbgAssuredListAllPopUp.render('assuredListAllPopUpTG');
	
	function showSortPopUp(){
		try {
			overlayBillsUnderAgeSortPopUp = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action    : "showAssuredListSortPopUp",																
									ajax      : "1",
									assdNo    : $F("assdNo"),
					},
				    title: "Sort",
				    height: 280,
				    width: 360,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay Error: " , e);
			}
	}
	
	$("btnSort").observe("click", function(){
		showSortPopUp();
	});
	
	$("btnReturn").observe("click", function(){
		overlayAssuredListAllPopUp.close();
		delete overlayAssuredListAllPopUp;
	});
</script>