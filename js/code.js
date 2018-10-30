$(document).ready(function () {

    // prepare bulletin for user clicks
    $('.challenge').each(function (el) {
        // display grade if exists
        if ($(this).data('grade') > 0) $(this).html($(this).html()+'<br><span class="grade">'+$(this).data('grade')+'</span>')
        // on click, prepare modal and show it
        $(this).click(function () {
            pin = $('#pin').val()
            $('#challengeid').val($(this).data('challengeid'))
            $('#questionid').val($(this).data('questionid'))
            $('#challengeText').html($(this).data('question'))
            $('#ModalChallenge').modal('show')
        })
    })

    // Put person id in input field when click on generate diploma
    $('button[name="diploma"]').click(function () {
        $('#pid').val($(this).data('pid'))
        inp = document.createElement('input');
        inp.name = 'diploma'
        document.getElementById('adminform').appendChild(inp)
        $('#adminform').submit()
    })

    // Remove message
    setTimeout(function(){
        $('#alert').fadeOut();
    },2000);
})