<div id="summarizedDistMainDiv">
	<div class="sectionDiv" style="width: 745px; height: 312px; margin-top: 8px;">
		<div id="policyDiv" class="sectionDiv" style="border: none; margin-top: 15px;">
			<label style="margin-left: 117px; margin-top: 6px;">Policy</label>
			<input type="text" id="policyNo" style="margin-left: 5px; width: 240px;" readonly="readonly"/>
			<%-- <div id="lineCdDiv" class="dspPolicy" style="float: left; width: 49px; height: 19px; margin-top: 2px; margin-left: 5px; border: 1px solid gray;">
				<input id="lineCd" title="Line Code" type="text" maxlength="2" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;">
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
			</div>
			<div id="sublineCdDiv" class="dspPolicy" style="float: left; width: 74px; height: 19px; margin-left: 1px; margin-top: 2px; border: 1px solid gray;">
				<input id="sublineCd" title="Subline Code" type="text" style="float: left; height: 12px; width: 46px; margin: 0px; border: none;">
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCdLOV" name="searchSublineCdLOV" alt="Go" style="float: right;"/>
			</div>
			<div id="issCdDiv" class="dspPolicy" style="float: left; width: 49px; height: 19px; margin-left: 1px; margin-top: 2px; border: 1px solid gray;">
				<input id="issCd" title="Issue Code" maxlength="2" type="text" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;">
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCdLOV" name="searchIssCdLOV" alt="Go" style="float: right; "/>
			</div>
			<div class="dspPolicy">
				<input id="issueYy" title="Year" maxlength="2" type="text" style="float: left; width: 33px; margin-left: 1px; text-align: right;">
				<input id="polSeqNo" title="Policy Sequence Number" maxlength="6" type="text" style="float: left; width: 53px; margin-left: 1px; text-align: right;" >
				<input id="renewNo" title="Renew Number" maxlength="2" type="text" style="float: left; width: 33px; margin-left: 1px; text-align: right;">
			</div> --%>
		</div>
		<div class="sectionDiv" style="border: none;">
			<label style="margin-left: 44px; margin-top: 6px;">Total Sum Insured</label>
			<input id="txtTsi" type="text" style="margin-left: 5px; width: 240px; float: left;  text-align: right;" readonly="readonly"/>
			<label style="margin-left: 14px; margin-top: 6px; float: left;">Premium</label>
			<input id="txtPremium" type="text" style="margin-left: 5px; width: 200px; float: left;  text-align: right;" readonly="readonly"/>
		</div>
		<div id="summarizedDistTGDiv" class="sectionDiv" style="height: 200px; width: 732px; margin-left: 5px; margin-top: 15px;">
			
		</div>
		<div id="sectionDiv">
			<label style="margin-left: 158px; margin-top: 6px;">Total</label>
			<input type="text" id="txtTotTsiSpct" style="width: 126px; margin-left: 5px; text-align: right;" readonly="readonly"/>
			<input type="text" id="txtTotDistTsi" style="width: 126px; text-align: right;" readonly="readonly"/>
			<input type="text" id="txtTotPremSpct" style="width: 126px; text-align: right;" readonly="readonly"/>
			<input type="text" id="txtTotDistPrem" style="width: 126px; text-align: right;" readonly="readonly"/>
		</div>
	</div>	
	<div id="buttonsDiv" class="sectionDiv" align="center" style="border: none; margin-top: 8px; margin-left: 5px; width: 732px;">
<!-- 	replaced by codes below --robert SR 4887 09.18.15 
		<input type="button" id="btnOk" class="button" value="Ok" style="float: left; width: 140px; margin-left: 9px;"/>
		<input type="button" id="btnRiPlacement" class="button" value="RI Placement" style="float: left; width: 140px; margin-left: 5px;"/>
		<input type="button" id="btnDistPerItem" class="button" value="Distribution Per Item" style="float: left; width: 140px; margin-left: 5px;"/>
		<input type="button" id="btnDistPerPeril" class="button" value="Distribution Per Peril" style="float: left; width: 140px; margin-left: 5px;"/>
		<input type="button" id="btnInsert" class="button" value="Insert" style="float: left; width: 140px; margin-left: 5px;"/> -->
		<input type="button" id="btnOk" class="button" value="Ok" style="float: left; width: 176px; margin-left: 9px;"/>
		<input type="button" id="btnRiPlacement" class="button" value="RI Placement" style="float: left; width: 176px; margin-left: 5px;"/>
		<input type="button" id="btnDistPerItem" class="button" value="Distribution Per Item" style="float: left; width: 176px; margin-left: 5px;"/>
		<input type="button" id="btnDistPerPeril" class="button" value="Distribution Per Peril" style="float: left; width: 176px; margin-left: 5px;"/>
		<input type="button" id="btnInsert" class="hidden" value="Insert" style="float: left; width: 140px; margin-left: 5px;"/>
	</div>
</div>
<script type="text/javascript">
try{	
	if(objUWGlobal.previousModule == "GIUWS005" ||
	   objUWGlobal.previousModule == "GIUWS004" || 		//added by Gzelle 06132014
	   objUWGlobal.previousModule == "GIUWS012" ||
	   objUWGlobal.previousModule == "GIUWS017" || 
	   objUWGlobal.previousModule == "GIUWS016" ||
	   objUWGlobal.previousModule == "GIUWS013" ||
	   objUWGlobal.previousModule == "GIUWS006"){
		$("hidDistNo").value = objGIPIS130.distNo;
		$("hidDistSeqNo").value = objGIPIS130.distSeqNo;
	}else if (objUWGlobal.previousModule == "GIUWS003"){//edgar 06/10/2014
		$("hidDistNo").value = objGIPIS130.distNo;
		$("hidDistSeqNo").value = objGIPIS130.distSeqNo;
	}
	
	function onLoadSummarizedDist(){
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=onLoadSummarizedDist",{
				parameters: {
					lineCd : $F("hidLineCd"),
					sublineCd : $F("hidSublineCd"),
					issCd : $F("hidIssCd"),
					issueYy : $F("hidIssueYy"),
					polSeqNo : $F("hidPolSeqNo"),
					renewNo : $F("hidRenewNo")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					var withBinder = nvl(objGIPIS130.details, null) == null ? "N" : nvl(objGIPIS130.details.withBinder, "N");
					if(response.responseText == "Y"){
						enableButton("btnRiPlacement");
					}else{
						disableButton("btnRiPlacement");
					}
					if($F("hidDistNo") != "" && withBinder != "Y"){
						enableButton("btnInsert");
					}else{
						disableButton("btnInsert");
						//enableButton("btnInsert"); //dito
					} 
				}
			});
		}catch(e){
			showMessageBox("onLoadSummarizedDist ",e);
		}
	}
	
	onLoadSummarizedDist();
	
	var jsonSummarizedDist = JSON.parse('${summarizedDist}');
	
	summarizedDistTableModel = {
		url : contextPath + "/GIPIPolbasicController?action=viewSummarizedDist&lineCd=" + $F("hidLineCd") + "&sublineCd=" + $F("hidSublineCd")
						  + "&issCd=" + $F("hidIssCd") + "&issueYy=" + $F("hidIssueYy") + "&polSeqNo=" + $F("hidPolSeqNo") + "&renewNo=" + $F("hidRenewNo") + "&refresh=1",
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgSummarizedDist.keys.removeFocus(tbgSummarizedDist.keys._nCurrentFocus, true);
					tbgSummarizedDist.keys.releaseKeys();
				}
			},
			width : '732px',
			height : '177px',
			onCellFocus : function(element, value, x, y, id) {
				tbgSummarizedDist.keys.removeFocus(tbgSummarizedDist.keys._nCurrentFocus, true);
				tbgSummarizedDist.keys.releaseKeys();
			}, 
			onRemoveRowFocus : function(element, value, x, y, id) {
				tbgSummarizedDist.keys.removeFocus(tbgSummarizedDist.keys._nCurrentFocus, true);
				tbgSummarizedDist.keys.releaseKeys();
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
				id : 'trtyName',
				title : 'Share',
				titleAlign: 'center',
				filterOption : true,
				sortable : true,
				width : '178px'
			},
			{
				id : 'tsiSpct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '134px',
				geniisysClass : 'rate',     
	            geniisysMinValue: '-999999999999.99',     
	            geniisysMaxValue: '999,999,999,999.99',
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : 'distTsi',
				title : 'Sum Insured',
				titleAlign: 'center',
				align: 'right',
				geniisysClass: 'money',
				sortable : true,
				width : '134px'
			},
			{
				id : 'premSpct',
				title : 'Percent Share',
				titleAlign: 'center',
				align: 'right',
				sortable : true,
				width : '134px',
				geniisysClass : 'rate',     
	            geniisysMinValue: '-999999999999.99',     
	            geniisysMaxValue: '999,999,999,999.99',
	            renderer: function(value){
					return formatToNineDecimal(value);
				}
			},
			{
				id : 'distPrem',
				title : 'Premium Amount',
				titleAlign: 'center',
				align: 'right',
				geniisysClass: 'money',
				sortable : true,
				width : '134px'
			}
		],
		rows : jsonSummarizedDist.rows
	};
	
	tbgSummarizedDist = new MyTableGrid(summarizedDistTableModel);
	tbgSummarizedDist.pager = jsonSummarizedDist;
	tbgSummarizedDist.render('summarizedDistTGDiv');
	tbgSummarizedDist.afterRender = function(){
		$("txtTotTsiSpct").value = formatToNineDecimal(tbgSummarizedDist.geniisysRows[0].totTsiSpct);
		$("txtTotDistTsi").value = formatCurrency(tbgSummarizedDist.geniisysRows[0].totDistTsi);
		$("txtTotPremSpct").value = formatToNineDecimal(tbgSummarizedDist.geniisysRows[0].totPremSpct);
		$("txtTotDistPrem").value = formatCurrency(tbgSummarizedDist.geniisysRows[0].totDistPrem);
		$("txtTsi").value = formatCurrency(tbgSummarizedDist.geniisysRows[0].totDistTsi);
		$("txtPremium").value = formatCurrency(tbgSummarizedDist.geniisysRows[0].totDistPrem);
		$("policyNo").value = $F("hidLineCd") + "-" + $F("hidSublineCd") + "-" + $F("hidIssCd") + "-" + $F("hidIssueYy")
						+ "-" + formatNumberDigits($F("hidPolSeqNo"),7) + "-" + formatNumberDigits($F("hidRenewNo"),2);
		/* $("lineCd").value = $F("hidLineCd");
		$("sublineCd").value = $F("hidSublineCd");
		$("issCd").value = $F("hidIssCd");
		$("issueYy").value = $F("hidIssueYy");
		$("polSeqNo").value = formatNumberDigits($F("hidPolSeqNo"),7);
		$("renewNo").value = formatNumberDigits($F("hidRenewNo"),2); */
	};
	
	function viewRiPlacement(){
		try{
			viewRiPlacementOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
				urlContent: true,
	            draggable: true,
	            urlParameters: {
	                    action : "viewSummDistRiPlacement",
	                    lineCd : $F("hidLineCd"),
	                    sublineCd : $F("hidSublineCd"),
	                    issCd : $F("hidIssCd"),
	                    issueYy : $F("hidIssueYy"),
	                    polSeqNo : $F("hidPolSeqNo"),
	                    renewNo : $F("hidRenewNo")
	            },
	            title: "Summarized Distribution",
	        	height: 291,
	        	width: 548
			});
		}catch(e){
			showMessageBox("viewRiPlacement",e);
		}
	}
	
	function viewDistPerItem(){
		viewDistPerItemOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            urlParameters: {
                    action : "viewDistItem",
                    lineCd : $F("hidLineCd"),
                    sublineCd : $F("hidSublineCd"),
                    issCd : $F("hidIssCd"),
                    issueYy : $F("hidIssueYy"),
                    polSeqNo : $F("hidPolSeqNo"),
                    renewNo : $F("hidRenewNo")
            },
            title: "Summarized Distribution (Per Item)",
        	height: 578,
        	width: 748
		});
	}
	
	function viewDistPerPeril(){
		viewDistPerPerilOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            urlParameters: {
                    action : "viewDistPeril",
                    lineCd : $F("hidLineCd"),
                    sublineCd : $F("hidSublineCd"),
                    issCd : $F("hidIssCd"),
                    issueYy : $F("hidIssueYy"),
                    polSeqNo : $F("hidPolSeqNo"),
                    renewNo : $F("hidRenewNo")
            },
            title: "Summarized Distribution (Per Peril)",
        	height: 558,
        	width: 614
		});
	}
	
	function insertSummDist(){
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=insertSummDist",{
				parameters: {
					lineCd : $F("hidLineCd"),
					sublineCd : $F("hidSublineCd"),
					issCd : $F("hidIssCd"),
					issueYy : $F("hidIssueYy"),
					polSeqNo : $F("hidPolSeqNo"),
					renewNo : $F("hidRenewNo"),
					distNo : $F("hidDistNo"),
					distSeqNo : $F("hidDistSeqNo")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if (objUWGlobal.previousModule != null){						
						if(objUWGlobal.previousModule == "GIUWS005"){
							$("parInfoMenu").show();
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							showPreliminaryOneRiskDistByTsiPrem();
						}else if(objUWGlobal.previousModule == "GIUWS004"){//added by Gzelle 06132014
							$("parInfoMenu").show();
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							showPreliminaryOneRiskDist();							
						}else if(objUWGlobal.previousModule == "GIUWS003"){//edgar 06/10/2014
							$("parInfoMenu").show();
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							showPreliminaryPerilDist();
						}else if(objUWGlobal.previousModule == "GIUWS012"){
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							showDistributionByPeril("Y");
						}else if(objUWGlobal.previousModule == "GIUWS017"){
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							var params = {};
							params.lineCd = $F("hidLineCd");
							params.sublineCd = $F("hidSublineCd");
							params.issCd = $F("hidIssCd");
							params.issueYy = $F("hidIssueYy");
							params.polSeqNo = $F("hidPolSeqNo");
							params.renewNo = $F("hidRenewNo");
							params.distNo = $F("hidDistNo");
							showDistByTsiPremPeril(params,'Y');
						}else if(objUWGlobal.previousModule == "GIUWS013"){
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							showDistributionByGroup("Y");
						}else if(objUWGlobal.previousModule == "GIUWS016"){
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							var params = {};
							params.lineCd = $F("hidLineCd");
							params.sublineCd = $F("hidSublineCd");
							params.issCd = $F("hidIssCd");
							params.issueYy = $F("hidIssueYy");
							params.polSeqNo = $F("hidPolSeqNo");
							params.renewNo = $F("hidRenewNo");
							params.distNo = $F("hidDistNo");
							showDistrByTsiPremGroup(params,'Y');
						}if(objUWGlobal.previousModule == "GIUWS006"){
							$("parInfoMenu").show();
							objGIPIS130.details = null;
							objGIPIS130.distNo = null;
							objGIPIS130.distSeqNo = null;
							showPreliminaryPerilDistByTsiPrem();
						}

						viewSummarizedDistOverlay.close();
					}
				}
			});
		}catch(e){
			showMessageBox("insertSummDist ",e);
		}
	}
	
	$("btnOk").observe("click", function(){
		viewSummarizedDistOverlay.close();
	});
	$("btnRiPlacement").observe("click", viewRiPlacement);
	$("btnDistPerItem").observe("click", viewDistPerItem);
	$("btnDistPerPeril").observe("click", viewDistPerPeril);
	$("btnInsert").observe("click", insertSummDist);
}catch(e){
	showMessageBox("summarizedDistribution page: ", e);
}
</script>