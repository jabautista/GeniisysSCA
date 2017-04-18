/**
 * Shows Par No. LOV for GIACS026
 * @author Emsy Bolaños
 * @date  5.11.2012
 */
function showGIACParNoLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
							action   : "getParNoLOV",
							moduleId : "GIACS026",
							assdNo	 : $F("txtAssdNo"), //added by steven 12/18/2012
								page : 1
			},
			     title: "List of Par No",
			    width : 475,
			   height : 400,
		    draggable : true,
			columnModel : [{	   id : "dspParNo",
								title : "PAR No.",
						   titleAlign : "left",
							    width : '200px',
							  visible : true
							},
							{	   id : "parLineCd",
								title : "Par Line Cd",
							    width : '0px',
							  visible : false
							},
							{	   id : "parIssCd",
							    title : "Par Iss Cd",
							    width : '0px',
							  visible : false
							},
							{	    id : 'parYy',
								 title : 'Par Yy',
								 width : '0px',
							   visible : false
							},
							{
								    id : 'parSeqNo',
								 title : 'Par Seq No',
								 width : '0px',
						       visible : false
							},
							{
								    id : 'quoteSeqNo',
								 title : 'Quote Seq No',
								 width : '0px',
							   visible : false
							}
			              ],
			draggable : true,
			onSelect : function(row){
				if(row != undefined){
					$("txtParNo").value	= row.dspParNo;
					$("txtParLineCd").value	= row.parLineCd;
					$("txtParIssCd").value = row.parIssCd;
					$("txtParYy").value = row.parYy;	
					$("txtParSeqNo").value = parseInt(row.parSeqNo).toPaddedString(6);	
					$("txtQuoteSeqNo").value = row.quoteSeqNo;
					
					
					$("txtAssdNo").value = row.assdNo;
					$("txtDrvAssuredName").value =  unescapeHTML2(row.assdNo + " - " +  row.assdName); //added by steven 12/18/2012
					$("txtAssuredName").value = unescapeHTML2(row.assdName); //added by steven 12/18/2012
					
					$("txtLineCd").value = nvl(row.polLineCd,"");
					$("txtSublineCd").value = nvl(row.polSublineCd,"");
					$("txtIssCd").value = nvl(row.polIssCd,"");
					$("txtIssueYy").value = nvl(row.polIssueYY,"");
					$("txtPolSeqNo").value = row.polSeqNo == null || row.polSeqNo == "" ? "" :parseInt(row.polSeqNo).toPaddedString(6);
					$("txtRenewNo").value = nvl(row.polRenewNo,"");
					$("txtPolicyNo").value =  (row.polLineCd == null || row.polLineCd == "") && (row.polSeqNo == null || row.polSeqNo == "") ? "" : row.policyNo;


				}				
			}			
		});
	}catch(e){
		showErrorMessage("showGIACParNoLOV", e);
	}
}