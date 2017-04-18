<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="lossAdviceListGrid" style="position:relative; height:360px;"></div>
<script type="text/javascript">
	objAC.hidObjGIACS009.lossAdviceTableGrid = JSON.parse('${lossAdviceTableGrid}'.replace(/\\/g, '\\\\'));
	objAC.hidObjGIACS009.lossAdviceListRows = objAC.hidObjGIACS009.lossAdviceTableGrid.rows || [];
	var dspLineCd;
	var dspFlaSeqNo;
	var dspLaYy;
	var dspRiCd;
	var dspPayeeType;
	var tableModel = {
		url: contextPath+"/GIACLossRiCollnsController?action=refreshLossAdviceListing&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd+
		"&transactionType="+$F("selTransactionTypeLossesRecov")+
		"&shareType="+$F("selShareTypeLossesRecov")+
		"&a180RiCd="+$F(objAC.hidObjGIACS009.hidCurrReinsurer)+
		"&e150LineCd="+$F("txtE150LineCdLossesRecov")+
		"&e150LaYy="+$F("txtE150LaYyLossesRecov")+
		"&e150FlaSeqNo="+$F("txtE150FlaSeqNoLossesRecov"),
		options: {
			hideColumnChildTitle: true,
			querySort: true,				// to sort using existing rows
			addSettingBehavior: false,     	// disable|remove setting icon button
			addDraggingBehavior: false,    	// disable dragging behavior
			onCellFocus : function(element, value, x, y, id) {
				if (id == 'recordStatus'){
					if (value){
						for (var b=0; b<objAC.objLossesRecovAC009.length; b++){
							if (tableGrid.rows[y][tableGrid.getColumnIndex('dspLineCd')] == objAC.objLossesRecovAC009[b].e150LineCd
									&& tableGrid.rows[y][tableGrid.getColumnIndex('dspFlaSeqNo')] == Number(objAC.objLossesRecovAC009[b].e150FlaSeqNo)
									&& tableGrid.rows[y][tableGrid.getColumnIndex('dspLaYy')] == Number(objAC.objLossesRecovAC009[b].e150LaYy)
									&& tableGrid.rows[y][tableGrid.getColumnIndex('dspRiCd')] == objAC.objLossesRecovAC009[b].a180RiCd
									&& tableGrid.rows[y][tableGrid.getColumnIndex('dspPayeeType')] == objAC.objLossesRecovAC009[b].payeeType
									//&& getSelectedRowId("rowRiTransLossesRecov") != b
									&& objAC.objLossesRecovAC009[b].recordStatus != -1){
								exists = true;
								tableGrid.setValueAt(false, x, y, false);
								$('mtgInput'+tableGrid._mtgId+'_0,'+y).checked = false;
								showMessageBox("Record already exist with the same Reinsurer and Final Loss Advice No.", imgMessage.ERROR);
								return false;
							}
						}
						if (changeSingleAndDoubleQuotes(tableGrid.rows[y][tableGrid.getColumnIndex('dspMsgAlert')] == null ? "" :nvl(tableGrid.rows[y][tableGrid.getColumnIndex('dspMsgAlert')],"")) != ""){
							tableGrid.setValueAt(false, x, y, false);
							$('mtgInput'+tableGrid._mtgId+'_0,'+y).checked = false;
							showMessageBox(changeSingleAndDoubleQuotes(tableGrid.rows[y][tableGrid.getColumnIndex('dspMsgAlert')]),imgMessage.ERROR);
							return false; 
						}
					}	
				}
				tableGrid.keys.releaseKeys(); //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
			},
			pager: { //dummy pagination
				total: 55,
				pages: 5,
				currentPage: 1,
				from: 1,
				to: 10
			},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
			}
		},
		columnModel: [
			{ 								// this column will only use for deletion
				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			 	title: '&#160;I',
			 	altTitle: 'Include?',
				width: 19,
				sortable: false,
				editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
				//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
				//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
				editor: 'checkbox',
				hideSelectAllBox: true
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{
				id: 'dspRiCd',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspLineCd dspLaYy dspFlaSeqNo',
				title: 'Final Loss Advice #',
				width : 117,
				children : [
		            {
		                id : 'dspLineCd',
		                title: 'FLA - Line Code',
		                width : 30,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspLaYy', 
		                title: 'FLA - Year',
		                width : 30,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						},
						filterOption: true,
						filterOptionType: 'integer'		
		            },
		            {
		                id : 'dspFlaSeqNo', 
		                title: 'FLA - Sequence Number',
		                width : 70,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),5);
						},
						filterOption: true,
						filterOptionType: 'integer'		
		            }
				]
			},
			{
                id : 'dspPayeeType',
                title: 'Pay T',
                width : 47,
                editable: false,
                filterOption: true		
            },
            {
				id: 'dspFlaDate',
				title: 'FLA Date',
				width: 80,
				editable: false,
				renderer: function (value){
					return dateFormat(value, "mm-dd-yyyy");
				},
                filterOption: true 		
			},
			{
				id: 'nbtClaimId',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspClmLineCd dspClmSublineCd dspClmIssCd dspClmYy dspClmSeqNo',
				title: 'Claim No.',
				width : 117,
				children : [
		            {
		                id : 'dspClmLineCd',
		                title: 'Claim No. - Line Code',
		                width : 30,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspClmSublineCd',
		                title: 'Claim No. - Subline Code',
		                width : 70,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspClmIssCd',
		                title: 'Claim No. - Issue Code',
		                width : 30,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspClmYy', 
		                title: 'Claim No. - Issue Year',
		                width : 30,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						},
						filterOption: true,
						filterOptionType: 'integer'		
		            },
		            {
		                id : 'dspClmSeqNo', 
		                title: 'Claim No. - Sequence Number',
		                width : 70,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),7);
						},
						filterOption: true,
						filterOptionType: 'integerNoNegative'		
		            }
		        ]
			},
			{
				id: 'nbtClaim',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspPolLineCd dspPolSublineCd dspPolIssCd dspPolIssueYy dspPolSeqNo dspPolRenewNo',
				title: 'Policy No.',
				width : 117,
				children : [
		            {
		                id : 'dspPolLineCd',
		                title: 'Policy No. - Line Code',
		                width : 30,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspPolSublineCd',
		                title: 'Policy No. - Subline Code',
		                width : 70,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspPolIssCd',
		                title: 'Policy No. - Issue Code',
		                width : 30,
		                editable: false,
		                filterOption: true		
		            },
		            {
		                id : 'dspPolIssueYy', 
		                title: 'Policy No. - Issue Year',
		                width : 30,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						},
						filterOption: true,
						filterOptionType: 'integer'		
		            },
		            {
		                id : 'dspPolSeqNo', 
		                title: 'Policy No. - Sequence Number',
		                width : 70,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),7);
						},
						filterOption: true,
						filterOptionType: 'integerNoNegative'		
		            },
		            {
		                id : 'dspPolRenewNo', 
		                title: 'Policy No. - Renew Number',
		                width : 30,
		                editable: false,
		                align: 'right',
						renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						},
						filterOption: true,
						filterOptionType: 'integer'		
		            }
		        ]
			},
			{
				id: 'nbtPolicy',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspAssdName',
				title: 'Assured Name',
				width: 150,
				editable: false,
                filterOption: true 		
			},
			{
				id: 'dspLossDate',
				title: 'Loss Date',
				width: 80,
				editable: false,
				renderer: function (value){
					return dateFormat(value, "mm-dd-yyyy");
				},
                filterOption: true 		
			},
			{
                id : 'dspCollectionAmt', 
                title: 'Collection',
                titleAlign: 'right',
                width : 120,
                editable: false,
                align: 'right',
				renderer: function (value){
					return nvl(value,'') == '' ? '' :formatCurrency(nvl(value,0));
				},
				filterOption: true,
				filterOptionType: 'number'		
            },
            {
				id: 'nbtGaccTranId',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspForeignCurrAmt',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspCurrencyCd',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspCurrencyDesc',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspConvertRate',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspMsgAlert',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'dspMsgAlert',
				title: '',
				width: '0',
				editable: false,
				visible: false
			},
			{
				id: 'cond', //added by steven 4.17.2012
				title: '',
				width: '0',
				editable: false,
				visible: false
			}
		],
		rows : objAC.hidObjGIACS009.lossAdviceListRows
	};		

 	function disableExistingLossAdvice(){
		try{
			for (var i=0; i<tableGrid.rows.length; i++){
				for (var b=0; b<objAC.objLossesRecovAC009.length; b++){
					if (tableGrid.rows[i][tableGrid.getColumnIndex('dspLineCd')] == objAC.objLossesRecovAC009[b].e150LineCd
							&& tableGrid.rows[i][tableGrid.getColumnIndex('dspFlaSeqNo')] == Number(objAC.objLossesRecovAC009[b].e150FlaSeqNo)
							&& tableGrid.rows[i][tableGrid.getColumnIndex('dspLaYy')] == Number(objAC.objLossesRecovAC009[b].e150LaYy)
							&& tableGrid.rows[i][tableGrid.getColumnIndex('dspRiCd')] == objAC.objLossesRecovAC009[b].a180RiCd
							&& tableGrid.rows[i][tableGrid.getColumnIndex('dspPayeeType')] == objAC.objLossesRecovAC009[b].payeeType
							//&& getSelectedRowId("rowRiTransLossesRecov") != b
							&& objAC.objLossesRecovAC009[b].recordStatus != -1
							&& $("btnAddLossesRecov").value != 'Update'){
						exists = true;
						$('mtgInput'+tableGrid._mtgId+'_0,'+i).checked = true;
						$('mtgInput'+tableGrid._mtgId+'_0,'+i).disable();
						$('mtgIC'+tableGrid._mtgId+'_32,'+i).value="true";
						objAC.objLossesRecovAC009[b].cond = "true";
						//showMessageBox("Record already exist with the same Reinsurer and Final Loss Advice No.", imgMessage.ERROR);
						//return false;
					}
				}
			}	
		}catch(e){
			showErrorMessage("disableExistingLossAdvice", e);
		}
	} 
	
	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objAC.hidObjGIACS009.lossAdviceTableGrid; //to update pager section
	tableGrid.afterRender = disableExistingLossAdvice;
	tableGrid.render('lossAdviceListGrid');

	objAC.hidObjGIACS009.transactionTypeSelected = $F("selTransactionTypeLossesRecov");
	objAC.hidObjGIACS009.shareTypeSelected = $F("selShareTypeLossesRecov");
	objAC.hidObjGIACS009.reinsurerSelected = $F(objAC.hidObjGIACS009.hidCurrReinsurer);
	
	//when OK button click
	$("btnLossAdviceOk").observe("click",function(){
		try{
			var hasSelected = false;
			var exists = false;
			
			for (var i=0; i<tableGrid.rows.length; i++){
				if (!exists){
					if ($('mtgInput'+tableGrid._mtgId+'_0,'+i).checked == true && $('mtgIC'+tableGrid._mtgId+'_32,'+i).value != "true") {
						$("selTransactionTypeLossesRecov").value 		= objAC.hidObjGIACS009.transactionTypeSelected;
						$("selShareTypeLossesRecov").value	 			= objAC.hidObjGIACS009.shareTypeSelected;
						updateRiTransLossRecovLOV();
						$(objAC.hidObjGIACS009.hidCurrReinsurer).value 	= objAC.hidObjGIACS009.reinsurerSelected;
						$("txtE150LineCdLossesRecov").value			= changeSingleAndDoubleQuotes(nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspLineCd')],""));
						$("txtE150LaYyLossesRecov").value 			= (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspLaYy')],null) == null ? "" :formatNumberDigits(tableGrid.rows[i][tableGrid.getColumnIndex('dspLaYy')],2));
						$("txtE150FlaSeqNoLossesRecov").value 		= (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspFlaSeqNo')],null) == null ? "" :formatNumberDigits(tableGrid.rows[i][tableGrid.getColumnIndex('dspFlaSeqNo')],5));
						$("txtPayeeTypeLossesRecov").value			= changeSingleAndDoubleQuotes(nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspPayeeType')],""));
						//John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
						$("txtCollectionAmtLossesRecov").value		= (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspCollectionAmt')],null) == null ? "" : objAC.hidObjGIACS009.transactionTypeSelected == 1 ? formatCurrency(tableGrid.rows[i][tableGrid.getColumnIndex('dspCollectionAmt')]) : formatCurrency(tableGrid.rows[i][tableGrid.getColumnIndex('dspCollectionAmt')]*-1));
						objAC.hidObjGIACS009.hidWsCollectionAmt		= $("txtCollectionAmtLossesRecov").value;
						$("txtDspPolicyLossesRecov").value			= unescapeHTML2(nvl(tableGrid.rows[i][tableGrid.getColumnIndex('nbtPolicy')],""));
						$("txtDspClaimNoLossesRecov").value			= unescapeHTML2(nvl(tableGrid.rows[i][tableGrid.getColumnIndex('nbtClaim')],""));
						$("txtDspAssuredLossesRecov").value			= unescapeHTML2(nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspAssdName')],""));
						objAC.hidObjGIACS009.hidClaimId				= nvl(tableGrid.rows[i][tableGrid.getColumnIndex('nbtClaimId')],"");
						$("foreignCurrAmtLossesRecov").value 		= (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspForeignCurrAmt')],null) == null ? "" : objAC.hidObjGIACS009.transactionTypeSelected == 1 ? formatCurrency(tableGrid.rows[i][tableGrid.getColumnIndex('dspForeignCurrAmt')]) : formatCurrency(tableGrid.rows[i][tableGrid.getColumnIndex('dspForeignCurrAmt')]*-1));
						objAC.hidObjGIACS009.hidWsForeignCurrAmt	= $("foreignCurrAmtLossesRecov").value;	
						$("currencyCdLossesRecov").value 			= nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspCurrencyCd')],"");
						$("convertRateLossesRecov").value 			= nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspConvertRate')],"");
						$("currencyDescLossesRecov").value 			= changeSingleAndDoubleQuotes(nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspCurrencyDesc')],""));;
						$("tempCollectionAmt").value				= (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('dspCollectionAmt')],null) == null ? "" : objAC.hidObjGIACS009.transactionTypeSelected == 1 ? formatCurrency(tableGrid.rows[i][tableGrid.getColumnIndex('dspCollectionAmt')]) : formatCurrency(tableGrid.rows[i][tableGrid.getColumnIndex('dspCollectionAmt')]*-1));
						$("txtCollectionAmtLossesRecov").readOnly 		= false;
						$("foreignCurrAmtLossesRecov").readOnly 		= false;
						$("currencyCdLossesRecov").readOnly 			= false;
						$("convertRateLossesRecov").readOnly 			= false;
						$("txtParticularsLossesRecov").readOnly 		= false;
						
						$("tempCollectionAmt").value = $("txtCollectionAmtLossesRecov").value; //robert 03.18.2013
						defaultCollectionAmount = $("txtCollectionAmtLossesRecov").value; //john 11.18.2014
						
						fireEvent($("btnAddLossesRecov"), "click"); //john 11.17.2014
						
						//objAC.hidObjGIACS009.addLossesRecov(); // comment out by bonok :: 01.09.2013
						Modalbox.hide();
						tableGrid.keys.releaseKeys();
					}else{
						Modalbox.hide();
						tableGrid.keys.releaseKeys();
					}
				}
			}
		}catch (e) {
			showErrorMessage("btnLossAdviceOk function", e);
		}
	});
</script>