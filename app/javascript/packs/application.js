/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Webpacker')
// stylesheets
import "./stylesheets/admin"

// javascripts
import Rails from "rails-ujs"
import "./admin/admin-lte"

require("trix")
require("@rails/actiontext")

$("#register_button").click(function(){
    var base_url = location.href.split('#')[1].split('&');
    var access_token = base_url[0].replace('access_token=','');
    var expires_in   = base_url[3].replace('expires_in=','');
    location.href = location.protocol + '//' + location.host + '/pages/register?access_token=' + access_token + '&expires_in=' + expires_in;
});

Rails.start()

console.log('Hello World from Webpacker end')
