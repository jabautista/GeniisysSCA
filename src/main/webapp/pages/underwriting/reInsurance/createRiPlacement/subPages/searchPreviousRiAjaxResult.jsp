<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="prevRiGrid" style="position:relative; height:320px; width: 663px;"></div>
<script type="text/javascript">
	//objUW.hidObjGIRIS001.prevRiTableGrid = JSON.parse('${message}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIRIS001.prevRiTableGrid = JSON.parse('${previousRiTG}'); //marco - GENQA 5256 - 01.04.2016
	objUW.hidObjGIRIS001.prevRiRows = objUW.hidObjGIRIS001.prevRiTableGrid.rows || [];

	var varTmpSumRiShrPct = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct);
	var varTmpSumRiShrPct2 = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2);

	function chkdExistingRi(riCd){
		try{
			var ok = true;
			var arr = tableGrid.getDeletedIds();
			for (var i=0; i<tableGrid.rows.length; i++){
				var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
				if (arr.indexOf(divCtrId) == -1){
					if (riCd == tableGrid.rows[i][tableGrid.getColumnIndex('riCd')]){
						showMessageBox('Reinsurer is already placed.', 'I');
						ok = false;
						return false;
					}	
				}
			}		
			var newRowsAdded = tableGrid.getNewRowsAdded();
			for (var i=0; i<newRowsAdded.length; i++){
				if (tableGrid.newRowsAdded[i] != null){
					if (riCd == tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('riCd')]){
						showMessageBox('Reinsurer is already placed.', 'I');
						ok = false;
						return false;
					}	
				}
			}		
			return ok;
		}catch(e){
			showErrorMessage("chkdExistingRi", e);
		}		
	}	
	
	var prevRiGridTableModel = {
		url: contextPath+"/GIRIWFrpsRiController?action=searchPreviousRiModal&refresh=1&distNo="+objUW.hidObjGIRIS001.viewJSON.distNo,
		options : {
			height: '308px',
			pager: { 
				total: 55,
				pages: 5,
				currentPage: 1,
				from: 1,
				to: 10
			},
			onCellFocus: function(element, value, x, y, id){
				var validShr = 0;
				var validShr2 = 0;
				var shrPct = parseFloat(prevRiGrid.getValueAt(prevRiGrid.getColumnIndex('riShrPct'), y));
				var shrPct2 = parseFloat(prevRiGrid.getValueAt(prevRiGrid.getColumnIndex('riShrPct2'), y));
				var riCd = prevRiGrid.getValueAt(prevRiGrid.getColumnIndex('riCd'), y);
				if (id=="recordStatus" && value){
					if (chkdExistingRi(riCd)){
						validShr = nvl(unformatCurrencyValue($F("txtV100TotFacSpct")), 0) - nvl(varTmpSumRiShrPct, 0);
						validShr2 = nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")), 0) - nvl(varTmpSumRiShrPct2, 0);
						if (shrPct > validShr || shrPct2 > validShr2){
							showMessageBox('The share% of this reinsurer exceeds the remaining facultative share% which is '+validShr+'%', 'I');
							prevRiGrid.setValueAt(false, x, y, false);
							$('mtgInput'+prevRiGrid._mtgId+'_0,'+y).checked = false;
							return false;
						}		
					}else{
						prevRiGrid.setValueAt(false, x, y, false);
						$('mtgInput'+prevRiGrid._mtgId+'_0,'+y).checked = false;
						return false;
					}	
				}else if (id=="recordStatus" && !value){
					varTmpSumRiShrPct = varTmpSumRiShrPct - shrPct;
					varTmpSumRiShrPct2 = varTmpSumRiShrPct2 - shrPct2;
					return false;
				}	
				varTmpSumRiShrPct = varTmpSumRiShrPct + shrPct;
				varTmpSumRiShrPct2 = varTmpSumRiShrPct2 + shrPct2;
			}	
		},
		columnModel: [
		  	{ 								// this column will only use for deletion
		  		id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
		  		title: '&#160;&#160;I',
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
				id: 'lineCd',
				width: '0',
				visible: false 	
			},
			{
				id: 'frpsYy',
				width: '0',
				visible: false 	
			},
			{
				id: 'frpsSeqNo',
				width: '0',
				visible: false 	
			},
			{
				id: 'riSeqNo',
				width: '0',
				visible: false 	
			},
			{
				id: 'riCd',
				width: '0',
				visible: false 	
			},
			{
				id: 'fnlBinderId',
				width: '0',
				visible: false 	
			},
			{
				id: 'riTsiAmt',
				width: '0',
				visible: false 	
			},
			{
				id: 'riPremAmt',
				width: '0',
				visible: false 	
			},
			{
				id: 'reverseSw',
				width: '0',
				visible: false 	
			},
			{
				id: 'annRiSAmt',
				width: '0',
				visible: false 	
			},
			{
				id: 'annRiPct',
				width: '0',
				visible: false 	
			},
			{
				id: 'riCommRt',
				width: '0',
				visible: false 	
			},
			{
				id: 'riCommAmt',
				width: '0',
				visible: false 	
			},
			{
				id: 'premTax',
				width: '0',
				visible: false 	
			},
			{
				id: 'otherCharges',
				width: '0',
				visible: false 	
			},
			{
				id: 'renewSw',
				width: '0',
				visible: false 	
			},
			{
				id: 'facobligSw',
				width: '0',
				visible: false 	
			},
			{
				id: 'bndrRemarks1',
				width: '0',
				visible: false 	
			},
			{
				id: 'bndrRemarks2',
				width: '0',
				visible: false 	
			},
			{
				id: 'bndrRemarks3',
				width: '0',
				visible: false 	
			},
			{
				id: 'remarks',
				width: '0',
				visible: false 	
			},
			{
				id: 'deleteSw',
				width: '0',
				visible: false 	
			},
			{
				id: 'revrsBndrPrintDate',
				width: '0',
				visible: false 	
			},
			{
				id: 'masterBndrId',
				width: '0',
				visible: false 	
			},
			{
				id: 'cpiRecNo',
				width: '0',
				visible: false 	
			},
			{
				id: 'cpiBranchCd',
				width: '0',
				visible: false 	
			},
			{
				id: 'bndrPrintedCnt',
				width: '0',
				visible: false 	
			},
			{
				id: 'revrsBndrPrintedCnt',
				width: '0',
				visible: false 	
			},
			{
				id: 'riAsNo',
				width: '0',
				visible: false 	
			},
			{
				id: 'riAcceptBy',
				width: '0',
				visible: false 	
			},
			{
				id: 'riAcceptDate',
				width: '0',
				visible: false 	
			},
			{
				id: 'riPremVat',
				width: '0',
				visible: false 	
			},
			{
				id: 'riCommVat',
				width: '0',
				visible: false 	
			},
			{
				id: 'riWholdingVat',
				width: '0',
				visible: false 	
			},
			{
				id: 'address1',
				width: '0',
				visible: false 	
			},
			{
				id: 'address2',
				width: '0',
				visible: false 	
			},
			{
				id: 'address3',
				width: '0',
				visible: false 	
			},
			{
				id: 'premWarrDays',
				width: '0',
				visible: false 	
			},
			{
				id: 'premWarrTag',
				width: '0',
				visible: false 	
			},
			{
				id: 'packBinderId',
				width: '0',
				visible: false 	
			},
			{
				id: 'arcExtData',
				width: '0',
				visible: false 	
			},
			{
				id: 'riSname',
				title: 'Reinsurer',
				width: '250',
				titleAlign: 'center',
				editable: false
			},
			{
				id: 'riShrPct',
				title: 'TSI Share Pct',
				width: '150',
				titleAlign: 'center',
	            type : 'number',
	            geniisysClass: 'rate',
	            deciRate: 14,
				editable: false 	
			},
			{
				id: 'riShrPct2',
				title: 'Premium Share Pct',
				width: '150',
				titleAlign: 'center',
	            type : 'number',
	            geniisysClass: 'rate',
	            deciRate: 9,
				editable: false 	
			}
		],
		rows : objUW.hidObjGIRIS001.prevRiRows		
	};

	prevRiGrid = new MyTableGrid(prevRiGridTableModel);
	prevRiGrid.pager = objUW.hidObjGIRIS001.prevRiTableGrid; //to update pager section
	prevRiGrid.render('prevRiGrid');

	$("btnOk").observe("click", function(){
		var rows = [];
		// modified, irwin 12.18.2012
		for (var i=0; i<prevRiGrid.rows.length; i++){
			var recordStatus = nvl(prevRiGrid.rows[i][tableGrid.getColumnIndex('recordStatus')], false);
			if (recordStatus){
				var rec = {};
				rec.riCd = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riCd')];
				rec.riSname = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riSname')];
				rec.riTsiAmt = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riTsiAmt')];
				rec.riShrPct = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riShrPct')];
				rec.riShrPct2 = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riShrPct2')];
				rec.riPremAmt = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riPremAmt')];
				rec.riPremVat = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riPremVat')];
				rec.riCommRt = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riCommRt')];
				rec.riCommAmt = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riCommAmt')];
				rec.reusedBinder = "Y";
				
				//added by jeffdojello 11.19.2013 GENQA SR-925
				objUW.hidObjGIRIS001.sumRiShrPct = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct) + parseFloat(rec.riShrPct);
				objUW.hidObjGIRIS001.sumRiTsiAmt = parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt) + parseFloat(rec.riTsiAmt);
				objUW.hidObjGIRIS001.sumRiShrPct2 = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2) + parseFloat(rec.riShrPct2);
				objUW.hidObjGIRIS001.sumRiPremAmt = parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt) + parseFloat(rec.riPremAmt)
				
				//added by jeffdojello 11.19.2013 GENQA SR-925
				$("sumRiShrPct").value = formatToNthDecimal(roundNumber(objUW.hidObjGIRIS001.sumRiShrPct,14), 14);
				$("sumRiTsiAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiTsiAmt);
				$("sumRiShrPct2").value = formatToNthDecimal(roundNumber(objUW.hidObjGIRIS001.sumRiShrPct2,9),9);
				$("sumRiPremAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiPremAmt);
					
				var objParameters = {};
				objParameters.riPremVat = rec.riPremVat;
				objParameters.riCd 		= rec.riCd;
				objParameters.lineCd 	= objUW.hidObjGIRIS001.viewJSON.lineCd;
				objParameters.issCd 	= objUW.hidObjGIRIS001.viewJSON.issCd;
				objParameters.parYy 	= objUW.hidObjGIRIS001.viewJSON.parYy;
				objParameters.parSeqNo 	= objUW.hidObjGIRIS001.viewJSON.parSeqNo;
				objParameters.sublineCd = objUW.hidObjGIRIS001.viewJSON.sublineCd;
				objParameters.issueYy 	= objUW.hidObjGIRIS001.viewJSON.issueYy;
				objParameters.polSeqNo 	= objUW.hidObjGIRIS001.viewJSON.polSeqNo;
				objParameters.renewNo 	= objUW.hidObjGIRIS001.viewJSON.renewNo;
				objParameters.action	= "adjustPremVat";
				
				new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
					parameters: objParameters,
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)) {
							var res = JSON.parse(response.responseText);
							rec.riPremVat = res.riPremVat;
							rec.riCommVat = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('riCommVat')];
							rec.premWarrTag = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('premWarrTag')];
							rec.premWarrDays = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('premWarrDays')];
							rec.address1 = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('address1')];
							rec.address2 = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('address2')];
							rec.address3 = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('address3')];
							rec.preBinderId = prevRiGrid.rows[i][prevRiGrid.getColumnIndex('fnlBinderId')];
							rec.giriFrpsRiCtr = "1";
							rec.lineCd = objUW.hidObjGIRIS001.viewJSON.lineCd;
							rec.frpsYy = objUW.hidObjGIRIS001.viewJSON.frpsYy;
							rec.frpsSeqNo = objUW.hidObjGIRIS001.viewJSON.frpsSeqNo;
							rec.frpsSeqNo = objUW.hidObjGIRIS001.viewJSON.frpsSeqNo;
							rows.push(rec);
						}else{
							return false;
						}	
					}
				});	
			}	
			/*if (i==(prevRiGrid.rows.length-1)){
				tableGrid.createNewRows(rows);
				objUW.hidObjGIRIS001.computeSumAmt();
				Modalbox.hide();
			}*/
		}
		//if(prevRiGrid.rows.lenght > 0){
			tableGrid.createNewRows(rows);
		//}
		prevRiGrid.releaseKeys();
		//Modalbox.hide();
		previousRiListOverlay.close();
	});

</script>