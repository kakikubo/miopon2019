$("#register_button").click(function(){
    access_token = location.href.split('#')[1].split('&')[0].replace('access_token=','');
    expires_in   = location.href.split('#')[1].split('&')[3].replace('expires_in=','');
    location.href = location.protocol + '//' + location.host + '/pages/register?access_token=' + access_token + '&expires_in=' + expires_in;
});

