var currentEndpoint = 'http://sissvoc.ereefs.info/sissvoc/ereefs';

var ereefsSearch = function(q) {
    $('#dropdown-suggestions').append('<div class="dd-display"><div class="list-group"></div></div>');
    $.when(searchConcepts(q, function( data ) {
       var conceptsByType = parseConceptSearchResults(data);
       
		if(conceptsByType.substanceOrTaxon.length > 0) {
			renderListGroup(conceptsByType.substanceOrTaxon, 'substance or taxon');
		}
	   if(conceptsByType.unit.length > 0) {
			renderListGroup(conceptsByType.unit, 'unit');
		}    
	   if(conceptsByType.qk.length > 0) {
			renderListGroup(conceptsByType.qk, 'quantity');
		}
    })).done(function(){
  	   searchCollections(q, function( data ) {
    		renderListGroup(data.result.items, 'collection');
	   });
    });	   
 
}

var renderListGroup = function (arrItems, typeLabel) {
	$.each(arrItems, function(i, item) {
		if(i <= 10) {
			if(typeof item.prefLabel === 'string'){
				var label = '<span class="search-suggestion-itemLabel">'+ item.prefLabel +'</span>';	
			}else{
				var label = '<span class="search-suggestion-itemLabel">'+ item.prefLabel.join(', ') +'</span>';
			}
			
			var type  = '<span class="search-suggestion-typeLabel">'+ typeLabel +'</span>';
			var uri = item._about;
			var itemobj = $('<a href="#" id="'+ uri +'" class="search-suggestion-lg list-group-item">'  +  label +  type + '</a>');
			$('#dropdown-suggestions > div > div.list-group').append(itemobj);
			$('body').data( uri, item );
		}
	});
}

var parseConceptSearchResults = function(data) {
    var arrSubstanceOrTaxon = new Array();
	var arrUnits = new Array();
	var arrQuantityKinds = new Array();
	
	
    $.each(data.result.items, function( i, item ) {
	   $.each(item.type, function( j, type ) {
          if(type._about == 'http://environment.data.gov.au/def/op#SubstanceOrTaxon') {
	          arrSubstanceOrTaxon.push(item);
		  }
		  else if(type._about == 'http://environment.data.gov.au/def/op#ScaledQuantityKind') {
		      arrQuantityKinds.push(item);
		  }	
		  else if(type._about == 'http://qudt.org/schema/qudt#Unit') {
		      arrUnits.push(item);
		  }  
	   }); 
	});
	var itemMap = {substanceOrTaxon: arrSubstanceOrTaxon, unit: arrUnits, qk: arrQuantityKinds}
	return itemMap;
}




var delay = (function () {
	var timer = 0;
	return function (callback, ms) {
		clearTimeout(timer);
		timer = setTimeout(callback, ms);
	};
})();


$(document).bind("click", function (event) {
	$("div#dropdown-suggestions").hide();
});

var keyUpFn = $("#filter").keyup(function (e) {
		if( e.keyCode == 13){
			filterElementByInput();
		}else{
			delay(function () {
			   doSearch();	
			}, 500);
		}
	});
	
	
var doSearch = function() {
	$('#dropdown-suggestions').show();
	$('#dropdown-suggestions').empty();
	
	var q = $('#filter').val();
	if (q != ''){
		ereefsSearch(q);	
	}
	
		
};
	
$(document).ready(function(){

   $(document).on('click', '.search-suggestion-lg', function(e){
   	 
     var elem = $(e.currentTarget);
	 var id = elem.attr('id');
	 var item = $('body').data(id);
	 
	 if(typeof item.prefLabel === 'string'){
	 	var prefLabel = item.prefLabel;
	 }else{
	 	var prefLabel = item.prefLabel.join(', ');
	 }
	 	
	$('#dropdown-suggestions').hide();
	$('#content').empty();
	 $('#filter').text(prefLabel);
	 $('#filter').val(prefLabel);
	 filterElementByInput('exactMatch');
	 var resourceUri = item._about;
			var promise = $.ajax({
					url : currentEndpoint + "/resource.json",
					data : {
						uri : resourceUri,
						_view : "all"
					},
					type : "GET"
				}).done(function (itemDetails) {
					$("#content").append(renderSearchResultItem(resourceUri, processSkosLabel(item.prefLabel), itemDetails));
				});

   });
});
