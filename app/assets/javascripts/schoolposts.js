$(document).ready(function () {
    $("#gallery").magnificPopup({
        delegate: 'img',
        type: 'image',
        gallery: {
            enabled: true
        }
    });
});