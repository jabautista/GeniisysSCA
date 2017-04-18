<div id="perilDistributionMainDiv">
	<div id="perilDistributionMainTGDiv" name="perilDistributionMainTGDiv" class="sectionDiv" style="height: 200px; width: 99%;">
		<div id="divPerilDistributionMainTG">
			Table Grid1
		</div>
	</div>
	<div id="policyPerilDtlTGDiv" name="policyPerilDtlTGDiv" class="sectionDiv" style="height: 200px; width: 99%;">
		<div id="divPerilDistributionDtlTG">
			Table Grid2
		</div>
	</div>
	<div id="grandTotalsDiv" name="totalsDiv" class="sectionDiv" style="height: 25px; width: 99%; padding-bottom: 15px;">
		<div id="totalsDiv">
			<table align="right" border="0">
				<tbody>
					<td class="rightAligned" style="width: 10%;">Total : </td>
					<td class="rightAligned">
						<input id="txtSumDistSpct" type="text" class="rightAligned" name="txtSumDistSpct" style="width: 120px;" readonly="readonly"/>
						<input id="txtSumDistTsi" type="text" class="rightAligned" name="txtSumDistTsi" style="width: 120px;" readonly="readonly"/>
						<input id="txtSumDistSpct1" type="text" class="rightAligned" name="txtSumDistSpct1" style="width: 120px;" readonly="readonly"/>
						<input id="txtSumDistPrem" type="text" class="rightAligned" name="txtSumDistPrem" style="width: 120px;" readonly="readonly"/>
					</td>
				</tbody>
			</table>
		</div>
	</div>
	<div id="buttonsMainDiv" name="buttonsMainDiv" class="sectionDiv" style="height: 25px; width: 99%; padding-bottom: 15px;">
		<div class="buttonsDiv" style="margin-bottom: 10px; margin-top: 5px;">
			<input type="button" class="button" id="btnOk" value="Ok" style="width: 140px;">
			<input type="hidden" id="hidParId" name="hidParId" value="${parId}"/>
			<input type="hidden" id="hidDistNo" name="hidDistNo" value="${distNo}"/>
			<input type="hidden" id="hidDistFlag" name="hidDistFlag" value="${distFlag}"/>
			<input type="hidden" id="hidPolicyNo" name="hidPolicyNo" value="${policyNo}"/>
			<input type="hidden" id="hidStatus" name="hidStatus" value="${policyStatus}"/>
		</div>
	</div>
</div>
<script type="text/javascript">
try{
	
	var jsonViewDistributionItem = JSON.parse('${viewDistribution}');
	jsonViewDistributionItemDtl = new Object();
	objCurrPolicyDS = {};
	
	var viewPolicyDistributionItemDtlTableModel = {
			id: 2,
			options : {
				hideColumnChildTitle: true,
				width : '710px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgViewPolicyDistributionItemDtl.keys.removeFocus(tbgViewPolicyDistributionItemDtl.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionItemDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgViewPolicyDistributionItemDtl.keys.removeFocus(tbgViewPolicyDistributionItemDtl.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionItemDtl.keys.releaseKeys();
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "trtyName",
				title : "Treaty Name",
				width : '190px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "distSpct",
				title : "Percent Share",
				width : '120px',
				titleAlign : 'leftAligned',
				align : 'right',
				geniisysClass : 'rate', //'money', changed by robert SR 4887 09.18.15
	            geniisysMinValue: '0.00', //'-999999999999.99', changed by robert SR 4887 09.18.15
	            geniisysMaxValue: '100.00', //'999,999,999,999.99', changed by robert SR 4887 09.18.15
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			}, {
				id : "distTsi",
				title : "Sum Insured",
				width : '120px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right'
			}, {
				id : "distSpct1",
				title : "Percent Share",
				width : '130px',
				titleAlign : 'leftAligned',
				align : 'right',
				geniisysClass : 'rate', //'money', changed by robert SR 4887 09.18.15
	            geniisysMinValue: '0.00', //'-999999999999.99', changed by robert SR 4887 09.18.15
	            geniisysMaxValue: '100.00', //'999,999,999,999.99', changed by robert SR 4887 09.18.15
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			}, {
				id : "distPrem",
				title : "Premium Amount",
				width : '130px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right'
			}],
			resetChangeTag: true,
			rows: []
	};
	
	tbgViewPolicyDistributionItemDtl = new MyTableGrid(viewPolicyDistributionItemDtlTableModel);
	tbgViewPolicyDistributionItemDtl.pager = jsonViewDistributionItemDtl;
	tbgViewPolicyDistributionItemDtl.mtgId = 2;
	tbgViewPolicyDistributionItemDtl.render('divPerilDistributionDtlTG');
	tbgViewPolicyDistributionItemDtl.afterRender = function(){
		tbgViewPolicyDistributionItemDtl.keys.removeFocus(tbgViewPolicyDistributionItemDtl.keys._nCurrentFocus, true);
		tbgViewPolicyDistributionItemDtl.keys.releaseKeys();
		
		if(tbgViewPolicyDistributionItemDtl.geniisysRows.length > 0){
			var rec = tbgViewPolicyDistributionItemDtl.geniisysRows[0];
			tbgViewPolicyDistributionItemDtl.selectRow('0');
			$("txtSumDistSpct").value = rec == null ? "" : formatToNineDecimal(rec.sDistSpct);
			$("txtSumDistTsi").value = rec == null ? "" : formatCurrency(rec.sDistTsi);
			$("txtSumDistSpct1").value = rec == null ? "" : formatToNineDecimal(rec.sDistSpct1);
			$("txtSumDistPrem").value = rec == null ? "" : formatCurrency(rec.sDistPrem);
		}
	};
	
	
	viewPolicyDistributionItemTableModel = {
			//added itemSw by robert SR 4887 10.05.15
			url : contextPath + "/GIPIPolbasicController?action=viewDistribution&refresh=1&itemSw=Y&parId=" + $F("hidParId") + "&distNo=" + $F("hidDistNo") + "&distFlag=" + $F("hidDistFlag") + "&policyNo=" + $F("hidPolicyNo") + "&policyStatus=" + $F("hidStatus"),
			options : {
				hideColumnChildTitle: true,
				width : '710px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgViewPolicyDistributionItem.keys.removeFocus(tbgViewPolicyDistributionItem.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionItem.keys.releaseKeys();
					objCurrPolicyDS = tbgViewPolicyDistributionItem.geniisysRows[y];
					objCurrPolicyDS.selectedIndex = y;
					showPolicyDSDtlTG(true);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objCurrPolicyDS = null;
					tbgViewPolicyDistributionItem.keys.removeFocus(tbgViewPolicyDistributionItem.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionItem.keys.releaseKeys();
					showPolicyDSDtlTG(false);
				},
				onSort: function(){ //added by robert SR 4887 10.05.15
					objCurrPolicyDS = null;
					tbgViewPolicyDistributionItem.keys.removeFocus(tbgViewPolicyDistributionItem.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionItem.keys.releaseKeys();
					showPolicyDSDtlTG(false);
				},
				afterRender : function(element, value, x, y, id) {
					tbgViewPolicyDistributionItem.keys.removeFocus(tbgViewPolicyDistributionItem.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionItem.keys.releaseKeys();
					//initializeButtons(); removed by robert SR 4887 10.05.15
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "policyNo",
				title : "Policy No.",
				width : '180px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
			/* added by robert SR 4887 09.18.15 */
				id : "distNo",
				title : "Distribution No.",
				width : '100px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "distSeqNo",
				title : "Group No.",
				width : '75px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "itemNo",
				title : "Item No.",
				width : '75px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
			/* end robert SR 4887 09.18.15 */
				id : "perilName",
				title : "Peril",
				width : '180px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
    		    id: 'distFlag status',
    		    title: 'Status',
    		    width : '140px',
    		    children : [
    	            {
    	                id : 'distFlag',
    	                width: 30,
    	            },
    	            {
    	                id : 'status', 
    	                width: 110,
    	            }
    	        ]
        	/* }, { commented out by robert SR 4887 09.18.15
					id : "distNo",
					title : "Distribution No.",
					width : '100px',
					titleAlign : 'leftAligned',
					align : 'left'
				}, {
					id : "distSeqNo",
					title : "Group No.",
					width : '75px',
					titleAlign : 'leftAligned',
				align : 'left' */
				}, { // added by robert SR 4887 10.05.15
					id : "tsiAmt",
					title : "Total Sum Insured",
					width : '110px',
					titleAlign : 'leftAligned',
					geniisysClass: 'money',
					align : 'right'
				}, {
					id : "premAmt",
					title : "Premium",
					width : '110px',
					titleAlign : 'leftAligned',
					geniisysClass: 'money',
					align : 'right'
			}],
			rows : jsonViewDistributionItem.rows
	};
	
	tbgViewPolicyDistributionItem = new MyTableGrid(viewPolicyDistributionItemTableModel);
	tbgViewPolicyDistributionItem.pager = jsonViewDistributionItem;
	tbgViewPolicyDistributionItem.render('divPerilDistributionMainTG');
	
	function showPolicyDSDtlTG(show){	
		try{	
			if(show){
				var distNo = objCurrPolicyDS.distNo;
				var distSeqNo = objCurrPolicyDS.distSeqNo;
				var lineCd = objCurrPolicyDS.lineCd;
				var perilCd = objCurrPolicyDS.perilCd;
				var postFlag = objCurrPolicyDS.postFlag;
				//added itemNo by robert to get the correct data SR 4887 10.05.15
				var itemNo = objCurrPolicyDS.itemNo;
				tbgViewPolicyDistributionItemDtl.url = contextPath+"/GIPIPolbasicController?action=getDistDtl2&distNo=" + distNo + "&distSeqNo=" + distSeqNo + "&lineCd=" + lineCd + "&perilCd=" + perilCd + "&itemNo=" + itemNo+ "&postFlag" + postFlag  ;
				tbgViewPolicyDistributionItemDtl._refreshList();
			} else{
				if($("policyDistributionDtlTGDiv") != null){
					clearTableGridDetails(tbgViewPolicyDistributionItemDtl); 
					$("txtSumDistSpct").clear(); //added by robert SR 4887 10.05.15
					$("txtSumDistTsi").clear(); //added by robert SR 4887 10.05.15
					$("txtSumDistSpct1").clear(); //added by robert SR 4887 10.05.15
					$("txtSumDistPrem").clear(); //added by robert SR 4887 10.05.15
				}
			}
		}catch(e){
			showErrorMessage("showPolicyDSDtl",e);
		}
	}
	
	$("btnOk").observe("click", function() {
		viewDistributionPerItemOverlay.close();
		delete viewDistributionPerItemOverlay;
	});

} catch (e) {
	showErrorMessage("Peril Distribution Overlay.", e);
}
</script>