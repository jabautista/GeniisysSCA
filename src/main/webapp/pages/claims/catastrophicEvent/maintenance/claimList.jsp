<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div class="sectionDiv" style="width: 798px; margin-top: 5px;">
	<div style="padding-top: 10px;">
		<div id="claimListTable" style="height: 348px; margin-left: 11px;"></div>
	</div>
	<div style="text-align: center;">
		<div style="float: left; margin: 15px 0 0 20px;">
			<input type="checkbox" id="chkCheckAll" style="float: left; margin-right: 10px;"/>
			<label for="chkCheckAll">Check All</label>
		</div>
		<div style="float: left; margin-left: 200px;">
			<input type="button" class="button" id="btnOk" value="Ok" style="width: 100px; margin: 10px auto;"/>
			<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 100px; margin: 10px auto;"/>
		</div>		
	</div>
</div>
<script type="text/javascript">
	try {
		/* 
		var objCatastrophicEventDetails = null;
		
		objGicls056ClaimList.exitPage = null; */
		/* try{
			showMessageBox(contextPath + "/GICLCatastrophicEventController?action=showGicls056ClaimList&refresh=1&lossCatCd=" + $F("lossCatCd")
					+ "&startDate=" + $F("txtStartDate")
					+ "&endDate=" + $F("txtEndDate")
					+ "&location=" + $F("txtLocation")
				    + "&provinceCd" + objFireDetails.provinceCd
					+ "&cityCd" + objFireDetails.cityCd
					+ "&districtNo" + objFireDetails.cityCd
					+ "&blockNo" + objFireDetails.cityCd);
		} catch (e) {
		} */
				
		var objGicls056ClaimList = {};
		objGicls056ClaimList.claimList = JSON.parse('${jsonCatastrophicEventClaimList}');
		
		var checkedClaims2 = [];
		
		var claimListTable = {};
		
		claimListTable = {
			id : "tbgClaimList",
			url : contextPath + "/GICLCatastrophicEventController?action=showGicls056ClaimList&refresh=1&lossCatCd=" + nvl(objClaimListParams.lossCatCd, "")
					+ "&startDate=" + nvl(objClaimListParams.startDate, "")
					+ "&endDate=" + nvl(objClaimListParams.endDate, "")
					+ "&location=" + nvl(objClaimListParams.location, "")
				    + "&provinceCd=" + nvl(objClaimListParams.provinceCd, "")
					+ "&cityCd=" + nvl(objClaimListParams.cityCd, "")
					+ "&districtNo=" + nvl(objClaimListParams.districtNo, "")
					+ "&blockNo=" + nvl(objClaimListParams.blockNo, "")
					+ "&lineCd=" + nvl(objClaimListParams.lineCd, "")
					+ "&searchType=" + nvl(objClaimListParams.searchType, ""),
			options : {
				width : 776,
				hideColumnChildTitle: true,
				pager : {},
				validateChangesOnPrePager: false,
				onCellFocus : function(element, value, x, y, id){
					tbgClaimList.keys.removeFocus(tbgClaimList.keys._nCurrentFocus, true);
					tbgClaimList.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					tbgClaimList.keys.removeFocus(tbgClaimList.keys._nCurrentFocus, true);
					tbgClaimList.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						//rowIndex = -1;
						//setFieldValues(null);
						tbgClaimList.keys.removeFocus(tbgClaimList.keys._nCurrentFocus, true);
						tbgClaimList.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					/* if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} */
				},
				onSort: function(){
					//rowIndex = -1;
					//setFieldValues(null);
					tbgClaimList.keys.removeFocus(tbgClaimList.keys._nCurrentFocus, true);
					tbgClaimList.keys.releaseKeys();
				},
				onRefresh: function(){
					//rowIndex = -1;
					//setFieldValues(null);
					tbgClaimList.keys.removeFocus(tbgClaimList.keys._nCurrentFocus, true);
					tbgClaimList.keys.releaseKeys();
				},				
				prePager: function(){
					/* if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} */
					//rowIndex = -1;
					//setFieldValues(null);
					tbgClaimList.keys.removeFocus(tbgClaimList.keys._nCurrentFocus, true);
					tbgClaimList.keys.releaseKeys();
				}/* ,
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				} */
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
					id : "chkTag",
					title: "",
					width: 25,
					editable: true,
					sortable: false,
					editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
						if (value){
							return"Y";
						}else{
							return"N";
						}
					}})
				},
				{
					id : "claimNo",
					title: "Claim Number",
					width: 150,
					filterOption: true
				},
				{
					id: "policyNo",
					title: "Policy Number",
					width: 150,
					filterOption: true,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id: "assdName",
					title: "Assured",
					width: 250,
					filterOption: true,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id: "lossCat",
					title: "Loss Category",
					width: 150,
					filterOption: true,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id: "dspLossDate",
					title: "Loss Date",
					width: 100,
					align: "center",
					titleAlign : "center",
					filterOption : true,
					filterOptionType : "formattedDate",
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					}
				},
				{
					id: "inHouAdj",
					title: "Processor",
					width: 150,
					filterOption: true,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id: "clmStatDesc",
					title: "Status",
					width: 200,
					filterOption: true,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				}							
			],
			rows : objGicls056ClaimList.claimList.rows
		};

		tbgClaimList = new MyTableGrid(claimListTable);
		tbgClaimList.pager = objGicls056ClaimList.claimList;
		tbgClaimList.render("claimListTable");
		tbgClaimList.afterRender = function(){
			hideNotice();
			//$("chkCheckAll").checked = false;
			
			if(tbgClaimList.geniisysRows.length > 0)
				$("chkCheckAll").disabled = false;
			else
				$("chkCheckAll").disabled = true;
			
			if(tbgClaimList.geniisysRows.length <= 0)
				return; 
			
			$$("div#myTableGridtbgClaimList .mtgInputCheckbox").each(
					function(obj){
						obj.observe("click", function(){
							var index = this.id.substring(this.id.length - 1);
							var claimId = tbgClaimList.geniisysRows[index].claimId;
							
							if(this.checked){
								checkedClaims2.push(claimId);
							} else {
								for(var x = 0; x < checkedClaims2.length; x++){
									if(claimId == checkedClaims2[x]){
										checkedClaims2.splice(x, 1);
										break;
									}
								}
								
								$("chkCheckAll").checked = false;
							}
							
							if(checkedClaims2.length > 0){
								enableButton("btnOk");
							} else {
								disableButton("btnOk");
							}
								
						}
					);
				});
				
			for(var x = 0; x < tbgClaimList.geniisysRows.length; x++){
				for(var y = 0; y < checkedClaims2.length; y++){
					if(tbgClaimList.geniisysRows[x].claimId == checkedClaims2[y]){
						$("mtgInputtbgClaimList_2," + x).checked = true;
						break;
					}
				}
			}
			
			if(checkedClaims2.length > 0){
				enableButton("btnOk");
			} else {
				disableButton("btnOk");
			}
			
		};
		
		function getCheckedRecords(objArray){			
			var tempObjArray = new Array();
			
			if(objArray != null){
				for (var i = 0; i<objArray.length; i++){
					if($("mtgInput"+tbgClaimList._mtgId+"_2,"+i).checked){
						tempObjArray.push(objArray[i]);
					}		
				}
			}			
			return tempObjArray;
		}
		
		function updateDetails () {
			
			var objParams = new Object();
			objParams.setRows = getCheckedRecords(tbgClaimList.geniisysRows);
			
			new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
				method: "POST",
				parameters: {
						     action : "gicls056UpdateDetails",
						     catCd : objGicls056.catCd,
						     objParams : JSON.stringify(objParams),
						     pAction : "ADD",
						     checkedClaims : checkedClaims2.toString()
						     
				},
				asynchronous: false,
				onCreate : function(){
					showNotice("Updating, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						overlayClaimList.close();
						delete overlayClaimList;
						tbgdetails._refreshList();
						$("chkRemoveAll").checked = false;
						
						if(tbgdetails.geniisysRows.length > 0) {
							var rec = tbgdetails.geniisysRows[0];
							$("txtTotResNetRet").value = formatCurrency(rec.totNetResAmt);
							$("txtTotResPropTrty").value = formatCurrency(rec.totTrtyResAmt);
							$("txtTotResNonPropTrty").value = formatCurrency(rec.totNpTrtyResAmt);
							$("txtTotResFacul").value = formatCurrency(rec.totFaculResAmt);
							$("txtTotPdNetRet").value = formatCurrency(rec.totNetPdAmt);
							$("txtTotPdPropTrty").value = formatCurrency(rec.totTrtyPdAmt);
							$("txtTotPdNonPropTrty").value = formatCurrency(rec.totNpTrtyPdAmt);
							$("txtTotPdFacul").value = formatCurrency(rec.totFaculPdAmt);
							$("chkRemoveAll").disabled = false;
						} else {
							$("txtTotResNetRet").clear();
							$("txtTotResPropTrty").clear();
							$("txtTotResNonPropTrty").clear();
							$("txtTotResFacul").clear();
							$("txtTotPdNetRet").clear();
							$("txtTotPdPropTrty").clear();
							$("txtTotPdNonPropTrty").clear();
							$("txtTotPdFacul").clear();
							$("chkRemoveAll").disabled = true;
						}
					}
				}
			});
		}
		
		function updateDetailsAll () {
			
			new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
				method: "POST",
				parameters: {
						     action : "gicls056UpdateDetailsAll",
						     catCd : objGicls056.catCd,
						     lossCatCd : objClaimListParams.lossCatCd,
						     startDate : objClaimListParams.startDate,
						     endDate : objClaimListParams.endDate,
						     location : objClaimListParams.location,
						     provinceCd : objClaimListParams.provinceCd,
						     cityCd : objClaimListParams.cityCd,
						     districtNo : objClaimListParams.districtNo,
						     blockNo : objClaimListParams.blockNo,
						     lineCd : objClaimListParams.lineCd,
						     searchType : objClaimListParams.searchType
						     
				},
				asynchronous: false,
				onCreate : function(){
					showNotice("Updating, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						overlayClaimList.close();
						delete overlayClaimList;
						tbgdetails._refreshList();
						$("chkRemoveAll").checked = false;
						
						if(tbgdetails.geniisysRows.length > 0) {
							var rec = tbgdetails.geniisysRows[0];
							$("txtTotResNetRet").value = formatCurrency(rec.totNetResAmt);
							$("txtTotResPropTrty").value = formatCurrency(rec.totTrtyResAmt);
							$("txtTotResNonPropTrty").value = formatCurrency(rec.totNpTrtyResAmt);
							$("txtTotResFacul").value = formatCurrency(rec.totFaculResAmt);
							$("txtTotPdNetRet").value = formatCurrency(rec.totNetPdAmt);
							$("txtTotPdPropTrty").value = formatCurrency(rec.totTrtyPdAmt);
							$("txtTotPdNonPropTrty").value = formatCurrency(rec.totNpTrtyPdAmt);
							$("txtTotPdFacul").value = formatCurrency(rec.totFaculPdAmt);
							$("chkRemoveAll").disabled = false;
						} else {
							$("txtTotResNetRet").clear();
							$("txtTotResPropTrty").clear();
							$("txtTotResNonPropTrty").clear();
							$("txtTotResFacul").clear();
							$("txtTotPdNetRet").clear();
							$("txtTotPdPropTrty").clear();
							$("txtTotPdNonPropTrty").clear();
							$("txtTotPdFacul").clear();
							$("chkRemoveAll").disabled = true;
						}
					}
				}
			});
		}
			
		function checkTaggedRecords(){
			/* var x = false;
			for(var i = 0; i < tbgClaimList.geniisysRows.length; i++){
				if($("mtgInput"+tbgClaimList._mtgId+"_2,"+i).checked) {
					x = true;
					break;
				}				
			}
			return x; */
			
			if(checkedClaims2.length > 0)
				return true;
			else if ($("chkCheckAll").checked)
				return true;
			else
				return false;
		}
		
		$("btnOk").observe("click", function(){
			
			if($("chkCheckAll").checked) {
				showConfirmBox("Confirmation", "Are you sure you want to include all records?", "Yes", "No", function(){
					updateDetailsAll();
				}, null, null);
				
				return;
			}
			
			if(checkTaggedRecords()) {
				updateDetails();
			} else {
				showMessageBox("Please check at least one record.");
				return;	
			}			
		});
		
		$("chkCheckAll").observe("click", function(){
			
			if(this.checked)
				getClaimNos2();
			else
				checkedClaims2 = [];
			
			for(var i = 0; i < tbgClaimList.geniisysRows.length; i++){
				$("mtgInput"+tbgClaimList._mtgId+"_2,"+i).checked = this.checked;				
			}
			
			if(this.checked)
				enableButton("btnOk");
			else
				disableButton("btnOk");
		});
			
		$("btnCancel").observe("click", function(){
			overlayClaimList.close();
			delete overlayClaimList;
		});
		
		$("mtgRefreshBtntbgClaimList").stopObserving();
		
		$("mtgRefreshBtntbgClaimList").observe("click", function(){
			checkedClaims2 = [];
			tbgClaimList._refreshList();
		});
		
		if(tbgClaimList.geniisysRows.length > 0){
			$("chkCheckAll").disabled = false;							
		} else {
			$("chkCheckAll").disabled = true;
			disableButton("btnOk");
		}
		
		function getClaimNos2(){		
			new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
				method: "POST",
				parameters:{
					action     : "gicls056GetClaimNos2",
					lossCatCd : objClaimListParams.lossCatCd,
					startDate : objClaimListParams.startDate,
					endDate : objClaimListParams.endDate,
					location : objClaimListParams.location,
					provinceCd : objClaimListParams.provinceCd,
					cityCd : objClaimListParams.cityCd,
					districtNo : objClaimListParams.districtNo,
					blockNo : objClaimListParams.blockNo,
					searchType : objClaimListParams.searchType,
					lineCd : objClaimListParams.lineCd 	
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)) {
						var temp = response.responseText.trim();
						var claimNos = new Array();
						if(temp != ""){
							temp = temp.substring(0, temp.length - 1);
							claimNos = temp.split(",");
						}
						checkedClaims2 = claimNos;					
					}
				}
			});
		}
		
		
	} catch (e) {
		showErrorMessage("claimList", e);
	}
</script>