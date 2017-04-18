<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="binderExit">Exit</a></li>
		</ul>
	</div>
</div>
<div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Group Binders</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
				<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
		</div>
	</div>
	<div id="binderTableGridSectionDiv" class="sectionDiv" style="height: 500px;">
		<div id="binderTableGridDiv" style="padding: 10px;">
			<table align="center" style="margin-top: 10px;">
					<tr>
						<td class="rightAligned" width="100px">Policy No.</td>
						<td class="leftAligned" width="205px">
							<div class="withIconDiv" style="width:205px">
								<input type="text" id="polNo" name="polNo" class="withIcon" style="width: 175px;" readonly="readonly" />
								<img id="hrefPolNo" alt="goPolNo"  class="hover" name="hrefPolNo" src="/Geniisys/images/misc/searchIcon.png" style="float: right; height: 18px;">
							</div>
						</td>
						<td class="rightAligned" width="80px">Endt No.</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="endtNo" name="endtNo" style="width: 200px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Assured Name</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="assuredName" name="assuredName" style="width: 200px;" readonly="readonly" />
						</td>
					</tr>
				</table>
			<div id="binderListingTable" style="height: 200px; margin-top: 25px"></div>
			
		</div>
		<div class="buttonsDiv" style="margin-top: 150px">
				<input type="button" id="btnGrpBndrs" name="btnGrpBndrs" class="button" value="Group Binders" style="width: 115px;"/>
				<input type="button" id="btnUngrpBndrs" name="btnUngrpBndrs" class="button" value="Ungroup Binders" style="width: 125px;">
			</div>
	</div>
<input type="hidden" value="${isEdit}" id="isEdit" name="isEdit" />
<input id="policyId" type="hidden" />
</div>


<script>
	initializeAccordion();
	setModuleId("GIRIS053");
	setDocumentTitle("Group/Ungroup Binder");
	
	var userId = '${userId}';
	var objTGBinders = {};
	var riCd = null;
	var currencyCd = null;
	var currencyRt = null; 
	var binderNo = null;
	
	$("binderExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	$("hrefPolNo").observe("click", function() {
		riCd = null;
		currencyCd = null;
		currencyRt = null;  
		binderNo = null; 
		showPolicyNoLOV2();
	});
	
	disableButton("btnGrpBndrs");
	disableButton("btnUngrpBndrs");
	
	$("reloadForm").observe("click", function(){
		showGroupBindersTableGridListing();
	});
	$("btnGrpBndrs").observe("click", function(){
		groupBinders();
	}); 
	$("btnUngrpBndrs").observe("click", function(){
		ungroupBinders();
	});
 	
	selectedIndex = -1;
	objTGBinders.objTGBinderListing = JSON.parse('${binderTableGridListing}'.replace(/\\/g, '\\\\'));
	objTGBinders.objTGBinderList = objTGBinders.objTGBinderListing.rows || [];
	
	var objFrps = {};
	
	var binderListingTable = {
		 url: contextPath+"/GIRIFrpsRiController?action=showBinderListing&refresh=1&policyId="+'${policyId}',
		options: {
			width: '900px',
			height: '325px',
			id: 1,
			onCellFocus : function(element, value, x, y, id){
				var mtgId = binderTableGrid._mtgId;
				selectedIndex = -1;
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					selectedIndex = y;
					objFrps = binderTableGrid.getRow(y);
				}
				observeChangeTagInTableGrid(binderTableGrid);
			},
			onCellBlur: function(){
				observeChangeTagInTableGrid(binderTableGrid);
			},
			onRemoveRowFocus: function(){
				selectedIndex = -1;
				objFrps = null;
			},
			onRowDoubleClick: function(y){
				var row = binderTableGrid.geniisysRows[y];
				binderTableGrid.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN] 
			}
		},
		columnModel: [
					{   
						id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'group',
						title: 'G',
					    width: '20',
					    visible: true,
					    titleAlign: 'center',
					    align: 'left',
					    editable:true,
					    hideSelectAllBox: true,
					    sortable: false,
					    altTitle : 'Group Binders',
					    editor: new MyTableGrid.CellCheckbox({
							getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	} ,
			            	onClick: function(value,checked) {
								checkForGrouping(value,checked);			            	
					    	} 
			            })
					},
					{	id: 'dspFrpsNo',
						title: 'FRPS No.',
						titleAlign: 'left',
						width: '80',
						visible: true,
						filterOption: true
					},
					{
						id: 'dspBinderNo',
						title: 'Binder No.',
						titleAlign: 'left',
						width: '90',
						visible: true,
						filterOption: true
					},
					 {
				    	id : 'dspReinsurer',
						title: 'Reinsurer',
						width: '250px',
						titleAlign: 'left',
						visible: true,
						filterOption: true
				    },
				    {
				   		id: 'fmtRiShrPct',
				   		title: 'RI Share %',
				   		width: '83',
				   		titleAlign: 'right',
				   		align: 'left',
				   		visible: true,
				   		geniisysClass: 'rate'
				    },
				    {
				    	id: 'fmtRiTsiAmt', 
				    	title: 'RI TSI Amount',
				    	width: '100',
				    	titleAlign: 'right',
				    	align: 'right',
				    	visible: true
				    },
				    {
				    	id: 'fmtRiPremAmt',
				    	title: 'RI Prem Amount',
				    	width: '100',
				    	titleAlign: 'right',
				    	align: 'right',
				    	visible: true
				    },
				    {	
				    	id: 'ungroup',
				    	title: 'U',
				    	width: '20',
				    	titleAlign: 'center',
				    	editor: 'checkbox',		
				    	align: 'left',
				    	visible: true,
				    	editable: true,
				    	hideSelectAllBox: true,
					    sortable: false,
					    altTitle : 'Ungroup Binders',
				    	editor: new MyTableGrid.CellCheckbox({
							getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value,checked) {
		            			checkForUngrouping(value,checked);
			              }
				       })
				    },
				    {
				    	id: 'dspGrpBinderNo',
				    	title: 'Grp. Binder No.',
				    	width: '113',
				    	titleAlign: 'center',
				    	visible: true,
				    	filterOption: true
				    },
				    {
				    	id: 'lineCd',
				    	title: 'Line Code',
				    	width: '0',
				    	visible: false
				    },
				    
				    
				    {
				    	id: 'frpsYy',
				    	title: 'Frps Yy',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'frpsSeqNo',
				    	title: 'Frps Seq. No.',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'binderYy',
				    	title: 'Binder Yy',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'binderSeqNo',
				    	title: 'Binder Seq. No.',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'riCd',
				    	title: '',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'currencyRt',
				    	title: '',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'currencyCd',
				    	title: '',
				    	width: '0',
				    	visible: false
				    },
				    {
				    	id: 'masterBndrId',
				    	title: '',
				    	width: '0',
				    	visible: false
				    }
				],
		rows: objTGBinders.objTGBinderList
	};
	binderTableGrid = new MyTableGrid(binderListingTable);
	binderTableGrid.pager = objTGBinders.objTGBinderListing;
	binderTableGrid.render('binderListingTable');
	
	
	function groupBinders() {
		try{
			var objParameters = {};
			objParameters.rows = prepareJsonAsParameter(binderArr);
			
			new Ajax.Request(contextPath+"/GIRIFrpsRiController?", {
				method: "POST",
				asynchronous: true,
				evalScripts: true,
				parameters : {
					action : "groupBinders",
					parameters : JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Grouping Binders...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						binderTableGrid._refreshList();
						changeTag = 0;
						disableButton("btnGrpBndrs");
						ctr=0;
						riCd=null;
						currencyCd=null;
						currencyRt=null;
						
					}
				}
			});
		}catch(e){
			showErrorMessage("groupBinders", e);
		}
	}
	function ungroupBinders() {
		try{
			for ( var i = 0; i < binderTableGrid.rows.length; i++) {
				if($("mtgInput"+binderTableGrid._mtgId+"_9,"+i).checked == true){
					var masterBndrId = binderTableGrid.getRow(i).masterBndrId;
				}
			}
			new Ajax.Request(contextPath+"/GIRIFrpsRiController?", {
				method: "POST",				
				asynchronous: true,
				evalScripts: true,
				parameters : {
					action : "ungroupBinders",
					masterBndrId : masterBndrId
				}, 
				onCreate: function(){
					showNotice("Ungrouping Binders...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS,  imgMessage.SUCCESS);
						binderTableGrid._refreshList();
						disableButton("btnUngrpBndrs");
					}
				}
			});
		}catch(e){
			showErrorMessage("ungroupBinders", e);
		}
	}
	function checkForGrouping(value,checked){
		try{
			binderArr = [];
    		for ( var i = 0; i < binderTableGrid.rows.length; i++) {
				if($("mtgInput"+binderTableGrid._mtgId+"_2,"+i).checked == true){
					var objBinder = binderTableGrid.getRow(i);
					if (binderTableGrid.getRow(selectedIndex).masterBndrId != null){
						showWaitingMessageBox("This binder has already been grouped.", imgMessage.INFO, function(){
							if($("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked == true){
								 $("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked = false;
							}
						});
					}
					else{
						if(binderTableGrid.getRow(i).riCd != binderTableGrid.getRow(selectedIndex).riCd){
							showWaitingMessageBox("You cannot group binders of different reinsurers.", imgMessage.INFO, function(){
								if($("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked == true){
		   							 $("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked = false;
								 }	
							});
						}else if(binderTableGrid.getRow(i).currencyCd != binderTableGrid.getRow(selectedIndex).currencyCd){
							showWaitingMessageBox("You cannot group binders of different currency.", imgMessage.INFO, function(){
								if($("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked == true){
		   							 $("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked = false;
								 }	
							});
						}else if(binderTableGrid.getRow(i).currencyRt != binderTableGrid.getRow(selectedIndex).currencyRt){
							showWaitingMessageBox("You cannot group binders of different currency rate.", imgMessage.INFO, function(){
								if($("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked == true){
		   							 $("mtgInput"+binderTableGrid._mtgId+"_2,"+selectedIndex).checked = false;
								 }	
							});
						}else{
							binderArr.push(objBinder);
							if(binderArr.length>1){
								 enableButton("btnGrpBndrs");
							 }
						}
					}
				}else{
					if (binderArr.length>0){
						binderArr.splice(i,1);
						if (binderArr.length<2){
	        				disableButton("btnGrpBndrs");
						}
					}
				}
    		}
    		if (binderArr.length==0){
				riCd = null;
				currencyCd = null;
				currencyRt = null;
			}
		}catch(e){
			showErrorMessage("checkForGrouping", e);
		}
	}
	function checkForUngrouping(value,checked) {
		try{
			binderArr2=[];			
			for ( var i = 0; i < binderTableGrid.rows.length; i++) {
				if($("mtgInput"+binderTableGrid._mtgId+"_9,"+i).checked == true){
					var objBinder2 = binderTableGrid.getRow(i);
					 if (binderTableGrid.getRow(i).masterBndrId == null){
						 showWaitingMessageBox("Cannot ungroup binder which is not yet grouped.", imgMessage.INFO, function(){
							 if($("mtgInput"+binderTableGrid._mtgId+"_9,"+selectedIndex).checked == true){ 
								 $("mtgInput"+binderTableGrid._mtgId+"_9,"+selectedIndex).checked = false;
							 }
						 });
	    			}else{
						binderArr2.push(objBinder2);
						enableButton("btnUngrpBndrs");
						if (binderArr2.length>1){
							showWaitingMessageBox("There is already a group tagged for ungrouping.", imgMessage.INFO, function(){
								if($("mtgInput"+binderTableGrid._mtgId+"_9,"+selectedIndex).checked == true){ 
									$("mtgInput"+binderTableGrid._mtgId+"_9,"+selectedIndex).checked = false;
									 binderArr2.splice(objBinder2,1);
								 }
							});
						}
					}
				}
			}
			if (binderArr2.length<1){
				disableButton("btnUngrpBndrs");
			}
		}catch(e){
			showErrorMessage("checkForUngrouping", e);
		}
	}
</script>

   