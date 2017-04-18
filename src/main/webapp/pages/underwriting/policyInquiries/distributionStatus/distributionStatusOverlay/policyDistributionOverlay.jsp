<div id="policyDistributionMainDiv">
	<div id="policyDistributionMainTGDiv" name="policyDistributionMainTGDiv" class="sectionDiv" style="height: 200px; width: 99%;">
		<div id="divPolicyDistributionMainTG">
			Table Grid1
		</div>
	</div>
	<div id="policyDistributionDtlTGDiv" name="policyDistributionMainTGDiv" class="sectionDiv" style="height: 200px; width: 99%;">
		<div id="divPolicyDistributionDtlTG">
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
			<input type="button" class="button" id="btnRIPlacement" value="RI Placement" style="width: 140px;">
			<input type="button" class="button" id="btnDistPerItem" value="Dist Per Item" style="width: 140px;">
			<input type="button" class="button" id="btnRIPlacementInquiry" value="RI Placement Inquiry" style="width: 140px;">
			<input type="hidden" id="hidParId" name="hidParId" value="${parId}"/>
			<input type="hidden" id="hidDistNo" name="hidDistNo" value="${distNo}"/>
			<input type="hidden" id="hidDistFlag" name="hidDistFlag" value="${distFlag}"/>
			<input type="hidden" id="hidPolicyNo" name="hidPolicyNo" value="${policyNo}"/>
			<input type="hidden" id="hidStatus" name="hidStatus" value="${policyStatus}"/>
			<input type="hidden" id="hidLineCd" name="hidLineCd" value="${lineCd}"/>
			<input type="hidden" id="hidSublineCd" name="hidSublineCd" value="${sublineCd}"/>
			<input type="hidden" id="hidIssCd" name="hidIssCd" value="${issCd}"/>
			<input type="hidden" id="hidIssueYy" name="hidIssueYy" value="${issueYy}"/>
			<input type="hidden" id="hidPolSeqNo" name="hidPolSeqNo" value="${polSeqNo}"/>
			<input type="hidden" id="hidRenewNo" name="hidRenewNo" value="${renewNo}"/>
		</div>
	</div>
</div>
<script type="text/javascript">
try{
	

	var jsonViewDistribution = JSON.parse('${viewDistribution}');
	var postFlag;
	jsonViewDistributionDtl = new Object();
	objCurrPolicyDS = {};
	
	var viewPolicyDistributionDtlTableModel = {
			id: 2,
			options : {
				hideColumnChildTitle: true,
				width : '710px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgViewPolicyDistributionDtl.keys.removeFocus(tbgViewPolicyDistributionDtl.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgViewPolicyDistributionDtl.keys.removeFocus(tbgViewPolicyDistributionDtl.keys._nCurrentFocus, true);
					tbgViewPolicyDistributionDtl.keys.releaseKeys();
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
	
	tbgViewPolicyDistributionDtl = new MyTableGrid(viewPolicyDistributionDtlTableModel);
	tbgViewPolicyDistributionDtl.pager = jsonViewDistributionDtl;
	tbgViewPolicyDistributionDtl.mtgId = 2;
	tbgViewPolicyDistributionDtl.render('divPolicyDistributionDtlTG');
	tbgViewPolicyDistributionDtl.afterRender = function(){
		if(tbgViewPolicyDistributionDtl.geniisysRows.length > 0){
			var rec = tbgViewPolicyDistributionDtl.geniisysRows[0];
			tbgViewPolicyDistributionDtl.selectRow('0');
			$("txtSumDistSpct").value = rec == null ? "" : formatToNineDecimal(rec.sDistSpct);
			$("txtSumDistTsi").value = rec == null ? "" : formatCurrency(rec.sDistTsi);
			$("txtSumDistSpct1").value = rec == null ? "" : formatToNineDecimal(rec.sDistSpct1);
			$("txtSumDistPrem").value = rec == null ? "" : formatCurrency(rec.sDistPrem);
			tbgViewPolicyDistributionDtl.keys.removeFocus(tbgViewPolicyDistributionDtl.keys._nCurrentFocus, true); //added by robert SR 4887 09.18.15
			tbgViewPolicyDistributionDtl.keys.releaseKeys(); //added by robert SR 4887 09.18.15
		}
	};
	
	viewPolicyDistributionTableModel = {
			url : contextPath + "/GIPIPolbasicController?action=viewDistribution&refresh=1&parId=" + $F("hidParId") + "&distNo=" + $F("hidDistNo") + "&distFlag=" + $F("hidDistFlag") + "&policyNo=" + $F("hidPolicyNo") + "&policyStatus=" + $F("hidStatus"),
			options : {
				hideColumnChildTitle: true,
				width : '710px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgViewPolicyDistribution.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true); //added by robert SR 4887 09.18.15
					tbgViewPolicyDistribution.keys.releaseKeys(); //added by robert SR 4887 09.18.15
					objCurrPolicyDS = tbgViewPolicyDistribution.geniisysRows[y];
					enableButtons(tbgViewPolicyDistribution.geniisysRows[y]);
					showPolicyDSDtlTG(true);					
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					showPolicyDSDtlTG(false);
					disableButton("btnRIPlacement");
					disableButton("btnRIPlacementInquiry");
					disableButton("btnDistPerItem");
					tbgViewPolicyDistribution.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true);
					tbgViewPolicyDistribution.keys.releaseKeys();
				},
				afterRender : function(element, value, x, y, id) {;
					tbgViewPolicyDistribution.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true);
					tbgViewPolicyDistribution.keys.releaseKeys();
				},
				onSort: function(){
					showPolicyDSDtlTG(false); // added by robert SR 4887 10.05.15
					disableButton("btnRIPlacement"); // added by robert SR 4887 10.05.15
					disableButton("btnRIPlacementInquiry"); // added by robert SR 4887 10.05.15
					disableButton("btnDistPerItem"); // added by robert SR 4887 10.05.15
					tbgViewPolicyDistribution.keys.removeFocus(tbgViewPolicyDistribution.keys._nCurrentFocus, true);
					tbgViewPolicyDistribution.keys.releaseKeys();
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
				width : '160px',
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
        	}, {
				id : "distNo",
				title : "Distribution No.",
				width : '100px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "distSeqNo",
				title : "Group No.",
				width : '70px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				//added by robert SR 4887 09.18.15
    		    id: 'perilCd', 
    		    title: objGipis130.postFlag == 'O' ? '' : 'Peril',
    		    width :  objGipis130.postFlag == 'O' ? '0' : '50px',
    		    visible: objGipis130.postFlag == 'O' ? false : true,
    		    altTitle: 'Peril Code'
			}, {
    		    id: 'perilName', 
    		    title: objGipis130.postFlag == 'O' ? '' : 'Peril Name',
    		    width :  objGipis130.postFlag == 'O' ? '0' : '150px',
    		    visible: objGipis130.postFlag == 'O' ? false : true,
    		    altTitle: 'Peril Name'
/* 			}, {
				id : "premAmt",
				title : "Premium",
				width : '110px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right' */
			}, {
				id : "tsiAmt",
				title : "Total Sum Insured",
				width : '110px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right'
			}, { // added by robert SR 4887 10.05.15 
				id : "premAmt",
				title : "Premium",
				width : '110px',
				titleAlign : 'leftAligned',
				geniisysClass: 'money',
				align : 'right'
			}],
			rows : jsonViewDistribution.rows
	};
	
	tbgViewPolicyDistribution = new MyTableGrid(viewPolicyDistributionTableModel);
	tbgViewPolicyDistribution.pager = jsonViewDistribution;
	tbgViewPolicyDistribution.render('divPolicyDistributionMainTG');
	
	function enableButtons(rec){
		postFlag = rec == null ? "" : rec.postFlag;
		
		if(rec.status == 'U w/ Facultative' || rec.status == 'D w/ Facultative'){
			enableButton("btnRIPlacement");
			enableButton("btnRIPlacementInquiry");
		} else {
			disableButton("btnRIPlacement");
			disableButton("btnRIPlacementInquiry");
		}
		
		if(postFlag == 'O'){
			disableButton("btnDistPerItem");
		} else {
			enableButton("btnDistPerItem");
		}
	}
	
	function showPolicyDSDtlTG(show){	
		try{	
			if(show){
				var distNo = objCurrPolicyDS.distNo;
				var distSeqNo = objCurrPolicyDS.distSeqNo;
				var lineCd = objCurrPolicyDS.lineCd;
				var perilCd = objCurrPolicyDS.perilCd;
				var postFlag = objCurrPolicyDS.postFlag;
				if(postFlag == 'P'){
					tbgViewPolicyDistributionDtl.url = contextPath+"/GIPIPolbasicController?action=getDistDtl2&distNo=" + distNo + "&distSeqNo=" + distSeqNo + "&lineCd=" + lineCd + "&perilCd=" + perilCd + "&postFlag" + postFlag;
					tbgViewPolicyDistributionDtl._refreshList();
				} else {
					tbgViewPolicyDistributionDtl.url = contextPath+"/GIPIPolbasicController?action=getDistDtl&distNo=" + distNo + "&distSeqNo=" + distSeqNo;
					tbgViewPolicyDistributionDtl._refreshList();
				}
			} else{
				if($("policyDistributionDtlTGDiv") != null){
					clearTableGridDetails(tbgViewPolicyDistributionDtl);
					$("txtSumDistSpct").clear(); // added by robert SR 4887 10.05.15
					$("txtSumDistTsi").clear(); // added by robert SR 4887 10.05.15
					$("txtSumDistSpct1").clear(); // added by robert SR 4887 10.05.15
					$("txtSumDistPrem").clear(); // added by robert SR 4887 10.05.15
				}
			}
		}catch(e){
			showErrorMessage("showPolicyDSDtl",e);
		}
	}
	
	function viewDistPerItem(){
		viewDistributionPerItemOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            asynchronous: false,
            evalScripts: true,
            urlParameters: {
                    action		 : "viewDistributionPerItem",
                    parId        : $("hidParId").value,
                    distNo       : $("hidDistNo").value,
                    distFlag     : $("hidDistFlag").value,
                    policyNo     : $("hidPolicyNo").value,
                    policyStatus : $("hidStatus").value,
                    itemSw		 : 'Y' // added by robert SR 4887 10.05.15
            },
            title: "Distribution Per Item", //"Peril Distribution", // changed by robert SR 4887 10.05.15
        	height: 500,
        	width: 720
		});
	}
	
	function viewRIPlacement(){
		viewRIPlacementOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            urlParameters: {
                    action		    : "viewRIPlacement",
                    distNo          : objCurrPolicyDS.distNo,
                    distSeqNo       : objCurrPolicyDS.distSeqNo,
                    placementSource : objCurrPolicyDS.placementSource,
            },
            title: "RI Placement",
        	height: 300,
        	width: 720
		});
	}
	
	$("btnDistPerItem").observe("click", viewDistPerItem);
	$("btnRIPlacement").observe("click", viewRIPlacement);
	$("btnRIPlacementInquiry").observe("click", function() {
	 /* viewDistributionOverlay.close();
		delete viewDistributionOverlay;
		showViewRIPlacementsOnGIPIS130(); */ //benjo 07.20.2015 UCPBGEN-SR-19626
		checkRIPlacementAccess(); //benjo 07.20.2015 UCPBGEN-SR-19626
	});
	
	/* benjo 07.20.2015 UCPBGEN-SR-19626 */
	function checkRIPlacementAccess(){
		new Ajax.Request(contextPath+"/GIRIBinderController", {
			method: "GET",
			parameters: {
				action: "checkRIPlacementAccess",
				lineCd: $F("hidLineCd"),
				issCd: $F("hidIssCd")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					viewDistributionOverlay.close();
					delete viewDistributionOverlay;
					showViewRIPlacementsOnGIPIS130();
				}
			}
		});
	}
	
	$("btnOk").observe("click", function() {
		viewDistributionOverlay.close();
		delete viewDistributionOverlay;
	});
	
	disableButton("btnRIPlacement");
	disableButton("btnRIPlacementInquiry");
	disableButton("btnDistPerItem");
	// added by robert SR 4887 10.05.15
	if(objGipis130.postFlag == 'O'){
		$("btnDistPerItem").hide();
	} else {
		$("btnDistPerItem").show();
	}
} catch (e) {
	showErrorMessage("Policy Distribution Overlay.", e);
}
</script>