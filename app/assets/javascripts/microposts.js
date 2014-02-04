function updateCountdown() {
    // 140 is the max message length
    var remaining = 140 - jQuery('#micropost_content').val().length;
    
    //set correct pluralization and account for negative values
    if(remaining == 1){
    	var charactersRemaining = ' character remaining.';
    }

    else if(remaining == -1){
    	var charactersRemaining = ' character too many.';
    }

    else if(remaining < 0){
    	var charactersRemaining = ' characters too many.';
    }

    else {
    	charactersRemaining = ' characters remaining.';
    }
    
    //set color of countdown
    if ( remaining >= 21){
    	jQuery(".countdown").css("color", "gray");
    }
    

    else if ( remaining >= 11){
    	jQuery(".countdown").css("color", "black");
    }
    
    
    else {
    	jQuery(".countdown").css("color", "red");
    }
    
    jQuery('.countdown').text(Math.abs(remaining) + charactersRemaining);


}

jQuery(document).ready(function($) {
    updateCountdown();
    $('#micropost_content').change(updateCountdown);
    $('#micropost_content').keyup(updateCountdown);
});

