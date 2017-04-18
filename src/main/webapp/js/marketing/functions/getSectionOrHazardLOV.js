/**
 * Shows LOV for Capacity
 * @author robert
 * @date 12.14.2011
 */
function getSectionOrHazardLOV() {
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getSectionOrHazardLOV",
									  page : 1,
									  lineCd : objGIPIQuote.lineCd, //Added by Jerome 09.07.2016 SR 5644
									  sublineCd : objGIPIQuote.sublineCd}, //Added by Jerome 09.07.2016 SR 5644
		title: "Section or Hazard Details",
		width: 500,
		height: 386,
		columnModel: [ {   id: 'recordStatus',
							    title: '',
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	id: 'divCtrId',
								width: '0',
								visible: false
							},
							{
								id: 'sectionOrHazardTitle',
								title: 'Section or Hazard Title',
								sortable: false,
								width: '387px'
							},
							{
								id: 'sectionOrHazardCd',
								title: 'Code',
								sortable: false,
								width: '94px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtSectionOrHazardCd").value = unescapeHTML2(row.sectionOrHazardCd);
				$("txtSectionOrHazardTitle").value = unescapeHTML2(row.sectionOrHazardTitle);
				$("txtSectionOrHazardCd").focus();
  		},
  		onCancel: function(){
  				$("txtSectionOrHazardCd").focus();
  		}
	});
}