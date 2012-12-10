/*
Author: Addam M. Driver
Date: 10/31/2006
*/

var sMax;	// Isthe maximum number of stars
var holder; // Is the holding pattern for clicked state
var preSet; // Is the PreSet value onces a selection has been made

// Rollover for image Stars //
function rating(num){
	sMax = 0;	// Isthe maximum number of stars
	for(n=0; n<num.parentNode.childNodes.length; n++){
		if(num.parentNode.childNodes[n].nodeName == "A"){
			sMax++;	
		}
	}
	
	s = parseInt($(num).attr("rating")); // Get the selected star
	a = 0;
	var pid = $(num).attr("product_id");
	for(i=1; i<=sMax; i++){		
		if(i<=s){
			$(".rating_"+i+"_"+pid).addClass("on");
			$("#rateStatus_"+pid).html(num.title);
			holder = a+1;
			a++;
		}else{
			$(".rating_"+i+"_"+pid).removeClass("on");
		}
	}
}

// For when you roll out of the the whole thing //
function off(me){
	var pid = $(me).attr("product_id");
	if(!preSet){	
		for(i=1; i<=sMax; i++){		
			$("#rating_"+i+"_"+pid).removeClass("on");
			$("#rateStatus_"+pid).html(me.parentNode.title);
		}
	}else{
		rating(preSet);
		$("#rateStatus_"+pid).html($("#ratingSaved_"+pid).html());
	}
}

// When you actually rate something //
function rateIt(me){
	var pid = $(me).attr("product_id");
	$("#rateStatus_"+pid).html($("#ratingSaved_"+pid).html() + " :: "+me.title);
	preSet = me;
	rated=1;
	sendRate(me);
	rating(me);
	
	var user_id = $(me).attr("user_id");
	if(user_id != null && user_id != ""){
		var rid = parseInt($(me).attr("rating"));
		setRating(pid,rid,user_id);
	}
}

function setRating(pid,rid,user_id){
	var hash = {};
	hash["user_id"] = user_id;
	hash["product_id"] = pid;
	hash["preference"] = rid;
	jsRequest("/set_product_rating",hash);
}

// Send the rating information somewhere using Ajax or something like that.
function sendRate(sel){
	//alert("Your rating was: "+sel.title);
}

