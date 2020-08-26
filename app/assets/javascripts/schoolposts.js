$(document).ready(function () {
    $("#gallery").magnificPopup({
        delegate: 'img',
        type: 'image',
        gallery: {
            enabled: true
        }
    });
});

function screenshot() {
    html2canvas(document.querySelector("#postshow"), {
        y: 100
    }).then(function (canvas) {
        canvas.style.display = 'none';
        document.body.appendChild(canvas)
        var a = document.createElement('a');
        a.style.display = 'none';
        a.href = canvas.toDataURL("image/jpeg").replace("image/jpeg", "image/octet-stream");
        a.download = document.title + ".jpg";
        a.click();
        canvas.remove();
        a.remove();
    });
}