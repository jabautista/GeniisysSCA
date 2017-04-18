function resetDivs(){
		$$("div[name='rowPrelimDist']").each(function (r) {
			r.remove();
			objUW.requery = 'Y';
	    });
		$$("div[name='rowGroupDist']").each(function (r) {
			r.remove();
			objUW.requery = 'Y';
		});
		$$("div[name='rowShareDist']").each(function (r) {
			r.remove();
			objUW.requery = 'Y';
		});	
}